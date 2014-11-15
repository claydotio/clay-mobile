_ = require 'lodash'

status = (response) ->
  if response.status >= 200 and response.status < 300
    Promise.resolve response
  else
    Promise.reject response

json = (response) ->
  response.json()

module.exports = ->
  options = arguments[1]
  if _.isObject options?.body
    options.headers = _.defaults (options.headers or {}),
      'Accept': 'application/json'
      'Content-Type': 'application/json'
    options.body = JSON.stringify options.body

  window.fetch.apply null, arguments
  .then status
  .then json
