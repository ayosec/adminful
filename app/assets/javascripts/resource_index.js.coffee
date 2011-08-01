
Global = window

class Global.ResourcesIndex extends Backbone.View
  className: "resources-index"

  initialize: ->

    @collection = new Global[@model.collection_name()]
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

    $(@el).empty().append table
    this

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

    for field in @model.collection.resource.fields
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
    console.log "edit"
