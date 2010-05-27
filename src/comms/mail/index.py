from countershape.doc import *

this.markup = "markdown"

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
        
    Page("test.md",
        title="Tests",
        pageTitle="Testing Connectivity"),
        
    Page("postfix.md",
        title="Postfix",
        pageTitle="Postfix Mail Server"),
        
    Directory("postfix"),
]
