$ ->
  return unless $('.entries_controller.show_action')

  $('article pre').addClass('prettyprint')
  prettyPrint()
