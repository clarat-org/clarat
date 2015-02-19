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

  category_input = $(".js-category-suggestions__trigger input")
  if category_input.length
    elem = $(
      "<div style='margin:10px;display:inline-block;width:300px;'></div>")
    $(".js-category-suggestions .controls .help-block").before elem

    category_input.on 'blur', (e) ->
      name = category_input.val()

      $.get "/categories/#{name}.json", (category_array) ->
        if category_array.length
          display = "Ähnliche Angebote verwenden folgende Kategorien:<br>
                    #{category_array.join(', ')}"
        else
          display = "Es gibt keine Kategorien für Angebote mit genau diesem
                    Namen."

        elem.html display
