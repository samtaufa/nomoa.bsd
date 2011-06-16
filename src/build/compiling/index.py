from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Compile] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/compiling/buildiso.html',
        )

pages = [
    Page("buildiso.md", 
        title="Build ISO", 
        pageTitle="Building an Install ISO"),
]
