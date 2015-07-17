###
Extendable class to implement the Singleton Design Pattern
###
class ActiveScript.Singleton
  @_instance: null
  @get: ->
    @_instance ?= new @( arguments... )
