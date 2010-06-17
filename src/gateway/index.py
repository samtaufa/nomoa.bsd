from countershape.doc import *
import countershape

this.layout = ns.tpl_layout
this.markup = "markdown"

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/gateway/pf.html',
    )
 
ns.docTitle = "Gateway Services"

pages = [
    Page("highavailability.mdtext", 
        title="High Availability",
        pageTitle=""),
    Directory("highavailability"),
    
    Page("pf.mdtext", 
        title="Firewall",
        pageTitle="PF Firewall"),
    Directory("pf"),

    Page("routing.mdtext", 
        title="Routing",
        pageTitle=""),
    Directory("routing"),
    
]
