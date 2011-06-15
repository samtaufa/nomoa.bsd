from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Consistency] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/consistency/auscert.html',
        )

pages = [
            
    Page("auscert.mdtext",
        title="auscert - Build", 
        pageTitle="auscert - Build Checklist"),
            
    # Page("diagnostics.mdtext",
        # title="Diagnostics", 
        # pageTitle="Build Diagnostics"),
            
    # Page("monitoring.mdtext",
        # title="Monitoring", 
        # pageTitle="Monitoring"),
            
]
