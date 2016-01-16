'use strict'

findMaxMin = (values) ->
  if !values
    return [0, 0]
  max = min = values[0]
  for i in [1...values.length] by 1
    max = values[i] if values[i] > max
    min = values[i] if values[i] < min
  return [max, min]

defaultOptions  =
  startX:0,
  startY:0,
  width:100,
  height:40,
  lineColor:'green',
  shadowColor:"rgba(0,255,0,0.1)"

getCoordinates = (values, startX, startY, width, height) ->
  coords = []
  #values = values.reverse()
  [maxV, minV] = findMaxMin(values)
  offsetX = width/(values.length+1)  # every x would be offsetX*(index of x+1)
  offsetY = height/(maxV-minV)  # every y would be offsetY*(y-min)
  for value, i in values.reverse()  # draw the line from old day to new day
    x = startX + offsetX*(i+1)
    #y = startY - offsetY*(value-minV)  # draw sparkline above
    y = startY + offsetY*(maxV-value) + 2
    coords.push([x, y]) # coords.push([offsetX*(i+1), offsetY*(value-min)])
  return coords

window.drawSparkline = (values, options={}) ->
  # return a canvas object
  options[k] ?= v for k, v of defaultOptions
  [startX, startY, width, height, lineColor, shadowColor] =
  [options.startX, options.startY, options.width, options.height, options.lineColor, options.shadowColor]
  coords = getCoordinates(values, startX, startY, width, height)
  canvas=document.createElement("canvas")
  # define the height and width
  canvas.height = height + 10
  canvas.width = width
  #canvas = document.getElementById('tutorial')
  ctx = canvas.getContext('2d')
  #ctx.rect(10, 10, 400, 400)
  #ctx.rect(startX, startY-height, width, height+20)  # draw sparkline above
  #ctx.rect(startX, startY, width, height+5)
  #ctx.stroke()
  ctx.lineWidth = 0.5
  ctx.beginPath()
  ctx.moveTo(startX, startY)
  ctx.lineTo(startX, startY+height+5)
  ctx.lineTo(startX+width, startY+height+5)
  ctx.stroke()
  ctx.closePath()
  ctx.strokeStyle = lineColor  # darkgreen
  ctx.lineWidth = 1.5
  ctx.beginPath()
  ctx.moveTo(coords[0][0], coords[0][1])
  for coord in coords
    ctx.lineTo(coord[0], coord[1])
  ctx.stroke()
  ctx.closePath()
  ctx.fillStyle = shadowColor;
  #ctx.fillStyle = "rgba(215,84,85,0.1)"
  ctx.beginPath();
  ctx.moveTo(coords[0][0], coords[0][1])
  for coord in coords
    ctx.lineTo(coord[0], coord[1])
  #ctx.lineTo(coords[coords.length-1][0], startY+20)  # right bottom, draw sparkline above
  #ctx.lineTo(coords[0][0], startY+20)  # left bottom, draw sprakline above
  ctx.lineTo(coords[coords.length-1][0], startY+height+5)
  ctx.lineTo(coords[0][0], startY+height+5)
  ctx.fill()
  ctx.closePath()
  return canvas

window.getSparklines = (data) ->
  # sparkline for each column except the filter column
  sparklines = {}
  for key, group of data.groups
    keyed = sparklines[key] = {}
    keyed[column] = drawSparkline(values, {startX:0, startY:0, width:100, height:30, lineColor:'green', shadowColor:"rgba(0,255,0,0.1)"}) for column, values of group
  return sparklines
