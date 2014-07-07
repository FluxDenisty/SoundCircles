$ ->
  window.canvas = $('#drawable')
  window.ctx = canvas.get(0).getContext('2d')
  window.last = new Date().getTime()

  #implement array remove function, stolen directly from stackoverflow.
  Array::remove = (e) ->
    @[t..t] = [] if (t = @indexOf(e)) > -1

  update = ->

  draw = ->

  gameLoop = ->
    now = new Date().getTime()
    diff = now - last
    update()
    draw()

    last = new Date().getTime()
    setTimeout(gameLoop, 1000 /60)

  setTimeout(gameLoop, 1000 /60)
