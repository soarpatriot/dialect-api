$(window).bind 'page:change', ->
  $("#merchant_mq100l_ids").select2(allowClear: true)
  $("#merchant_mq100n_ids").select2(allowClear: true)
