module MapHelper

  APP_KEY = "4abeaefcc6f753454346f612d8636ba8"
  PLACE_TYPES = %W{商务大厦 地产小区}

  def map_url geolocation
    "http://api.map.baidu.com/geocoder/v2/?ak=#{APP_KEY}&output=json&pois=1&location=#{geolocation}"
  end
  
  def places_by_geolocation geolocation
    res = JSON.parse RestClient.get(map_url(geolocation)), symbolize_names: true
    res = res[:result]
    places = res[:pois].select{|item| PLACE_TYPES.include? item[:poiType] }.sort_by{|item| item[:distance].to_i }
    if places.empty?
      places = Place.where(ptype: "虚拟地址").limit(10)
      only_virtual = true
    end
    addr = res[:addressComponent]
    places = places.map do |item|
      if only_virtual
        place = item 
      else
        place = Place.where({name: item[:name], ptype: item[:poiType], addr: item[:addr], province: addr[:province], city: addr[:city], district: addr[:district]}).first_or_create
      end
      favorited = current_user.favorite_places.where(place_id: place.id).any?
      {id: place.id, favorited: favorited, name: "#{place.name}", address: place.address, type: place.ptype, image_url: place.image_url}
    end
    {
      address: {
        name: res[:formatted_address],
        components: res[:addressComponent]
      },
      places: places
    }
  end

  def log_location_and_place
    if params[:geolocation]
      begin
        geolocation = params[:geolocation].split(",").reverse.join(",")
        Rails.logger.info "#{params[:geolocation]} - place: #{places_by_geolocation(geolocation)[:places].first}"
      rescue Exception
      end
    end
  end

end
