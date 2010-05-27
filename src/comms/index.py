from countershape.doc import *
this.markup = "markdown"
ns.docTitle = "VPN"

pages = [
       
           
    Page("ftp.md", 
        title="FTP",
        pageTitle="File Transfer Proxy"),

    Page("samba.md", 
        title="File Sharing",
        pageTitle=""),

    Page("ssh.md", 
        title="SSH Client",
        pageTitle=""),    
   
    Page("mysql.md", 
        title="SQL Database",
        pageTitle="MySQL Database"),

    #~ Page("./actived/actived.md", 
        #~ title="ADS", 
        #~ pageTitle="Active Directory"),
    #~ Directory("actived"),

    Page("mail.md", 
        title="Mail",
        pageTitle="Electronic Mail Service"),
    Directory("mail"),
    
    Page("openvpn.md", 
        title="OpenVPN", 
        pageTitle="OpenVPN"),
    Directory("openvpn"),

    Page("www.md", 
        title="Web", 
        pageTitle="WWW Access - Apache"),
    Directory("www"),

]
