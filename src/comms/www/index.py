from countershape.doc import *
from countershape import  markup

this.markup = markup.Markdown()

this.titlePrefix = ns.titlePrefix + "[Communications | WWW] "

pages = [
       
    Page("squid.4.9.mdtext", 
        title="Caching 4.9",
        pageTitle="Web Caching with Squid"),
    
    Page("squid.4.8.mdtext", 
        title="Caching 4.8",
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
