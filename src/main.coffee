$ ->
  window.canvas = $('#drawable')
  window.ctx = canvas.get(0).getContext('2d')
  window.last = new Date().getTime()

  #implement array remove function, stolen directly from stackoverflow.
  Array::remove = (e) ->
    @[t..t] = [] if (t = @indexOf(e)) > -1

  window.paused = false
  window.pauseplay = ->
    window.paused = not window.paused
    if window.paused is false
      window.mainLoop = setTimeout(gameLoop, 1000 /60)
    else
      clearTimeout(window.mainLoop)

  width = canvas.width()
  height = canvas.height()
  window.lines = []
  lines.push([{x: width / 2, y: height / 2}, {x: width, y: height / 2}])

  letters = ['C', 'D', 'E', 'F', 'G', 'A', 'B']
  window.dots = []
  orbit = 10
  id = 0
  for i in [2..6]
    for l in letters
      note = MIDI.keyToNote[l + i.toString()]
      dot = new Dot(id, note, orbit, 200000 / (88 - id))
      dots.push(dot)
      orbit += Math.floor(dot.radius * 0.9)
      id += 1

  window.timer = 0
  update = ->
    timer += 1
    if timer is 10
      window.timer = 0
      delay = 0 # play one note every quarter second
      note = Math.floor(Math.random() * 87) + 21 # the MIDI note
      velocity = 127 # how hard the note hits
      # play the note
      MIDI.setVolume(0, 127)
      MIDI.noteOn(0, note, velocity, delay)
      MIDI.noteOff(0, note, delay + 0.75)
    Dot.time += Math.floor(1000/60)
    for dot in dots
      dot.update()

  window.drawCircle = (x, y, r) ->
    ctx.beginPath()
    ctx.arc(x, y, r, 0, 2*Math.PI, false)
    ctx.fill()

  draw = ->
    width = canvas.width()
    height = canvas.height()
    Dot.center.x = width / 2
    Dot.center.y = height / 2

    # Clear
    ctx.fillStyle = "black"
    ctx.fillRect(0, 0, width, height)

    # Center
    ctx.fillStyle = "white"
    drawCircle(width/2, height/2, 5)

    for dot in dots
      dot.draw()

    ctx.strokeStyle = "white"
    ctx.beginPath()
    for line in lines
      ctx.moveTo(line[0].x, line[0].y)
      ctx.lineTo(line[1].x, line[1].y)
    ctx.stroke()

  window.gameLoop = ->
    now = new Date().getTime()
    diff = now - last
    update()
    draw()

    last = new Date().getTime()
    window.mainLoop = setTimeout(gameLoop, 1000 /60)

  window.onload = ->
    MIDI.loadPlugin(
      soundfontUrl: "./MIDI/soundfont/",
      instrument: "acoustic_grand_piano",
      callback: ->
        window.mainLoop = setTimeout(gameLoop, 1000 /60)
    )

