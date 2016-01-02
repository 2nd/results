'use strict'

locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
dateFilter = 'day'


class ResultShow
  constructor: (@ele) ->

  showByMode: (rows) ->
    list = ['M0','M1','M2']
    modeIndex = 0
    @showTable(rows,modeIndex)

    document.onkeydown = (e) =>
      return unless e.keyCode == 77
      modeIndex++
      modeIndex = 0 if modeIndex == list.length
      @showTable(rows,modeIndex)

  showTable: (rows,modeIndex)->

    fields = rows[rows.length - 1]
    html = ''
    valuesAfterCal = data[modeIndex].valueDic
    stylesAfterCal = data[modeIndex].styleDic
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
      break unless i < rows.length - 1
      d = new Date(row[0])
      dayIndex = dateLi.indexOf(String(d))
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
        columnIndex = i
        columnKey = columnLi[columnIndex]

        if i == 1 
          currentKeys = ''
        if s = settings[i]
          html += "<td#{@seal(s, true)}>"
          if s.filter
            if currentKeys == ''
              currentKeys += value
            else if value == "undefine"
              currentKeys = value
              break
            else
              currentKeys += '$'+value
            html += '<span>' + value + '</span>'
          else
            html += '<span>' + value + '</span>'
        else
          for keyAfterCal , valueAfterCal of valuesAfterCal
            if keyAfterCal == currentKeys || columnLi[columnLi.length - 1] == 1
              if modeIndex == 0
                valueToShow = valueAfterCal[columnKey][dayIndex]
              else
                if valueAfterCal[columnKey][dayIndex].toString() != 'na'
                  valueToShow = valueAfterCal[columnKey][dayIndex] * 100
                  if valueAfterCal[columnKey][dayIndex] <= 0
                    if valueToShow > -10
                      valueToShow = valueToShow.toString()[0..3] + "%"
                    else
                      valueToShow = valueToShow.toString()[0..4] + "%"
                  else
                    if valueToShow < 10
                      valueToShow = valueToShow.toString()[0..2] + "%"
                    else
                      valueToShow = valueToShow.toString()[0..3] + "%"
                else
                  valueToShow = NaN
              if stylesAfterCal[keyAfterCal][columnKey][dayIndex] == 'better'
                html += '<td class=' + stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow
              else if stylesAfterCal[keyAfterCal][columnKey][dayIndex] == 'worse'
                html += '<td class=' + stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow
              else
                html += '<td class=' + stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow
              break
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
window.ResultShow = ResultShow
