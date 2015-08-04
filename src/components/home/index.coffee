z = require 'zorium'
log = require 'clay-loglevel'

Game = require '../../models/game'
config = require '../../config'

styles = require './index.styl'

module.exports = class Home
  constructor: ->
    styles.use()

    # Prism, Treasure Arena, Little Alchemy, Cut The Rope
    featuredGameIds = [
      'b339f236-9bda-46cb-ae26-d0d255bae4fd'
      'b25349c1-86ad-45d4-9257-33e444f89041'
      '42db4b0a-464e-4ae6-b06e-96440ce66573'
      '2c0d64c9-fb3e-4a75-a14c-ee2c6a2ba1cf'
    ]

    @state = z.state
      featuredGames: z.observe Game.get(featuredGameIds).catch log.trace

  render: =>
    {featuredGames} = @state()
    z '.z-home',
      z '.hero.l-content-container',
        z '.info',
          z 'h1', 'Play hundreds of HTML5 mobile games, instantly!'
          z '.sub-head', 'Get the Android app or visit us on Kik or the web'
          z 'a.google-play[target=_blank]
            [href=https://play.google.com/store/apps/details?id=com.clay.clay]',
            z 'img[src=//cdn.wtf/d/images/google_play/google_play_get_it.svg]'
          z 'img.kik[src=//cdn.wtf/d/images/kik/kik_logo.svg]'
        z 'img.phones[src=//cdn.wtf/d/images/desktop_site/devices.jpg]' +
          '[width=430][height=325]'
      z '.featured',
        z '.l-content-container',
            _.map featuredGames, (game) ->
              headerImageUrl = game.headerImage?.versions[0].url or
                               game.promo440Url
              z.router.link z "a.link[href=/game/#{game.key}]",
                z "img.image[src=#{headerImageUrl}]"
      z '.dev-info.l-content-container',
        z 'h1', 'Publish your mobile games to over 5 million players'
        z '.sdk-features',
          z '.sdk-feature',
            z 'i.icon.icon-cloud-upload'
            z '.title', 'Distribution'
            z '.info', 'Distribute your game to the Clay Marketplace and get
                        exposed to millions of players!'
          z '.sdk-feature',
            z 'i.icon.icon-ads'
            z '.title', 'Advertising'
            z '.info', 'Easily implement advertisements in your game to
                        start making money right away.'
          z '.sdk-feature',
            z 'i.icon.icon-share'
            z '.title', 'Social Sharing'
            z '.info', 'Get your players posting to Facebook, Twitter, Kik,
                        and more - inviting their friends to play your game!'
        z '.dev-actions',
          z 'a.button-primary.get-started' +
            "[href=https://#{config.DEV_HOST}/login]",
            'Get started!'
          z 'a.button-ghost.explore-sdk'+
            '[href=https://github.com/claydotio/clay-sdk]', 'Explore the SDK'
      z '.team',
        z '.l-content-container',
          z 'h1', 'Join the team!'
          z '.info', 'Are you an experienced developer?
                      Passionate about games? Join us in San Francisco
                      to help shape the future of Clay!'
          z 'a.apply.button-secondary' +
            '[href=mailto:jobs@clay.io?Subject=Let\'s change the world]',
            'Apply now!'
