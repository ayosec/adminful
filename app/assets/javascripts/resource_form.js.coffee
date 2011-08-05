
Global = window

class Global.ResourceFormView extends Backbone.View
  className: "resource-form"
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

  @generated_field_counter: 0

  initialize: ->
    @wasNew = @model.instance.isNew()

  render: ->
    # generate form
    form = $ "<form>", class: "#{@model.resource.get "name"}"
    for field in @model.resource.fields()
      continue if $.inArray(field.name, ResourceFormView.FIELD_BLACKLIST) != -1

      widget_id = @_generate_field_id()
      widget = $ "<input>"
        id: widget_id
        type: ResourceFormView.INPUT_TYPES[field.type]
        name: field.name
        value: @model.instance.get(field.name)
        required: field.required

      $("<div>", class: "field")
        .append($("<label>", for: widget_id, text: field.label))
        .append(widget)
        .appendTo(form)

    form.append $("<input>", type: "button", class: "button", value: "Save")
    form.append $("<a>", class: "cancel", text:"Cancel")

    form.bind "submit", (e) -> e.preventDefault()
    $(@el).empty().append form
    this

  cancel: ->
    Backbone.history.navigate "/#{@model.resource.get("name")}", true

  submit: ->

    # Check if the form is valid before send the values
    # If the browser has no support for Form#checkValidity the check will be skipped
    if $(@el).find("form").get(0).checkValidity?() == false
      return

    values = {}
    for field in @model.resource.fields()
      values[field.name] = $("input:[name=#{field.name}]").val()
    @model.instance.save values,
      success: (model, response) =>
        $.jGrowl I18n.t("#{if @wasNew then 'create' else 'update'}.success")

        Backbone.history.navigate "/#{@model.resource.get("name")}", true

      error: (model, response) =>
        alert "Error saving record!"


  _generate_field_id: ->
    "form_field_#{ResourceFormView.generated_field_counter++}"
