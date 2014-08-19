class V2::GeocoderApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  namespace :geocoder do
    
    desc "根据经纬度查询附近的地点信息"
    params do
      requires :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
    end
    get do
      places_by_geolocation params[:geolocation]
    end

    desc "获取随机地址"
    params do
      requires :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
    end
    get "random" do
      offset = rand Place.count(:all)
      place = Place.offset(offset).first
      favorited = current_user.favorite_places.where(place_id: place.id).any?
      {
        id: place.id,
        favorited: favorited,
        name: place.name,
        address: place.address,
        image_url: place.image_url,
        type: place.ptype,
      }
    end

  end

end
