# Ajax replacement of container with remote content, even if multiple queries
# got startet
# Caution: Is it possible that the latest ajax request (that we actually want to
# be the final replacement) gets processed before an earlier request?
@Clarat.ajaxStack = {}
@Clarat.ajaxReplace = (container, targetURL, options = {}) ->
  defaultOptions = { historyPush: true }
  options = _.merge defaultOptions, options

  container.addClass 'Ajax'

  Clarat.ajaxStack[container] = [] unless Clarat.ajaxStack[container]
  Clarat.ajaxStack[container].push targetURL

  $.get targetURL, (data) ->
    # update container
    container.html data

    # update URL
    if options.historyPush
      history.pushState { turbolinks: true, url: targetURL }, '', targetURL

    if Clarat.ajaxStack[container]
      # remove appropriate element from stack
      processedIndex = Clarat.ajaxStack[container].lastIndexOf targetURL
      Clarat.ajaxStack[container].splice processedIndex, 1

    # remove waiting-for-ajax display styling when stack empty
    container.removeClass 'Ajax' unless Clarat.ajaxStack[container]?.length

    $(document).trigger 'ajax_replaced'
