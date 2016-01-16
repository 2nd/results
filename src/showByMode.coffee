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
    html += '<tr'
    html += ' class=h ' if rowIndex++ % 2 == 1 
    html += '><td class=filter><span>' + 'Trend' + '</span>'
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
    slArray = @showSparkLine(input,mode)
    for dayIndex in [0...input.numberOfDays] by 1
      for key in @keys
        cellIndex += input.dataOffset
        for column, i in @columns
          value = mode[key][column][dayIndex]
          cell = @cells[cellIndex++]
          cell.innerHTML = value.value
          cell.className = value.style
    startIndex = @cells.length - input.fields.length + input.dataOffset
    for slIndex in [0...slArray.length] by 1
      slCell = @cells[startIndex + slIndex]
      slCell.innerHTML = ''
      slCell.appendChild(slArray[slIndex])
    return

  showSparkLine: (input,mode) ->
    width = 200
    height = 80
    innerWidth = 190
    innerHeight = 60
    fields = input.fields
    slArray = []
    for columnkeys,columnValues of mode[Object.keys(mode)]
      sparkValue = []
      max = min = columnValues[0].value
      for cvKey , cvValue of columnValues
        cvValue.value = Number(cvValue.value)
        sparkValue.push(cvValue.value)
        max = cvValue.value if max < cvValue.value
        min = cvValue.value if min > cvValue.value
        
      length = sparkValue.length
      range = max - min
      canvas = document.createElement("canvas")
      canvas.width = width
      canvas.height = height
      canvas.id = columnkeys
      ctx = canvas.getContext("2d")
      ctx.beginPath()
      ctx.fillStyle = "rgba(0, 200, 100, 0.1)"
      for data,i in sparkValue
        X = (i + 1) / length * innerWidth 
        Y = (data - min) / range * innerHeight - (height - innerHeight)*2/3
        ctx.lineTo(innerWidth - X,innerHeight - Y)
      ctx.strokeStyle = "darkgreen"
      ctx.stroke()
      ctx.lineTo(0,height)
      ctx.lineTo(innerWidth - 1/length * innerWidth,height)
      ctx.fill()
      slArray.push(canvas)
    return slArray
      

window.ResultShow = ResultShow
