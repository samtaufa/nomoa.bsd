from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Monitoring - Network Traffic] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/monitoring/announcements.html',
        )

pages = [

    Page("announcements.md", 
        title="Announcements",
        pageTitle="Announcements"),    
    Directory ("notify"),
               
    Page("hippo.md", 
        title="Hippo",
        pageTitle="Hippo Host Configuration State"),    
    Directory ("hippo"),
    
    Page("nagios.md", 
        title="Nagios",
        pageTitle="Nagios Infrastructure Monitor"),    
    Directory ("nagios"),
	
    Page("snmp.md", 
        title="SNMP",
        pageTitle="SNMP - Simple Network Management Protocol"),    
        
    Page("netflow.md", 
        title="Netflow",
        pageTitle="Netflow Traffic Filtering, Analysis"),    
    Directory ("netflow"),
    
    Page("smokeping.md", 
        title="Smokeping",
        pageTitle="Smokeping Latency, Connectivity History"),    
 ]
