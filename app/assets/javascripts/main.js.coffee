$ ->
  $('a[title], button[title]').tooltip()
  $welcome_popover = $('a[rel=welcome-popover]')
  $welcome_popover.popover('show')
  $('.popover').live('click', () ->
    $welcome_popover.popover('hide')
    location.href = $welcome_popover.attr('href')
  )
