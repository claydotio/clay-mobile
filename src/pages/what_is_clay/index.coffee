z = require 'zorium'

InviteLanding = require '../../components/invite_landing'

# DELETE IF 'personal' A/B for invite_page FAILS

module.exports = class WhatIsClay
  constructor: ->
    @state = z.state
      $inviteLanding: new InviteLanding()

  render: =>
    {$inviteLanding} = @state()

    z 'div.z-invite-landing-page',
      $inviteLanding
