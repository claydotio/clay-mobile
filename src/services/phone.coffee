dialCodes = require '../lib/dial_codes.json'
request = require '../lib/request'

INTERNATIONAL_PHONE_REGEX = new RegExp '\\+(9[976]\\d|8[987530]\\d|6[987]\\d|' +
                            '5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9' +
                            '[8543210]|8[6421]|6[6543210]|5[87654321]|' +
                            '4[987654310]|3[9643210]|2[70]|7|1)' +
                            '\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d' +
                            '\\W*\\d\\W*\\d\\W*(\\d{1,2})$'


class PhoneService
  sanitizePhoneNumber: (phone) ->
    # strip everything but intial plus and digits
    digitPhone = phone.replace /[^\+?\d]/g, ''

    isInternationalPhone = phone.match INTERNATIONAL_PHONE_REGEX
    if isInternationalPhone
      Promise.resolve digitPhone
    else
      request('https://ipinfo.io/json')
      .then (locationData) ->
        return dialCodes[locationData.country] + digitPhone


module.exports = new PhoneService()
