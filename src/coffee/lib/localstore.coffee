Q = require 'q'

module.exports =
  get: (key) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      value = window.localStorage[key]

      if _.isString value
        return resolve JSON.parse value

      resolve()

  set: (key, value) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      unless _.isObject value
        return reject new Error 'Value must be an object'

      window.localStorage[key] = JSON.stringify value
      resolve value

  del: (key) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      delete window.localStorage[key]
      resolve()
