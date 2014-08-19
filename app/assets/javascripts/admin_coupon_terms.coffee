$(window).bind 'page:change', ->
  $("#coupon_term_ids").select2(allowClear: true)
