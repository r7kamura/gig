$ ->
  $('a[title], button[title]').tooltip()
  $welcomeMessage = $('a[rel=welcome-message]')
  $welcomeMessage.popover('show')
  $('.popover').live('click', () ->
    $welcomeMessage.popover('hide')
    location.href = $welcomeMessage.attr('href')
  )
