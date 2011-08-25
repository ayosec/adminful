
#= require json2
#= require underscore
#= require backbone
#= require adminful_base
#= require_tree .

class Global.Adminful

  constructor: (@resources) ->
    @router = new Router
    @router.app = this

    prepareCustomClass("HomeView")
    $("#resources-links").append (new HomeView @resources).render()

    Backbone.history.start()

  setView: (view) ->
    @currentView = view
    view.app = @
    $("#layout").
      empty().
      append view.render().el

