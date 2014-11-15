_ = require 'lodash'

module.exports =
  get: (key) ->
    new Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      value = window.localStorage[key]

      if _.isString value
        return resolve JSON.parse value

      resolve()

  set: (key, value) ->
    new Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      unless _.isObject value
        return reject new Error 'Value must be an object'

      window.localStorage[key] = JSON.stringify value
      resolve value

  del: (key) ->
    new Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      delete window.localStorage[key]
      resolve()
