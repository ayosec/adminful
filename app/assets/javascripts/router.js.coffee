
Global = window

class Global.Router extends Backbone.Router
  routes:
    "":                 "home"
    "/:resource":       "resource_index"

  set_view: (view) ->
    view.app = @app
    $("#layout").
      empty().
      append view.render().el

  home: ->
    $("#layout").empty()

  resource_index: (resource_name) ->
    resource = @app.resources.detect (r) -> r.get("name") == resource_name
    if resource
      @set_view new ResourcesIndex(model: resource)
