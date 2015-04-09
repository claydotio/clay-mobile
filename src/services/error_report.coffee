_ = require 'lodash'

config = require '../config'

stringifyError = (error) ->
  errorString = try
    JSON.stringify error
  catch
    ''

  try
    JSON.stringify
      message: error.message or errorString or String error
      stack: error.stack or error.error?.stack or '' # ErrorEvent
  catch
    String error

class ErrorReportService
  report: (errors...) ->
    # Remove the circular dependency within error objects
    errors = _.map errors, stringifyError

    window.fetch config.PUBLIC_CLAY_API_URL + '/log',
      method: 'POST'
      headers:
        'Accept': 'application/json'
        'Content-Type': 'application/json'
      body:
        JSON.stringify message: errors.join ' '
    .catch (err) ->
      console?.error err

module.exports = new ErrorReportService()
