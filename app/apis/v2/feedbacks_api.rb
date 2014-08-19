class V2::FeedbacksApi < Grape::API
  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :feedbacks do
    params do
      requires :content, type: String, desc: "反馈内容"
    end
    post do
      feed_content = params[:content]
      locale_error! "feedbacks.content_blank_not_allow", 400 if feed_content.blank?

      feedback = Feedback.create content:feed_content, user: current_user
      feedback.nil?? (locale_error! "server_save_error", 500): {feedback:true}
    end

  end
end
