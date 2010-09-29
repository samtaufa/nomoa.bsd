from countershape.doc import *
import countershape
from countershape import  markup

this.markup = markup.Markdown()
this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/comms/mail.html',
        )
 
this.titlePrefix = ns.titlePrefix + "[Communications] "

pages = [

    Page("mail.mdtext", 
        title="Mail",
        pageTitle="Electronic Mail Service"),
    Directory("mail"),
    
    Page("openvpn.mdtext", 
        title="OpenVPN", 
        pageTitle="OpenVPN"),
    Directory("openvpn"),

    Page("www.mdtext", 
        title="Web", 
        pageTitle="WWW Access - Apache"),
    Directory("www"),

    Page("misc.mdtext", 
        title="Miscellaneous",
        pageTitle="Miscellaneous Servers"),
    Directory("misc"),
    
]
