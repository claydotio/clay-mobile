should = require('clay-chai').should()

WinkActionView = new (require 'views/wink_action')()

describe 'WinkActionView', ->
  it 'renders a button, with text Wink!', ->
    $el = WinkActionView.render()
    $el.attrs.onclick.should.be.a 'function'
    $el.children.should.be 'Wink!'
