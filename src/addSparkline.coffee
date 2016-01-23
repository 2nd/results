'use strict'

defaultOptions  =
  startX: 0,
  startY: 0,
  width: 100,
  height: 40,
  lineColor: 'green',
  lineWidth: 1.5
  shadowColor: "rgba(0,255,0,0.1)"

findMaxMin = (values) ->
  if !values
    return [0, 0]
  max = min = values[0]
  for i in [1...values.length] by 1
    value = values[i]
    if value > max
      max = value
    else
      min = value if value < min
  return [max, min]

window.drawSparkline = (values, options={}) ->
  # return a canvas object
  options[k] ?= v for k, v of defaultOptions
  [startX, startY, width, height, lineColor, lineWidth, shadowColor] =
  [options.startX, options.startY, options.width, options.height, options.lineColor, options.lineWidth, options.shadowColor]

  [maxV, minV] = findMaxMin(values)
  stepX = width / (values.length-1)  # every x would be offsetX*(index of x+1)
  stepY = height / (maxV - minV)  # every y would be offsetY*(y-min)

  canvas=document.createElement("canvas")
  # define the height and width
  canvas.height = startY + height + 10
  canvas.width = startX + width
  ctx = canvas.getContext('2d')
  # ctx.fillStyle = 'black'
  # ctx.rect(startX, startY, width, height+5)
  # ctx.fill()
  ctx.strokeStyle = lineColor  # darkgreen
  ctx.lineWidth = lineWidth
  ctx.fillStyle = shadowColor
  ctx.beginPath()
  #ctx.moveTo(coords[0][0], coords[0][1])
  # draw the line from bottom left to top right
  for i in [0...values.length-1] by 1 # draw the line from old day to new day
    x = startX + stepX * i
    i = values.length - 1 - i
    y = startY + stepY * (maxV - values[i]) + 2
    #ctx.arc(x, y, 1, 0, 360, true)
    ctx.lineTo(x, y)
  ctx.stroke()
  ctx.lineTo(x, startY + height + 5)  # draw lines from right to left, so this x is the last x
  ctx.lineTo(startX, startY + height + 5) # draw lines from right to left, so this x is the first x
  ctx.fill()
  ctx.closePath()
  return canvas

window.getSparklines = (data) ->
  # sparkline for each column except the filter column
  sparklines = {}
  for key, group of data.groups
    keyed = sparklines[key] = {}
    keyed[column] = drawSparkline(values, {startX:0, startY:0, width:80, height:40, lineColor:'green', shadowColor:"rgba(0,255,0,0.1)"}) for column, values of group
  return sparklines
