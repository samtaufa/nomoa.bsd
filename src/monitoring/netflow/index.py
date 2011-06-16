from countershape.doc import *
import countershape

#from countershape import  markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Netflow] "

pages = [
               
    Page("sensor.md", 
        title="Sensor",
        pageTitle="Sensor"),    

    Page("collector.md", 
        title="Collector",
        pageTitle="Collector"),    

	Page("flow.views.md",
		title="Flow - Console",
		pageTitle="netflow Views"),

	Page("flow.flowscan.md",
		title="Flow - Graphs",
		pageTitle="netflow Graphs - Flowscan and CUFlow"),

	Page("flow.flowviewer.md",
		title="Flow - Custom",
		pageTitle="netflow Graphs - FlowViewer"),
]
