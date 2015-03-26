# Ajax replacement of container with remote content, even if multiple queries
# got startet
# Caution: Is it possible that the latest ajax request (that we actually want to
# be the final replacement) gets processed before an earlier request?
@Clarat.ajaxStack = {}
@Clarat.ajaxReplace = (container, targetURL) ->
  container.addClass 'Ajax'

  Clarat.ajaxStack[container] = [] unless Clarat.ajaxStack[container]
  Clarat.ajaxStack[container].push targetURL

  $.get targetURL, (data) ->
    container.html data

    processedIndex = Clarat.ajaxStack[container].lastIndexOf targetURL
    Clarat.ajaxStack[container].splice processedIndex, 1

    container.removeClass 'Ajax' unless Clarat.ajaxStack[container].length
