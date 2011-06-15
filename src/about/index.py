from countershape.doc import *
import countershape
#from countershape import  markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/about/site.html',
        )
        
this.titlePrefix = ns.titlePrefix + "[About] "

   
pages = [
    Page("site.md",
        title="Site Info",
        pageTitle="Site Information"),
        
    Page("directions.md",
        title="Directions",
        pageTitle="Future Site Directions"),
		
    Page("guides.md",
        title="Guides",
        pageTitle="The Guides"),
]
