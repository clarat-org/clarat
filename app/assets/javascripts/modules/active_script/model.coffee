# "ActiveScript" is a custom implementation of rails' Active* Style methods for
# JavaScript.
# Meant to be extended. Might be made into a gem.
window.ActiveScript ?= {}
class ActiveScript.Model
  constructor: (@attrs) ->
    for attribute, value of @attrs
      @[attribute] = value
