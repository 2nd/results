'use strict'

defaultOptions ={
  height: 50
  width: 140
  dots: false  # an array of data index, indicates which dots are highlighted.
  shadeStart: false
  shadeEnd: false
  lineColor: "rgb(0, 0, 240)"
  dotColor: "rgba(240, 128, 0, 1)"
  shadeColor: "rgba(192, 208, 240, 1)"
  shadow: true
  shadowColor: "rgba(192, 208, 240, 1)"
  verticalLineColor: "rgba(240, 32, 32, 1)"
  bigDotColor: "rgba(80, 240, 80, 1)"
  verticalLineDashDist: 3
  background: false
  backgroundColor: "yellow"
  textColor: "black"
}

class Sparkline
  constructor: (canvasId, @data, options = {}) ->

    options[k] ?= v for k, v of defaultOptions
    {@height, @width, @dots, @shadeStart, @shadeEnd, @lineColor, @dotColor, @shadeColor, @shadow, @shadowColor, @verticalLineColor, @bigDotColor, @verticalDashDist, @background, @backgroundColor, @textColor} = options
    console.log 'oh:   '+@height
    # leaving space in up, down, left, right
    @lineWidth = @height * 0.04
    @bigDotSize = @height * 0.06
    @dotSize = @height * 0.05
    @upSpace = @bigDotSize/2
    @downSpace = @bigDotSize
    @leftSpace = @bigDotSize
    @rightSpace = @height * 0.14 * 4

    # define basic characristics of sparkline
    @ys = @scaleY(@data)
    @portions = @calculatePortions(@data)
    @lastPortion = 0
    @canvas = document.getElementById(canvasId)
    console.log "@canvas:  "+ @canvas
    @canvas.height = @height
    @canvas.width = @width

    # set screen resolution accroding to different device.
    @ratio = @scaleScreen(@canvas)
    @ctx = @canvas.getContext('2d')
    @ctx.scale(@ratio, @ratio);

    # draw sparkline
    @canvas.addEventListener('mousemove', @mouseEvent)
    @drawSparkline()

  scaleY: =>
    max = Math.max.apply(Math, @data)
    min = Math.min.apply(Math, @data)
    ystep = (max-min)*1.1 / (@height-@upSpace-@downSpace)
    ys = []
    for i in [0...@data.length] by 1
      ys.push (@height-@downSpace) - (@data[i]-min) / ystep
    return ys

  scaleScreen: (@canvas) =>
    ctx = @canvas.getContext('2d')
    devicePixelRatio = window.devicePixelRatio
    backingStoreRatio = ctx.webkitBackingStorePixelRatio ||ctx.mozBackingStorePixelRatio ||ctx.msBackingStorePixelRatio ||ctx.oBackingStorePixelRatio ||ctx.backingStorePixelRatio || 1
    ratio = devicePixelRatio / backingStoreRatio
    if devicePixelRatio != backingStoreRatio
          oldWidth = @canvas.width;
          oldHeight = @canvas.height;
          @canvas.width = Math.round(oldWidth * ratio);
          @canvas.height = Math.round(oldHeight * ratio);
          @canvas.style.width = oldWidth + 'px';
          @canvas.style.height = oldHeight + 'px';
        return ratio

  drawSparkline: =>
    number = @data.length
    xstep = (@width-@leftSpace-@rightSpace) / (number-1)
    ctx = @ctx

    ctx.clearRect(0, 0, @canvas.width, @canvas.height)

    if @background
      ctx.fillStyle = @backgroundColor
      ctx.rect(@leftSpace,0,@width-@rightSpace-@leftSpace,@height)
      ctx.fill()

    if @shadow
      ctx.beginPath()
      ctx.fillStyle = @shadowColor
      ctx.moveTo(xstep * (number-i) + @leftSpace, @ys[0])
      for i in [1...number] by 1
        x = xstep * (number-i) + @leftSpace
        y = @ys[i]  
        ctx.lineTo(x, y)
      #ctx.lineTo(x, @height)
      ctx.lineTo(xstep + @leftSpace, @height)
      ctx.lineTo(xstep * (number-1) + @leftSpace, @height)
      ctx.fill()

    if @shadeStart
      ctx.beginPath()
      ctx.fillStyle = @shadeColor
      ctx.moveTo(xstep * (number-i) + @leftSpace, @ys[0])
      for i in [1...number] by 1
        x = xstep * (number-i) + @leftSpace
        y = @ys[i]
        ctx.lineTo(x, y)
      #ctx.lineTo(x, @height)
      ctx.lineTo(xstep + @leftSpace, @height)
      ctx.lineTo(xstep * (number-1) + @leftSpace, @height)
      ctx.fill()

    ctx.beginPath()
    #ctx.setLineDash([1]);
    ctx.lineWidth = @lineWidth
    ctx.strokeStyle = @lineColor
    #ctx.moveTo(xstep * (number-1-i) + @leftSpace, @ys[0]) 
    for i in [1...number] by 1
      x = xstep * (number-i) + @leftSpace
      y = @ys[i]
      ctx.lineTo(x, y)

    ctx.stroke()

    if @dots
      for dot in @dots
        ctx.beginPath()
        ctx.fillStyle = @dotColor
        ctx.arc(xstep * dot + @leftSpace, @ys[dot], @dotSize, 0, 2 * Math.PI)
        ctx.fill()
    return ctx

  # add mouse event
  getMousePos: (evt) =>
    rect = @canvas.getBoundingClientRect()
    return {
      x: evt.clientX - rect.left
      y: evt.clientY - rect.top
    }

  mouseEvent: (evt) =>
    number = @data.length
    mousePos = @getMousePos(evt)
    for i in [0...@portions.length] by 1
      portion = @portions[i]
      if mousePos.x < portion[0]
        x = portion[1]
        message = @data[number-i]
        break

    return if x == @lastPortion
    @lastPortion = x
    ctx = @drawSparkline()  
    ctx.lineWidth = @lineWidth * 0.3

    ctx.font = @height*0.14 + "pt Calibri";
    ctx.fillStyle = @textColor #"rgba(80, 240, 80, 1)"
    ctx.fillText(message, x+2, @height * 0.2) #@height * 0.2
    #ctx.fill()

    ctx.strokeStyle = @verticalLineColor
    #ctx.setLineDash([1])
    ctx.moveTo(x, 0)
    ctx.lineTo(x, @height)
    ctx.stroke()

    ctx.beginPath()
    ctx.setLineDash([1])
    ctx.arc(x, @ys[number-i], @bigDotSize, 0, 2 * Math.PI)
    ctx.fillStyle = @bigDotColor
    ctx.fill()

  calculatePortions: (data) =>
    step = (@width-@leftSpace-@rightSpace) / (@data.length - 1)
    offset = step / 2
    portions = []
    sums = @leftSpace
    for i in [0...@data.length] by 1
      if i == 0
        sums = sums + step / 2
      else 
        sums = sums + step
      portions.push [sums, sums - offset]
    console.log portions
    return portions


