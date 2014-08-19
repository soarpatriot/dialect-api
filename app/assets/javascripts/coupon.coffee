$(window).bind 'page:change', ->

  $('a[name="collapse-term"]').click ->
    $icon = $(this).find("span")
    if $icon.hasClass('glyphicon-chevron-right')
      $icon.removeClass('glyphicon-chevron-right')
      $icon.addClass('glyphicon-chevron-down')
    else
      $icon.removeClass('glyphicon-chevron-down')
      $icon.addClass('glyphicon-chevron-right')

