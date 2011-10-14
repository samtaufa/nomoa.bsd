import os, os.path, subprocess
import countershape, pygments
from countershape import Page, Directory, model, template, state, blog, markup, sitemap

this.markup = markup.Markdown( extras=["code-friendly"] )
ns.titlePrefix = "=8> nomoa.com/bsd/ "
this.titlePrefix = ns.titlePrefix
this.site_url = "http://www.nomoa.com/bsd/"

ns.blk_banner       = template.File(None, "../templates/_banner.tpl")
ns.blk_relatedsites = template.File(None, "../templates/_relatedsites.tpl")
ns.blk_footer       = template.File(None, "../templates/_footer.tpl")
ns.blk_rss = template.File(None, "../templates/_rss.tpl")
ns.blk_copyright    = template.File(None, "../templates/_copyright.tpl")

ns.tpl_layout = countershape.Layout("../templates/_layout.tpl", bgcolor="#fffacd", onLoad="preloadImages();")
ns.tpl_bloglayout = countershape.Layout("../templates/_blog.tpl", bgcolor="#fffacd", onLoad="preloadImages();")
ns.tpl_frontpage = countershape.Layout("../templates/_frontpage.tpl", bgcolor="#fffacd", onLoad="preloadImages();")
this.layout = ns.tpl_frontpage


ns.blk_menubar = countershape.widgets.SiblingPageIndex(
                '/index.html', 
            depth = 1,
            divclass = "navBarLineOne"
     )

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/index.html',
        )
                
ns.blk_submenu = ""
ns.submenuTitle = ""
ns.homelink=model.UrlTo("/index.html")

this.stdHeaders = [
    model.UrlTo("media/css/reset.css"),
    model.UrlTo("media/css/docstyle.css"),
    model.UrlTo("media/css/content.css"),
    model.UrlTo("media/css/nomoa.bsd.css"),
    model.UrlTo("media/css/navBar.css"),
    model.UrlTo("media/css/syntax.css"),
    
    model.UrlTo("media/js/imagerollover.js"),
]
    
ns.OpenBSD="<a href=\"http://www.openbsd.org\" title=\"The OpenBSD project produces a FREE, multi-platform 4.4BSD-based UNIX-like operating system. Our efforts emphasize portability, standardization, correctness, proactive security and integrated cryptography. \">OpenBSD</a>"

def Image(imagefile, title=None, basepath=None, klass=None, kaption=None):
        defaultpath="media/images"

        if basepath is None:
            src = """src="%s" """ % model.UrlTo(imagefile)
        else:
            src = """src="%s" """ % model.UrlTo(os.path.join(defaultpath, imagefile))

        if title is None:
            title=""
        else:
            title=""" title="%s" """ % title
        
        image = """<img %s%s>""" % (src, title)
        
        if klass is None:
            klass =""
        else:
            klass=""" class="%s" """ % klass            
        
        if kaption is None:
            kaption = ""
        else:
            kaption ="""<p %s>
    %s 
</p>""" % (klass, kaption)

        url = image
        if not klass == "" or not kaption == "":
            url="""
<div %s>
    %s
    %s
</div>
""" % (klass, image, kaption)

        return url
            
ns.Image = Image
            
htmlfiles=['', '.html','.htm']
htmlext=os.path.extsep+'html'
def section(fname, dirname, title, pageTitle):
    mfname=fname
    filename=os.path.splitext(fname)
    if filename[1] not in htmlfiles:
        mfname = "%s%s"%(filename[0],htmlext)
    
    menu = countershape.widgets.ExtendedParentPageIndex(
        '/%s'%mfname,
        depth = 1,
        divclass = "navBarLineTwo",
        currentActive = True
    )
    page = Page(
            fname,
            title,
            pageTitle = pageTitle,
    )
    page.namespace["blk_submenu"] = menu
    page.namespace["submenuTitle"] = title
    directory = Directory(dirname)
    directory.namespace["blk_submenu"] = menu
    return [page, directory]


ns.blog = blog.Blog(
        blogname="!NO Moa 'O Sauce", 
        blogdesc="! the echo $? chamber", 
        base="null", 
        src="../posts")
       
blogindex = ns.blog.index("dev.html", "echo $?")
blogindex.namespace["blk_submenu"] = countershape.widgets.ExtendedParentPageIndex(
    '/dev.html',
    depth = 1,
    divclass = "navBarLineTwo",
    currentActive = True
)
blogindex.namespace["submenuTitle"] = "log"

#blogindex.layout = ns.tpl_bloglayout
blogindex.markup = markup.Markdown( extras=["code-friendly"] )
blogdir = Directory("dev")
blogdir.namespace["blk_submenu"] = blogindex.namespace["blk_submenu"]
blogdir.namespace["submenuTitle"] = blogindex.namespace["submenuTitle"]
blogdir.layout = ns.tpl_bloglayout
blogdir.markup = markup.Markdown( extras=["code-friendly"] )

pages = [    
]
     
pages += section(
            fname="index.mdtext", 
            dirname="about", 
            title="O'BSD",
            pageTitle="OpenBSD Guides"
    )
    
pages += section(
            fname="build.mdtext", 
            dirname="build", 
            title="Build",
            pageTitle="System Build"
        )

pages += section(
            "comms.mdtext", "comms", "Communications",
            "Secured Communications"
        )

pages += section(
            "gateway.mdtext", "gateway", "Gateway",
            "Border, Gateway Systems"
        )

pages += section(
            fname="toolkit.mdtext", 
            dirname="toolkit", 
            title="Toolkit",
            pageTitle="Monitoring and Maintenance"
        )

#pages.extend(
pages +=    [
        blogindex, 
        blogdir,
        ns.blog.rss( name="rss.xml", title="Nomoa.com/bsd", fullrss=True ),
    ]
#)

rootPath = os.path.abspath(".")

def showsrc(path):        
    return readFrom(os.path.join(rootPath, path))

ns.showsrc = showsrc
ns.breadcrumbs = countershape.widgets.PageTrail

def manpage(keyword, sektion=None, arch=None):
    query_sektion = ""
    query_arch = ""
    title="""OpenBSD Project Manual Pages (%s)""" % keyword
    if sektion is not None:
        query_sektion="&sektion=%s" % sektion
    if arch is not None:
        query_arch = "&arch=%s"% arch
        
    url = "http://www.openbsd.org/cgi-bin/man.cgi?query=%s%s%s" % (
        keyword, query_sektion, query_arch)
    aref =  """<a href="%s" title="%s">""" % (
            url, title)
    manshort = keyword
    if sektion is not None:
        if arch is not None:
            manshort = "%s(%s/%s)" % (keyword, sektion, arch)
        else:
            manshort = "%s(%s)" % (keyword, sektion)
            
    manref="%s%s</a>" % (aref, manshort)
    
    return manref

ns.manpage = manpage
