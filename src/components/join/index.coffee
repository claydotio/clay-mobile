z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PhoneService = require '../../services/phone'
EnvironmentService = require '../../services/environment'
PrimaryButton = require '../primary_button'
Spinner = require '../spinner'
config = require '../../config'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    o_name = z.observe ''
    o_nameError = z.observe null
    o_phone = z.observe ''
    o_phoneError = z.observe null
    o_password = z.observe ''
    o_passwordError = z.observe null

    @state = z.state
      isLoading: false
      $spinner: new Spinner()
      $nameInput: new Input {
        o_value: o_name
        o_error: o_nameError
      }
      $phoneInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $passwordInput: new Input {
        o_value: o_password
        o_error: o_passwordError
      }
      $signupButton: new PrimaryButton()
      o_nameError: o_nameError
      o_name: o_name
      o_phone: o_phone
      o_phoneError: o_phoneError
      o_password: o_password
      o_passwordError: o_passwordError

  signup: (fromUserId) =>
    @state.set isLoading: true

    name = @state.o_name()
    password = @state.o_password()
    phone = @state.o_phone()

    unless name
      @state.o_nameError.set 'Please enter a name'
      @state.set isLoading: false
      return Promise.resolve null

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, password}
    .then (me) =>
      @state.set isLoading: false
      return me
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_phoneError.set err.detail
      @state.set isLoading: false
      throw err
    .then (me) ->
      User.setMe Promise.resolve me
    .then (me) ->
      User.updateMe({name: name}).catch log.trace

      User.setSignedUpThisSession true

      if fromUserId
        User.addFriend(fromUserId).catch log.trace

      ga? 'send', 'event', 'user', 'signup', fromUserId
      User.convertExperiment('phone_signup').catch log.trace

      z.router.go '/invite'

  render: ({fromUserId}) =>
    {$nameInput, $phoneInput, $passwordInput, $signupButton,
      $spinner, isLoading} = @state()

    windowTarget = if EnvironmentService.isClayApp() \
                   then '_system'
                   else '_blank'

    z '.z-join',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @signup(fromUserId).catch log.trace
      },
        # enter button on keyboard only calls onsubmit if there is
        # an input[type=submit] in the form
        # https://html.spec.whatwg.org/multipage/forms.html#implicit-submission
        z 'input[type=submit]', {style: display: 'none'}
        z $nameInput,
          hintText: 'Name'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        z $phoneInput,
          hintText: 'Phone number'
          type: 'tel'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        z $passwordInput,
          hintText: 'Password'
          type: 'password'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        if isLoading
          $spinner
        else
          z 'div.signup-button',
            z $signupButton,
              text: 'Sign up'
              onclick: (e) =>
                e.preventDefault()
                @signup(fromUserId).catch log.trace

      z 'div.terms',
        'By signing up, you agree to receive SMS messages and to our '
        z "a[href=/privacy][target=#{windowTarget}]", 'Privacy Policy'
        ' and '
        z "a[href=/tos][target=#{windowTarget}]", 'Terms'
        '.'
