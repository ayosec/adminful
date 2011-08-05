
Global = window

class Global.ResourcesIndex extends Backbone.View
  className: "resources-index"
  events:
    "click .actions .new":  "action_new"

  initialize: ->

    @collection = new Global[@model.instanceCollectionClass()]
    @collection.bind "reset", =>
      @loading_records = false
      @render()

    @loading_records = true
    @collection.fetch()

  render: ->
    if @loading_records
      $(@el).text I18n.t("resource_index.loading")
      return this

    table = $ "<table>", class: "#{@model.get "name"}-index"

    # Header with column names
    header = $("<thead>").appendTo(table)
    for field in @model.fields()
      header.append $("<th>", text: field.label)

    header.append $("<th>", text: " ", class: "actions")

    # Every row is a ResourceRow instance
    body = $("<tbody>").appendTo(table)
    @collection.each (instance) =>
      body.append (new ResourceRow(model: instance)).render().el


    actions = $ "<div>", class: "actions"
    actions.append $("<a>", class: "new", text: I18n.t("resource_index.actions.new"))

    $(@el).empty().append table
    $(@el).append actions
    this

  action_new: ->
    view = new ResourceFormView
      model:
        resource: @model
        instance: new Global[@model.get("model").name]
    view.app = @app
    $("#layout").
      empty().
      append view.render().el
    Backbone.history.navigate "/#{@model.get("name")}/new", false

class Global.ResourceRow extends Backbone.View
  tagName: "tr"

  events:
    "click .actions .remove":  "action_remove"
    "click .actions .edit":    "action_edit"

  initialize: ->
    @model.bind "remove", => @remove()
    @model.bind "change", => @render()

  render: ->
    $(@el).empty()

    for field in @model.collection.resource.get("model").fields
      $("<td>", text: @model.get(field.name)).appendTo @el

    actions = $ "<td>", class: "actions"
    actions.append $("<a>", class: "edit", text: I18n.t("resource_index.actions.edit"))
    actions.append $("<a>", class: "remove", text: I18n.t("resource_index.actions.remove"))
    actions.appendTo @el

    this

  action_remove: ->
    return unless confirm(I18n.t("resource_index.actions.confirm_remove"))
    @model.destroy()

  action_edit: ->
    view = new ResourceFormView
      model:
        resource: @model.collection.resource
        instance: @model
    view.app = @app
    $("#layout").
      empty().
      append view.render().el
    Backbone.history.navigate "/#{@model.collection.resource.get("name")}/#{@model.id}/edit", false