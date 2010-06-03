from countershape.doc import *

this.markup = "markdown"

pages = [
    Page("sendmail.mdtext",
        title="Sendmail",
        pageTitle=""),

    Page("dovecot.mdtext",
        title="Client Access",
        pageTitle="'dovecot' POP3, IMAP Connection"),
        
    Page("web.mdtext",
        title="Web",
        pageTitle="Web Clients"),
        
    Page("test.mdtext",
        title="Tests",
        pageTitle="Testing Connectivity"),
        
    Page("postfix.mdtext",
        title="Postfix",
        pageTitle="Postfix Mail Server"),
        
    Directory("postfix"),
]
