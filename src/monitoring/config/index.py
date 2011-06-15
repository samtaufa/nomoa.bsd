from countershape.doc import *
import countershape

#from countershape import  markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Configuration] "

pages = [
               
	Page("install.mdtext",
		title="Install",
		pageTitle="Simple Message System"),
]
