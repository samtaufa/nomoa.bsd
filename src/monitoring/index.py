from countershape.doc import *
import countershape
from countershape import  markup

this.markup = markup.Markdown()
this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/monitoring/nagios.html',
        )

this.titlePrefix = ns.titlePrefix + "[Monitoring] "

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
        
    Page("netflow.mdtext", 
        title="Netflow",
        pageTitle="Netflow"),    
    Directory("netflow"),    
]
