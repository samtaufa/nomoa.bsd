import countershape
from countershape import Page


this.layout = ns.tpl_bloglayout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/dev/null.html'
    )
    
this.titlePrefix = ns.titlePrefix + "[echo $0] "
 
pages = [
    Page("../about/guides.md","About"),
    ns.blog.archive("archive.html", "Archive"),
    ns.blog(),
]
