class V2::ScripsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :scrips do

    desc "获取当前用户的所有纸条", {
      entity: ScripEntity
    }
    params do
      optional :after, type: Integer, desc: "查询大于此id的纸条"
      optional :before, type: Integer, desc: "查询小于此id的纸条"
    end
    get do
      scrips = current_user.scrips.includes(:information).order("id desc")
      if params[:after] or params[:before]
        if params[:after]
          scrip_id = Scrip.unscoped{ Information.unscoped.find(params[:after]).infoable.id }
          scrips = scrips.where("id > ?", scrip_id)
        elsif params[:before]
          scrip_id = Scrip.unscoped{ Information.unscoped.find(params[:before]).infoable.id }
          scrips = scrips.where("id < ?", scrip_id)
        end

        sum = scrips.count
        start = sum - Settings.paginate_per_page
        has_more = start > 0
        if start > 0 and params[:after]
          scrips = scrips.limit "#{start}, #{Settings.paginate_per_page}"
        else
          scrips = scrips.limit Settings.paginate_per_page
        end
      else
        has_more = (scrips.count - Settings.paginate_per_page) > 0
        scrips = scrips.limit(Settings.paginate_per_page)
      end

      present scrips, with: ScripEntity, auth_token: params[:auth_token]
      body( { has_more: has_more, data: body() })
    end

    desc "创建纸条", {
      entity: ScripEntity
    }
    params do
      optional :content, type: String
      optional :image
      optional :subject_id, type: Integer
      optional :place_id, type: Integer
    end
    post do
      if params[:content].nil? and params[:image].nil?
        locale_error! "content_and_image_not_both_null", 400
      end

      place = Place.where(id: params[:place_id]).first
      subject = Subject.where(id: params[:subject_id]).first

      scrip_params = {}
      if params[:geolocation]
        lon, lat = params[:geolocation].split(",") 
        scrip_params[:longitude] = lon
        scrip_params[:latitude] = lat
      end
      scrip_params[:content] = params[:content]
      scrip_params[:address] = params[:address]
      scrip_params[:country] = params[:country]
      scrip_params[:province] = params[:province]
      scrip_params[:city] = params[:city]
      scrip_params[:district] = params[:district]
      scrip_params[:street] = params[:street]
      scrip_params.keys.each do |key|
        scrip_params[key] = scrip_params[key].try(:force_encoding, "UTF-8")
      end
      scrip_params[:image] = params[:image]
      scrip = current_user.scrips.create scrip_params
      scrip.information.update place: place

      unless subject.nil?
        scrip.information.update subject_id: params[:subject_id]
        Information.where(infoable: subject, place: place).first.try(:touch)
      end

      present scrip, with: ScripEntity, auth_token: params[:auth_token]
    end


    desc "获取当前热门字条所有纸条", {
        entity: ScripEntity
    }
    params do
      optional :after, type: Integer, desc: "查询大于此id的纸条"
      optional :before, type: Integer, desc: "查询小于此id的纸条"
    end
    get 'hot' do
      scrips = Scrip.order_by_hot

=begin
      if params[:after] or params[:before]
        if params[:after]
          scrips = scrips.joins(:information).where("information.id > ? ", params[:after])
        elsif params[:before]
          scrips = scrips.joins(:information).where("information.id < ? ", params[:after])
        end
        sum = scrips.count
        start = sum - Settings.paginate_per_page
        has_more = start > 0
        if start > 0 and params[:after]
          scrips = scrips.limit "#{start}, #{Settings.paginate_per_page}"
        else
          scrips = scrips.limit Settings.paginate_per_page
        end
      else
      end
=end
        # has_more = (scrips.count - Settings.paginate_per_page) > 0
      has_more = false
      scrips = scrips.limit(Settings.paginate_per_page)


      present scrips, with: ScripEntity, auth_token: params[:auth_token]
      body( { has_more: has_more, data: body() })
    end
  end
end
