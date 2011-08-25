
class Global.Router extends Backbone.Router
  routes:
    "":                     "home"
    "/:resource":           "resourceIndex"
    "/:resource/:id/edit":  "resourceEdit"
    "/:resource/new":       "resourceNew"

  home: ->
    $("#layout").empty()

  resourceNew: (resourceName) ->
    collection = @app.resources[resourceName]
    if collection
      collection = new collection
      newInstance = new collection.model
      newInstance.collection = collection
      view = new ResourceFormView(model: newInstance)
      @app.setView view

  resourceIndex: (resourceName) ->
    collection = @app.resources[resourceName]
    if collection
      collection = new collection
      viewClass = prepareCustomClass(collection.resource.className + "ListView", "ListViewBase")
      @app.setView new viewClass(collection: collection)

  resourceEdit: (resourceName, instanceId) ->
    collection = @app.resources[resourceName]

    if collection
      # TODO Show a message while loading the instance

      collection = new collection
      newInstance = new collection.model id: instanceId
      newInstance.collection = collection
      newInstance.fetch
        success: =>
          @app.setView new ResourceFormView(model: newInstance)

        error: (model, response) ->
          # TODO Use I18n
          alert "Error fetching record!"
