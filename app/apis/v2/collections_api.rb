class V2::CollectionsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :collections do

    desc "获取用户的所有收藏", {
      entity: FavoriteInformationEntity
    }
    params do
      optional :after, type: Integer, desc: "查询大于此id的收藏"
      optional :before, type: Integer, desc: "查询小于此id的收藏"
    end
    get do
      favorites = current_user.favorites.includes(:information).order("id desc")

      if params[:after] or params[:before]
        if params[:after]
          favorites = favorites.where("id > ?", params[:after])
        elsif params[:before]
          favorites = favorites.where("id < ?", params[:before])
        end

        sum = favorites.count
        start = sum - Settings.paginate_per_page
        has_more = start > 0
        if start > 0 and params[:after]
          favorites = favorites.limit "#{start}, #{Settings.paginate_per_page}"
        else
          favorites = favorites.limit Settings.paginate_per_page
        end
      else
        has_more = (favorites.count - Settings.paginate_per_page) > 0
        favorites = favorites.limit(Settings.paginate_per_page)
      end

      present favorites, with: FavoriteInformationEntity, auth_token: params[:auth_token]
      body( { has_more: has_more, data: body() })
    end

  end

end
