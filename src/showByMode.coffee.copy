'use strict'

locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
dateFilter = 'day'

class ResultShow
  constructor: (@ele) ->

  showByMode: (input, modes) ->
    index = 0
    @buildTable(input)
    @showMode(input, modes[0])

    document.onkeydown = (e) =>
      return unless e.keyCode == 77
      index++
      index = 0 if index == modes.length
      @showMode(input, modes[index])

  buildTable: (input) ->
    header = ''
    fields = input.fields
    for i in [1...fields.length] by 1
      field = fields[i]
      if name = field.name
        header += '<th class=filter>' + name
      else
        header += '<th>' + field

    dataCells = ''
    dataCells += '<td>' for i in [0...fields.length - input.dataOffset]

    # keys need to be the same order across modes
    keys = Object.keys(input.groups).sort()
    keyParts = if keys[0] == '*' then null else (key.split('$') for key in keys)

    rowIndex = 0
    html = @buildHeader(new Date(input.firstDay), header)
    for i in [input.firstDay..input.lastDay] by -86400000
      d = new Date(i)
      if d.getDay() == 0
        html += @buildHeader(d, header)
        rowIndex = 0
      for key, j in keys
        dayText = if j == 0 then locale.weekdays[d.getDay()] + ' ' + d.getDate() else ''
        html += '<tr'
        html += ' class=o' if rowIndex++ % 2 == 1
        html += '><td class=filter><span>' + dayText + '</span>'
        html += '<td class=filter><span>' + filter + '</span>' for filter in keyParts[j] if keyParts
        html += dataCells

    @keys = keys
    @columns = Object.keys(input.groups[keys[0]])
    @ele.innerHTML = html
    @cells = $(@ele, 'td')
    null

  buildHeader: (d, header) ->
    '<tr><th class=filter>' + locale.months[d.getMonth()] + ' ' + d.getFullYear() + header

  showMode: (input, mode) ->
    cellIndex = 0
    for dayIndex in [0...input.numberOfDays] by 1
      for key in @keys
        cellIndex += input.dataOffset
        for column, i in @columns
          value = mode[key][column][dayIndex]
          cell = @cells[cellIndex++]
          cell.innerHTML = value.value
          cell.className = value.style
    return
window.ResultShow = ResultShow
