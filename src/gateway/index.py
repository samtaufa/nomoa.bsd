from countershape.doc import *
import countershape

#from countershape import markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/gateway/pf.html',
    )
 
this.titlePrefix = ns.titlePrefix + "[Gateway Services] "

pages = [
    Page("highavailability.md", 
        title="High Availability",
        pageTitle="High Availability Gateways"),
    Directory("highavailability"),
    
    Page("pf.md", 
        title="Firewall",
        pageTitle="Firewalls with Packet Filter PF"),
    Directory("pf"),

    Page("routing.md", 
        title="Routing",
        pageTitle="Gateways and Routing"),
    Directory("routing"),
    
]
