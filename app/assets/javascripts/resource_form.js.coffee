
Global = window

class Global.ResourceFormView extends Backbone.View
  className: "resource-edit"
  events:
    "click .button":  "submit"
    "click .cancel":  "cancel"

  @INPUT_TYPES =
    big_decimal: "number",
    boolean: "checkbox",
    date: "date",
    date_time: "datetime",
    float: "number",
    integer: "number",
    string: "text",
    time: "time"

  @FIELD_BLACKLIST = ["created_at", "updated_at"]

  render: ->
    # generate form
    form = $ "<form>", class: "#{@model.resource.get "name"}"
    for field in @model.resource.fields()
      if $.inArray(field.name, ResourceFormView.FIELD_BLACKLIST) == -1
        form.append $("<label>", for: "#{@model.resource.get('name')}_#{field.name}", text: field.label)
        form.append $("<input>", type: ResourceFormView.INPUT_TYPES[field.type], name: field.name, value: @model.instance.get(field.name), required: field.required)
        form.append $("<br/>")
    form.append $("<input />", type: "submit", class: "button", value: "Save")
    form.append $("<a>", class: "cancel", text:"Cancel")

    form.bind "submit", (e) -> e.preventDefault()
    $(@el).empty().append form
    this

  cancel: ->
    Backbone.history.navigate "/#{@model.resource.get("name")}", true

  submit: ->
    values = {}
    for field in @model.resource.fields()
      values[field.name] = $("input:[name=#{field.name}]").val()
    @model.instance.save values,
      success: (model, response) =>
        Backbone.history.navigate "/#{@model.resource.get("name")}", true
      error: (model, response) =>
        alert "Error saving record!"