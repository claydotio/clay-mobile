_ = require 'lodash'

User = require '../models/user'

module.exports = class SDKDir
  onMessage: (e) =>
    data = JSON.parse e.data
    method = data.method
    _id = data._id

    if method is 'ping'
      # pong
      e.source.postMessage JSON.stringify({_id}), '*'

    else if method is 'auth.getStatus'
      @authGetStatus()
      .then (status) ->
        message = _.defaults {_id}, status
        e.source.postMessage JSON.stringify(message), '*'

    else if /^kik\.[\w.]+$/
      caller = null
      fn = kik

      if /^kik\.getMessage$/.test method
        caller = null
        fn = kik.message

      else if /^kik\.isInPicker$/.test method
        caller = null
        fn = kik.picker

      else
        # kik.abc.xyz(), caller is kik.abc, fn is kik.abc.xyz
        methods = method.split('.').slice 1
        while methods.length
          next = methods.shift()
          caller = fn
          fn = caller[next]

      if typeof fn is 'function'

        # reply
        cb = (args...) ->
          res = args
          if args.length is 1
            res = args[0]

          message = _.defaults {_id}, result: res
          e.source.postMessage JSON.stringify(message), '*'

        fn.apply caller, (data.params or []).concat [cb]

      else
        message = _.defaults {_id}, result: fn
        e.source.postMessage JSON.stringify(message), '*'

  authGetStatus: ->
    User.me().then (user) ->
      accessToken: user.id

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    @$iframe = $el

    window.addEventListener 'message', @onMessage

    ctx.onunload = =>
      window.removeEventListener 'message', @onMessage
