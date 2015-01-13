_ = require 'lodash'

serializeQueryString = (obj, prefix) ->
  str = []
  for p of obj
    if obj.hasOwnProperty(p)
      k = (if prefix then prefix + '[' + p + ']' else p)
      v = obj[p]
      str.push (if typeof v is 'object' then serializeQueryString(v, k) \
                else encodeURIComponent(k) + '=' + encodeURIComponent(v))
  str.join '&'

statusCheck = (response) ->
  if response.status >= 200 and response.status < 300
    Promise.resolve response
  else
    Promise.reject response

toJson = (response) ->
  if response?._body then response.json() else {}

module.exports = (url, options) ->
  if _.isObject options?.body or _.isArray options?.body
    options.headers = _.defaults (options.headers or {}),
      'Accept': 'application/json'
      'Content-Type': 'application/json'
    options.body = JSON.stringify options.body

  if _.isObject options?.qs
    url += '?' + serializeQueryString options.qs

  window.fetch url, options
  .then statusCheck
  .then toJson
