'use strict'

values = [10, 20, 26, 22, 38]
startX = 20
startY = 100
height = 20
width = 50

findMaxMin = (values) ->
  if !values
    return [0, 0]
  max = min = values[0]
  for i in [1...values.length] by 1
    max = if values[i] > max then values[i] else max
    min = if values[i] < min then values[i] else min
  return [max, min]

getCoordinates = (values, startX, startY, width=300, height=100) ->
  coords = []
  [maxV, minV] = findMaxMin(values)
  offsetX = width/(values.length+1)  # every x would be offsetX*(index of x+1)
  offsetY = height/(maxV-minV)  # every y would be offsetY*(y-min)
  for value, i in values
    x = startX + offsetX*(i+1)
    #y = startY - offsetY*(value-minV)  # draw sparkline above
    y = startY + offsetY*(maxV-value)
    coords.push([x, y]) # coords.push([offsetX*(i+1), offsetY*(value-min)])
  return coords

window.drawSparkline = (startX, startY, values, width=300, height=100) ->
  #alert('hello')
  coords = getCoordinates(values, startX, startY, width, height)
  canvas = document.getElementById('tutorial')
  ctx = canvas.getContext('2d')
  #ctx.rect(10, 10, 400, 400)
  #ctx.rect(startX, startY-height, width, height+20)  # draw sparkline above
  ctx.rect(startX, startY, width, height+20)
  ctx.stroke()
  ctx.strokeStyle = 'darkgreen'
  ctx.beginPath()
  ctx.moveTo(coords[0][0], coords[0][1])
  for coord in coords
    ctx.lineTo(coord[0], coord[1])
  ctx.stroke()
  ctx.closePath()
  ctx.fillStyle = "rgba(0,255,0,0.1)";
  ctx.beginPath();
  ctx.moveTo(coords[0][0], coords[0][1])
  for coord in coords
    ctx.lineTo(coord[0], coord[1])
  #ctx.lineTo(coords[coords.length-1][0], startY+20)  # right bottom, draw sparkline above
  #ctx.lineTo(coords[0][0], startY+20)  # left bottom, draw sprakline above
  ctx.lineTo(coords[coords.length-1][0], startY+height+20)
  ctx.lineTo(coords[0][0], startY+height+20)

  ctx.fill()
  ctx.closePath()


drawSparkline(startX, startY, values, width, height)
#window.ResultShow = ResultShow
