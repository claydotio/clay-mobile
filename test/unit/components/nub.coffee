should = require('clay-chai').should()

Nub = require 'components/nub'

describe 'Nub', ->

  it 'begins closed', ->
    NubComponent = new Nub({onToggle: -> null})

    NubComponent.isOpen.should.be.false

  it 'toggles properly', ->
    NubComponent = new Nub({onToggle: -> null})
    NubComponent.toggleOpenState()
    NubComponent.isOpen.should.be.true
    NubComponent.toggleOpenState()
    NubComponent.isOpen.should.be.false

  it 'onToggle works properly', (done) ->
    onToggle = ->
      NubComponent.isOpen.should.be.true
      done()
    NubComponent = new Nub({onToggle})
    NubComponent.toggleOpenState()
