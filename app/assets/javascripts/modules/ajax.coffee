# Ajax replacement of container with remote content, even if multiple queries
# got startet
# Caution: Is it possible that the latest ajax request (that we actually want to
# be the final replacement) gets processed before an earlier request?
class Ajax
  constructor: ->
    ### PUBLIC ATTRIBUTES ###

    @stack = {}

    @defaultOptions =
      historyPush: true


  ### PUBLIC METHODS ###

  replace: (container, targetURL, options = {}) ->
    options = _.merge _.clone(@defaultOptions), options
    that = this

    container.addClass 'Ajax'

    @stack[container] = [] unless @stack[container]
    @stack[container].push targetURL

    $.ajax
      url: targetURL
      success: (data) ->
        # update container
        container.html data

        # update URL & inform analytics
        if options.historyPush
          history.pushState? { turbolinks: true, url: targetURL }, '', targetURL
          Clarat.Analytics.pageView()

        # remove appropriate element from stack & finish
        that.pop targetURL, container
        that.onComplete container

        $(document).trigger 'ajax_replaced'
      error: (error) ->
        console.log error.statusText
        console.log error.responseText.substr(0, 200)

        container.html(
          HoganTemplates['error_ajax'].render I18n.t('js.ajax_error')
        )

        # still remove element from stack & finish
        that.pop targetURL, container
        that.onComplete container

  ### PRIVATE METHODS (not enforced) ###

  # remove something from stack
  pop: (targetURL, container) ->
    if @stack[container]

      processedIndex = @stack[container].lastIndexOf targetURL
      @stack[container].splice processedIndex, 1

  # remove waiting-for-ajax display styling when stack empty
  onComplete: (container) ->
    container.removeClass 'Ajax' unless @stack[container]?.length

Clarat.Ajax = new Ajax
