
#= require json2
#= require underscore
#= require backbone
#= require_tree .

Global = window
String::camelcase = -> @replace /(^|_)(.)/g, (char) -> char.substr(-1).toUpperCase()

class Global.Adminful

  constructor: (resources) ->
    @resources = new Resources(resources)
    @router = new Router
    @router.app = this

    resources_box = new ResourcesBox(collection: @resources)
    resources_box.app = this
    $("#resources-links").append resources_box.render().el

    Backbone.history.start()

