z = require 'zorium'
kik = require 'kik'

# TODO: update paths if feature approved
config = require '../../../../coffee/config'
vars = require '../../../../stylus/vars.json'
UrlService = require '../../../../coffee/services/url'

users = [
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'c4af134dbaa272675bc16e972a713d39/l.jpg', name: 'Dan :)',
    scoreMultiplier: 1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '968e19d1f139111d6c2dd3dc600f0da7/l.jpg', name: 'KayLeigh \u2665\u2665',
    scoreMultiplier: 1.2}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'd554d238274becce017a310792795526/l.jpg', name: 'Giovanni Travis',
    scoreMultiplier: 1.1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '2a336cdd1bdbe898a04813640c4ae8cb/l.jpg', name: ':)',
    scoreMultiplier: 1.3}
  # {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
  #  '561d8bf6a9447cba75108c9e72719bff/l.jpg', name: 'nyl oicatsana',
  #  scoreMultiplier: 0.7}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'b992bca3c391389a26afcd7310e4894b/l.jpg', name: 'Serainna BoO c:',
    scoreMultiplier: 1.1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'f322ada6fd1217e7c9e771f82b218e35/l.jpg', name: 'Shrooms Guy',
    scoreMultiplier: 1.5}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'fe2331ac6863d8aa70a6df499ad326be/l.jpg', name: 'Rachael Mooney',
    scoreMultiplier: 0.6}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '8263796019ac893cb9396b94152ba176/l.jpg', name: 'Cynthia Madison',
    scoreMultiplier: 0.9}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'f47751db57c0886d36ecd5d701b271e3/l.jpg', name: 'Mehar Aneja',
    scoreMultiplier: 1.2}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '514c00469539d17567e264fc07dcaafc/l.jpg', name: 'Amari Kasparian',
    scoreMultiplier: 0.5}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '8e96eb29ddfc66530af55dfbf403c472/l.jpg', name: 'Sara ',
    scoreMultiplier: 1.4}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    'd70a4336f0955772916c79610c191368/l.jpg', name: 'Tk Mills',
    scoreMultiplier: 1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '218a38de9e6e742e25c7522a4beb7257/l.jpg', name: 'Meeka Massey',
    scoreMultiplier: 1.2}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '549e0397a411569c511449887562a0e3/l.jpg', name: 'Rakesh Shaw',
    scoreMultiplier: 0.9}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '1153ac13664d261267814680373037c5/l.jpg', name: 'LOL :)',
    scoreMultiplier: 1.1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '1906defd8cd5478720e4763270da3301/l.jpg', name: 'Eren Jaeger',
    scoreMultiplier: 0.8}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '43424399187ec949e72154e39704573d/l.jpg', name: 'Kyle Kersten',
    scoreMultiplier: 1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '6cbd3af365aa54c00cbb03406ef0f057/l.jpg', name: 'Dustin Cronan',
    scoreMultiplier: 1.3}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '184c50a7bf71db9b37e581422d74938a/l.jpg', name: 'Jack Warrington',
    scoreMultiplier: 0.7}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '5845ee702b37c316cffe79054738c89a/l.jpg', name: 'Mo Miles',
    scoreMultiplier: 0.8}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
    '42f17d20603c0356010d8462c10128be/l.jpg', name: 'Adam Afro',
    scoreMultiplier: 1.2}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
   '6f19f00d84fa2227e039553dc66a6176/l.jpg', name: 'Baby Doll',
   scoreMultiplier: 1.1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
   '58d1e0307c7d7675b453f483e1bb73e6/l.jpg', name: 'Jasmine Ceasar',
   scoreMultiplier: 1}
  {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
   'a6a0585f48aa7a66f38c4a63128ab272/l.jpg', name: 'Jessie \u2661',
   scoreMultiplier: 0.9}
  # {pic: 'http://d2ljkm6t8g2y1h.cloudfront.net/' +
  #   '6225e4845dbc9fedc94e6efd99f29e95/l.jpg', name: '\u270cLauren \u270c',
  #   scoreMultiplier: 1.3}
]

