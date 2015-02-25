z = require 'zorium'
log = require 'clay-loglevel'

InviteLanding = require '../../components/invite_landing'
InviteLandingPersonal = require '../../components/invite_landing/personal'
User = require '../../models/user'

module.exports = class InviteLandingPage
  constructor: ({fromUserId}) ->
    @state = z.state
      $inviteLanding: z.observe User.getExperiments().then( ({inviteLanding}) ->
        inviteLanding = 'personal' # FIXME
        if inviteLanding is 'personal'
        then new InviteLandingPersonal()
        else new InviteLanding()
      ).catch log.trace
      fromUserId: fromUserId

  render: =>
    {$inviteLanding, fromUserId} = @state()

    z 'div.z-invite-landing-page',
      z $inviteLanding, {fromUserId}
