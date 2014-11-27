$(document).on 'rails_admin.dom_ready', ->

  # Character Counter

  $.fn.extend
    counter: (elem) ->
      $(@).on "keyup focus", ->
        setCount @, elem

      setCount = (src, elem) ->
        elem.html src.value.length

      setCount $(@)[0], elem


  count_inputs = $(".js-count-character textarea")
  if count_inputs.length
    for input in count_inputs
      elem = $("<span style='margin-left:10px'></span>")
      $(input).after elem
      $(input).counter elem


  # Tag Suggestions

  tag_input = $(".js-tag-suggestions__trigger input")
  if tag_input.length
    elem = $(
      "<div style='margin:10px;display:inline-block;width:300px;'></div>")
    $(".js-tag-suggestions .controls .help-block").before elem

    tag_input.on 'blur', (e) ->
      name = tag_input.val()

      $.get "/tags/#{name}.json", (tag_array) ->
        if tag_array.length
          display = "Ähnliche Angebote verwenden folgende Tags:<br>
                    #{tag_array.join(', ')}"
        else
          display = "Es gibt keine Tags für Angebote mit genau diesem Namen."

        elem.html display