games = [
  {
    pic: 'http://cdn.wtf/g/8/meta/icon_128.png', name: 'Slime Volley',
    key: 'slime', fakeScore: 12
  }
  {
    pic: 'http://cdn.wtf/g/22/meta/icon_128.png', name: 'Word Wars',
    key: 'wordwars', fakeScore: 120
  }
  {
    pic: 'http://cdn.wtf/g/4875/meta/icon_128.png', name: 'Prism',
    key: 'prism', fakeScore: 4000
  }
  {
    pic: 'http://cdn.wtf/g/389/meta/icon_128.png', name: 'Lunch Bug',
    key: 'lunchbug', fakeScore: 20000
  }
  {
    pic: 'http://cdn.wtf/g/6799/meta/icon_128.png', name: 'Epic Ice Cream',
    key: 'epic', fakeScore: 40000
  }
  {
    pic: 'http://cdn.wtf/g/2492/meta/icon_128.png', name: 'Black & White Snake'
    key: 'blackandwhitesnake', fakeScore: 1600
  }

  {
    pic: 'http://cdn.wtf/g/8/meta/icon_128.png', name: 'Slime Volley',
    key: 'slime', fakeScore: 12
  }
  {
    pic: 'http://cdn.wtf/g/22/meta/icon_128.png', name: 'Word Wars',
    key: 'wordwars', fakeScore: 120
  }
  {
    pic: 'http://cdn.wtf/g/4875/meta/icon_128.png', name: 'Prism',
    key: 'prism', fakeScore: 4000
  }
  {
    pic: 'http://cdn.wtf/g/389/meta/icon_128.png', name: 'Lunch Bug',
    key: 'lunchbug', fakeScore: 20000
  }
  {
    pic: 'http://cdn.wtf/g/6799/meta/icon_128.png', name: 'Epic Ice Cream',
    key: 'epic', fakeScore: 40000
  }
  {
    pic: 'http://cdn.wtf/g/2492/meta/icon_128.png', name: 'Black & White Snake'
    key: 'blackandwhitesnake', fakeScore: 1600
  }

  {
    pic: 'http://cdn.wtf/g/8/meta/icon_128.png', name: 'Slime Volley',
    key: 'slime', fakeScore: 12
  }
  {
    pic: 'http://cdn.wtf/g/22/meta/icon_128.png', name: 'Word Wars',
    key: 'wordwars', fakeScore: 120
  }
  {
    pic: 'http://cdn.wtf/g/4875/meta/icon_128.png', name: 'Prism',
    key: 'prism', fakeScore: 4000
  }
  {
    pic: 'http://cdn.wtf/g/389/meta/icon_128.png', name: 'Lunch Bug',
    key: 'lunchbug', fakeScore: 20000
  }
  {
    pic: 'http://cdn.wtf/g/6799/meta/icon_128.png', name: 'Epic Ice Cream',
    key: 'epic', fakeScore: 40000
  }
  {
    pic: 'http://cdn.wtf/g/2492/meta/icon_128.png', name: 'Black & White Snake'
    key: 'blackandwhitesnake', fakeScore: 1600
  }

  {
    pic: 'http://cdn.wtf/g/8/meta/icon_128.png', name: 'Slime Volley',
    key: 'slime', fakeScore: 12
  }
  {
    pic: 'http://cdn.wtf/g/22/meta/icon_128.png', name: 'Word Wars',
    key: 'wordwars', fakeScore: 120
  }
  {
    pic: 'http://cdn.wtf/g/4875/meta/icon_128.png', name: 'Prism',
    key: 'prism', fakeScore: 4000
  }
  {
    pic: 'http://cdn.wtf/g/389/meta/icon_128.png', name: 'Lunch Bug',
    key: 'lunchbug', fakeScore: 20000
  }
  {
    pic: 'http://cdn.wtf/g/6799/meta/icon_128.png', name: 'Epic Ice Cream',
    key: 'epic', fakeScore: 40000
  }
  {
    pic: 'http://cdn.wtf/g/2492/meta/icon_128.png', name: 'Black & White Snake'
    key: 'blackandwhitesnake', fakeScore: 1600
  }
]

shuffle = (array) ->
  counter = array.length
  temp = undefined
  index = undefined

  # While there are elements in the array
  while counter > 0

    # Pick a random index
    index = Math.floor(Math.random() * counter)

    # Decrease counter by 1
    counter -= 1

    # And swap the last element with it
    temp = array[counter]
    array[counter] = array[index]
    array[index] = temp
  array

