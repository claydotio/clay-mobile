z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'
request = require '../../lib/request'
VerticalDivider = require '../../components/vertical_divider'
InputText = require '../input_text'
User = require '../../models/user'
Developer = require '../../models/developer'

styles = require './index.styl'

module.exports = class DevLogin
  constructor: ->
    styles.use()

    @o_email = z.observe ''
    @o_password = z.observe ''
    @o_applyEmail = z.observe ''
    @o_applyGameUrl = z.observe ''

    @state = z.state
      emailInput: new InputText {
        label: 'Email'
        o_value: @o_email
        theme: '.theme-full-width'
      }
      passwordInput: new InputText {
        type: 'password'
        label: 'Password'
        o_value: @o_password
        theme: '.theme-full-width'
      }
      applyEmailInput: new InputText {
        label: 'Email'
        o_value: @o_applyEmail
        theme: '.theme-full-width'
      }
      applyGameUrlInput: new InputText {
        label: 'Game URL'
        o_value: @o_applyGameUrl
        theme: '.theme-full-width'
      }
      verticalDivider: new VerticalDivider()

  login: =>
    User.loginBasic {email: @o_email(), password: @o_password()}
    .then (me) ->
      User.setMe me
    .then ({id}) ->
      Developer.find {ownerId: id }
    .then (developers) ->
      if _.isEmpty developers
        Developer.create()

  apply: =>
    User.getMe().then ({accessToken}) =>
      request("#{config.CLAY_API_URL}/developerApplications", {
        method: 'post'
        qs:
          accessToken: accessToken
        body:
          email: @o_applyEmail()
          gameUrl: @o_applyGameUrl()
      })

  render: (
    {
      emailInput
      passwordInput
      applyEmailInput
      applyGameUrlInput
      verticalDivider
    }
  ) ->
    z 'div.z-dev-login',
      z 'div.banner.l-flex.l-vertical-center',
        z 'div.content',
          z 'div', 'Welcome, developers.'
          z 'div', 'Sign in to start publishing'

      z 'div.login-apply.l-content-container.l-flex',
        z 'div.login',
          z 'h1', 'Sign In'
          z 'div.friendly-message', 'Hey, good to see you again.'
          z 'form', {
            onsubmit: (e) =>
              e.preventDefault()
              @login()
              .then ->
                z.router.go '/dashboard'
              .catch (err) ->
                log.trace err
                error = JSON.parse err._body
                # TODO: (Austin) better error handling UX
                window.alert "Error: #{error.detail}"
                throw err
              .catch log.trace
            },
            emailInput
            passwordInput
            # TODO (Austin) forgot password, whenever someone aks for it
            z 'button.button-secondary.sign-in-button', 'Sign In'
          z 'div.tos',
            'By signup up for Clay.io, you agree to our '
            z 'a[href=/tos]', 'Terms of Service'

        verticalDivider

        z 'div.apply',
          z 'h1', 'Request an invite'
          z 'div.friendly-message',
            z 'p',
              'We aim to provide the best possible support to every developer on
              Clay.'
            z 'p', "To do this we're limiting signups for now.
              Share your awesome game with us and we'll send you an
              invite when we can."

          z 'form', {
            onsubmit: (e) =>
              e.preventDefault()
              @apply()
              .then ->
                # TODO: (Austin) application success page
                window.alert 'Application recieved. Thanks!'
              .catch (err) ->
                log.trace err
                error = JSON.parse err._body
                # TODO: (Austin) better error handling UX
                window.alert "Error: #{error.detail}"
                throw err
              .catch log.trace
            },
            applyEmailInput
            applyGameUrlInput
            z 'button.button-primary.apply-button', 'Apply!'

      z 'div.player-message',
        z 'div.l-content-container.content',
          z 'h1', 'Are you a player?'
          z 'div', 'Download our Android app or visit Clay on Kik or your
                    web browser to play.'
          z 'div.links',
            z 'a.google-play[target=_blank][href=
              http://play.google.com/store/apps/details?id=com.clay.clay]',
              z 'img' +
                '[src=//cdn.wtf/d/images/google_play/google_play_get_it.svg]'
            z 'a.kik[href=http://kik.com][target=_blank]',
              z 'img[src=//cdn.wtf/d/images/kik/kik_logo.svg]'
