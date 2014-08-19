class V1::InformationsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :informations do

    desc "收藏信息", {
      entity: FavoriteEntity
    }
    params do
      requires :id, type: Integer
    end
    post ":id/favorite" do
      information = Information.find params[:id]
      favorite = current_user.favorites.create information: information
      present favorite, with: FavoriteEntity
    end

    desc "取消收藏信息", {
      entity: FavoriteEntity
    }
    params do
      requires :id, type: Integer
    end
    delete ":id/favorite" do
      favorite = current_user.favorites.where(information_id: params[:id]).first
      locale_error! "could_not_find_information", 404 if favorite.nil?

      favorite.destroy
      present Favorite.new, with: FavoriteEntity
    end

  end

end
