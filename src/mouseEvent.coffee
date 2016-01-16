# data [1345, 1267, 1178, 891, 1349, 1567, 1891, 1921, 2045, 2102, 2391, 2197, 1899, 1456, 1209, 781, 567, 344]

defaultOptions = {
	height: 100
	width: 50
	dot: 'False'
	shadeStart: 'False'
	shadeEnd: 'False'
	lineColor: "rgba(0,0,0,.5)"
	dotColor: "red"
	shadeColor: "rgba(1,0,0,.1)"
}

sparkline = (canvasId, data, options = {}) ->
	options[k] ?= v for k, v of defaultOptions
	{height, width, dot, shadeStart, shadeEnd, lineColor, dotColor, shadeColor} = options

	if window.HTMLCanvasElement
		canvas = document.getElementById(canvasId)
		ctx = canvas.getContext('2d')
		canvas.height = height
		canvas.width = width
		height = canvas.height - 2
		width = canvas.width - 2
		number = data.length
		max = Math.max.apply(Math, data)
		xstep = width / number
		ystep = height / max

		x = 0
		y = height - data[0] * ystep

		ctx.beginPath()
		ctx.strokeStyle = lineColor
		ctx.moveTo(x, y)
		for i in [1...number] by 1
			x = xstep * i
			y = height - data[i] * ystep
			ctx.lineTo(x, y)
		ctx.stroke()

		# console.log shadeStart
		# if shadeStart != 'False'
		# 	ctx.beginPath()
		# 	ctx.strokeStyle = shadeColor
		# 	ctx.moveTo(xstep*shadeStart, height - data[shadeEnd]*ystep)
		# 	for i in [shadeStart...shadeEnd by 1
		# 		x = xstep * i
		# 		y = height - data[i] * ystep
		# 		ctx.lineTo(x, y)
		# 	ctx.stroke()

		if dot != 'False'
			ctx.beginPath()
			ctx.arc(xstep * dot, height - data[dot]*ystep, 1.8, 0, 2 * Math.PI)
			ctx.fillStyle = dotColor
			ctx.fill()


		# add mouse event
		getMousePos = (canvas, evt) ->
			rect = canvas.getBoundingClientRect()
			return {
				x: evt.clientX - rect.left
				y: evt.clientY - rect.top
			}

		mouseEvent = (evt) ->
			mousePos = getMousePos(canvas, evt)
			message = mousePos.x + ',' + mousePos.y
			ctx.strokeText(message, mousePos.x, mousePos.y)



		canvas.addEventListener('mousemove', mouseEvent)




window.sparkline = sparkline
