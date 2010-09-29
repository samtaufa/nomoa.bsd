from countershape.doc import *
import countershape
from countershape import  markup
this.markup = markup.Markdown()

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/consistency.html',
        )

this.titlePrefix = ns.titlePrefix + "[Build Consistency] "


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
