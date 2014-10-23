# = require jquery.flot
# = require jquery.flot.resize

$(document).on 'rails_admin.dom_ready', ->

  # Character Counter

  $.fn.extend
    counter: (elem) ->
      $(@).on "keyup focus", ->
        setCount @, elem

      setCount = (src, elem) ->
        elem.html src.value.length

      setCount $(@)[0], elem


  inputs = $(".js-count-character textarea")
  if inputs.length
    for input in inputs
      elem = $("<span style='margin-left:10px'></span>")
      $(input).after elem
      $(input).counter elem


  # Statistics Page

  graphWrapper = $('.graph-wrapper')
  graphWrapper.each (index, wrapper) ->
    $wrapper = $(wrapper)
    rawData = $wrapper.data('stats');
    graphData = []
    seriesInfo = {}
    colors = ['#71C73E', '#77B7C5'] #, '#D4D137', '#B474CE', '#7A3A20'

    for key, value of rawData
      seriesInfo[graphData.length] = key

      series =
        data: value
        color: colors[graphData.length]

      graphData.push series

    # graphData = [
    #   # Visits
    #   data: [ [6, 1300], [7, 1600], [8, 1900], [9, 2100], [10, 2500], [11, 2200], [12, 2000], [13, 1950], [14, 1900], [15, 2000] ]
    #   color: '#71c73e'
    # ,
    #   # Returning Visits
    #   data: [ [6, 500], [7, 600], [8, 550], [9, 600], [10, 800], [11, 900], [12, 800], [13, 850], [14, 830], [15, 1000] ]
    #   color: '#77b7c5'
    #   points:
    #     radius: 4
    #     fillColor: '#77b7c5'
    # ]

    # Line Chart
    lines = $wrapper.find('.graph-lines')
    $.plot lines, graphData,
      series:
        points:
          show: true
          radius: 5
        lines:
          show: true
        shadowSize: 0
      grid:
        color: '#646464'
        borderColor: 'transparent'
        borderWidth: 20
        hoverable: true

    # Bar Chart
    bars = $wrapper.find('.graph-bars')
    $.plot bars, graphData,
      series:
        bars:
          show: true
          barWidth: 0.9
          align: 'center'
        shadowSize: 0
      grid:
        color: '#646464'
        borderColor: 'transparent'
        borderWidth: 20
        hoverable: true

    bars.hide()

    linesBtn = $wrapper.find('.lines')
    barsBtn = $wrapper.find('.bars')

    linesBtn.on 'click', (e) ->
      barsBtn.removeClass 'active'
      bars.fadeOut()
      $(this).addClass 'active'
      lines.fadeIn()
      e.preventDefault()

    barsBtn.on 'click', (e) ->
      linesBtn.removeClass 'active'
      lines.fadeOut()
      $(this).addClass 'active'
      bars.fadeIn().removeClass 'hidden'
      e.preventDefault()


    showTooltip = (x, y, contents) ->
      $('<div id="tooltip">' + contents + '</div>').css(
        top: y - 16
        left: x + 20
      ).appendTo('body').fadeIn()

    previousPoint = null

    $wrapper.find('.graph-lines, .graph-bars').bind 'plothover', (event, pos, item) ->
      if item
        if previousPoint isnt item.dataIndex
          previousPoint = item.dataIndex
          $('#tooltip').remove()
          x = item.datapoint[0]
          y = item.datapoint[1]
          showTooltip(item.pageX, item.pageY, "#{y} #{seriesInfo[item.seriesIndex]} in calendar week #{x}")
      else
        $('#tooltip').remove()
        previousPoint = null

