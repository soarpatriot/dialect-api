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
      user_chats = current_user.chats.where("updated_at >= ? and last_sender_id <> ?", Time.at(params[:since]), current_user.id).order("id desc")

      place_ids = current_user.places.pluck(:id)
      group_chats = Chat.where(target_type: "Place", target_id: place_ids)
        .where("updated_at >= ? and last_sender_id <> ?", Time.at(params[:since]), current_user.id).order("id desc")

      chats = user_chats.to_a + group_chats.to_a
      present chats, with: ChatEntity, user: current_user

      webview_file_path = Dir[Rails.root.join("public/uploads/webview*.html")].first
      if webview_file_path
        file_name = webview_file_path.split("/").last
      end
      html_update_timestamp = file_name.nil? ? 0 : file_name.delete("webview.html").try(:to_i)

      body({ timestamp: Time.now.to_i, html_update_timestamp: html_update_timestamp, data: body() })
    end

  end
end
