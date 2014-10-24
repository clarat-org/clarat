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
