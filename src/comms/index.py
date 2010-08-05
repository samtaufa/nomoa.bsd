from countershape.doc import *
import countershape
from countershape import  markup

this.markup = markup.Markdown()
this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/comms/mail.html',
        )
 
ns.docTitle = "VPN"

pages = [
    #~ Page("./actived/actived.mdtext", 
        #~ title="ADS", 
        #~ pageTitle="Active Directory"),
    #~ Directory("actived"),

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
