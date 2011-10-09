from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Gateway | Proxies] "

this.markdown = "textish"

pages = [
    Page("mail.md",
        title="Mail",
        pageTitle="Electronic Mail - Proxying to the Internet"
        ),
		Directory("postfix"),
        
    Page("web.md",
        title="Web",
        pageTitle="Web Access - Proxying to the Internet"
        ),
	Directory("squid"),
]
