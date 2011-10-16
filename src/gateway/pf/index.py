from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Gateway | Firewall] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/gateway/pf/maint.html',
        )


pages = [
    Page("valid.md", 
        title="a. Verify",
        pageTitle="Ruleset: Validate and Test"),
    Directory("valid"),

    Page("maint.md", 
        title="b. Maintenance",
        pageTitle="Firewall: Maintenance"),
    Directory("maint"),
        
    Page("manage.md", 
        title="c. Management",
        pageTitle="Firewall Management"),
    Directory("manage"),

    Page("other.md", 
        title="d. Other",
        pageTitle="Other"),

]
