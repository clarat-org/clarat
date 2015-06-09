# using qTip2
Clarat.Tooltip =
  initializeAllTooltips: ->
    tooltips = $('.JS-tooltip')
    if tooltips.length
      tooltips.qtip Clarat.Tooltip.settings

  settings:
    position:
      my: 'bottom left'
      at: 'top left'
      effect: false
      viewport: $(window)
      adjust:
        method: 'none shift'
    content:
      text: (event, api) ->
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
