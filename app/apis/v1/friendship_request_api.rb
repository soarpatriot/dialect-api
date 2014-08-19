class V1::FriendshipRequestApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  namespace :friendship_request do

    desc "发送添加好友请求", {
      entity: FriendshipRequestEntity
    }
    post "new" do
      current_user.friendship_requests.delete_all
      friendship_request = current_user.friendship_requests.create status: "waiting"
      present friendship_request, with: FriendshipRequestEntity
    end

    desc "取消添加好友请求", {
      entity: FriendshipRequestEntity
    }
    post "cancel" do
      current_user.friendship_requests.delete_all
      present current_user.friendship_requests.new(status: "cancel"), with: FriendshipRequestEntity
    end

    desc "当前添加好友请求的状态", {
      entity: FriendshipRequestEntity
    }
    get "status" do
      friendship_request = current_user.friendship_requests.first
      error! "couldn't find any friendship request", 404 if friendship_request.nil?
      present friendship_request, with: FriendshipRequestEntity
    end
    
    desc "接受对方添加好友请求", {
      entity: FriendshipRequestEntity
    }
    params do
      requires :service_code, type: String
    end
    post "accept" do
      user = SoundinkCode.where(service_code: params[:service_code]).first.try(:user)
      error! "couldn't find user with service_code #{params[:service_code]}", 404 if user.nil?

      friendship = Friendship.where(user_id: user.id, friend_id: current_user.id).first
      error! "already been friend", 400 unless friendship.nil?

      friendship_request = user.friendship_requests.first
      error! "couldn't find any friendship_requests of this user", 404 if friendship_request.nil?

      user.friends << current_user
      friendship_request.delete

      present user.friendship_requests.new(target_user: current_user, status: "done"), with: FriendshipRequestEntity
    end

  end

end
