from countershape.doc import *
from countershape import  markup

this.markup = markup.Markdown(extras=["code-friendly"])

this.titlePrefix = ns.titlePrefix + "[Communications | OpenVPN] "

pages = [
   
    Page("certificates.md", 
        title="Certificates",
        pageTitle=""),
        
    Page("server.md", 
        title="Server",
        pageTitle=""),

    Page("wan.md", 
        title="WAN",
        pageTitle="Wide Area Network"),
        
    Page("winclient.md", 
        title="Win Clients",
        pageTitle="Windows Clients"),
        
]
