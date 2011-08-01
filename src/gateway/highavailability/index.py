from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | High Availability] "

this.markdown = "textish"

pages = [
    Page("carp.md",
        title="Hot Failover",
        pageTitle="High Availability - Hot Failover with CARP"
        ),
        
    Page("relayd.md",
        title="Load Balancing",
        pageTitle="High Availability - Load Balancing"
        ),
]
