class Clarat.QueryFieldPlaceholder.Presenter extends ActiveScript.Presenter
  firstPlaceholderInterval: 3000
  nextPlaceholderInterval: 6000
  nextConstructionStepInterval: 40
  currentConstructionState: ''
  # Attention: choosable words may not be longer than
  # nextPlaceholderInterval / nextConstructionStepInterval (currently 40 chars)

  constructor: ->
    super()
    @queryField = $('#search_form_query')
    if @queryField.length
      @model = new Clarat.QueryFieldPlaceholder.Model
      _.delay @handlePlaceholderTick, @firstPlaceholderInterval, @

  # NO CALLBACKS - manually triggered via timed interval

  # Tick for a new randomized placeholder:
  # Chooses one, then starts letter-by-letter constructing
  handlePlaceholderTick: =>
    # when field is in focus …
    if @queryField.is(':focus')
      # … get a random placeholder …
      placeholder = @model.randomPlaceholder()
      # … and put it character by character into the field
      @handleConstructionTick(
        I18n.t 'js.query_field.example_placeholder', word: placeholder
      )

      # do it again in a few seconds
      _.delay @handlePlaceholderTick, @nextPlaceholderInterval

  # construct placeholder words one character at a time
  handleConstructionTick: (placeholder) =>
    currentLength = @currentConstructionState.length

    if currentLength < placeholder.length
      @currentConstructionState = placeholder.substr 0, (currentLength + 1)
      @queryField.attr 'placeholder', @currentConstructionState

      _.delay(
        @handleConstructionTick, @nextConstructionStepInterval, placeholder
      )
    else
      @currentConstructionState = ''

$(document).ready ->
  new Clarat.QueryFieldPlaceholder.Presenter
