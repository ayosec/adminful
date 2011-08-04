
Global = window
FIELD_MAPPINGS = {
  #array: ?,
  big_decimal: "number",
  boolean: "checkbox",
  date: "date",
  date_time: "datetime",
  float: "number",
  #hash: ?,
  integer: "number",
  string: "text",
  #symbol: ?,
  time: "time"
}

class Global.ResourceFormView extends Backbone.View
  className: "resource-edit"
  events:
    "click .button":  "submit"
    "click .cancel":  "cancel"

  render: ->

    # generate form
    form = $ "<form>", class: "#{@model.resource.get "name"}"
    for field in @model.resource.fields()
      form.append $("<label>", for: "#{@model.resource.get('name')}_#{field.name}", text: field.label)
      form.append $("<input>", type: FIELD_MAPPINGS[field.type], name: "#{@model.resource.get('name')}[#{field.name}]", id: "#{@model.resource.get('name')}_#{field.name}", value: @model.instance.get(field.name), required: true)
      form.append $("<br/>")
    form.append $("<input />", type: "submit", class: "button", value: "Save")
    form.append $("<a>", class: "cancel", text:"Cancel")

    $(@el).empty().append form
    this

  cancel: ->
    alert("cancel")
    # redirect to resource index

  submit: ->
    alert("submit")
    #for field in @model.resource.fields()
      #assign value from field
    @model.instance.save
