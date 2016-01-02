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
    fields = input.fields
    header = ''
    dataCells = ''
    for i in [0...fields.length] by 1
      field = fields[i]
      if name = field.name
        header += '<th>' + name
      else
        header += '<th>' + field
        dataCells += '<td>'

    html = header
    for day in input.days
      for key in input.keys
        html += '<tr><td>' + day
        html += '<td>' + filter for filter in key.split('$')
        html += dataCells

    @ele.innerHTML = html
    @cells = $(@ele, 'td')
    null

  showMode: (input, mode) ->
    cellIndex = 0
    for day, row in input.days
      for key in input.keys
        cellIndex += input.filterCount
        for column, i in input.dataColumns
          value = mode[key][column][row]
          @cells[cellIndex++].innerHTML = value.value
    return
window.ResultShow = ResultShow
