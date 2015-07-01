# "ActiveScript" is a custom implementation of rails' Active* Style methods for
# JavaScript.
# Meant to be extended. Might be made into a gem.
window.ActiveScript ?= {}
class ActiveScript.Controller
  # A Controller should be a singleton
  constructor: ->
    return Clarat.Search.controller if Clarat.Search.controller

  # render a template to the current browser view
  render: (template, locals) ->
    $('.content-main').html HandlebarsTemplates[template] locals
