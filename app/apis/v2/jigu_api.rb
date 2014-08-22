class V2::JiguApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :jigu do

    desc "叽咕一下", {
      entity: InformationEntity,
      notes: <<-NOTES
        叽咕一下返回一个Information，Information包括的具体信息为Scrip和Coupon两类，通过type区分。
      NOTES
    }
    params do
      optional :service_code, type: String
      optional :delay, type: Integer
      optional :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "逗号分隔。lon,lat => 123.2,39.8"
    end
    get do
      log_location_and_place
      black_list = %w{92232580 98008780 97873240 93262763 98539278}.map{|item| "+65#{item}" }
      if current_user.information_visit_records.count == 0 and current_user.country_code == 65 and !black_list.include?(current_user.mobile_number)
        coupon = Coupon.offset(Kernel.rand(Coupon.count)).first
        information = coupon.try(:information)
        current_user.favorites.create information: information unless information.nil?
      end

      if information.nil?
        merchant = Mq100.where(service_code: params[:service_code]).first.try(:merchant)
        information = Information.get_recommended_record_for current_user, merchant, params[:geolocation]
      end

      unless information.nil?
        InformationVisitRecord.create information: information, user: current_user
        information.increase_for :visits_count
        present information, with: InformationEntity, auth_token: params[:auth_token], user: current_user
      else
        {
          id: -1,
          type: "Scrip",
          url: Settings.host + "/information/no_scrip?locale=#{params[:locale]}"
        }
      end
    end

    desc "叽咕列表", {
      entity: InformationEntity,
      notes: <<-NOTES
        叽咕一下返回一个Information，Information包括的具体信息为Scrip和Subject两类，通过type区分。
      NOTES
    }
    params do
      requires :place_id, type: Integer, desc: "地点ID"
      optional :subject_id, type: Integer, desc: "专题ID"
      optional :before, type: Integer, desc: "查询此ID以前的信息"
    end
    get "list" do
      place = Place.find params[:place_id]
      place.users.where(id: current_user.id).first_or_create

      if params[:subject_id]
        subject = Subject.find params[:subject_id]
        informations = subject.informations.where("infoable_type = 'Scrip' and place_id = ?", params[:place_id])
      else
        Subject.where(category: place.ptype).each do |_subject|
          Information.where(infoable: _subject, place: place).first_or_create
        end
        informations = place.information.where("infoable_type <> 'Coupon' and subject_id is null")
      end

      informations = informations.order("updated_at desc")

      if params[:before]
        informations = informations.where("id < ?", params[:before])

        sum = informations.count
        start = sum - Settings.paginate_per_page
        has_more = start > 0
        informations = informations.limit Settings.paginate_per_page
      else
        has_more = (informations.count - Settings.paginate_per_page) > 0
        informations = informations.limit(Settings.paginate_per_page)
      end

      if params[:subject_id].nil? and !informations.map(&:infoable_type).include?("Scrip")
        informations = informations.unshift current_user.scrips.create_first_for_the_place(place, current_user)
      end

      present informations, with: InformationEntity, user: current_user

      body has_more: has_more, data: body()
    end

  end
end
