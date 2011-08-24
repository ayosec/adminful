
Global = window

class Global.ResourcesIndex extends Backbone.View
  className: "resources-index"
  events:
    "click .actions .new":  "action_new"
    "click .batch-delete": "batch_delete"

  initialize: ->

    @collection.bind "reset", =>
      @loading_records = false
      @render()

    @loading_records = true
    @collection.fetch()

  render: ->
    if @loading_records
      $(@el).text I18n.t("resource_index.loading")
      return this

    table = $ "<table>", class: "#{@collection.resource.name}-index"

    # Header with column names
    header = $("<thead>").appendTo(table)
    header.append $("<th>") # we will place the checkbox for each row here for batch operations
    for field in @collection.resource.fields
      header.append $("<th>", text: field.label)

    header.append $("<th>", text: " ", class: "actions")

    # Every row is a ResourceRow instance
    body = $("<tbody>").appendTo(table)
    @collection.each (instance) =>
      rowView = new ResourceRow(model: instance)
      rowView.app = @app
      body.append rowView.render().el


    batch = $ "<div>", class: "batch-operations"
    batch.append $("<button>", class: "batch-delete", text: I18n.t("resource_index.batch_operations.delete.button"))

    actions = $ "<div>", class: "actions"
    actions.append $("<button>", class: "new", text: I18n.t("resource_index.actions.new"))

    $(@el).empty()
    if @collection.length > 0
      $(@el).append batch
    $(@el).append table
    if @collection.length > 0
      $(@el).append batch.clone()
    $(@el).append actions
    this

  action_new: ->
    Backbone.history.navigate "/#{@collection.resource.name}/new", true

  batch_delete: ->
    checkboxes = $("input.batch-delete-resource:checked")
    if checkboxes.length == 0
      $.jGrowl I18n.t("resource_index.batch_operations.none_selected")
    else
      for input in checkboxes
        $(input).data("instance").destroy()

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
    checkbox_col = $("<td>")
    checkbox_input = $ "<input>",
                        type: "checkbox",
                        name: @model.id, value: "1",
                        class: "batch-delete-resource"
                        data:
                          instance: @model
    checkbox_col.append checkbox_input
    checkbox_col.appendTo @el


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
    view = new ResourceFormView(model: @model)
    @app.set_view view
    Backbone.history.navigate "/#{@model.collection.resource.name}/#{@model.id}/edit", false

