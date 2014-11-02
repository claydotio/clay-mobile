_ = require 'lodash-contrib'
should = require('clay-chai').should()

RatingsWidget = require 'components/stars'

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.attrs.className.split(' '), className

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

  describe 'interactive', ->

    it 'sets stars to 4', ->
      RatingsWidgetComponent = new RatingsWidget stars: 0
      RatingsWidgetComponent.setStarAmounts 4

      RatingsWidgetComponent.fullStars.should.be 4
      RatingsWidgetComponent.halfStars.should.be 0
      RatingsWidgetComponent.emptyStars.should.be 1
      RatingsWidgetComponent.getStarCount().should.be 4

    it 'sets rounds stars to 4.5 if set to 4.25', ->
      RatingsWidgetComponent = new RatingsWidget stars: 0
      RatingsWidgetComponent.setStarAmounts 4.25

      RatingsWidgetComponent.fullStars.should.be 4
      RatingsWidgetComponent.halfStars.should.be 1
      RatingsWidgetComponent.emptyStars.should.be 0
      RatingsWidgetComponent.getStarCount().should.be 4.5

    it 'adds onclick for interactive ratings RatingsWidgetComponents', ->
      RatingsWidgetComponent = new RatingsWidget stars: 0, interactive: true
      $ = RatingsWidgetComponent.render()

      clickableStars = _.reduce $.children, (sum, $star) ->
        if hasClass($star, 'icon-star') and $star.attrs.onclick
        then sum + 1
        else sum
      , 0

      clickableStars.should.be 5

    it 'ignores onclick for non-interactive ratings RatingsWidgetComponents', ->
      RatingsWidgetComponent = new RatingsWidget stars: 0
      $ = RatingsWidgetComponent.render()

      clickableStars = _.reduce $.children, (sum, $star) ->
        if hasClass($star, 'icon-star') and $star.attrs.onclick
        then sum + 1
        else sum
      , 0

      clickableStars.should.be 0

    it 'sets stars to 1 onclick', ->
      RatingsWidgetComponent = new RatingsWidget stars: 0, interactive: true
      $ = RatingsWidgetComponent.render()

      $firstStar = domWalker.find $, ($node) ->
        return hasClass $node, 'icon-star'

      $firstStar.attrs.onclick()

      RatingsWidgetComponent.getStarCount().should.be 1
