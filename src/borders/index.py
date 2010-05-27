from countershape.doc import *
this.markup = "markdown"

ns.docTitle = "Gateway Services"

pages = [
    Page("highavailability.md", 
        title="High Availability",
        pageTitle=""),
    Directory("highavailability"),
    
    Page("pf.md", 
        title="Firewall",
        pageTitle="PF Firewall"),
    Directory("pf"),

    Page("routing.md", 
        title="Routing",
        pageTitle=""),
    Directory("routing"),
    
]
