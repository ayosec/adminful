
#= require json2
#= require underscore
#= require backbone

# Use Global identifier to (a) make clasess available outside this file and (b)
# minify the identifier (window is kept by most minifiers)
Global = window

#
# Available resources

class Global.Resource extends Backbone.Model

class Global.Resources extends Backbone.Collection
  model: Resource

class Global.ResourceLink extends Backbone.View
  tagName: "a"
  events:
    click: "open"

  render: ->
    $(@el).text @model.title
    this

  open: ->
    @app.router.navigate "/#{@model.name}", true

class Global.ResourcesBox extends Backbone.View
  className: "resources-box"

  render: ->
    el = $(@el)
    for resource in @collection
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
    @resources_box = new Global.ResourcesBox
    @resources_box.collection = @app.resources
    @resources_box.app = @app

    $("#adminful-home").
      empty().
      append @resources_box.render().el

  resource_index: (resource_name) ->
    console.log resource_name

class Global.Adminful

  constructor: (@resources) ->
    @router = new Router
    @router.app = this

    Backbone.history.start()
