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

  graphWrapper = $('#graph-wrapper')
  if graphWrapper
    rawData = $('#graph-wrapper').data('stats');
    graphData = []
    seriesInfo = {}

    for key, value of rawData
      seriesInfo[graphData.length] = key

      series =
        data: value
        color: '#71c73e'

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
    $.plot $('#graph-lines'), graphData,
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
    $.plot $('#graph-bars'), graphData,
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

    $('#graph-bars').hide()

    $('#lines').on 'click', (e) ->
      $('#bars').removeClass 'active'
      $('#graph-bars').fadeOut()
      $(this).addClass 'active'
      $('#graph-lines').fadeIn()
      e.preventDefault()

    $('#bars').on 'click', (e) ->
      $('#lines').removeClass 'active'
      $('#graph-lines').fadeOut()
      $(this).addClass 'active'
      $('#graph-bars').fadeIn().removeClass 'hidden'
      e.preventDefault()


    showTooltip = (x, y, contents) ->
      $('<div id="tooltip">' + contents + '</div>').css(
        top: y - 16
        left: x + 20
      ).appendTo('body').fadeIn()

    previousPoint = null

    $('#graph-lines, #graph-bars').bind 'plothover', (event, pos, item) ->
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

