from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | Routing] "

pages = [

    Page("bgp.mdtext", 
        title="BGP", 
        pageTitle="Routing with OpenBSD BGPD"),
        
    Page("cisco.mdtext", 
        title="Cisco", 
        pageTitle="Routing with Cisco Routers/Switches"),
    Directory("cisco"),
]
