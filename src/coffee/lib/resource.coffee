_ = require 'lodash'
Q = require 'q'
z = require 'zorium'
Restangular = require 'restangular'

resource = {}
Restangular.call(resource)

_.assign(resource, resource.$get[2](z.request.bind(z), Q))

module.exports = resource
