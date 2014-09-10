class V2::PlacesApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :places do
    
    desc "当前用户收藏的圈子", {
      entity: FavoritePlaceEntity
    }
    params do
      optional :before, type: Integer, desc: "查询此ID以前的收藏"
    end
    get "favorited" do
      favorites = current_user.favorite_places.order("id desc")
      if params[:before]
        favorites = favorites.where("id < ?", params[:before])

        sum = favorites.count
        start = sum - Settings.paginate_per_page
        has_more = start > 0
        favorites = favorites.limit Settings.paginate_per_page
      else
        has_more = (favorites.count - Settings.paginate_per_page) > 0
        favorites = favorites.limit Settings.paginate_per_page
      end

      present favorites, with: FavoritePlaceEntity
      body( { hasmore: has_more, data: body() })
    end

    desc "收藏圈子", {
      entity: PlaceEntity
    }
    params do
      requires :id, type: Integer, desc: "地点id"
    end
    post ":id/favorite" do
      place = Place.find params[:id]
      favorite = current_user.favorite_places.where(place: place).first_or_create
      if favorite.persisted?
        present place, with: PlaceEntity, user: current_user
      else
        locale_error! "place.favorite_error", 400
      end
    end

    desc "取消收藏圈子", {
      entity: PlaceEntity
    }
    params do
      requires :id, type: Integer, desc: "地点id"
    end
    delete ":id/favorite" do
      place = Place.find params[:id]
      favorite = current_user.favorite_places.where(place: place).first
      if favorite
        favorite.destroy
        present place, with: PlaceEntity, user: current_user
      else
        locale_error! "place.unfavorite_error", 400
      end
    end

  end
end
