Q = require 'q'

module.exports =
  get: (key) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      try
        value = window.localStorage[key]

        if _.isString value
          return resolve JSON.parse value

        resolve()

      catch err
        reject err

  set: (key, value) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      unless _.isObject value
        return reject new Error 'Value must be an object'

      try
        window.localStorage[key] = JSON.stringify value
        resolve value

      catch err
        reject err

  del: (key) ->
    Q.Promise (resolve, reject) ->
      unless _.isString key
        return reject new Error 'Key must be a String'

      try
        delete window.localStorage[key]
        resolve()

      catch err
        reject err
