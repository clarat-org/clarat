$(document).on 'rails_admin.dom_ready', ->
  $.fn.extend
    counter: (elem) ->
      $(@).on "keyup focus", ->
        setCount @, elem

      setCount = (src, elem) ->
        elem.html src.value.length

      setCount $(@)[0], elem


  input = $(".js-count-character textarea")
  if input.length
    elem = $("<span style='margin-left:10px'></span>")
    input.after elem
    input.counter elem
