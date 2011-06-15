from countershape.doc import *
import countershape

#from countershape import  markup
#this.markup = markup.Markdown(extras=["code-friendly"])

this.layout = ns.tpl_layout

this.titlePrefix = ns.titlePrefix + "[Netflow] "

pages = [
               
    Page("sensor.mdtext", 
        title="Sensor",
        pageTitle="Sensor"),    

    Page("collector.mdtext", 
        title="Collector",
        pageTitle="Collector"),    

	Page("flow.views.mdtext",
		title="Flow - Console",
		pageTitle="netflow Views"),

	Page("flow.flowscan.mdtext",
		title="Flow - Graphs",
		pageTitle="netflow Graphs - Flowscan and CUFlow"),

	Page("flow.flowviewer.mdtext",
		title="Flow - Custom",
		pageTitle="netflow Graphs - FlowViewer"),
]
