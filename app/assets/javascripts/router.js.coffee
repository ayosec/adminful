
Global = window

class Global.Router extends Backbone.Router
  routes:
    "":                     "home"
    "/:resource":           "resource_index"
    "/:resource/:id/edit":  "resource_edit"

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

  resource_edit: (resource_name, instance_id) ->
    # need the model definition to know which fields we need to display
    resource = @app.resources.detect (r) -> r.get("name") == resource_name

    # instantiate the resource
    if resource
      instance = new Global[resource.get("model").name](id: instance_id)

    if resource && instance
      instance.fetch
        success: (model, response) =>
          @set_view new ResourceFormView
            model:
              resource: resource
              instance: instance
        error: (model, response) =>
          alert "Error fetching record!"
    else
      alert("Record not found!")
