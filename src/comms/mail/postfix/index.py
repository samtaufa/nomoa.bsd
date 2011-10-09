import countershape.widgets
from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Mail | Postfix] "

pages = [

    Page("admin.md",
        title="Admin GUI",
        pageTitle="Administration - PostfixAdmin"),
               
    Page("server.md",
        title="Mail Server",
        pageTitle="Mail Server"),

    Page("tls.md",
        title="TLS/SSL",
        pageTitle="TLS/SSL"),
               
    Page("certificates.md",
        title="SSL Certificates",
        pageTitle="SSL Certificates"),
               
    Page("virtual_accounts.md",
        title="Virtual Accounts",
        pageTitle="Virtual Accounts"),
        
    Page("virtual_domains.md",
        title="Virtual Domains",
        pageTitle="Multiple Virtual Domains"),
 ]
