from countershape.doc import *
from countershape import  markup

this.markup = markup.Markdown()

ns.docTitle = "WWW"

pages = [
       
    Page("squid.mdtext", 
        title="Caching",
        pageTitle="Web Caching with Squid"),
    
    Page("dansguardian.mdtext", 
        title="Content Filter",
        pageTitle="Web Content Filter with Dansguardian"),

    Page("portal.mdtext", 
        title="Portal",
        pageTitle="Portal"),    
        
    Page("ssl.mdtext", 
        title="SSL Certificates",
        pageTitle="SSL Certificates"),    
        
    Page("test.mdtext",
        title="Validation",
        pageTitle="Validating Connectivity"),
]
