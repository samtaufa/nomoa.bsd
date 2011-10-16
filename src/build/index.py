from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/consistency.html',
        )

this.titlePrefix = ns.titlePrefix + "[Build Consistency] "


pages = [
       
    Page("preview.md",
        title="Preview", 
        pageTitle="Pre Installation"),
    Directory("preview"),
            
    Page("install.md", 
        title="Install", 
        pageTitle="Base Install"),
    Directory("install"),
        
    Page("consistency.md",
        title="Consistency", 
        pageTitle="Consistency"),
    Directory("consistency"),
 ]
