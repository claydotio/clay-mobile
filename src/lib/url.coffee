_ = require 'lodash'

class UrlLib
  serializeQueryString: (obj, prefix) =>
    str = []
    for p of obj
      if obj.hasOwnProperty(p)
        k = (if prefix then prefix + '[' + p + ']' else p)
        v = obj[p]
        str.push (if typeof v is 'object' then @serializeQueryString(v, k) \
                  else encodeURIComponent(k) + '=' + encodeURIComponent(v))
    str.join '&'

module.exports = new UrlLib()