module.exports = class Meet
  constructor: ->
    shuffle users
    shuffle games
    @currentUser = users[1] # 2nd user
    @currentGame = games[1] # 2nd game

  # in case we want to use css animations
  # animationIndex: 0
  spin: =>
    # always show the 10th person (user/game arrays are shuffled)
    newPersonIndex = 18 #Math.floor(Math.random() * games.length)

    imageMargin = vars.$hackMeetImageYMargin
    imageHeight = vars.$hackMeetImageSize
    imageHeightWithMargin = vars.$hackMeetImageSize + 2 * imageMargin
    spinnerHeight = vars.$hackMeetSpinnerHeight
    baseTopPos = -1 * imageHeightWithMargin +
                 (spinnerHeight - imageHeightWithMargin) / 2
    # skip over 2 images
    # game #0 never gets picked
    newTopPosPx = (baseTopPos - (newPersonIndex - 1) * imageHeightWithMargin) +
                  'px'

    # alternative way to do (would need to factor in base top offset)
    #newTopPosPx = -1 *
    #  document.querySelector('.meet-spinner-user-image-3').offsetTop + 'px'

    $meetSpinnerUsers = document.querySelector '.meet-spinner-users'
    $meetSpinnerUsers.style.top = newTopPosPx
    $meetSpinnerGames = document.querySelector '.meet-spinner-games'
    $meetSpinnerGames.style.top = newTopPosPx

    # hide spinner
    $meetSpinnerButton = document.querySelector '.meet-spinner-try-again'
    $meetSpinnerButton.style.display = 'none'

    # after spinning is done (2s)
    setTimeout (=> @setUserAndGame(newPersonIndex)), 2000

    ###
    In case we want to use CSS animations: (rough implementation. problem is
    CSS animation end-result doesn't persist)
    # only supports webkit for now (supporting others can be done easily by
    # adding other prefixes)
    this may not work if we're inlining css
    keyframes = "@-webkit-keyframes spin#{Meet::animationIndex} " +
                '{ 0% { top: 50px; }' +
                '100% { top: 250px; } }'
    document.styleSheets[0].insertRule( keyframes, 0 )
    $meetSpinnerList.style.webkitAnimation = "spin#{Meet::animationIndex}" +
                                             ' 1s linear 1'
    # deleting old keyframes doesn't actually seem to get rid of them.
    # so we create a crap-ton. 2 per spin
    Meet::animationIndex += 1
    ###

  setUserAndGame: (index) =>
    @currentUser = users[index]
    @currentGame = games[index]
    z.redraw()

  acceptChallenge: =>
    # send user to the selected game, ignore the score for now (hack)
    # TODO: this code is copied from game_box.coffee. We might want a
    # service to send people to games?
    z.route UrlService.getGameRoute {game: @currentGame}
    httpSubDomainUrl = UrlService.getGameSubdomain
      game: @currentGame, protocol: 'http:'
    kik.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z 'div.meet',
      z 'div.meet-content',
        z 'h2', 'Meet and play games!'
        # own component?
        z 'div.meet-spinner',
          z 'ul.meet-spinner-list.meet-spinner-users',
            for user, i in users
              z 'li',
                z "img.meet-spinner-user-image-#{i}",
                  src: user.pic
                  width: vars.$hackMeetImageSize
                  height: vars.$hackMeetImageSize

          z 'ul.meet-spinner-list.meet-spinner-games',
            for game, i in games
              z 'li',
                z "img.meet-spinner-game-image-#{i}",
                  src: game.pic
                  width: vars.$hackMeetImageSize
                  height: vars.$hackMeetImageSize


          z 'button.meet-spinner-try-again', onclick: @spin,
            z 'i.icon.icon-dice'

        z 'div.meet-spinner-labels',
          z 'div.meet-spinner-user', 'Austin Hallock'
          z 'div.meet-spinner-game', 'Treasure Arena'

        z 'div.l-content-container',
          z 'div.meet-challenge', 'They scored ',
            z 'strong',
              (Math.round @currentGame.fakeScore * @currentUser.scoreMultiplier)
              .toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') # prettify
            ' points'
          z 'button.button-primary.is-block.meet-button',
            {onclick: @acceptChallenge},
            'I can beat that!',
            z 'span.meet-button-challenge-icon',
              z 'i.icon.icon-challenge'
