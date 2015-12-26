'use strict';
locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
weekdayIndex = {'Sun':6, 'Mon':5, 'Tue':4, 'Wed':3, 'Thu':2, 'Fri':1, 'Sat':0}

weekdayIndex = {'Sun':6, 'Mon':5, 'Tue':4, 'Wed':3, 'Thu':2, 'Fri':1, 'Sat':0}
class Results
  constructor: (@ele) ->

  show: (rows, weekday, filters) ->
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
      console.log(name)

    html = ''
    last = 0
    index = 0
    for row, i in rows
      d = new Date(row[0])
      day = d.getDay()
      remain = (day + weekdayIndex[weekday]) % 7
      if remain > last ||  i == 0
        html +=
        switch zero.filter
          when 'day'
            '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
          when 'hour'
            '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header

        index = 0
      last = remain

      html += '<tr' + (if index % 2 == 1 then ' class=o' else '') + '><td class=filter>'
      html +=
      switch zero.filter
        when 'day'
          "<span>" + locale.weekdays[day] + ' ' + d.getDate() + '</span>'
        when 'hour'
          "<span>" + d.getHours() + ':00</span>'

      console.log filters
      for i in [1...filters]
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

      if filters?
        for i in [filters...row.length]
          valueRaw = row[i][0]
          value = Number(Math.abs(Math.round(valueRaw * 100).toFixed(5))) + '%'
          styl = row[i][1]
          if s = settings[i]
            html += "<td#{@seal(s, true)}>"
            if s.filter
              html += '<span>' + value + '</span>'
            else
              html += value
          else
              if styl == "better"
                html += '<td class=better>' + value + '<svg width="10px" height="20px"><defs><marker id="arrow" markerWidth="3" markerHeight="6" refx="0" refy="3" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,6 L2.5,3 z" fill="#FF6666" /></marker></defs><line x1="5" y1="20" x2="5" y2="8" stroke="#FF6666" stroke-width="1.6" marker-end="url(#arrow)" /></svg>';
              else if styl == "worse"
                html += '<td class=worse>' + value + '<svg width="10px" height="20px"><defs><marker id="arrow" markerWidth="3" markerHeight="6" refx="0" refy="3" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,6 L2.5,3 z" fill="#33CC99" /></marker></defs><line x1="5" y1="4" x2="5" y2="16" stroke="#33CC99" stroke-width="1.6" marker-end="url(#arrow)" /></svg>';
              else
                html += '<td>' + value
        index++
      else
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

    @ele.innerHTML = html

  seal: (settings, data) ->
    return '' unless settings?
    cls = ''
    attributes = ''

    cls += 'left' if settings.align == 'left'
    cls += ' filter' if data && settings.filter
    attributes += ' class="' + cls + '"' if cls.length != 0
    attributes



window.Results = Results
