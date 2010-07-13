from countershape.doc import *

ns.docTitle = "Firewall with OpenBSD Packet Filter (PF)"

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
