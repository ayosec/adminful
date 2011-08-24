
Global = window

class Global.Router extends Backbone.Router
  routes:
    "":                     "home"
    "/:resource":           "resource_index"
    "/:resource/:id/edit":  "resource_edit"
    "/:resource/new":       "resource_new"

  home: ->
    $("#layout").empty()

  resource_new: (resource_name) ->
    collection = @app.resources[resource_name]
    if collection
      collection = new collection
      newInstance = new collection.model
      newInstance.collection = collection
      view = new ResourceFormView(model: newInstance)
      @app.set_view view

  resource_index: (resource_name) ->
    collection = @app.resources[resource_name]
    if collection
      @app.set_view new ResourcesIndex(collection: new collection)

  resource_edit: (resource_name, instance_id) ->
    collection = @app.resources[resource_name]

    if collection
      # TODO Show a message while loading the instance

      collection = new collection
      newInstance = new collection.model id: instance_id
      newInstance.collection = collection
      newInstance.fetch
        success: =>
          @app.set_view new ResourceFormView(model: newInstance)

        error: (model, response) ->
          # TODO Use I18n
          alert "Error fetching record!"
