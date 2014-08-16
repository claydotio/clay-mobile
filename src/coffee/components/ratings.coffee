z = require 'zorium'
_ = require 'lodash'

module.exports = class RatingsWidget
  constructor: ({stars}) ->
    if stars > 5
      stars = 5
    if stars < 0
      stars = 0

    @halfStars = Math.round(stars * 2)

    @fullStars = Math.floor(@halfStars / 2)
    @halfStars -= @fullStars * 2

    @emptyStars = 5 - (@fullStars + @halfStars)


  render: =>
    z 'div', _.flatten([
      _.map _.range(@fullStars), ->
        z 'i.fa.fa-star'
      _.map _.range(@halfStars), ->
        z 'i.fa.fa-star-half-o'
      _.map _.range(@emptyStars), ->
        z 'i.fa.fa-star-o'
    ])
