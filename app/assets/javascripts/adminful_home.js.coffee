
#= require json2
#= require underscore
#= require backbone

#
# Handy methods

String::camelcase = -> @replace /(^|_)(.)/g, (char) -> char.substr(-1).toUpperCase()

# Use Global identifier to (a) make clasess available outside this file and (b)
# minify the identifier (window is kept by most minifiers)
Global = window

#
# Available resources

class Global.Resource extends Backbone.Model

  initialize: ->
    # TODO: Listen to bind("change") to update the model if the definition changes

    model = @get("model")

    # A Backbone.Model for the application model
    Global[model.name] = Backbone.Model.extend fields: model.fields

    # A Backbone.Collection for the application resource
    Global[@get("name").camelcase()] = Backbone.Collection.extend
      model: Global[model.name]
      resource: model
      url: @get("index_path")


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

#
# Router
class Global.Router extends Backbone.Router
  routes:
    "":                 "home"
    "/:resource":       "resource_index"

  home: ->
    @resources_box = new Global.ResourcesBox(collection: @app.resources)
    @resources_box.app = @app

    $("#adminful-home").
      empty().
      append @resources_box.render().el

  resource_index: (resource_name) ->
    console.log 

class Global.Adminful

  constructor: (resources) ->
    @resources = new Resources(resources)
    @router = new Router
    @router.app = this

    Backbone.history.start()

