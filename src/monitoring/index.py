from countershape.doc import *
import countershape

#from countershape import  markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/monitoring/nagios.html',
        )

this.titlePrefix = ns.titlePrefix + "[Monitoring] "

pages = [
               
    Page("announcements.md", 
        title="Announcements",
        pageTitle="Announcements"),    

    Page("configuration.md", 
        title="Configuration",
        pageTitle="Configuration Management"),    
    Directory ("config"),

    Page("nagios.md", 
        title="Nagios",
        pageTitle="Nagios Monitoring"),    
    Directory ("nagios"),
        
    Page("netflow.md", 
        title="Netflow",
        pageTitle="Netflow"),    
    Directory("netflow"),    
    
    Page("smokeping.md",
        title="Smokeping",
        pageTitle="Smokeping"),
    
]
