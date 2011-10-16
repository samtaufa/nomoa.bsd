from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Compile] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/toolkit/dev/subversion.html',
        )

pages = [

	Page("subversion.md",
		title="Subversion",
		pageTitle="Source Control with Subversion"),
]
