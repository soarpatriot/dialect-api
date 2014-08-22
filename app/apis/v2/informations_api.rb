class V2::InformationsApi < Grape::API

  before do
    token_authenticate! if params[:auth_token]
    @current_user = User.non_login if @current_user.nil?
  end

  resources :informations do

    desc "收藏信息", {
      entity: FavoriteInformationEntity
    }
    params do
      requires :id, type: Integer
    end
    post ":id/favorite" do
      information = Information.find params[:id]
      locale_error! "could_not_find_information", 404 if information.nil?
      favorite = current_user.favorites.where(information: information).first_or_create
      information.liked_by current_user
      information.increase_for :votes_count

      Chat.create_for_information_favorite information, current_user

      present favorite, with: FavoriteInformationEntity
    end

    desc "查看信息", {
      entity: FavoriteInformationEntity
    }
    params do
      requires :id, type: Integer
    end
    post ":id/visit" do
      information = Information.find params[:id]
      locale_error! "could_not_find_information", 404 if information.nil?
      if information.is_scrip?
        information_visit_record = InformationVisitRecord.create user:@current_user, information:information
        information_visit_record.nil?? (locale_error! "server_save_error", 500): {visited:true}
      else
        error! I18n.t("information.invalid_id"), 400
      end
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
      information = Information.find params[:id]
      information.unliked_by current_user
      information.decrease_for :votes_count
      present Favorite.new, with: FavoriteEntity
    end

    desc "更新分享统计信息"
    params do
      requires :id, type: Integer
      requires :auth_token, type: String
      optional :social_type, type: Symbol, values: [:wechat, :facebook]
    end
    put ":id/share_statistic" do
      information = Information.find params[:id]
      locale_error! "could_not_find_information", 404 if information.nil?
      if information.is_scrip?
        information_share_record = InformationShareRecord.create user:@current_user, information:information
        information_share_record.nil?? (locale_error! "server_save_error", 500): {count:information.information_share_records.count}
      else
        error! I18n.t("information.invalid_id"), 400
      end
    end

    desc "删除信息", {
      entity: InformationEntity
    }
    params do
      requires :auth_token, type: String
      requires :id, type: Integer
    end
    delete ":id" do
      information = Information.find params[:id]
      if information.is_scrip? and information.infoable.owner == current_user
        information.soft_delete
        present information, with: InformationEntity, user: current_user
      else
        error! I18n.t("information.invalid_id"), 400
      end
    end

    desc "举报字条", {
      entity: InformationEntity
    }
    params do
      requires :id, type: Integer
    end
    post ":id/report" do

      information = Information.find params[:id]
      if information.is_scrip?
        Report.where(information:information,user:current_user).first_or_create
        {reported:true}
      else
        error! I18n.t("information.invalid_id"), 400
      end
    end

    desc "赞过此信息的用户列表", {
      entity: UserFavoriteEntity
    }
    params do
      requires :id, type: Integer
      optional :after, type: Integer, desc: "查询大于此favorited id的赞"
      optional :before, type: Integer, desc: "查询小于此favorited id的赞"
    end
    get ":id/users/favorited" do

      information = Information.find params[:id]
      if information.is_scrip?
        favorites = Favorite.group("user_id").where("information_id"=>information.id)
        user_favorite_page(favorites,params[:before], params[:after])
      else
        error! I18n.t("information.invalid_id"), 400
      end
    end

    desc "评论过此信息的用户列表", {
      entity: UserCommentEntity
    }
    params do
      requires :id, type: Integer
      optional :after, type: Integer, desc: "查询大于此comment id的评论用户"
      optional :before, type: Integer, desc: "查询小于此comment id的评论用户"
    end
    get ":id/users/commented" do
      information = Information.find params[:id]
      if information.is_scrip?
        # comments = Comment.joins(:user).where('comments.scrip_id' => information.infoable_id).order("comments.id desc").distinct
        ids =  Comment.find_by_sql("SELECT max(id) as id FROM comments where scrip_id="+information.infoable_id.to_s+" group by user_id order by id desc")
        comments = Comment.where("id"=>ids)
        #comments = Comment.group("user_id").where("scrip_id"=>information.infoable_id)
        comment_user_page(comments,params[:before], params[:after])
      else
        error! I18n.t("information.invalid_id"), 400
      end

    end

    desc "分享过此信息的用户列表", {
      entity: UserShareEntity
    }
    params do
      requires :id, type: Integer
      optional :after, type: Integer, desc: "查询大于此shared id的分享用户"
      optional :before, type: Integer, desc: "查询小于此shared id的分享用户"
    end
    get ":id/users/shared" do
      information = Information.find params[:id]
      if information.is_scrip?
        ids =  InformationShareRecord.find_by_sql("SELECT max(id) as id FROM information_share_records where information_id="+information.id.to_s+" group by user_id order by id desc")
        share_records = InformationShareRecord.where("id"=>ids)
        share_user_page(share_records,params[:before], params[:after])

      else
        error! I18n.t("information.invalid_id"), 400
      end
    end

    desc "浏览过此信息的用户列表", {
      entity: UserVisitEntity
    }
    params do
      requires :id, type: Integer
      optional :after, type: Integer, desc: "查询大于此visited id的浏览过用户"
      optional :before, type: Integer, desc: "查询小于此visited id的浏览过用户"
    end
    get ":id/users/visited" do
      information = Information.find params[:id]
      if information.is_scrip?

        ids =  InformationVisitRecord.find_by_sql("SELECT max(id) as id FROM information_visit_records where information_id="+information.id.to_s+" group by user_id order by id desc")

        # visit_records = InformationVisitRecord.group("user_id").where("information_id"=>information.id)

        visit_records = InformationVisitRecord.where("id"=>ids)
        visit_user_page(visit_records,params[:before],params[:after])

      else
        error! I18n.t("information.invalid_id"), 400
      end
    end
  end

end
