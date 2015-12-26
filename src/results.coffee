'use strict';
locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

class Results
  constructor: (@ele) ->

  show: (rows) ->
    fields = rows[rows.length - 1]
    #console.log fields
    zero = fields[0]

    header = ''
    settings = {0: zero}
    for i in [1...fields.length] by 1
      field = fields[i]
      name = field
      if field.name
        settings[i] = field
        name = field.name
        zero.parent = i
      header += "<th>" + name

    html = ''
    last = 0
    index = 0
    for row, i in rows
      d = new Date(row[0])
      day = d.getDay()
      if day > last ||  i == 0
        html +=
        switch zero.filter
          when 'day'
            '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
          when 'hour'
            '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header

        index = 0
      last = day

      html += '<tr' + (if index % 2 == 1 then ' class=o' else '') + '><td class=filter>'
      html +=
      switch zero.filter
        when 'day'
          "<span>" + locale.weekdays[day] + ' ' + d.getDate() + '</span>'
        when 'hour'
          "<span>" + d.getHours() + ':00</span>'


      for i in [1...row.length]
        value = row[i]
        if s = settings[i]
          html += "<td#{@seal(s, true)}>"
          if s.filter
            html += '<span>' + value + '</span>'
          else
            html += value
        else
            html += '<td>' + value
      index++

    @settings = settings
    @ele.classes('-focus')
    @ele.innerHTML = html
    @cells = $(@ele, 'td')
    @fields = fields.length
    null

  seal: (settings, data) ->
    return '' unless settings?
    cls = ''
    attributes = ''

    cls += 'left' if settings.align == 'left'
    cls += ' filter' if data && settings.filter
    attributes += ' class="' + cls + '"' if cls.length != 0
    attributes

window.Results = Results
