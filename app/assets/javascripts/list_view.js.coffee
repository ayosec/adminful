
class Global.ListViewBase extends Backbone.View
  className: "resources-index"
  events:
    "click    .actions .new":  "actionNew"
    "change   .batch-global":  "toggleBatchGlobal"
    "change   .batch-action":  "updateBatchGlobal"

  initialize: ->

    @collection.bind "reset", =>
      @loadingRecords = false
      @render()

    @loadingRecords = true
    @collection.fetch()

    @rowClass = prepareCustomClass(@collection.model::modelName + "ListRow", "ListViewRowBase")

  tableFields: ->
    if @fieldNames
      fieldNames = @fieldNames()
      _.select(
        @collection.resource.fields,
        (field) -> _.indexOf(fieldNames, field.name) != -1
      )
    else
      @collection.resource.fields

  render: ->
    if @loadingRecords
      $(@el).text I18n.t("resource_index.loading")
      return this

    table = $ "<table>", class: "#{@collection.resource.name}-index"
    table.append @renderHeader()

    body = $("<tbody>").appendTo(table)
    for instance in @collection.models
      body.append @renderRow(instance)

    batch = @generateBatchActions()

    actions = $ "<div>", class: "actions"
    actions.append $("<button>", class: "new", text: I18n.t("resource_index.actions.new"))

    $(@el).empty()
    if @collection.length > 0
      $(@el).append batch
    $(@el).append table
    if @collection.length > 0
      $(@el).append batch.clone(true)
    $(@el).append actions
    this

  renderHeader: ->
    # Header with column names
    header = $("<thead>")

    # Checkbox for batch operations
    $("<input>", type: "checkbox", class: "batch-global").appendTo($("<th>", class: "batch-global").appendTo(header))

    for field in @tableFields()
      header.append $("<th>", text: field.label, class: "#{field.name}-column")

    header.append $("<th>", text: " ", class: "actions")

    header

  renderRow: (instance) ->
    rowView = new @rowClass(model: instance)
    rowView.parent = this
    rowView.app = @app
    rowView.render().el

  actionNew: ->
    Backbone.history.navigate "/#{@collection.resource.name}/new", true

  batchActions: ->
    [
      text: I18n.t("resource_index.batch_operations.delete.button")
      class: "batch-delete"
      click: => @batchDelete()
    ]

  toggleBatchGlobal: ->
    @$("input.batch-action").attr("checked", @$("input.batch-global").get(0).checked)

  updateBatchGlobal: ->
    @$("input.batch-global").attr("checked", _.all(@$("input.batch-action"), (input) -> input.checked))

  generateBatchActions: ->
    batch = $ "<div>", class: "batch-operations"
    for action in @batchActions()
      $("<button>", action).appendTo batch
    batch

  instancesGetSelection: (alertIfEmpty = true) ->
    checkboxes = $("input.batch-action:checked", @el)
    if checkboxes.length == 0
      $.jGrowl I18n.t("resource_index.batch_operations.none_selected") if alertIfEmpty
      []
    else
      $(input).data("instance") for input in checkboxes

  instancesClearSelection: ->
    @$("input.batch-action, input.batch-global").attr "checked", false

  batchDelete: ->
    for instance in @instancesGetSelection()
      instance.destroy()
    return

class Global.ListViewRowBase extends Backbone.View
  tagName: "tr"

  events:
    "click .actions .remove":  "actionRemove"
    "click .actions .edit":    "actionEdit"

  initialize: ->
    @model.bind "remove", => @remove()
    #@model.bind "change", => @render()

  render: ->
    $(@el).empty()
    checkboxCol = $("<td>", class: "batch")
    checkboxInput = $ "<input>",
                        type: "checkbox"
                        class: "batch-action"
                        data:
                          instance: @model
    checkboxCol.append checkboxInput
    checkboxCol.appendTo @el


    for field in @parent.tableFields()
      @renderCell(field).appendTo @el

    actions = $ "<td>", class: "actions"
    actions.append $("<a>", class: "edit", text: I18n.t("resource_index.actions.edit"))
    actions.append $("<a>", class: "remove", text: I18n.t("resource_index.actions.remove"))
    actions.appendTo @el

    this

  renderCell: (field) ->
    field_name = field.name
    cell = $ "<td>", class: "#{field_name}-column"

    self = @
    renderMethod = @["cell#{field_name.camelcase()}"] ? @defaultCellRender
    renderHandler = -> renderMethod.call(self, cell, field)

    do renderHandler
    @model.bind "change:#{field_name}", ->
      self.animateCell cell
      cell.empty()
      renderHandler()
    cell

  animateCell: (cell) ->
    cell.css "opacity", 0
    cell.animate opacity: 1

  defaultCellRender: (cell, field) ->
    cell.text @model.get(field.name)

  actionRemove: ->
    return unless confirm(I18n.t("resource_index.actions.confirm_remove"))
    @model.destroy()

  actionEdit: ->
    view = new ResourceFormView(model: @model)
    @app.setView view
    Backbone.history.navigate "/#{@model.collection.resource.name}/#{@model.id}/edit", false

