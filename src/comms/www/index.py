from countershape.doc import *
this.markup = "markdown"

ns.docTitle = "WWW"

pages = [
       
    Page("squid.md", 
        title="Caching",
        pageTitle="Web Caching with Squid"),
    
    Page("dansguardian.md", 
        title="Content Filter",
        pageTitle="Web Content Filter with Dansguardian"),

    Page("portal.md", 
        title="Portal",
        pageTitle="Portal"),    
        
    Page("ssl.md", 
        title="SSL Certificates",
        pageTitle="SSL Certificates"),    
        
    Page("test.md",
        title="Validation",
        pageTitle="Validating Connectivity"),
]
