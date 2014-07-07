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


  draw = ->

  window.gameLoop = ->
    now = new Date().getTime()
    diff = now - last
    update()
    draw()

    last = new Date().getTime()
    window.mainLoop = setTimeout(gameLoop, 1000 /60)

  window.onload = ->
    MIDI.loadPlugin(
      soundfontUrl: "MIDI/soundfont/",
      instrument: "acoustic_grand_piano",
      callback: ->
        window.mainLoop = setTimeout(gameLoop, 1000 /60)
    )

