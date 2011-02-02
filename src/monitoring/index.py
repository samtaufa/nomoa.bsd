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
               
    Page("announcements.mdtext", 
        title="Announcements",
        pageTitle="Announcements"),    

    Page("nagios.mdtext", 
        title="Nagios",
        pageTitle="Nagios Monitoring"),    
        
    Page("netflow.mdtext", 
        title="Netflow",
        pageTitle="Netflow"),    
    Directory("netflow"),    
	
    Page("smokeping.mdtext",
        title="Smokeping",
        pageTitle="Smokeping"),
        
]
