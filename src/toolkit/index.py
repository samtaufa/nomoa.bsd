from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/announcements.html',
        )

this.titlePrefix = ns.titlePrefix + "[Monitoring] "

pages = [
               
    Page("announcements.md", 
        title="Announcements",
        pageTitle="Announcements"),    
    Directory ("notify"),

    Page("hosts.md", 
        title="Hosts",
        pageTitle="Host Information State"),    
    Directory ("hosts"),
    
    Page("network.md", 
        title="Network",
        pageTitle="Network Traffic Analysis"),    
    Directory ("network"),
 ]
