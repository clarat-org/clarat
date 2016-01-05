class Clarat.QueryFieldPlaceholder.Model
  currentPlaceholder: ''

  constructor: ->
    @section = $('body').data('section')
    @placeholderWords =
      I18n.t("js.query_field.placeholder_words.#{@section}")

  # get a random element of the list (except the current one)
  randomPlaceholder: ->
    potentialWords = _.without @placeholderWords, @currentPlaceholder
    @currentPlaceholder = _.sample potentialWords
