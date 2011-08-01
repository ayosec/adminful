
window.I18n =

  t: (id) ->
    dict = Adminful.LocaleStrings
    for key in id.split(".")
      dict = dict[key]
      if not dict?
        return "Unknown translation for #{id}"

    dict

  count: (id, count) ->
    hash = I18n.t(id)
    switch count
      when 0
        pattern = hash.zero ? hash.other
      when 1
        pattern = hash.one ? hash.other
      else
        pattern = hash.other

    pattern.replace "{{count}}", count
