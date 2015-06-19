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
        # ToDo: Refactor, refactor, refactor...
        if event.currentTarget.id == 'google_translate_element'
          'Hier kannst du dir clarat in andere Sprachen übersetzen lassen. Die
          Übersetzungen werden automatisch gemacht. In solchen Übersetzungen
          gibt es oft sprachliche Fehler. Es kann also sein, dass etwas komisch
          klingt. Schau dann lieber noch einmal in den deutschen Text.'
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
