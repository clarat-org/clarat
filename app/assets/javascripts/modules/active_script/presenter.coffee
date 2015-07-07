# "ActiveScript" is a custom implementation of rails' Active* Style methods for
# JavaScript.
# Meant to be extended. Might be made into a gem.
window.ActiveScript ?= {}
class ActiveScript.Presenter extends ActiveScript.Singleton
  constructor: ->
    # Presenters are two-way streets. We render via the presenter and callbacks give information back.
    @registerCallbacks()

  # render a template to the current browser view
  render: (wrapperSelector, template, locals) ->
    $(wrapperSelector).html HandlebarsTemplates[template] locals

  ### PRIVATE METHODS (ue) ###

  # Callbacks are defined as
  # CALLBACKS = {selector: {eventName: callbackFunction}}
  registerCallbacks: ->
    for selector, callback of @CALLBACKS
      for event, method of callback
        $('body').on event, selector, @[method]
    return
