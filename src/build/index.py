from countershape.doc import *
import countershape

this.layout = ns.tpl_layout
this.markup = "markdown"

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/consistency.html',
        )

ns.docTitle = "Build Consistency"

pages = [
       
    Page("preview.mdtext",
        title="Preview", 
        pageTitle="Pre Installation"),
    Directory("preview"),
            
    Page("install.mdtext", 
        title="Install", 
        pageTitle="Base Install"),
    Directory("install"),
    
    Page("compiling.mdtext", 
        title="Compiling", 
        pageTitle="Compiling from Src"),
    Directory("compiling"),
    
    Page("consistency.mdtext",
        title="Consistency", 
        pageTitle="Consistency"),
    Directory("consistency"),
 ]
