# "ActiveScript" is a custom implementation of rails' Active* Style methods for
# JavaScript.
# Meant to be extended. Might be made into a gem.
class ActiveScript.Model
  constructor: (@attrs) ->
    @assignAttributes(@attrs)

  # Load stateful resource from persister. Equivalent to ActiveRecord #find
  @load: ->
    new this Clarat.Search.persister.load()
    # TODO: this shouldn't know about the Clarat namepsace

  save: ->
    Clarat.Search.persister.save()
    # TODO: this shouldn't know about the Clarat namepsace

  assignAttributes: (attributes) ->
    for attribute, value of attributes
      @[attribute] = value

  updateAttributes: (attributes) ->
    @assignAttributes(attributes)
    @save()
