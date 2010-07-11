from countershape.doc import *

ns.docTitle = "Firewall with OpenBSD Packet Filter (PF)"

pages = [
    Page("valid.mdtext", 
        title="1. Test",
        pageTitle="Ruleset: Validate and Test"),
    Directory("valid"),

    Page("maint.mdtext", 
        title="2. Maintenance",
        pageTitle="Firewall: Maintenance"),
    Directory("maint"),
        
    Page("manage.mdtext", 
        title="3. Management",
        pageTitle="Firewall Management"),
    Directory("manage"),

]
