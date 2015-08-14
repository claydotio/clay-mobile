z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'

styles = require './index.styl'

module.exports = class About
  constructor: ->
    styles.use()

  render: ->
    z '.z-about.l-content-container',
      z 'h2', 'The Team'
      z 'h3', 'Cristian Ruiz - Lead Designer'
      z 'div',
        '''
        Cristian is an incredibly talented designer and user experience expert
        who loves games and design. In his free time he reimagines
        poorly designed Android  apps following Android's design guidelines. The
        resulting mockups always generate an overwhelming response
        of users saying they wished the apps would be based on his designs.
        Thanks to him, Clay.io will have beautiful, functional
        products the first time around.
        '''
      z 'div',
        z 'a', {
          href: 'http://pixel-shift.com'
        },
          'Cristian\'s blog'
      z 'div',
        z 'a', {
          href: 'http://twitter.com/razgriz94'
        },
          'Twitter'
      z 'div',
        z 'a', {
          href: 'http://behance.net/c_ruiz'
        },
          'Behance'

      z 'h3', 'Zoli Kahan - CTO'
      z 'div',
        '''
        When Zoli was 15, he was busy finding exploits in massive corporations'
        websites
        (eg. Google, getting into their
        '''
        z 'a', {
          href: 'https://www.google.com/about/appsecurity/hall-of-fame/reward/'
        },
          ' Security Hall of Fame'
        '''
        ).
        Soon after, he combined his passions for games and development to create
        several HTML5 games. After dropping out of high school, he began work on
        his next goal: helping lead Clay.io toward becoming everyone's source for
        finding great games to play.
        '''
      z 'div',
        z 'a', {
          href: 'http://zolmeister.com/'
        },
          'Zoli\'s blog'
      z 'div',
        z 'a', {
          href: 'http://twitter.com/zolmeister'
        },
          'Twitter'
      z 'div',
        z 'a', {
          href: 'https://github.com/Zolmeister'
        },
          'GitHub'


      z 'h3', 'Austin Hallock - CEO'
      z 'div',
        '''
        Austin comes from a technical background, building websites since 8th
        grade. At age 16, he was one of 5 at IntenseDebate when it was acquired
        by Automattic.
        After starting Clay.io in early 2012, for two years he juggled all of
        development and turning the company into a
        viable business. He is going to do whatever it takes to fulfill the
        vision for Clay.io.
        '''
      z 'div',
        z 'a', {
          href: 'http://austinhallock.com'
        },
          'Austin\'s blog'
      z 'div',
        z 'a', {
          href: 'http://twitter.com/austinhallock'
        },
          'Twitter'
      z 'div',
        z 'a', {
          href: 'https://github.com/austinhallock'
        },
          'GitHub'
