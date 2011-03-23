import os, os.path, subprocess
import countershape, pygments
from countershape import Page, Directory, model, template, state, blog, markup

this.markup = markup.Markdown()
ns.titlePrefix = "=8> nomoa.com/bsd/ "
this.titlePrefix = ns.titlePrefix

ns.blk_banner  = template.File(None, "../templates/_banner.tpl")
ns.blk_relatedsites = template.File(None, "../templates/_relatedsites.tpl")
ns.blk_footer  = template.File(None, "../templates/_footer.tpl")
ns.blk_rss = template.File(None, "../templates/_rss.tpl")
ns.blk_copyright = template.File(None, "../templates/_copyright.tpl")

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
    model.UrlTo("media/js/menu.js"),
    model.UrlTo("media/js/simpletreemenu.js"),
]
    
ns.OpenBSD="<a href=\"http://www.openbsd.org\" title=\"Click through to the Project Website\">OpenBSD</a>"

def Image(imagefile, title=None, basepath=None, klass=None):
        defaultpath="media/images"

        if basepath is None:
            src = """src="%s" """ % model.UrlTo(imagefile)
        else:
            src = """src="%s" """ % model.UrlTo(os.path.join(defaultpath, imagefile))

        if title is None:
            title=""
        else:
            title=""" title="%s" """ % title
            
        if klass is None:
            klass=""
        else:
            klass=""" class="%s" """ % klass            
            
        url="""<img %s%s%s />""" % (src, title, klass)
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
        blogname="{; !nomoa", 
        blogdesc="Cacophony of Sound", 
        url="http://www.nomoa.com/bsd/", 
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
blogindex.markup = markup.Markdown()
blogdir = Directory("dev")
blogdir.namespace["blk_submenu"] = blogindex.namespace["blk_submenu"]
blogdir.namespace["submenuTitle"] = blogindex.namespace["submenuTitle"]
blogdir.layout = ns.tpl_bloglayout
blogdir.markup = markup.Markdown()

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
            "monitoring.mdtext", "monitoring", "Monitoring",
            "Monitoring and Maintenance"
        )

pages.extend(
    [
        blogindex, blogdir,
        ns.blog.rss("rss.xml", "Nomoa.com/bsd"),
    ]
)

# This should be factored out into a library and tested...
class ShowSrc:
    def __init__(self, d):
        self.klass = "output"
        self.d = os.path.abspath(d)
    
    def _wrap(self, proc, path):
        f = file(os.path.join(self.d, path)).read()
        if proc:
            f = proc(f)
        post = """
<div class=\"fname\">
(%s)
</div>
"""%path
        return f + post

    def py(self, path, **kwargs):
        return self._wrap(ns.pySyntax.withConf(**kwargs), path)

    def _preProc(self, f):
        return """
<pre class="%s">
%s
</pre>
""" % (self.klass, f)

    def plain(self, path):
        return self._wrap(self._preProc, path)

    def config(self, path):
        self.klass="config-file"
        return self._wrap(self._preProc, path)

    def pry(self, path, args):
        cur = os.getcwd()
        os.chdir(os.path.join(self.d, path))
        prog = os.path.join(self.d, "doc")
        pipe = subprocess.Popen(
                    "%s "%prog + args,
                    shell=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE
                ).stdout
        os.chdir(cur)

        content = "> pry %s\n"%args + pipe.read()
        return self._preProc(content)

ns.showsrc = ShowSrc(".")
ns.breadcrumbs = countershape.widgets.PageTrail

def manpage(app, sektion=None, architecture=None):
    query_sektion = ""
    query_architecture = ""
    title="""OpenBSD Project Manual Pages (%s)""" % app
    if sektion is not None:
        query_sektion="&sektion=%s" % sektion
    if architecture is not None:
        query_architecture = "&arch=%s"% architecture
        
    url = "http://www.openbsd.org/cgi-bin/man.cgi?query=%s%s%s" % (
        app, query_sektion, query_architecture)

    if sektion is None:
        manref = """<a href="%s" title="%s">%s</a>""" % (
            url, title, app)
    else:
        manref = """<a href="%s" title="%s">%s(%s)</a>""" % (
            url, title, app, sektion)
    return manref

ns.manpage = manpage
