# "ActiveScript" is a custom implementation of rails' Active* Style methods for
# JavaScript.
# Meant to be extended. Might be made into a gem.
class ActiveScript.Model
  constructor: (@attrs) ->
    @assignAttributes(@attrs)
    # @persistedAttributes = @attrs

  # Load stateful resource from persister. Equivalent to ActiveRecord #find
  @load: ->
    new this Clarat.Search.persister.load()
    # TODO: this shouldn't know about the Clarat namepsace

  save: ->
    Clarat.Search.persister.save(arguments...)
    # TODO: this shouldn't know about the Clarat namepsace
    # @persistedAttributes = @attributes()

  # attributes: ->
  #   attributeObject = {}
  #   for field in Clarat.Search.persister.LOADABLE_FIELDS
  #     attributeObject[field] = @[field]
  #
  #   attributeObject

  # changes: ->
  #   changeArray = []
  #   for field, oldValue in @persistedAttributes
  #     newValue = @[field]
  #     changeArray.push {field : newValue} if oldValue isnt newValue
  #
  #   changeArray

  assignAttributes: (attributes) ->
    for attribute, value of attributes
      @[attribute] = value

  updateAttributes: (attributes) ->
    @assignAttributes attributes
    @save attributes
