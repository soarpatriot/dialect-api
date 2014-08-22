module CommentHelper

  def comment_page(scrips,before)
    if before
      scrips = scrips.where("scrips.id < ?", before)
      sum = scrips.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0
        scrips = scrips.limit "#{start}, #{Settings.paginate_per_page}"
      else
        scrips = scrips.limit Settings.paginate_per_page
      end
    else
      has_more = (scrips.count - Settings.paginate_per_page) > 0
      scrips = scrips.limit(Settings.paginate_per_page)
    end
    present scrips, with: CommentInformationEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end

  def comment_user_page(comments,before,after)
    if after or before
      if after
        comments = comments.where("id > ?", after)
      elsif before
        comments = comments.where("id < ?", before)
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
