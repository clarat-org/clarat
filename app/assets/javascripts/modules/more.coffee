moreHandler = ->
  moreArea = $('.js-more')
  if moreArea.length
    trigger = moreArea.find('.js-more-trigger')
    target = moreArea.find('.js-more-target')
    displays = trigger.find('.js-more-display')
    trigger.on 'click', (e) ->
      displays.toggleClass 'is--hidden'
      target.toggleClass 'is--hidden'
      e.preventDefault()
      false

$(document).ready moreHandler
$(document).on 'page:load', moreHandler
