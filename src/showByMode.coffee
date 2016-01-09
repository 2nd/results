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
  showSparkLine: (data,modes) ->
    width = 300
    height = 100
    for keys,values of modes[0][Object.keys(modes[0])]
      sparkValue = []
      console.log keys

      for valuesKey , valuesValue of values
        if sparkValue.length == 0
          max = valuesValue.value
          min = valuesValue.value
        if max < valuesValue.value then max = valuesValue.value
        if min > valuesValue.value then min = valuesValue.value
        sparkValue.push(valuesValue.value)
        
      length = sparkValue.length
      range = max - min
      console.log "max is:  " + max
      console.log "min is:  " + min
      console.log "length is:  " + length
      canvas = document.createElement("canvas")
      canvas.width = width
      canvas.height = height
      document.body.appendChild(canvas)
      ctx = canvas.getContext("2d")
      ctx.beginPath()
      ctx.moveTo(0,height)
      
      ctx.strokeStyle = "darkgreen"
      ctx.fillStyle = "rgba(0, 200, 100, 0.1)"
      for data,i in sparkValue
        X = (i + 1) / length * width
        Y = (data - min) / range * height
        ctx.lineTo(X,Y)
      ctx.lineTo(width,height)
      ctx.lineTo(0,height)
      ctx.fill()
      ctx.stroke()





window.ResultShow = ResultShow
