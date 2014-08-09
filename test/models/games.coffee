should = require('clay-chai').should()

Games = require 'models/games'
Zock = require 'zock'

# Function.prototype.bind shim
Function::bind = Function::bind or (d) ->
  a = Array::splice.call(arguments, 1)
  c = this
  b = ->
    e = a.concat(Array::splice.call(arguments, 0))
    return c.apply(d, e)  unless this instanceof b
    c.apply this, e
    return

  b:: = c::
  b


window.XMLHttpRequest = new Zock()
  .base('')
  .get('/games')
  .reply(200, ['test'])
  .XMLHttpRequest

describe 'GamesModel', ->

  it 'getList()', ->
    Games.getList().then (list) ->
      console.log 'List', list
    .then null, (err) ->
      console.log 'Erro', err
