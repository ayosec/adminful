
window.Global = window
String::camelcase = -> @replace /(^|_)(.)/g, (char) -> char.substr(-1).toUpperCase()

Global.prepareCustomClass = (cls, defaultBase = "#{cls}Base") ->
    unless Global[cls]
      class Global[cls] extends Global[defaultBase]

    Global[cls]
