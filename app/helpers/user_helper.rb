module UserHelper

  def user_page(users,before,after)
    if after or before
      if after
        users = users.where("users.id > ?", after)
      elsif before
        users = users.where("users.id < ?", before)
      end
      sum = users.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0 and after
        users = users.limit "#{start}, #{Settings.paginate_per_page}"
      else
        users = users.limit Settings.paginate_per_page
      end
    else
      has_more = (users.count - Settings.paginate_per_page) > 0
      users = users.limit(Settings.paginate_per_page)
    end
    present users, with: UserEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end

end
