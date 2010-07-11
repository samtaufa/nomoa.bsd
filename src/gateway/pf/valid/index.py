from countershape.doc import *

ns.docTitle = "Firewall with OpenBSD Packet Filter (PF)"

pages = [
    Page("pfctl.mdtext", 
        title="1. pfctl",
        pageTitle="pfctl PF Userland Control Tool"),

    Page("flow.mdtext", 
        title="2. Traffic Flow",
        pageTitle="Firewall Traffic Flow"),
        
    Page("performance.mdtext", 
        title="3. Performance",
        pageTitle="Firewall Performance Review"),
        
    Page("validation.mdtext", 
        title="4. Validation",
        pageTitle="Firewall Ruleset Validation"),
    
    Page("other.mdtext", 
        title="5. Tools",
        pageTitle="Firewall - Ancilliary Tools"),
]
