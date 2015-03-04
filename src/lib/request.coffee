_ = require 'lodash'

UrlLib = require './url'
MIN_REQUEST_TIME_ERROR_MS = 2000 # 2s
statusCheck = (response) ->
  if response.status >= 200 and response.status < 300
    Promise.resolve response
  else
    Promise.reject response

toJson = (response) ->
  if response.status is 204 then null else response.json()

module.exports = (url, options) ->
  startTime = Date.now()

  if _.isObject options?.body or _.isArray options?.body
    options.headers = _.defaults (options.headers or {}),
      'Accept': 'application/json'
      'Content-Type': 'application/json'
    options.body = JSON.stringify options.body

  if _.isObject options?.qs
    url += '?' + UrlLib.serializeQueryString options.qs

  window.fetch url, options
  .then statusCheck
  .then toJson
  .then (res) ->
    endTime = Date.now()
    requestTime = endTime - startTime
    if requestTime > MIN_REQUEST_TIME_ERROR_MS
      setTimeout ->
        throw new Error "event=long_request,
                        request_time_ms=#{requestTime},
                        url=#{url},
                        options=#{options}"
    return res
  .catch (err) ->
    if err?.json
      err.json().then (error) ->
        throw error
    else
      throw err
