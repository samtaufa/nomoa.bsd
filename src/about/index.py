from countershape.doc import *
import countershape

this.layout = ns.tpl_layout
this.markup = "markdown"

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/about/site.html',
        )
   
pages = [
    Page("site.mdtext",
        title="Site Info",
        pageTitle="Site Information"),
        
    Page("directions.mdtext",
        title="Directions",
        pageTitle="Futuer Site Directions"),
]
