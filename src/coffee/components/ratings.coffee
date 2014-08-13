z = require 'zorium'
_ = require 'lodash'

module.exports = class RatingsWidget
  constructor: ({@stars}) ->
    @totalStars = 5
  render: ->
    z 'div', _.flatten([
      _.map _.range(@stars), ->
        z 'i.fa.fa-star'
      _.map _.range(@totalStars - @stars), ->
        z 'i.fa.fa-star-o'
    ])
