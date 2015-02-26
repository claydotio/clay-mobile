_ = require 'lodash'

UrlService = require '../services/url'

statusCheck = (response) ->
  if response.status >= 200 and response.status < 300
    Promise.resolve response
  else
    Promise.reject response

toJson = (response) ->
  if response.status is 204 then null else response.json()

module.exports = (url, options) ->
  if _.isObject options?.body or _.isArray options?.body
    options.headers = _.defaults (options.headers or {}),
      'Accept': 'application/json'
      'Content-Type': 'application/json'
    options.body = JSON.stringify options.body

  if _.isObject options?.qs
    url += '?' + UrlService.serializeQueryString options.qs

  window.fetch url, options
  .then statusCheck
  .then toJson
