module FavoriteHelper

  def favorite_page(favorites,before)
    if before
      favorites = favorites.where("favorites.id < ?", before)
      sum = favorites.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0
        favorites = favorites.limit "#{start}, #{Settings.paginate_per_page}"
      else
        favorites = favorites.limit Settings.paginate_per_page
      end
    else
      has_more = (favorites.count - Settings.paginate_per_page) > 0
      favorites = favorites.limit(Settings.paginate_per_page)
    end
    present favorites, with: FavoriteInformationEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end

  def user_favorite_page(favorites,before,after)
    if after or before
      if after
        favorites = favorites.where("id > ?", after)
      elsif before
        favorites = favorites.where("id < ?", before)
      end
      sum = favorites.count.length
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0 and after
        favorites = favorites.limit "#{start}, #{Settings.paginate_per_page}"
      else
        favorites = favorites.limit Settings.paginate_per_page
      end
    else
      has_more = (favorites.count.length - Settings.paginate_per_page) > 0
      favorites = favorites.limit(Settings.paginate_per_page)
    end
    present favorites, with: UserFavoriteEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end
end
