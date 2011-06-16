from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | Firewall | Validation] "

pages = [
    Page("pfctl.md", 
        title="1. pfctl",
        pageTitle="pfctl PF Userland Control Tool"),

    Page("flow.md", 
        title="2. Traffic Flow",
        pageTitle="Firewall Traffic Flow"),
        
    Page("performance.md", 
        title="3. Performance",
        pageTitle="Firewall Performance Review"),
        
    Page("validation.md", 
        title="4. Validation",
        pageTitle="Firewall Ruleset Validation"),
    
    Page("other.md", 
        title="5. Tools",
        pageTitle="Firewall - Ancilliary Tools"),
]
