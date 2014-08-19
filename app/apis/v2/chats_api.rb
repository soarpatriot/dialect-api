class V2::ChatsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :chats do

    desc "获得用户当前的聊天列表", {
      entity: ChatEntity,
      notes: <<-NOTES
        type: system, chat, information
      NOTES
    }
    params do
      optional :since, type: Integer, default: Time.now.to_i, desc: "查询此时间戳后的聊天"
    end
    get do
      present Chat.where("updated_at >= ?", Time.at(params[:since])).limit(10).order("id desc"), with: ChatEntity, user: current_user
      body( { timestamp: Time.now.to_i, data: body() })
    end
    
  end
end
