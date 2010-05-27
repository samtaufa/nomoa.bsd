from countershape.doc import *
this.markup = "markdown"

ns.docTitle = "Configuration Archives"

pages = [
    Page("client.md",
        title="Client Tools",
        pageTitle="Client Tools"),
    Page("sanity.md",
        title="Change Mgmt",
        pageTitle="Change Management"),
        
    Page("restore.md",
        title="Restore",
        pageTitle="Restoring Configuration Changes"),
        
     Page("versioning.md",
        title="Versioning",
        pageTitle="Versioning with CVS"),
    
    Directory("versioning"),
]
