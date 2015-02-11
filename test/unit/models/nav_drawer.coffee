should = require('clay-chai').should()

NavDrawer = require 'models/nav_drawer'

describe 'NavDrawerModel', ->
  beforeEach ->
    NavDrawer.constructor() # reset

  it 'isOpen returns o_isOpen', ->
    NavDrawer.isOpen().should.be NavDrawer.o_isOpen

  it 'begins closed', ->
    o_open = NavDrawer.isOpen()
    o_open().should.be.false

  it 'open()', ->
    o_open = NavDrawer.isOpen()
    o_open().should.be.false
    NavDrawer.open()
    o_open().should.be.true

  it 'close()', ->
    o_open = NavDrawer.isOpen()
    NavDrawer.open()
    o_open().should.be.true
    NavDrawer.close()
    o_open().should.be.false
