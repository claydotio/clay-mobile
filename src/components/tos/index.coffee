z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'

styles = require './index.styl'

module.exports = class Tos
  constructor: ->
    styles.use()

  # coffeelint: disable=max_line_length
  render: ->
    z '.z-tos',
      z '.l-content-container',
        z 'p',
          '''
          The following terms and conditions govern all use of the Clay.io website and all content, services and products available at or through the website. The Website is owned and operated by Clay.io.
          . The Website is offered subject to your acceptance without modification of all of the terms and conditions contained herein and all other operating rules,
          policies (including, without limitation,
          '''
          z 'a', {
            href: 'https://clay.io/privacy/'
          },
            'Clay.io\'s Privacy Policy'
          '''
          ) and procedures that may be published from time to'
          time on this Site by Clay.io (collectively, the "Agreement").
          '''
        z 'p',
          '''
          Please read this Agreement carefully before accessing or using the Website. By accessing or using any part of the web site, you agree to become bound by the
          terms and conditions of this agreement. If you do not agree to all the terms and conditions of this agreement, then you may not access the Website or use any services.
          If these terms and conditions are considered an offer by Clay.io, acceptance is expressly limited to these terms. The Website is available only to individuals who
          are at least 13 years old.
          '''
        z 'ol',
          z 'li',
            z 'div.is-bold', 'Your Clay.io Account and Site.'
            '''
            If you create an account on the Website, you are responsible for maintaining the accuracy and security of your account,
            and you are fully responsible for all activities that occur under the account and any other actions taken in connection with the account. Clay.io will not
            be liable for any acts or omissions by You, including any damages of any kind incurred as a result of such acts or omissions.
            '''
          z 'li',
            z 'div.is-bold', 'SMS.'
            'Standard messaging and data rates may apply.'
          z 'li',
            z 'div.is-bold', 'Payment and Renewal.'
            z 'ul',
              z 'li',
                z 'div.is-bold', 'General Terms.'
                '''
                Optional paid services purchasing a game or in-game transaction are available on the Website.
                By purchasing an item you agree to pay Clay.io the fees indicated for that product. Payments are not refundable.
                '''
          z 'li',
            z 'div.is-bold', 'Responsibility of Website Visitors.'
            '''
            Clay.io has not reviewed, and cannot review, all of the material, including computer software,
            posted to the Website, and cannot therefore be responsible for that material's content, use or effects. By operating the Website, Clay.io does not
            represent or imply that it endorses the material there posted, or that it believes such material to be accurate, useful or non-harmful. You are

            or destructive content. The Website may contain content that is offensive, indecent, or otherwise objectionable, as well as content containing
            technical inaccuracies, typographical mistakes, and other errors. The Website may also contain material that violates the privacy or publicity rights,
            or infringes the intellectual property and other proprietary rights, of third parties, or the downloading, copying or use of which is subject to additional
            terms and conditions, stated or unstated. Clay.io disclaims any responsibility for any harm resulting from the use by visitors of the Website, or from
            any downloading by those visitors of content there posted.
            '''
          z 'li',
            z 'div.is-bold', 'Content Posted on Other Websites.'
            '''
            We have not reviewed, and cannot review, all of the material, including computer software, made available
            through the websites and webpages to which Clay.io links, and that link to Clay.io. Clay.io does not have any control over those external
            websites and webpages, and is not responsible for their contents or their use. By linking to a non-Clay.io website or webpage, Clay.io does not represent
            or imply that it endorses such website or webpage. You are responsible for taking precautions as necessary to protect yourself and your computer systems from
            viruses, worms, Trojan horses, and other harmful or destructive content. Clay.io disclaims any responsibility for any harm resulting from your use of
            non-Clay.io websites and webpages.
            '''
          z 'li',
            z 'div.is-bold', 'Copyright Infringement and DMCA Policy.'
            '''
            As Clay.io asks others to respect its intellectual property rights, it respects the intellectual property rights
            of others. If you believe that material located on or linked to by Clay.io violates your copyright, you are encouraged to notify Clay.io in
            accordance with
            '''
            z 'a', {
              href: 'https://github.com/claydotio/legal/blob/master/DMCA/Site%20Pages/DMCA%20Takedown%20Notice.md'
            },
              'Clay.io\'s Digital Millennium Copyright Act Policy'
            '''
            . Clay.io will respond
            to all such notices, including as required or appropriate by removing the infringing material or disabling all links to the infringing material. Clay.io     will terminate a visitor's access to and use of the Website if, under appropriate circumstances, the visitor is determined to be a repeat infringer of
            the copyrights or other intellectual property rights of Clay.io or others. In the case of such termination, Clay.io will have no obligation to provide
            a refund of any amounts previously paid to Clay.io.
            '''
          z 'li',
            z 'div.is-bold', 'Intellectual Property.'
            '''
            This Agreement does not transfer from Clay.io to you any Clay.io or third party intellectual property, and all
            right, title and interest in and to such property will remain (as between the parties) solely with Clay.io. Clay.io, the
            Clay.io logo, and all other trademarks, service marks, graphics and logos used in connection with Clay.io, or the Website are trademarks or
            registered trademarks of Clay.io or Clay.io's licensors. Other trademarks, service marks, graphics and logos used in connection with the Website
            may be the trademarks of other third parties. Your use of the Website grants you no right or license to reproduce or otherwise use any Clay.io or
            third-party trademarks.
            '''
          z 'li',
            z 'div.is-bold', 'Changes.'
            '''
            Clay.io reserves the right, at its sole discretion, to modify or replace any part of this Agreement. It is your responsibility
            to check this Agreement periodically for changes. Your continued use of or access to the Website following the posting of any changes to this Agreement
            constitutes acceptance of those changes. Clay.io may also, in the future, offer new services and/or features through the Website (including, the
            release of new tools and resources). Such new features and/or services shall be subject to the terms and conditions of this Agreement.
            '''
          z 'li',
            z 'div.is-bold', 'Termination.'
            '''
            Clay.io may terminate your access to all or any part of the Website at any time, with or without cause, with or without notice,
            effective immediately. If you wish to terminate this Agreement or your Clay.io account (if you have one), you may simply discontinue using the
            Website. All provisions of this Agreement which by their nature should survive termination
            shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.
            '''
          z 'li.important',
            z 'div.is-bold', 'Disclaimer of Warranties.'
            '''
            The Website is provided "as is". Clay.io and its suppliers and licensors hereby disclaim
            all warranties of any kind, express or implied, including, without limitation, the warranties of merchantability, fitness for a particular purpose
            and non-infringement. Neither Clay.io nor its suppliers and licensors, makes any warranty that the Website will be error free or that access
            thereto will be continuous or uninterrupted.
            You understand that you download from, or otherwise obtain content or services through, the Website at your own discretion and risk.</li>
            '''
          z 'li.important',
            z 'div.is-bold', 'Limitation of Liability.'
            '''In no event will Clay.io, or its suppliers or licensors, be liable with respect to any subject matter of
            this agreement under any contract, negligence, strict liability or other legal or equitable theory for: (i) any special, incidental or consequential damages;
            (ii) the cost of procurement for substitute products or services; (iii) for interruption of use or loss or corruption of data; or (iv) for any amounts that
            exceed the fees paid by you to Clay.io under this agreement during the twelve (12) month period prior to the cause of action. Clay.io shall have no
            liability for any failure or delay due to matters beyond their reasonable control. The foregoing shall not apply to the extent prohibited by applicable law.
            '''
          z 'li',
            z 'div.is-bold', 'General Representation and Warranty.'
            '''
            You represent and warrant that (i) your use of the Website will be in strict accordance with the
            Clay.io Privacy Policy, with this Agreement and with all applicable laws and regulations (including without limitation any local laws or regulations in
            your country, state, city, or other governmental area, regarding online conduct and acceptable content, and including all applicable laws regarding the
            transmission of technical data exported from the United States or the country in which you reside) and (ii) your use of the Website will not infringe or
            misappropriate the intellectual property rights of any third party.
            '''
          z 'li',
            z 'div.is-bold', 'Indemnification.'
            '''
            You agree to indemnify and hold harmless Clay.io, its contractors, and its licensors, and their respective directors,
            officers, employees and agents from and against any and all claims and expenses, including attorneys' fees, arising out of your use of the Website,
            including but not limited to your violation of this Agreement.
            '''
          z 'li',
            z 'div.is-bold', 'Miscellaneous.'
            '''
            This Agreement constitutes the entire agreement between Clay.io and you concerning the subject matter
            hereof, and they may only be modified by a written amendment signed by an authorized executive of Clay.io, or by the posting by Clay.io    of a revised version. Except to the extent applicable law, if any, provides otherwise, this Agreement, any access to or use of the Website will
            be governed by the laws of the state of Texas, U.S.A., excluding its conflict of law provisions, and the proper venue for any disputes
            arising out of or relating to any of the same will be the state and federal courts located in Austin County, Texas. Except for
            claims for injunctive or equitable relief or claims regarding intellectual property rights (which may be brought in any competent court without
            the posting of a bond), any dispute arising under this Agreement shall be finally settled in accordance with the Comprehensive Arbitration Rules
            of the Judicial Arbitration and Mediation Service, Inc. ("JAMS") by three arbitrators appointed in accordance with such Rules. The arbitration
            shall take place in Austin, Texas, in the English language and the arbitral decision may be enforced in any court. The prevailing
            party in any action or proceeding to enforce this Agreement shall be entitled to costs and attorneys' fees. If any part of this Agreement is held
            invalid or unenforceable, that part will be construed to reflect the parties' original intent, and the remaining portions will remain in full
            force and effect. A waiver by either party of any term or condition of this Agreement or any breach thereof, in any one instance, will not waive
            such term or condition or any subsequent breach thereof. You may assign your rights under this Agreement to any party that consents to, and agrees
            to be bound by, its terms and conditions; Clay.io may assign its rights under this Agreement without condition. This Agreement will be binding
            upon and will inure to the benefit of the parties, their successors and permitted assigns.
            '''

        z 'h3', 'Developers'
        z 'ol',
          z 'li',
            z 'div.is-bold', 'Responsibility of Contributors.'
            '''
            If you operate a game, post material to the Website, post links on the Website, or otherwise
            make (or allow any third party to make) material available by means of the Website (any such material, "Content"), You are entirely responsible for the content of,
            and any harm resulting from, that Content. That is the case regardless of whether the Content in question constitutes text, graphics, an audio file, or computer software.
            By making Content available, you represent and warrant that:
            '''
          z 'ul',
            z 'li',
              '''
              the downloading, copying and use of the Content will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark or trade
              secret rights, of any third party;
              '''
            z 'li',
              '''
              if your employer has rights to intellectual property you create, you have either (i) received permission from your employer to post or make available the Content,
              including but not limited to any software, or (ii) secured from your employer a waiver as to all rights in or to the Content;
              '''
            z 'li',
              '''
              you have fully complied with any third-party licenses relating to the Content, and have done all things necessary to successfully pass through to end users any
              required terms;
              '''
            z 'li',
              '''
              the Content does not contain or install any viruses, worms, malware, Trojan horses or other harmful or destructive content;
              '''
            z 'li',
              '''
              the Content is not spam, is not machine- or randomly-generated, and does not contain unethical or unwanted commercial content designed to drive
              traffic to third party sites or boost the search engine rankings of third party sites, or to further unlawful acts (such as phishing) or mislead recipients as to
              the source of the material (such as spoofing);
              '''
            z 'li',
              '''
              the Content is not pornographic, does not contain threats or incite violence towards individuals or entities, and does not violate the privacy or publicity rights
              of any third party;
              '''
            z 'li',
              '''
              the Content is not getting advertised via unwanted electronic messages such as spam links on newsgroups, email lists, blogs and web sites, and similar
              unsolicited promotional methods;
              '''
            z 'li',
              '''
              the Content is not named in a manner that misleads your readers into thinking that you are another person or company. For example, your game's URL or name
              is not the name of a person other than yourself or company other than your own; and
              '''
            z 'li',
              '''
              you have, in the case of Content that includes computer code, accurately categorized and/or described the type, nature, uses and effects of the materials, whether
              requested to do so by Clay.io or otherwise.
              '''
          z 'p',
            '''
            By submitting Content to Clay.io, you grant Clay.io a world-wide, royalty-free, and non-exclusive license to reproduce,
            modify, adapt and publish the Content solely for the purpose of displaying, distributing and promoting your game. If you delete Content, Clay.io will use
            reasonable efforts to remove it from the Website, but you acknowledge that caching or references to the Content may not be made immediately unavailable.
            '''
          z 'p',
            '''
            Without limiting any of those representations or warranties, Clay.io has the right (though not the obligation) to, in Clay.io's sole discretion (i)
            refuse or remove any content that, in Clay.io's reasonable opinion, violates any Clay.io policy or is in any way harmful or objectionable, or (ii)
            terminate or deny access to and use of the Website to any individual or entity for any reason, in Clay.io's sole discretion. Clay.io will have no
            obligation to provide a refund of any amounts previously paid.
            '''

        z 'li',
          z 'div.is-bold', 'Game Intellectual Property.'
          '''
          Games developed by third parties remain the propery of the 3rd party. Clay.io does not own this third party content,
          but the property owner has given Clay.io permission to distribute the content. Games can be added and removed at any time.
          '''
        z 'li',
          z 'div.is-bold', 'Commercialization.'
          '''
          You will receive a payment related to valid events performed in connection to your game, related to ads and In-App Payments (IAP).
          The Account balance is determined by the Ad-revenure share and In-App Payment (IAP) revenue share percentages below and the gross revenue the Content generates in either category.
          Except in the event of termination, we will pay you upon request in which the balance in your Account equals or exceeds the applicable payment threshold.
          Payments will be calculated solely based on our accounting. Payments to you may be withheld to reflect or adjusted to exclude any amounts arising from invalid activity.
          Invalid activity is determined by Clay.io in all cases and includes,
          but is not limited to: spam, invalid impressions or invalid clicks on Ads, requests for end users to click on Ads or take other actions.
          '''
        z 'li',
          z 'div.is-bold', 'Taxes.'
          '''
          Clay.io is responsible for all taxes (if any) associated with the transactions between Clay.io and advertisers in connection with Ads displayed on the Content.
          You are responsible for all taxes (if any) associated with the Services, other than taxes based on Clay.io's net income.  All payments to you from Clay.io in relation to the
          Services will be treated as inclusive of tax (if applicable) and will not be adjusted.
          '''

        z 'p', 'Payout threshold: $10.00 (USD)'
        z 'p', 'Ad-revenue share: 50%'
        z 'p', 'IAP revenue share: 70%'
  # coffeelint: enable=max_line_length
