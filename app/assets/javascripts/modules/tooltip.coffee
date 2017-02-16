# using qTip2
Clarat.Tooltip =
  initializeAllTooltips: ->
    tooltips = $('.JS-tooltip')
    if tooltips.length
      tooltips.qtip Clarat.Tooltip.settings

  settings:
    position:
      my: 'bottom left'
      at: 'top center'
      effect: false
      viewport: $(document)
      # To make sure the tooltip is always shown above
      # adjust:
      #   method: 'none shift'
    content:
      text: (event, api) ->
        # ToDo: Refactor, refactor, refactor...
        if $(event.currentTarget).hasClass 'JS-tooltip--from-title'
          $(event.currentTarget).attr('title')
        else
          $.ajax
            url: '/definitions/' + @data('id')
            dataType: 'html'
            success: (content) ->
              api.set 'content.text', content
            error: (xhr, status, error) ->
              api.set 'content.text', status + ': ' + error

          'Loading... <i class="fa fa-spin fa-circle-o-notch"></i>'

$(document).ready Clarat.Tooltip.initializeAllTooltips
$(document).on 'page:load', Clarat.Tooltip.initializeAllTooltips
