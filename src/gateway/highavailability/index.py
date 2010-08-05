from countershape.doc import *
from countershape import  markup

this.markup = markup.Markdown()

ns.docTitle = "High Availability"
this.markdown = "textish"

pages = [
    Page("carp.mdtext",
        title="Hot Failover",
        pageTitle="High Availability - Hot Failover with CARP"
        ),
        
    Page("relayd.mdtext",
        title="Load Balancing",
        pageTitle="High Availability - Load Balancing"
        ),
]
