
class Global.ResourcesIndex extends Backbone.View
  className: "resources-index"
  events:
    "click .actions .new":  "actionNew"
    "click .batch-delete": "batchDelete"

  initialize: ->

    @collection.bind "reset", =>
      @loadingRecords = false
      @render()

    @loadingRecords = true
    @collection.fetch()

  render: ->
    if @loadingRecords
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

  actionNew: ->
    Backbone.history.navigate "/#{@collection.resource.name}/new", true

  batchDelete: ->
    checkboxes = $("input.batch-delete-resource:checked")
    if checkboxes.length == 0
      $.jGrowl I18n.t("resource_index.batch_operations.none_selected")
    else
      for input in checkboxes
        $(input).data("instance").destroy()

class Global.ResourceRow extends Backbone.View
  tagName: "tr"

  events:
    "click .actions .remove":  "actionRemove"
    "click .actions .edit":    "actionEdit"

  initialize: ->
    @model.bind "remove", => @remove()
    @model.bind "change", => @render()

  render: ->
    $(@el).empty()
    checkboxCol = $("<td>")
    checkboxInput = $ "<input>",
                        type: "checkbox",
                        name: @model.id, value: "1",
                        class: "batch-delete-resource"
                        data:
                          instance: @model
    checkboxCol.append checkboxInput
    checkboxCol.appendTo @el


    for field in @model.collection.resource.fields
      $("<td>", text: @model.get(field.name)).appendTo @el

    actions = $ "<td>", class: "actions"
    actions.append $("<a>", class: "edit", text: I18n.t("resource_index.actions.edit"))
    actions.append $("<a>", class: "remove", text: I18n.t("resource_index.actions.remove"))
    actions.appendTo @el

    this

  actionRemove: ->
    return unless confirm(I18n.t("resource_index.actions.confirm_remove"))
    @model.destroy()

  actionEdit: ->
    view = new ResourceFormView(model: @model)
    @app.setView view
    Backbone.history.navigate "/#{@model.collection.resource.name}/#{@model.id}/edit", false

