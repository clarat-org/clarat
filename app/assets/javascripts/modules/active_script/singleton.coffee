###
Extendable class to implement the Singleton Design Pattern
###
window.ActiveScript ?= {}
class ActiveScript.Singleton
  @_instance: null
  @get: ->
    @_instance ?= new @( arguments... )
