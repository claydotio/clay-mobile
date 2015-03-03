# Bind polyfill (phantomjs doesn't support bind)
# coffeelint: disable=missing_fat_arrows
unless Function::bind
  Function::bind = (oThis) ->

    # closest thing possible to the ECMAScript 5
    # internal IsCallable function
    throw new TypeError(
      'Function.prototype.bind - what is trying to be bound is not callable'
    ) if typeof this isnt 'function'
    aArgs = Array::slice.call(arguments, 1)
    fToBind = this
    fNOP = -> null

    fBound = ->
      fToBind.apply(
        (if this instanceof fNOP and oThis then this else oThis),
        aArgs.concat(Array::slice.call(arguments))
      )

    fNOP:: = @prototype
    fBound:: = new fNOP()
    fBound
# coffeelint: enable=missing_fat_arrows

# Promise polyfill - https://github.com/zolmeister/promiz
Promise = require 'promiz'
window.Promise = window.Promise or Promise

# Fetch polyfill - https://github.com/github/fetch
require 'whatwg-fetch'

# window.screen.unlockOrientation polyfill
# Cannot override window.screen.orientation.unlock due to old browser conflicts
# Be careful with scope application `this`
window.screen ?= {}
window.screen.unlockOrientation = (window.screen.orientation?.unlock and
                                  (-> window.screen.orientation.unlock())) or
                                  window.screen.unlockOrientation or
                                  window.screen.webkitUnlockOrientation or
                                  window.screen.mozUnlockOrientation
