
Global = window

class Global.Router extends Backbone.Router
  routes:
    "":                 "home"
    "/:resource":       "resource_index"

  home: ->
    @resources_box = new ResourcesBox(collection: @app.resources)
    @resources_box.app = @app

    $("#adminful-home").
      empty().
      append @resources_box.render().el

  resource_index: (resource_name) ->
    console.log 
