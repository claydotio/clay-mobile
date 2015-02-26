z = require 'zorium'

InviteLanding = require '../../components/invite_landing'

# DELETE IF 'personal' A/B for invite_page FAILS

module.exports = class WhatIsClay
  constructor: ({fromUserId}) ->
    @state = z.state
      $inviteLanding: new InviteLanding {fromUserId}

  render: =>
    {$inviteLanding} = @state()

    z 'div.z-invite-landing-page',
      $inviteLanding
