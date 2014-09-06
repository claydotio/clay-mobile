_ = require 'lodash'
should = require('clay-chai').should()

RatingsWidget = require 'components/stars'

hasClass = ($node, className) ->
  _.contains $node.attrs.className.split(' '), className

describe 'RatingsWidget', ->

  it 'renders 3.5 stars (3.3 rounded up)', ->
    widget = new RatingsWidget(stars: 3.3)
    $ = widget.render()

    fullCount = _.reduce $.children, (sum, $star) ->
      if hasClass($star, 'icon-star') and hasClass($star, 'icon-star-fill')
      then sum + 1
      else sum
    , 0

    halfCount = _.reduce $.children, (sum, $star) ->
      if hasClass $star, 'icon-star-half-fill'
      then sum + 1
      else sum
    , 0

    emptyCount = _.reduce $.children, (sum, $star) ->
      if hasClass $star, 'icon-star-empty'
      then sum + 1
      else sum
    , 0

    fullCount.should.be 3
    halfCount.should.be 1
    emptyCount.should.be 1


  it 'defaults to 0 if less than 0 stars', ->
    widget = new RatingsWidget(stars: -5)
    $ = widget.render()

    emptyCount = _.reduce $.children, (sum, $star) ->
      if hasClass $star, 'icon-star-empty'
      then sum + 1
      else sum
    , 0

    emptyCount.should.be 5

  it 'defaults to 5 if greater than 5 stars', ->
    widget = new RatingsWidget(stars: 10)
    $ = widget.render()

    fullCount = _.reduce $.children, (sum, $star) ->
      if hasClass($star, 'icon-star') and hasClass($star, 'icon-star-fill')
      then sum + 1
      else sum
    , 0

    fullCount.should.be 5
