from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Monitoring - Network Traffic] "

pages = [
               
    Page("netflow.md", 
        title="Netflow",
        pageTitle="Netflow Traffic Filtering, Analysis"),    
    Directory ("netflow"),
    
    Page("smokeping.md", 
        title="Smokeping",
        pageTitle="Smokeping Latency, Connectivity History"),    
 ]
