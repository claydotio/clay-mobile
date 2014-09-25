_ = require 'lodash'
kik = require 'kik'
log = require 'loglevel'
Q = require 'q'

User = require '../models/user'

parseKikMethod = (method) ->
  caller = null
  fn = kik

  # Wrapper methods ontop of kik properties
  switch
    when /^kik\.getMessage$/.test method
      caller = null
      fn = kik.message

    when /^kik\.isInPicker$/.test method
      caller = null
      fn = Boolean kik.picker.reply

    when /^kik\.getLinkData$/.test method
      caller = null
      fn = kik.linkData

    when /^kik\.isBrowserBackground$/.test method
      caller = null
      fn = kik.browser.background

    when /^kik\.getPlatformOS$/.test method
      caller = null
      fn = kik.utils.platform.os

    when /^kik\.getPlatformBrowser$/.test method
      caller = null
      fn = kik.utils.platform.browser

    when /^kik\.getPlatformEngine$/.test method
      caller = null
      fn = kik.utils.platform.engine

    else
      # kik.abc.xyz(), caller is kik.abc, fn is kik.abc.xyz
      methods = method.split('.').slice 1
      while methods.length
        next = methods.shift()
        caller = fn
        fn = caller[next]

  { caller, fn }

module.exports = class SDKDir
  runKikMethod: (messageData) ->
    new Q.Promise (resolve, reject) ->
      method = messageData.method
      params = messageData.params

      notSupported = [
        'kik.photo.getFromCamera'
        'kik.photo.getFromGallery'
        'kik.browser.on'
        'kik.on'
        'kik.off'
        'kik.once'
      ]

      if _.contains notSupported, method
        reject 'METHOD NOT SUPPORTED'

      {caller, fn} = parseKikMethod(method)

      if typeof fn is 'function'

        kikMethodsWithoutCallback = [
          'kik.hasPermission'
          'kik.send'
          'kik.open'
          'kik.metrics.enableGoogleAnalytics'
          'kik.browser.getOrientationLock'
          'kik.formHelpers.show'
          'kik.formHelpers.hide'
          'kik.formHelpers.isEnabled'
          'kik.trigger'
        ]

        if _.contains kikMethodsWithoutCallback, method
          res = fn.apply caller, params or []
          resolve res

        else
          # reply
          cb = (args...) ->
            res = args
            if args.length is 1
              res = args[0]

            resolve res

          fn.apply caller, (params or []).concat([cb])

      else
        resolve fn

  onMessage: (e) =>
    try
      data = JSON.parse e.data
      method = data.method
      _id = data._id

    catch err
      log.trace err
      return

    switch
      when method is 'ping'
        # pong
        e.source.postMessage JSON.stringify({_id}), '*'

      when method is 'auth.getStatus'
        @authGetStatus()
        .then (status) ->
          message = _.defaults {_id}, result: status
          e.source.postMessage JSON.stringify(message), '*'

      when /^kik\.[\w.]+$/.test method
        @runKikMethod data
        .then (result) ->
          message = _.defaults {_id}, result: result
          e.source.postMessage JSON.stringify(message), '*'
        .catch (err) ->
          message = _.defaults {_id}, error: err
          e.source.postMessage JSON.stringify(message), '*'


      else null


  authGetStatus: ->
    User.getMe().then (user) ->
      accessToken: user.id

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    @$iframe = $el

    window.addEventListener 'message', @onMessage

    ctx.onunload = =>
      window.removeEventListener 'message', @onMessage
