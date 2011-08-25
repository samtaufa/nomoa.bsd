from countershape.doc import *
import countershape

this.layout = ns.tpl_layout

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/comms/mail.html',
        )
 
this.titlePrefix = ns.titlePrefix + "[Communications] "

pages = [

    Page("xmpp.md", 
        title="Chat XMPP",
        pageTitle="Chat/XMPP Services"),
    Directory("xmpp"),
    
    Page("mail.md", 
        title="Mail",
        pageTitle="Electronic Mail Service"),
    Directory("mail"),
    
    Page("openvpn.md", 
        title="VPN", 
        pageTitle="OpenVPN Virtual Private Networks"),
    Directory("openvpn"),

    Page("www.md", 
        title="Web", 
        pageTitle="Web Services with Apache"),
    Directory("www"),

    Page("misc.md", 
        title="Miscellaneous",
        pageTitle="Miscellaneous Servers"),
    Directory("misc"),
    
]
