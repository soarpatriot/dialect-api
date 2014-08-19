class V1::JiguApi < Grape::API

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

    desc "checkin by mq100", {
      entity: CheckinHistoryEntity
    }
    params do
      requires :merchant_service_code, type: String
      optional :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
    end
    post "checkin" do
      merchant = Mq100.where(service_code: params[:merchant_service_code]).first.try(:merchant)
      locale_error! "wrong_service_code_to_find_mq100", 404 if merchant.nil?

      ch_params = {
        merchant_id: merchant.id
      }
      if params[:geolocation]
        lon, lat = params.split(",")
        ch_params[:longitude] = lon
        ch_params[:latitude] = lat
      end
      ch = current_user.checkin_histories.create ch_params
      present ch, with: CheckinHistoryEntity
    end

  end

end
