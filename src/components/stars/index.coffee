z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class RatingsWidget
  # set interactive to true if tapping on a star should fill up to that star
  constructor: ({stars, @interactive}) ->
    styles.use()

    if stars > 5
      stars = 5
    if stars < 0
      stars = 0

    @setStarAmounts(stars)

  setStarAmounts: (stars) ->
    @halfStars = Math.round(stars * 2)

    @fullStars = Math.floor(@halfStars / 2)
    @halfStars -= @fullStars * 2

    @emptyStars = 5 - (@fullStars + @halfStars)

  # @return current rating: 0-5 with 0.5 precision (eg 0, 0.5, etc...)
  getStarCount: =>
    return @fullStars + @halfStars * 0.5

  render: =>
    # local versions
    emptyStars = @emptyStars
    halfStars = @halfStars
    fullStars = @fullStars

    z 'div.z-stars', _.map _.range(5), (i) ->
      rating = i + 1
      # what to do when a star is clicked

      if fullStars
        star = z 'i.icon.icon-star.is-filled'
        fullStars -= 1
      else if halfStars
        star = z 'i.icon.icon-star-half-fill.is-filled',
          z 'i.icon.icon-star.is-empty' # bg star
        halfStars -= 1
      else if emptyStars
        star = z 'i.icon.icon-star.is-empty'
        emptyStars -= 1

      return star
