class V2::CommentsApi < Grape::API

  before do
    token_authenticate! if params[:auth_token]
    @current_user = User.non_login if @current_user.nil?
  end

  resources :comments do

    desc "获取自己纸条的评论列表", {
      entity: CommentEntity
    }
    params do
      requires :auth_token, type: String
      optional :information_id, type: Integer, desc: "信息ID"
      optional :before, type: Integer, desc: "获得此ID之前的评论"
      optional :since, type: Integer, default: Time.now.to_i, desc: "查询此时间戳后的评论"
    end
    get do
      if params[:information_id]
        information = Information.find(params[:information_id])
        locale_error! "only_scrip_has_comments" unless information.is_scrip?

        comments = information.infoable.comments
        comments = comments.where("id < ?", params[:before]) if params[:before]

        sum = comments.count
        has_more = (sum - Settings.paginate_per_page) > 0

        comments = comments.limit Settings.paginate_per_page

        present comments, with: CommentEntity
        body( { has_more: has_more, data: body() })
      else
        scrip_ids = current_user.scrips.pluck(:id)
        comments = Comment.where("created_at >= ? and scrip_id in (?)", Time.at(params[:since]), scrip_ids)
        present comments, with: CommentEntity
        body( { timestamp: Time.now.to_i, data: body() })
      end
    end

    desc "创建评论", {
      entity: CommentEntity
    }
    params do
      requires :content, type: String, desc: "评论内容"
      requires :information_id, type: Integer, desc: "信息ID"
      optional :place_id, type:Integer, desc: "地点id"
      optional :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
      optional :address, type: String
    end
    post do
      information = Information.find params[:information_id]
      scrip = information.infoable
      locale_error! "comments.no_scrip_found", 404 if scrip.nil?
      place = Place.where(id: params[:place_id]).first
      # locale_error! "comments.no_place_found", 404 if place.nil?
      comment = scrip.comments.create content: params[:content],address:params[:address], user: current_user, place: place
      present comment, with: CommentEntity
    end

  end
end
