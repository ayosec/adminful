
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

  @generatedFieldCounter: 0

  initialize: ->
    @wasNew = @model.isNew()

  render: ->
    # generate form
    form = $ "<form>", class: "#{@model.collection.resource.name}"
    for field in @model.collection.resource.fields
      continue if $.inArray(field.name, ResourceFormView.FIELD_BLACKLIST) != -1

      widgetId = @_generateFieldId()
      inputClasses = [ResourceFormView.INPUT_TYPES[field.type]]
      if field.required
        inputClasses.push "required"
      widget = $ "<input>"
        class: inputClasses.join(" ")
        id: widgetId
        type: ResourceFormView.INPUT_TYPES[field.type]
        name: field.name
        value: @model.get(field.name)
        required: field.required
      label = $ "<label>", for: widgetId, text: field.label
      if field.required
        label.html label.html() + " "
        label.append $("<abbr>", title: I18n.t("resource_form.required.abbr"), text: I18n.t("resource_form.required.full"))

      $("<div>", class: "field " + inputClasses.join(" "))
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
    Backbone.history.navigate "/#{@model.collection.resource.name}", true

  submit: ->

    # Check if the form is valid before send the values
    # If the browser has no support for Form#checkValidity the check will be skipped
    if $(@el).find("form").get(0).checkValidity?() == false
      return

    values = {}
    for field in @model.collection.resource.fields
      values[field.name] = $("input:[name=#{field.name}]").val()
    @model.save values,
      success: (model, response) =>
        $.jGrowl I18n.t("#{if @wasNew then 'create' else 'update'}.success")

        Backbone.history.navigate "/#{@model.collection.resource.name}", true

      error: (model, response) =>
        $.jGrowl I18n.t("#{if @wasNew then 'create' else 'update'}.error")

  _generateFieldId: ->
    "form_field_#{ResourceFormView.generatedFieldCounter++}"
