
Global = window

class Global.Router extends Backbone.Router
  routes:
    "":                 "home"
    "/:resource":       "resource_index"

  set_view: (view) ->
    view.app = @app
    $("#adminful-home").
      empty().
      append view.render().el

  home: ->
    @set_view new ResourcesBox(collection: @app.resources)

  resource_index: (resource_name) ->
    resource = @app.resources.detect (r) -> r.get("name") == resource_name
    if resource
      @set_view new ResourcesIndex(model: resource)
