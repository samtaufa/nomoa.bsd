from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | Firewall] "

pages = [
    Page("valid.mdtext", 
        title="a. Verify",
        pageTitle="Ruleset: Validate and Test"),
    Directory("valid"),

    Page("maint.mdtext", 
        title="b. Maintenance",
        pageTitle="Firewall: Maintenance"),
    Directory("maint"),
        
    Page("manage.mdtext", 
        title="c. Management",
        pageTitle="Firewall Management"),
    Directory("manage"),

]
