from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Communications | Mail] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/comms/mail/sendmail.html',
        )

pages = [
    Page("sendmail.md",
        title="Sendmail",
        pageTitle=""),

    Page("dovecot.md",
        title="Client Access",
        pageTitle="'dovecot' POP3, IMAP Connection"),
        
    Page("web.md",
        title="Web",
        pageTitle="Web Clients"),
        
    Page("validate.md",
        title="Validate",
        pageTitle="Validate Connectivity"),
        
    Page("postfix.md",
        title="Postfix",
        pageTitle="Postfix Mail Server"),
        
    Directory("postfix"),
]
