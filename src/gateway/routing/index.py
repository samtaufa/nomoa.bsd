from countershape.doc import *

ns.docTitle = "Routing"

pages = [

    Page("bgp.mdtext", 
        title="BGP", 
        pageTitle="OpenBSD BGPD"),
        
    Page("cisco.mdtext", 
        title="Cisco", 
        pageTitle="Cisco Routers/Switches"),
    Directory("cisco"),
]
