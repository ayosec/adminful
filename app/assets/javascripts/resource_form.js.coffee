
Global = window

class Global.ResourceFormView extends Backbone.View
  className: "resource-form"
  events:
    "click .submit":  "submit"
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
      input_classes = [ResourceFormView.INPUT_TYPES[field.type]]
      if field.required
        input_classes.push "required"
      widget = $ "<input>"
        class: input_classes.join(" ")
        id: widget_id
        type: ResourceFormView.INPUT_TYPES[field.type]
        name: field.name
        value: @model.instance.get(field.name)
        required: field.required
      label = $ "<label>", for: widget_id, text: field.label
      if field.required
        label.html label.html() + " "
        label.append $("<abbr>", title: I18n.t("resource_form.required.abbr"), text: I18n.t("resource_form.required.full"))

      $("<div>", class: "input " + input_classes.join(" "))
        .append(label)
        .append(widget)
        .appendTo(form)

    $("<div>", class: "actions")
      .append($("<button>", type: "submit", class: "submit", text: I18n.t("resource_form.actions.save")))
      .append($("<button>", class: "cancel", text: I18n.t("resource_form.actions.cancel")))
      .appendTo form

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
        $.jGrowl I18n.t("#{if @wasNew then 'create' else 'update'}.error")

  _generate_field_id: ->
    "form_field_#{ResourceFormView.generated_field_counter++}"
