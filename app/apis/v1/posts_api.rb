class V1::PostsApi < Grape::API


  before do
    token_authenticate!
  end
  params do
    requires :auth_token, type: String
  end

  resources :posts do

    desc "上传声音", {

    }
    params do
      requires :image , desc: "图片文件"
      requires :sound, desc: "声音文件"
      optional :content, desc: "内容"
    end
    post  do
      post = Post.create image:params[:image], sound:params[:sound], content:params[:content]
      error! post.errors.full_messages.join(","), 400 unless post.persisted?
      success_result
    end

  end

end
