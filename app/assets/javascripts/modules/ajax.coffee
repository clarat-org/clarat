# Ajax replacement of container with remote content, even if multiple queries
# got startet
# Caution: Is it possible that the latest ajax request (that we actually want to
# be the final replacement) gets processed before an earlier request?
Clarat.Ajax =
  stack: {}

  defaultOptions:
    historyPush: true

  replace: (container, targetURL, options = {}) ->
    options = _.merge Clarat.Ajax.defaultOptions, options

    container.addClass 'Ajax'

    Clarat.Ajax.stack[container] = [] unless Clarat.Ajax.stack[container]
    Clarat.Ajax.stack[container].push targetURL

    $.get targetURL, (data) ->
      # update container
      container.html data

      # update URL
      if options.historyPush
        history.pushState { turbolinks: true, url: targetURL }, '', targetURL

      if Clarat.Ajax.stack[container]
        # remove appropriate element from stack
        processedIndex = Clarat.Ajax.stack[container].lastIndexOf targetURL
        Clarat.Ajax.stack[container].splice processedIndex, 1

      # remove waiting-for-ajax display styling when stack empty
      container.removeClass 'Ajax' unless Clarat.Ajax.stack[container]?.length

      $(document).trigger 'ajax_replaced'