window.Sparkline = Sparkline


locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
dateFilter = 'day'

options = {
  width: 160,
  background: false,
  shadow: "true",
  lineColor: "rgba(0,150,0,0.8)",
  shadow: true,
  shadowColor: "rgba(0,255,0,0.1)",
  verticalLineColor: "darkgreen",
  bigDotColor: "darkgreen"
}

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
    #width = 140
    #height = 60
    #innerWidth = 140
    #innerHeight = 50
    fields = input.fields
    slArray = []
    for columnkeys,columnValues of mode[Object.keys(mode)]
      console.log 'columnkeys:   '+columnkeys
      sparkValue = []
      max = min = columnValues[0].value
      for cvKey , cvValue of columnValues
        cvValue.value = Number(cvValue.value)
        sparkValue.push(cvValue.value)
        max = cvValue.value if max < cvValue.value
        min = cvValue.value if min > cvValue.value
        
      length = sparkValue.length
      range = max - min
      currentCanvas = document.createElement("canvas")
      currentCanvas.id = columnkeys
      tmp = document.getElementById("canvasGraph")
      tmp.appendChild(currentCanvas)
      console.log "currentCanvas.id:   "+currentCanvas.id
      new Sparkline(columnkeys,sparkValue,defaultOptions)

      # canvas.width = width
      # canvas.height = height
      # canvas.id = columnkeys
      # ctx = canvas.getContext("2d")
      # ctx.beginPath()
      # ctx.fillStyle = "rgba(0, 0, 0, 0.1)"
      # for data,i in sparkValue
      #   X = innerWidth - ((i + 1) / length * innerWidth )
      #   Y = innerHeight - ((data - min) / range * innerHeight - (height - innerHeight)*2/3)
      #   ctx.lineTo(X,Y)
      # ctx.strokeStyle = "black"
      # ctx.stroke()
      # ctx.lineTo(0,height)
      # ctx.lineTo(innerWidth - 1/length * innerWidth,height)
      # ctx.fill()
      slArray.push(currentCanvas)
    return slArray
window.ResultShow = ResultShow
