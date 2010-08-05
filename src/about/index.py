from countershape.doc import *
import countershape
from countershape import  markup
this.markup = markup.Markdown()

this.layout = ns.tpl_layout

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
