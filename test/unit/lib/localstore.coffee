should = require('clay-chai').should()

localstore = require 'lib/localstore'

describe 'localstore', ->
  it 'sets', ->
    localstore.set 'test', {hello: 'world'}
    .then (hello) ->
      hello.should.be {hello: 'world'}

  it 'gets', ->
    localstore.get 'test'
    .then (hello) ->
      hello.should.be {hello: 'world'}

  it 'deletes', ->
    localstore.del 'test'
    .then ->
      localstore.get 'test'
    .then (none) ->
      should.not.exist none

  it 'doesn\'t allow non strings for keys', ->

    Promise.all [
      localstore.get 1
      .then ->
        throw new Error 'Error expected'
      , ->
        null

      localstore.set 1, {}
      .then ->
        throw new Error 'Error expected'
      , ->
        null

      localstore.set {}, {}
      .then ->
        throw new Error 'Error expected'
      , ->
        null
    ]

  it 'doesn\'t allow non-objects for values', ->
    Promise.all [
      localstore.set 'abc', 1
      .then ->
        throw new Error 'Error expected'
      , ->
        null

      localstore.set 'abc', 'def'
      .then ->
        throw new Error 'Error expected'
      , ->
        null
    ]
