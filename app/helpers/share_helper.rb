module ShareHelper


  def share_user_page(share_records,before,after)
    if after or before
      if after
        share_records = share_records.where("users.id > ?", after)
      elsif before
        share_records = share_records.where("users.id < ?", before)
      end
      sum = share_records.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0 and after
        share_records = share_records.limit "#{start}, #{Settings.paginate_per_page}"
      else
        share_records = share_records.limit Settings.paginate_per_page
      end
    else
      has_more = (share_records.count - Settings.paginate_per_page) > 0
      share_records = share_records.limit(Settings.paginate_per_page)
    end
    present share_records, with: UserShareEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end
end
