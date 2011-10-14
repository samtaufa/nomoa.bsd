from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/monitoring.html',
        )

this.titlePrefix = ns.titlePrefix + "[Toolkit] "

pages = [
               
    Page("monitoring.md", 
        title="Monitoring",
        pageTitle="Monitoring hosts and network traffic"),    
    Directory ("monitoring"),
 ]
