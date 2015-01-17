should = require('clay-chai').should()
_ = require ('lodash-contrib')
Zock = new (require 'zock')()

config = require 'config'
Drawer = require 'components/drawer'
MockGame = require '../../_models/game'
MockUser = require '../../_models/user'

domWalker = _.walk ($node) ->
  return $node?.children

hasClass = ($node, className) ->
  _.contains $node?.properties.className?.split(' '), className

describe 'Drawer', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'toggles properly', ->
    Zock
      .base(config.CLAY_API_URL)
      .post '/users/login/anon'
      .reply 200, MockUser
      .base(config.FC_API_URL)
      .get '/experiments'
      .reply 200, {}

    DrawerComponent = new Drawer({game: MockGame})

    DrawerComponent.toggleState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'z-drawer'

    hasClass($drawer, 'is-open').should.be.true

    DrawerComponent.toggleState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'z-drawer'

    hasClass($drawer, 'is-open').should.be.false

  it 'closes properly', ->
    Zock
      .base(config.CLAY_API_URL)
      .post '/users/login/anon'
      .reply 200, MockUser
      .base(config.FC_API_URL)
      .get '/experiments'
      .reply 200, {}

    DrawerComponent = new Drawer(MockGame)

    DrawerComponent.toggleState()
    DrawerComponent.isOpen.should.be.true

    DrawerComponent.close()
    DrawerComponent.isOpen.should.be.false
