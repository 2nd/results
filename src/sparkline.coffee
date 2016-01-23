# data [1345, 1267, 1178, 891, 1349, 1567, 1891, 1921, 2045, 2102, 2391, 2197, 1899, 1456, 1209, 781, 567, 344]

defaultOptions ={
	height: 50
	width: 300
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
	verticalLineDashDist: 0
	background: false
	backgroundColor: "yellow"
	textColor: "black"
}

class Sparkline
	constructor: (canvasId, 	@data, options = {}) ->
		options[k] ?= v for k, v of defaultOptions
		{@height, @width, @dots, @shadeStart, @shadeEnd, @lineColor, @dotColor, @shadeColor, @shadow, @shadowColor, @verticalLineColor, @bigDotColor, @verticalDashDist, @background, @backgroundColor, @textColor} = options

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
			ctx.beginPath()
			ctx.fillStyle = @backgroundColor
			ctx.rect(@leftSpace,0,@width-@rightSpace-@leftSpace,@height)
			ctx.fill()

		if @shadow
			ctx.beginPath()
			ctx.fillStyle = @shadowColor
			ctx.moveTo(@leftSpace, @height)
			for i in [0...number] by 1
				x = xstep * i + @leftSpace
				y = @ys[i]
				ctx.lineTo(x, y)
			ctx.lineTo(x, @height)
			ctx.lineTo(0, @height)
			ctx.fill()

		if @shadeStart
			ctx.beginPath()
			ctx.fillStyle = @shadeColor
			ctx.moveTo(xstep * (@shadeStart-1), @height)
			for i in [(@shadeStart-1)...@shadeEnd] by 1
				x = xstep * i + @leftSpace
				y = @ys[i]
				ctx.lineTo(x, y)
			ctx.lineTo(x, @height)
			ctx.lineTo(xstep * (@shadeStart-1) + @leftSpace, @height)
			ctx.fill()

		ctx.beginPath()
		# ctx.setLineDash([0]);
		ctx.lineWidth = @lineWidth
		ctx.strokeStyle = @lineColor
		ctx.moveTo(@leftSpace, @ys[0]) 
		for i in [1...number] by 1
			x = xstep * i + @leftSpace
			y = @ys[i] 
			ctx.lineTo(x, y)
		ctx.stroke()

		if @dots
			for dot in @dots
				ctx.beginPath()
				ctx.moveTo(xstep * dot + @leftSpace, @ys[dot])
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
		mousePos = @getMousePos(evt)
		for i in [0...@portions.length] by 1
			portion = @portions[i]
			if mousePos.x < portion[0]
				x = portion[1]
				message = @data[i]
				break

		return if x == @lastPortion
		@lastPortion = x
		ctx = @drawSparkline()	
		ctx.lineWidth = @lineWidth * 0.3

		ctx.beginPath()
		ctx.font = @height*0.14 + "pt Calibri";
		ctx.fillStyle = @textColor #"rgba(80, 240, 80, 1)"
		ctx.fillText(message, x+2, @height * 0.2) #@height * 0.2
		ctx.fill()

		ctx.beginPath()
		ctx.strokeStyle = @verticalLineColor
		ctx.save()
		ctx.setLineDash([@verticalLineDashDist])
		ctx.moveTo(x, 0)
		ctx.lineTo(x, @height)
		ctx.stroke()
		ctx.restore()

		ctx.beginPath()
		ctx.arc(x, @ys[i], @bigDotSize, 0, 2 * Math.PI)
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