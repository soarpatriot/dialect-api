module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type.to_sym
    when :success
      "alert-success"
    when :error
      "alert-error"
    when :alert
      "alert-warning"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def is_tab_active?(current_tab_name, tab_name)
    return current_tab_name == tab_name
  end

end
