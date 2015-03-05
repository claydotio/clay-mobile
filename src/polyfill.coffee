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

# coffeelint: disable=missing_fat_arrows,cyclomatic_complexity
### Blob.js
# A Blob implementation.
# 2014-07-24
#
# By Eli Grey, http://eligrey.com
# By Devin Samarin, https://github.com/dsamarin
# License: X11/MIT
#   See https://github.com/eligrey/Blob.js/blob/master/LICENSE.md
###

###global self, unescape ###

###  @source http://purl.eligrey.com/github/Blob.js/blob/master/Blob.js ###

((view) ->
  'use strict'
  view.URL = view.URL or view.webkitURL
  if view.Blob and view.URL
    try
      new Blob()
      return
    catch e
  # Internally we use a BlobBuilder implementation to base Blob off of
  # in order to support older browsers that only have BlobBuilder
  BlobBuilder = view.BlobBuilder or view.WebKitBlobBuilder or \
  view.MozBlobBuilder or do (view) ->

    get_class = (object) ->
      Object::toString.call(object).match(/^\[object\s(.*)\]$/)[1]

    FakeBlobBuilder = ->
      @data = []
      return

    FakeBlob = (data, type, encoding) ->
      @data = data
      @size = data.length
      @type = type
      @encoding = encoding
      return

    FBB_proto = FakeBlobBuilder.prototype
    FB_proto = FakeBlob.prototype
    FileReaderSync = view.FileReaderSync

    FileException = (type) ->
      @code = @[@name = type]
      return

    file_ex_codes = (
      'NOT_FOUND_ERR SECURITY_ERR ABORT_ERR NOT_READABLE_ERR ENCODING_ERR ' +
      'NO_MODIFICATION_ALLOWED_ERR INVALID_STATE_ERR SYNTAX_ERR'
    ).split(' ')
    file_ex_code = file_ex_codes.length
    real_URL = view.URL or view.webkitURL or view
    real_create_object_URL = real_URL.createObjectURL
    real_revoke_object_URL = real_URL.revokeObjectURL
    URL = real_URL
    btoa = view.btoa
    atob = view.atob
    ArrayBuffer = view.ArrayBuffer
    Uint8Array = view.Uint8Array
    origin = /^[\w-]+:\/*\[?[\w\.:-]+\]?(?::[0-9]+)?/
    FakeBlob.fake = FB_proto.fake = true
    while file_ex_code -= 1
      FileException.prototype[file_ex_codes[file_ex_code]] = file_ex_code + 1
    # Polyfill URL
    if not real_URL.createObjectURL
      URL =
      view.URL = (uri) ->
        uri_info = document.createElementNS('http://www.w3.org/1999/xhtml', 'a')
        uri_origin = undefined
        uri_info.href = uri
        if not ('origin' in uri_info)
          if uri_info.protocol.toLowerCase() is 'data:'
            uri_info.origin = null
          else
            uri_origin = uri.match(origin)
            uri_info.origin = uri_origin and uri_origin[1]
        uri_info

    URL.createObjectURL = (blob) ->
      type = blob.type
      data_URI_header = undefined
      if type is null
        type = 'application/octet-stream'
      if blob instanceof FakeBlob
        data_URI_header = 'data:' + type
        if blob.encoding is 'base64'
          return data_URI_header + ';base64,' + blob.data
        else if blob.encoding is 'URI'
          return data_URI_header + ',' + decodeURIComponent(blob.data)
        if btoa
          return data_URI_header + ';base64,' + btoa(blob.data)
        else
          return data_URI_header + ',' + encodeURIComponent(blob.data)
      else if real_create_object_URL
        return real_create_object_URL.call(real_URL, blob)
      return

    URL.revokeObjectURL = (object_URL) ->
      if object_URL.substring(0, 5) isnt 'data:' and real_revoke_object_URL
        real_revoke_object_URL.call real_URL, object_URL
      return

    FBB_proto.append = (data) ->
      bb = @data
      # decode data to a binary string
      if Uint8Array and (data instanceof ArrayBuffer or \
      data instanceof Uint8Array)
        str = ''
        buf = new Uint8Array(data)
        i = 0
        buf_len = buf.length
        while i < buf_len
          str += String.fromCharCode(buf[i])
          i += 1
        bb.push str
      else if get_class(data) is 'Blob' or get_class(data) is 'File'
        if FileReaderSync
          fr = new FileReaderSync()
          bb.push fr.readAsBinaryString(data)
        else
          # async FileReader won't work as BlobBuilder is sync
          throw new FileException('NOT_READABLE_ERR')
      else if data instanceof FakeBlob
        if data.encoding is 'base64' and atob
          bb.push atob(data.data)
        else if data.encoding is 'URI'
          bb.push decodeURIComponent(data.data)
        else if data.encoding is 'raw'
          bb.push data.data
      else
        if typeof data isnt 'string'
          data += ''
          # convert unsupported types to strings
        # decode UTF-16 to binary string
        bb.push unescape(encodeURIComponent(data))
      return

    FBB_proto.getBlob = (type) ->
      if not arguments.length
        type = null
      new FakeBlob(@data.join(''), type, 'raw')

    FBB_proto.toString = ->
      '[object BlobBuilder]'

    FB_proto.slice = (start, end, type) ->
      args = arguments.length
      if args < 3
        type = null
      new FakeBlob(
        @data.slice(
          start,
          if args > 1 then end else @data.length),
          type, @encoding)

    FB_proto.toString = ->
      '[object Blob]'

    FB_proto.close = ->
      @size = 0
      delete @data
      return

    FakeBlobBuilder

  view.Blob = (blobParts, options) ->
    type = if options then options.type or '' else ''
    builder = new BlobBuilder()
    if blobParts
      i = 0
      len = blobParts.length
      while i < len
        if Uint8Array and blobParts[i] instanceof Uint8Array
          builder.append blobParts[i].buffer
        else
          builder.append blobParts[i]
        i += 1
    blob = builder.getBlob(type)
    if not blob.slice and blob.webkitSlice
      blob.slice = blob.webkitSlice
    blob

  getPrototypeOf = Object.getPrototypeOf or (object) ->
    object.__proto__
  view.Blob.prototype = getPrototypeOf(new (view.Blob))
  return
) typeof self isnt 'undefined' and self or typeof window isnt 'undefined' and \
  window or @content or this

# coffeelint: enable=missing_fat_arrows,cyclomatic_complexity
