_ = require 'lodash-contrib'
should = require('clay-chai').should()

RatingsWidget = require 'components/input_text'

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.properties.className.split(' '), className

describe 'InputText', ->

  it 'getValue()', ->
    null

  it 'setValue()', ->
    null

  it 'onchange updates value', ->
    null
