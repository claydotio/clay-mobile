should = require('clay-chai').should()
_ = require ('lodash-contrib')

NavDrawer = require 'components/nav_drawer'
NavDrawerModel = require 'models/nav_drawer'

domWalker = _.walk ($$node) ->
  return $$node?.children

hasClass = ($$node, className) ->
  _.contains $$node?.className?.split(' '), className

describe 'NavDrawer', ->
  it 'opens properly', ->
    $navDrawer = new NavDrawer({})

    NavDrawerModel.open()

    $$ = $navDrawer.render({})
    $$drawer = _.find $$, ($$nodeSet) ->
      domWalker.find $$nodeSet, ($$node) ->
        return hasClass $$node, 'z-nav-drawer'

    hasClass($$drawer, 'is-open').should.be.true

  it 'closes properly', ->
    $navDrawer = new NavDrawer({})

    NavDrawerModel.open()
    NavDrawerModel.close()

    $$ = $navDrawer.render({})
    $$drawer = _.find $$, ($$nodeSet) ->
      domWalker.find $$nodeSet, ($$node) ->
        return hasClass $$node, 'z-drawer'

    hasClass($$drawer, 'is-open').should.be.false
