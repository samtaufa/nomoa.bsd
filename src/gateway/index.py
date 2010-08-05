from countershape.doc import *
import countershape
from countershape import  markup

this.markup = markup.Markdown()
this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/gateway/pf.html',
    )
 
ns.docTitle = "Gateway Services"

pages = [
    Page("highavailability.mdtext", 
        title="High Availability",
        pageTitle="High Availability Gateways"),
    Directory("highavailability"),
    
    Page("pf.mdtext", 
        title="Firewall",
        pageTitle="Firewalls with Packet Filter PF"),
    Directory("pf"),

    Page("routing.mdtext", 
        title="Routing",
        pageTitle="Gateways and Routing"),
    Directory("routing"),
    
]
