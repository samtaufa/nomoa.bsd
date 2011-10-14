from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Nagios] "

pages = [
               
    Page("install.md",
        title="Install",
        pageTitle="Installation"),
		
    Page("config.md",
        title="Config",
        pageTitle="Configuration"),
		
    Page("console.md",
        title="Console",
        pageTitle="Command-line Console"),
		
    Page("snmp.md",
        title="SNMP",
        pageTitle="Simple Network Management Protocol"),
]
