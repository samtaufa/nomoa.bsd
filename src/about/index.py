from countershape.doc import *
import countershape
from countershape import  markup
this.markup = markup.Markdown()

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/about/site.html',
        )
        
this.titlePrefix = ns.titlePrefix + "[About] "

   
pages = [
    Page("site.mdtext",
        title="Site Info",
        pageTitle="Site Information"),
        
    Page("directions.mdtext",
        title="Directions",
        pageTitle="Future Site Directions"),
		
    Page("guides.mdtext",
        title="Guides",
        pageTitle="The Guides"),
]
