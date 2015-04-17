# using qTip2
ready =  ->
  tooltip = $('.JS-tooltip')
  if tooltip.length
    tooltip.qtip
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
            url: '/definitions/' + tooltip.data('id')
            dataType: 'html'
            success: (content) ->
              api.set 'content.text', content
            error: (xhr, status, error) ->
              api.set 'content.text', status + ': ' + error

          'Loading... <i class="fa fa-spin fa-circle-o-notch"></i>'

$(document).ready ready
$(document).on 'page:load', ready
