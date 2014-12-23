_ = require 'lodash-contrib'
should = require('clay-chai').should()

RatingsWidget = require 'components/stars'

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.properties.className.split(' '), className

countStars = ($children) ->
  _.reduce $children, (counts, $star) ->
    if hasClass($star, 'icon-star') and hasClass($star, 'is-filled')
      counts.full += 1

    else if hasClass($star, 'icon-star-half-fill') and
            hasClass($star, 'is-filled')
      counts.half += 1

    else if hasClass($star, 'icon-star') and hasClass($star, 'is-empty')
      counts.empty += 1

    return counts
  , {full: 0, half: 0, empty: 0}

describe 'RatingsWidgetComponent', ->

  describe 'static', ->

    it 'renders 3.5 stars (3.3 rounded up)', ->
      RatingsWidgetComponent = new RatingsWidget stars: 3.3
      $ = RatingsWidgetComponent.render()

      counts = countStars $.children

      counts.full.should.be 3
      counts.half.should.be 1
      counts.empty.should.be 1

    it 'defaults to 0 if less than 0 stars', ->
      RatingsWidgetComponent = new RatingsWidget stars: -5
      $ = RatingsWidgetComponent.render()

      countStars($.children).empty.should.be 5

    it 'defaults to 5 if greater than 5 stars', ->
      RatingsWidgetComponent = new RatingsWidget stars: 10
      $ = RatingsWidgetComponent.render()

      countStars($.children).full.should.be 5
