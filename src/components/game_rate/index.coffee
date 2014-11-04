z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'
RatingsWidget = require '../stars'
Rating = require '../../models/rating'

require './index.styl'

module.exports = class GameRate
  constructor: ({@game, @onRated}) ->
    # all stars empty, clickable stars
    @RatingsWidget = new RatingsWidget stars: 0, interactive: true

  submitRating: =>
    Rating.all('ratings').post
      vote: @RatingsWidget.getStarCount()
      # TODO: (Austin) have some sort of session so we don't need to pass
      # gameId for every API call
      gameId: @game.id
      # TODO: (Austin) pass userId
    .then =>
      @onRated()
    .catch log.trace

  render: =>
    disabled = if @RatingsWidget.getStarCount() is 0 then '[disabled]' else ''

    z 'div.game-rate',
      z 'div.game-rate-promo',
        style: "background-image: url(#{@game.promo440Url})"
        z 'h1', "Rate #{@game.name}"
      z 'p.game-rate-message', 'Help great games stand out!'
      z 'div.game-rate-stars',
        @RatingsWidget.render()
      z "button.button-ghost.is-block#{disabled}", {onclick: @submitRating},
        'Rate it'
