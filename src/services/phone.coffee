dialCodes = require '../lib/dial_codes.json'
request = require '../lib/request'
log = require 'clay-loglevel'

INTERNATIONAL_PHONE_REGEX = '\\+(9[976]\\d|8[987530]\\d|6[987]\\d|' +
                            '5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9' +
                            '[8543210]|8[6421]|6[6543210]|5[87654321]|' +
                            '4[987654310]|3[9643210]|2[70]|7|1)' +
                            '\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d' +
                            '\\W*\\d\\W*\\d\\W*(\\d{1,2})$'


class PhoneService
  normalizePhoneNumber: (phone) ->
    # strip everything but intial plus and digits
    digitPhone = phone.replace /[^\+?\d]/g, ''

    isInternationalPhone = phone.match new RegExp INTERNATIONAL_PHONE_REGEX
    if isInternationalPhone
      Promise.resolve digitPhone
    else
      request('https://ipinfo.io/json')
      .then (locationData) ->
        console.log locationData
        internationalPhone = dialCodes[locationData.country] + digitPhone
        if internationalPhone.match new RegExp INTERNATIONAL_PHONE_REGEX
          return dialCodes[locationData.country] + digitPhone
        else
          log.trace new Error "invalid phone number #{internationalPhone}"
          # TODO: (Austin) throw an err here when we have client-side validation
          return ''
      .catch (err) ->
        # if ipinfo fails, log to server and just assume user is U.S.
        log.trace err
        return "+1#{digitPhone}"

module.exports = new PhoneService()
