import countershape
this.layout = ns.tpl_bloglayout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/dev/null.html'
    )
 
pages = [
    ns.blog.archive("archive.html", "Archive"),
    ns.blog(),
]
