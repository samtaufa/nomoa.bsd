from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Consistency] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/consistency/auscert.html',
        )

pages = [
            
    Page("auscert.md",
        title="auscert - Build", 
        pageTitle="auscert - Build Checklist"),
            
    Page("diagnostics.md",
        title="Diagnostics", 
        pageTitle="Build Diagnostics"),
            
    # Page("monitoring.md",
        # title="Monitoring", 
        # pageTitle="Monitoring"),
            
]
