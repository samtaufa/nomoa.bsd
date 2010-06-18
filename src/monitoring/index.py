from countershape.doc import *
import countershape

this.layout = ns.tpl_layout
this.markup = "markdown"

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/monitoring/nagios.html',
        )
ns.docTitle = "Monitoring Systems"

pages = [
               
    Page("vulnerability.mdtext", 
        title="Published Issues",
        pageTitle="Publicised Vulnerabilities"),    

    Page("nagios.mdtext", 
        title="Nagios",
        pageTitle="Nagios Monitoring"),    
        
    Page("smokeping.mdtext",
        title="Smokeping",
        pageTitle="Smokeping"),
]
