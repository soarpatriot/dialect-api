module VisitHelper


  def visit_user_page(visit_records,before,after)

    if after or before
      if after
        visit_records = visit_records.where("id > ?", after)
      elsif before
        visit_records = visit_records.where("id < ?", before)
      end

      sum = visit_records.count
      start = sum - Settings.paginate_per_page
      has_more = start > 0
      if start > 0 and after
        visit_records = visit_records.limit "#{start}, #{Settings.paginate_per_page}"
      else
        visit_records = visit_records.limit Settings.paginate_per_page
      end
    else

      has_more = (visit_records.count - Settings.paginate_per_page) > 0
      visit_records = visit_records.limit(Settings.paginate_per_page)
    end
    present visit_records, with: UserVisitEntity, auth_token: params[:auth_token]
    body( { has_more: has_more, data: body() })
  end
end
