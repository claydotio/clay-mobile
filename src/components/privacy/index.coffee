z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'

styles = require './index.styl'

module.exports = class Privacy
  constructor: ->
    styles.use()

  # coffeelint: disable=max_line_length
  render: ->
    z '.z-privacy',
      z '.l-content-container',
        z 'h5', 'Website Visitors'
        z 'p',
          '''
        	Like most website operators, Clay.io collects non-personally-identifying information of the sort that web browsers and servers typically make available,
        	such as the browser type, language preference, referring site, and the date and time of each visitor request. Clay.io&#8217;s purpose in collecting
        	non-personally identifying information is to better understand how Clay.io&#8217;s visitors use its website. From time to time, Clay.io may release
        	non-personally-identifying information in the aggregate, e.g., by publishing a report on trends in the usage of its website.
          '''
        z 'p',
          '''
        	Clay.io also collects potentially personally-identifying information like Internet Protocol (IP) addresses for logged in users and for users of the Clay.io API.
        	Clay.io only discloses logged in user IP addresses under the same circumstances that it uses and
        	discloses personally-identifying information as described below.
          '''
        z 'h5', 'Gathering of Personally-Identifying Information'
        z 'p',
          '''
        	Certain visitors to Clay.io's websites choose to interact with Clay.io in ways that require Clay.io to gather personally-identifying information.
        	The amount and type of information that Clay.io gathers depends on the nature of the interaction. For example, we ask visitors who sign up for a
        	Clay.io account to provide a username and email address. Those who engage in transactions with
        	Clay.io – by purchasing games or items in games, for example – are asked to provide additional information, including as
        	necessary the personal and financial information required to process those transactions. In each case, Clay.io collects such information only insofar
        	as is necessary or appropriate to fulfill the purpose of the visitor's interaction with Clay.io. Clay.io does not disclose personally-identifying
        	information other than as described below. And visitors can always refuse to supply personally-identifying information, with the caveat that it may prevent
        	them from engaging in certain website-related activities.
          '''
        z 'h5', 'Aggregated Statistics'
        z 'p',
          '''
        	Clay.io may collect statistics about the behavior of visitors to its websites. Clay.io may display this information publicly or provide it to others.
        	However, Clay.io does not disclose personally-identifying information other than as described below. '''
        z 'h5', 'Protection of Certain Personally-Identifying Information'
        z 'p',
          '''Clay.io discloses potentially personally-identifying and personally-identifying information only to those of its employees, contractors and affiliated
        	organizations that (i) need to know that information in order to process it on Clay.io's behalf or to provide services available at Clay.io's websites,
        	and (ii) that have agreed not to disclose it to others. Some of those employees, contractors and affiliated organizations may be located outside of your
        	home country; by using Clay.io's websites, you consent to the transfer of such information to them. Clay.io will not rent or sell potentially
        	personally-identifying and personally-identifying information to anyone. Other than to its employees, contractors and affiliated organizations,
        	as described above, Clay.io discloses potentially personally-identifying and personally-identifying information only in response to a subpoena,
        	court order or other governmental request, or when Clay.io believes in good faith that disclosure is reasonably necessary to protect the property
        	or rights of Clay.io, third parties or the public at large. If you are a registered user of an Clay.io website and have supplied your email address,
        	Clay.io may occasionally send you an email to tell you about new features, solicit your feedback, or just keep you up to date with what's going on with
        	Clay.io and our products. We primarily use blog to communicate this type of information, so we expect to keep this type of email
        	to a minimum. If you send us a request (for example via a support email or via one of our feedback mechanisms), we reserve the right to publish it in order
        	to help us clarify or respond to your request or to help us support other users. Clay.io takes all measures reasonably necessary to protect against the
        	unauthorized access, use, alteration or destruction of potentially personally-identifying and personally-identifying information.
          '''
        z 'h5', 'Cookies'
        z 'p',
          '''
        	A cookie is a string of information that a website stores on a visitor's computer, and that the visitor's browser provides to the website each time the
        	visitor returns. Clay.io uses cookies to help Clay.io identify and track visitors, their usage of Clay.io website, and their website access preferences.
        	Clay.io visitors who do not wish to have cookies placed on their computers should set their browsers to refuse cookies before using Clay.io's websites,
        	with the drawback that certain features of Clay.io's websites may not function properly without the aid of cookies.
          '''
        z 'h5', 'Business Transfers'
        z 'p',
          '''
        	If Clay.io, or substantially all of its assets were acquired, or in the unlikely event that Clay.io goes out of business or enters bankruptcy,
        	user information would be one of the assets that is transferred or acquired by a third party. You acknowledge that such transfers may occur, and that
        	any acquirer of Clay.io may continue to use your personal information as set forth in this policy.
          '''
        z 'h5', 'Ads'
        z 'p',
          '''
        	Ads appearing on any of our websites may be delivered to users by advertising partners, who may set cookies. These cookies allow the ad server to
        	recognize your computer each time they send you an online advertisement to compile information about you or others who use your computer.
        	This information allows ad networks to, among other things, deliver targeted advertisements that they believe will be of most interest to you.
        	This Privacy Policy covers the use of cookies by Clay.io and does not cover the use of cookies by any advertisers.
          '''
        z 'h5', 'Privacy Policy Changes'
        z 'p',
          '''
        	Although most changes are likely to be minor, Clay.io may change its Privacy Policy from time to time, and in Clay.io's sole discretion.
        	Clay.io encourages visitors to frequently check this page for any changes to its Privacy Policy. Your continued use of this site after any change in this Privacy Policy will constitute
        	your acceptance of such change.
          '''
  # coffeelint: enable=max_line_length
