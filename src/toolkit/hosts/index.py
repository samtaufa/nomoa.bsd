from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Monitoring - Hosts] "

pages = [
               
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
 ]
