class Navigation
  constructor: ->
    @page = 'meet'

  setPage: (page) ->
    @page = page

  getPage: ->
    @page

module.exports = new Navigation()
