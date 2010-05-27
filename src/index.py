import os, os.path, subprocess
import countershape, pygments
from countershape import Page, Directory, model, template, state

this.layout = countershape.Layout("../templates/_layout.html")
#this.markdown = "textish"
this.markup = "markdown"
#this.markup = "textish"
this.titlePrefix = "=8> Nomoa "
ns.copyright = "Samiuela LV Taufa, 2010"
ns.footer = "When it pores, run!!"
ns.tpl_banner  = template.File(None, "../templates/_banner.html")
ns.tpl_navigate = template.File(None, "../templates/_navigate.html")
ns.tpl_relatedsites = template.File(None, "../templates/_relatedsites.html")
ns.tpl_footer  = template.File(None, "../templates/_footer.html")



ns.menubar = countershape.widgets.SiblingPageIndex(
                '/index.html', 
            depth = 1,
            divclass = "navBarLineOne"
     )

ns.menu_all = countershape.widgets.SiblingPageIndex(
                '/index.html',
        )
                
ns.submenu = ""
ns.submenuTitle = ""
ns.homelink=model.UrlTo("/index.html")
ns.readFrom = readFrom
this.stdHeaders = [
    model.UrlTo("media/css/reset.css"),
    model.UrlTo("media/css/docstyle.css"),
    model.UrlTo("media/css/content.css"),
    model.UrlTo("media/css/nomoa.openbsd.css"),
    model.UrlTo("media/css/navBar.css"),
    model.UrlTo("media/css/syntax.css"),
    
    model.UrlTo("media/js/imagerollover.js"),
    model.UrlTo("media/js/menu.js"),
    model.UrlTo("media/js/simpletreemenu.js"),
]
    
ns.OpenBSD="<a href=\"http://www.openbsd.org\">OpenBSD</a>"    
ns.bannerIMG = countershape.html.IMG(
        src=model.UrlTo("media/images/openbsd.gif"),
        name="openbsd",  
        align="left", 
        alt="OpenBSD ... The Only way to Go ...",
        border="0",
        height="50",
        width="368"
        )
ns.shSyntax = template.Syntax(pygments.lexers.BashLexer())
ns.shConsole = template.Syntax(pygments.lexers.BashSessionLexer())
ns.confSyntax = template.Syntax(pygments.lexers.ApacheConfLexer())

textfile=['text','txt','md','rst','rest']
htmlext=os.path.extsep+'html'
def section(fname, dirname, title, pageTitle):
    mfname=fname
    filename=os.path.splitext(fname)
    fileext=filename[1]
    if len(fileext)>1 and fileext[1:] in textfile:
        mfname = "%s%s"%(filename[0],htmlext)
    
    menu = countershape.widgets.ExtendedParentPageIndex(
        '\\%s'%mfname,
        depth = 1,
        divclass = "navBarLineTwo",
        currentActive = True
    )
    page = Page(
            fname,
            title,
            pageTitle = pageTitle,
    )
    page.namespace["submenu"] = menu
    page.namespace["submenuTitle"] = title
    directory = Directory(dirname)
    directory.namespace["submenu"] = menu
    return [page, directory]

pages = []
    
pages += section(
            fname="build.md", 
            dirname="build", 
            title="Build",
            pageTitle="System Build"
        )

pages += section(
            "comms.md", "comms", "Communications",
            "Secured Communications"
        )

pages += section(
            "config.md", "config", "Configuration",
            "Configuration Management"
        )

pages += section(
            "borders.md", "borders", "Gateway",
            "Border, Gateway Systems"
        )

pages += section(
            "monitoring.md", "monitoring", "Monitoring",
            "Monitoring and Maintenance"
        )
pages += section(
            fname="index.html", 
            dirname="about", 
            title="Home",
            pageTitle="OpenBSD Guides"
        )


# This should be factored out into a library and tested...
class ShowSrc:
    def __init__(self, d):
        self.d = os.path.abspath(d)
    
    def _wrap(self, proc, path):
        f = file(os.path.join(self.d, path)).read()
        if proc:
            f = proc(f)
        post = "<div class=\"fname\">(%s)</div>"%path
        return f + post

    def py(self, path, **kwargs):
        return self._wrap(ns.pySyntax.withConf(**kwargs), path)

    def _preProc(self, f):
        return "<pre class=\"output\">%s</pre>"%f

    def plain(self, path):
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
    if sektion is not None:
        query_sektion="&sektion=%s" % sektion
    if architecture is not None:
        query_architecture = "&arch=%s"% architecture
        
    url = "http://www.openbsd.org/cgi-bin/man.cgi?query=%s%s%s" % (
        app, query_sektion, query_architecture)

    if sektion is None:
        manref = "<a href=\"%s\">%s</a>" % (
            url, app)
    else:
        manref = "<a href=\"%s\">%s(%s)</a>" % (
            url, app, sektion)
    return manref
    
ns.manpage = manpage