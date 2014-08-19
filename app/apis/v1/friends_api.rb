class V1::FriendsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :friends do

    desc "获得当前用户的朋友列表", {
      entity: UserEntity
    }
    get do
      present current_user.friends, with: UserEntity
    end

  end

end
