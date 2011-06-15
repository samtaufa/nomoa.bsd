from countershape.doc import *
#from countershape import  markup

#this.markup = markup.Markdown(extras=["code-friendly"])

this.titlePrefix = ns.titlePrefix + "[Communications | Mail] "

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
        
    Page("validate.mdtext",
        title="Validate",
        pageTitle="Validate Connectivity"),
        
    Page("postfix.mdtext",
        title="Postfix",
        pageTitle="Postfix Mail Server"),
        
    Directory("postfix"),
]
