import countershape.widgets
from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Mail | Postfix] "

pages = [
    Page("admin.mdtext",
        title="GUI Admin",
        pageTitle="GUI Administration - PostfixAdmin"),
               
    Page("server.mdtext",
        title="Mail Server",
        pageTitle="Mail Server"),

    Page("proxy.mdtext",
        title="MX Proxy",
        pageTitle="Mail Proxy"),

    Page("instances.mdtext",
        title="MX Proxy++",
        pageTitle="MX Proxy Extended, using Multiple Instances"),

    Page("virtual_accounts.mdtext",
        title="Virtual Accounts",
        pageTitle="Virtual Accounts"),
        
    Page("virtual_domains.mdtext",
        title="Virtual Domains",
        pageTitle="Multiple Virtual Domains"),
 ]
