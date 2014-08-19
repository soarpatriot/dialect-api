module ScripHelper

  def scrip_page(scrips,before)
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
    present scrips, with: ScripEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end

end
