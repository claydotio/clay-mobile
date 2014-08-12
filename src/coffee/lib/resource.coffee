_ = require 'lodash'
Q = require 'q'
z = require 'zorium'
Restangular = require 'restangular'

resource = {}
Restangular.call(resource)

serializeQueryString = (obj, prefix) ->
  str = []
  for p of obj
    k = (if prefix then prefix + '[' + p + ']' else p)
    v = obj[p]
    str.push (
      if typeof v is 'object'
      then serialize(v, k)
      else encodeURIComponent(k) + '=' + encodeURIComponent(v)
    )
  str.join '&'

request = (opts) ->
  opts = _.defaults opts, {
    deserialize: _.identity
    extract: (xhr, xhrOptions) ->
      data: JSON.parse(xhr.responseText)
      status: xhr.status
      headers: _.bind xhr.getResponseHeader, xhr
      config: xhrOptions
      statusText: xhr.statusText
    }

  if opts.params
    opts.url = opts.url + '?' + serializeQueryString(opts.params)

  z.request(opts)

_.assign(resource, resource.$get[2](request, Q))

module.exports = resource
