$ ->
  class window.Dot
    @center = {x:0, y:0}
    @time = 0

    constructor: (@id, @note, @orbit, @period) ->
      @colour = MusicTheory.Synesthesia.map(0)[@id].hex
      @radius = (Math.pow(@id, 1) / 2) + 4
      @x = 0
      @y = 0
      @active = false

    update: ->
      angle = (Math.PI * 2) * ((Dot.time % @period) / @period)
      @x = @orbit * Math.cos(angle) + Dot.center.x
      @y = @orbit * Math.sin(angle) + Dot.center.y

    draw: ->
      if not @active
        ctx.fillStyle = @colour
      else
        ctx.fillStyle = "white"
      drawCircle(@x, @y, @radius)
