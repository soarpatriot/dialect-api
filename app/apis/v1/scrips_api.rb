class V1::ScripsApi < Grape::API

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
    get do
      scrips =  current_user.scrips.includes(:information).order("id desc")
      present scrips, with: ScripEntity, auth_token: params[:auth_token]
    end

    desc "创建纸条", {
      entity: ScripEntity
    }
    params do
      optional :content, type: String
      optional :image
      optional :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
      optional :address, type: String
    end
    post do
      if params[:content].nil? and params[:image].nil?
        locale_error! "content_and_image_not_both_null", 400
      end
      scrip_params = {}
      if params[:geolocation]
        lon, lat = params[:geolocation].split(",") 
        scrip_params[:longitude] = lon
        scrip_params[:latitude] = lat
      end
      scrip_params[:content] = params[:content]
      scrip_params[:address] = params[:address]
      scrip_params.keys.each do |key|
        scrip_params[key] = scrip_params[key].try(:force_encoding, "UTF-8")
      end
      scrip_params[:image] = params[:image]

      scrip = current_user.scrips.create scrip_params
      present scrip, with: ScripEntity, auth_token: params[:auth_token]
    end

  end

end
