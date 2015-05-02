require 'polyfill'
mock = require 'mock'

# NOTE: zock doesn't override native window.fetch, so it doesn't work in latest
# chrome
testsContext = require.context('./unit', true)
testsContext.keys().forEach testsContext
