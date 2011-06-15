from countershape.doc import *
from countershape import  markup

#this.markup = markup.Markdown(extras=["code-friendly"])

this.titlePrefix = ns.titlePrefix + "[Communications | OpenVPN] "

pages = [
   
    Page("certificates.mdtext", 
        title="Certificates",
        pageTitle=""),
        
    Page("server.mdtext", 
        title="Server",
        pageTitle=""),

    Page("wan.mdtext", 
        title="WAN",
        pageTitle="Wide Area Network"),
        
    Page("winclient.mdtext", 
        title="Win Clients",
        pageTitle="Windows Clients"),
        
]
