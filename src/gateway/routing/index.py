from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | Routing] "

pages = [

    Page("bgp.md", 
        title="BGP", 
        pageTitle="Routing with OpenBSD BGPD"),
        
    Page("cisco.md", 
        title="Cisco", 
        pageTitle="Routing with Cisco Routers/Switches"),
    Directory("cisco"),
]
