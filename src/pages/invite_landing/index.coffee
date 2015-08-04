z = require 'zorium'
log = require 'clay-loglevel'

InviteLanding = require '../../components/invite_landing'
InviteLandingPersonal = require '../../components/invite_landing/personal'

module.exports = class InviteLandingPage
  constructor: ({fromUserId}) ->
    @state = z.state
      $inviteLanding: new InviteLanding {fromUserId}

  render: =>
    {$inviteLanding} = @state()

    z 'div.z-invite-landing-page',
      $inviteLanding
