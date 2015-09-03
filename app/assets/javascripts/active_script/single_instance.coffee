###
Friends don't let friends write Singletons. But we don't want multiple instances
of certain things floating around.
###
class ActiveScript.SingleInstance
  _already_initialized: null

  constructor: ->
    debugger if @_already_initialized
    throw 'Already Initialized' if @_already_initialized
    @_already_initialized = true
