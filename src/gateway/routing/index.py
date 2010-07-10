from countershape.doc import *

ns.docTitle = "Routing"

pages = [

    Page("bgp.mdtext", 
        title="BGP", 
        pageTitle="Routing with OpenBSD BGPD"),
        
    Page("cisco.mdtext", 
        title="Cisco", 
        pageTitle="Routing with Cisco Routers/Switches"),
    Directory("cisco"),
]
