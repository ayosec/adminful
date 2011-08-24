
Global = window

class Global.HomeViewBase
  constructor: (@resources) ->

  render: ->
    items = $("<ul>")
    for own pathName, collection of @resources
      $ "<a>"
        text: collection::resource.label
        href: "#/#{pathName}"
      .appendTo $("<li>").appendTo(items)

    items
