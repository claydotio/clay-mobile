class ImageService
  getAvatarUrl: (user, {size} = {}) ->
    size ?= 'small'
    versions = {
      small: 0
      large: 1
    }
    return user.avatarImage?.versions[versions[size]].url or
      '//cdn.wtf/d/images/general/profile-square.png'

  getGameIconUrl: (game) ->
    return game.iconImage?.versions[0].url or game.icon128Url

module.exports = new ImageService()
