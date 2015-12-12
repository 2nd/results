'use strict';
locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

class Results
  constructor: (@ele) ->

  show: (rows) ->
    fields = rows.pop()
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
      header += "<th#{@seal(settings[i], false)}>" + name

    html = ''
    last = 0
    index = 0
    count = 0
    lastDate = 0
    firstLine = 0
    for row, i in rows
      d = new Date(row[0])
      day = d.getDay()
      date = d.getDate()

      console.log day,last,date,lastDate,count
      if (day > last || i == 0 && count >= 7) || count >=21
        last = day
        if count >= 19 
          if date != lastDate
            html +=
            switch zero.filter
              when 'day'
                count = 0
                '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
              when 'hour'
                '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
              
        else
          html +=
          switch zero.filter
            when 'day'
              count = 0
              '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
              
            when 'hour'
              '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
            

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
      lastDate = date
      count++

    @settings = settings
    @ele.classes('-focus')
    @ele.innerHTML = html
    #@ele.innerHTML = 'hello'
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
