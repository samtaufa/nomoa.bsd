from countershape.doc import *
#from countershape import  markup

#this.markup = markup.Markdown(extras=["code-friendly"])

this.titlePrefix = ns.titlePrefix + "[Communications | Mail] "

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
