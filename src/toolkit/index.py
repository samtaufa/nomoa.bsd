from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/monitoring.html',
        )

this.titlePrefix = ns.titlePrefix + "[Toolkit] "

pages = [
               
    Page("build.md", 
        title="Build",
        pageTitle="Building your OS"),    
    Directory ("build"),

    Page("dev.md", 
        title="Dev",
        pageTitle="Development Tools"),    
    Directory ("dev"),

    Page("monitoring.md", 
        title="Monitoring",
        pageTitle="Monitoring hosts and network traffic"),    
    Directory ("monitoring"),

    ]
