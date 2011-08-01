
Global = window

class Global.Resource extends Backbone.Model

  initialize: ->
    # TODO: Listen to bind("change") to update the model if the definition changes

    model = @get("model")

    # A Backbone.Model for the application model
    Global[model.name] = Backbone.Model.extend fields: model.fields

    # A Backbone.Collection for the application resource
    Global[@collection_name()] = Backbone.Collection.extend
      model: Global[model.name]
      resource: model
      url: @get("index_path")

  collection_name: ->
    @get("name").camelcase()

  fields: ->
    @get("model").fields

class Global.Resources extends Backbone.Collection
  model: Resource

class Global.ResourceLink extends Backbone.View
  tagName: "a"
  events:
    click: "open"

  render: ->
    $(@el).text @model.get("title")
    this

  open: ->
    @app.router.navigate "/#{@model.get("name")}", true

class Global.ResourcesBox extends Backbone.View
  className: "resources-box"

  render: ->
    el = $(@el)
    @collection.each (resource) =>
      link = new ResourceLink(model: resource)
      link.app = @app
      el.append link.render().el

    this

