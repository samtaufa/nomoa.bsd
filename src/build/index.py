from countershape.doc import *
this.markup = "markdown"

ns.docTitle = "Build Consistency"

pages = [
       
    Page("preview.md",
        title="Pre Install", 
        pageTitle="Pre Installation Tests"),
    Directory("preview"),
            
    Page("osinstall.md", 
        title="OS Install", 
        pageTitle="Base OS Install"),
    Directory("osinstall"),
    
    Page("compiling.md", 
        title="Compiling", 
        pageTitle="Compiling from Src"),
    Directory("compiling"),
    
    Page("checklist.md",
        title="Checklist", 
        pageTitle="Checklist Manifesto"),
    Directory("checklist"),
 ]
