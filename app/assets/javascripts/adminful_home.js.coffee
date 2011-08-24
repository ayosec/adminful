
#= require json2
#= require underscore
#= require backbone
#= require_tree .

Global = window
String::camelcase = -> @replace /(^|_)(.)/g, (char) -> char.substr(-1).toUpperCase()

class Global.Adminful

  @ensureClass: (base) ->
    unless Global[base]
      class Global[base] extends Global[base + "Base"]

    Global[base]

  constructor: (@resources) ->
    @router = new Router
    @router.app = this

    Adminful.ensureClass("HomeView")
    $("#resources-links").append (new HomeView @resources).render()

    Backbone.history.start()

  set_view: (view) ->
    view.app = @
    $("#layout").
      empty().
      append view.render().el

