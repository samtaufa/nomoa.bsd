from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Compile] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/build/buildiso.html',
        )

pages = [
    Page("compiling.md", 
        title="Compiling", 
        pageTitle="Compiling from Src"),
        
    Page("buildiso.md", 
        title="Build ISO", 
        pageTitle="Building an Install ISO"),
        
]
