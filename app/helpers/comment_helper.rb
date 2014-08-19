module CommentHelper

  def comment_page(comments,before)
    if before
      comments = comments.where("comments.id < ?", before)
      sum = comments.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0
        comments = comments.limit "#{start}, #{Settings.paginate_per_page}"
      else
        comments = comments.limit Settings.paginate_per_page
      end
    else
      has_more = (comments.count - Settings.paginate_per_page) > 0
      comments = comments.limit(Settings.paginate_per_page)
    end
    present comments, with: CommentInformationEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end

  def comment_user_page(comments,before,after)
    if after or before
      if after
        comments = comments.where("users.id > ?", after)
      elsif before
        comments = comments.where("users.id < ?", before)
      end
      sum = comments.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0 and after
        comments = comments.limit "#{start}, #{Settings.paginate_per_page}"
      else
        comments = comments.limit Settings.paginate_per_page
      end
    else
      has_more = (comments.count - Settings.paginate_per_page) > 0
      comments = comments.limit(Settings.paginate_per_page)
    end
    present comments, with: UserCommentEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end
end
