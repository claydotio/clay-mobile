require 'polyfill'
mock = require 'mock'

ZockService = require './_services/zock'

testsContext = require.context('./unit', true)
testsContext.keys().forEach testsContext

before ->
  window.XMLHttpRequest = ->
    ZockService.XMLHttpRequest()
