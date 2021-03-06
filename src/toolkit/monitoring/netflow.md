## Netflow for network monitoring

&#91;Ref: [Network Flow Analysis.](http://networkflowanalysis.com)]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#1">Monitoring your network</a></li>
	<li><a href="#2">Pushing Data using Sensors</a></li>
	<li><a href="#3">Capturing Data using Collectors</a></li>
	<li><a href="#4">Analysing Data</a></li>
	<li><a href="#5">Reference Resource</a></li>
</ol>

</div>

[Wikipedia Article](http://en.wikipedia.org/wiki/Netflow)

<blockquote>
NetFlow is a network protocol developed by Cisco Systems for collecting 
IP traffic information. NetFlow has become an industry standard for traffic 
monitoring and is supported by platforms other than Cisco IOS and NXOS such 
as Juniper routers, Enterasys Switches, Linux, FreeBSD, NetBSD and OpenBSD.
</blockquote>

A related protocol not discussed here, but is apparently supported
by the described tools is: [sFlow](http://en.wikipedia.org/wiki/SFlow)

Netflow gives us a closer view of traffic behaviour across supported network devices.
The challenge is deploying tools to use Netflow effectively: collect the 
data, analyse, and summarise.

### <a name="1"></a> 1. Monitoring your Network

Manage a computer network and you need monitoring for an overview of traffic 
behaviour across your network. Manage an expanded network spanning a large number of
hosts, devices, and/or geographical layout or multiple sites, and you really 
need network traffic monitoring/analysis tools. When you're responsible for
the network, everyone blames performance issues on your network and you 
need better knowledge of the security, stability and performance factors
of your network. You need live data, and historical data with enough
granularity to be able to extract useable information.

First look at [Michael W. Lucas'](http://www.michaelwlucas.com) book 
[Network Flow Analysis.](http://networkflowanalysis.com)
These notes augment the tool installation instructions from that book,
where the human factor is important, in customisation/localisation,
interpretation, we don't do any of that here. Buy the book.

These notes are what we've done to successfully deploy netflow tools with $!OpenBSD!$.
You will find other exorbitantly priced or free tools for monitoring the performance
of your network, but [Michael's book](http://networkflowanalysis.com) gives invaluable 
examples for  installing, validating and understanding your new netflow monitoring system 

$!Image("monitoring/netflow_architecture.png", title="Netflow Architecture", klass="imgcenter")!$

What netflow offers us, as shown in the diagram, is the ability to get network flow
traffic from our routers/gateways (*sensors*), archive that data (*collector*.) 
With the data *collected* we can analyse the data either in 'live' data stream
or from the archives.

1. Push data using sensor(s)
2. Capture data in a collector(s)
3. Analyse the Data

[Network Flow Analysis](http://networkflowanalysis.com) is an investment in
your time. If you've got more time then sense, go ahead and try to get Open
Source tools together and augment the information out there for how to do it.

### <a name="2"></a> 2. Pushing Data using Sensors 

We push data out of the router/gateways using [Sensors/Netflow exporter](netflow/sensor.html) 
using a directed UDP broadcast (i.e. data gets pushed in one direction to one target host.)

$!Image("monitoring/netflow_sensors.png", title="Netflow Architecture", klass="imgcenter")!$

As indicated by the diagram, netflow export facilities (i.e. sensors) can exist in various
devices. On gateway/routing appliances, such as from Cisco and Juniper, the sensor is often 
found pre-installed. Various software tools exist for Unix, including [softflowd](
http://code.google.com/p/softflowd) which is available in the [OpenBSD Package Collection](
http://www.openbsd.org/faq/faq15.html#Intro).

For these exercies in OpenBSD, we [document the use] of(netflow/sensor.html) $!manpage("pflow",4)!$
deployed in the base install.

### <a name="3"></a> 3. Capturing Data using Collectors

A Netflow [collector](netflow/collector.html "flow-tools: A library and collection of programs
used to collect, send, process, and generate reports from Netflow data.") captures the above 
[sensor](netflow/sensor.html) published data. 

In its simplest form, the collector dumps the data to storage, at which point the data is 
available to your analysis tools.

### <a name="4"></a> 4. Analysing Data

The point of collecting and monitoring is to interpret that data so we can 
make informed decisions, take action. Data analysis can be on a separate terminal 
from the Collector, but for our needs we will use the same host.

Our common workflow is to monitor traffic latency using GUI tools such as
[smokeping](smokeping.html), and [CUFlow](netflow/flow.flowscan.html). When 
latency and throughput indicators from the above charts show dramatic changes, 
we seek more information (a more granular view) using [FlowViewer](netflow/flow.flowviewer.html).

Another workflow is to use FlowViewer/FlowTracker to track network traffic for specific services
(for example, monitor traffic in and out of the primary file server or SMTP through the
Internet Gateway.) When the traffic is noticeably averaging above a useability threshold, 
we have this collected data as justification for increase in either host capacity or link 
capacity for that host.

We describe here, three toolsets for analysis of the netflow data:

1.	At the console, with flow-tools
2.	Graphs with CUFlow (using Cflow.pm and FlowScan)
3.	Graphs with more detail using FlowViewer

#### 4.1 At the Console

&#91;Ref: [Flow - Console](netflow/flow.views.html)]

The most powerful analysis tool is from the command-line using
[flow-tools](netflow/collector.html "A library and collection of programs
used to collect, send, process, and generate reports from Netflow data.")

The best tutorial I've found is in print with [Michael W. Lucas'](
http://www.michaelwlucas.com) book [Network Flow Analysis.](
http://networkflowanalysis.com). We give you a sufficient start
to make sure the data collection process is working correctly,
together with your tool install.

If you're networking kung fu is good, then use the command-line 
tools, but get the book and look at the following GUI tools.

#### 4.2 GUI Frontends

We review the installation of 3 GUI front-ends to captured
data. As with our above described workflows, a general overview of 
traffic behaviour can be extracted using our first tool:
[FlowScan/CUFlow](netflow/flow.flowscan.html).

To get more specifics on the traffic, and behaviour of specific
hosts or ports, we then drill deeper using
[FlowViewer](netflow/flow.flowviewer.html)

- 	[Flow - Graphs](netflow/flow.flowscan.html) reviews the Graphing front-ends
	FlowScan/CUFlow.
- 	[Flow - Custom](netflow/flow.flowviewer.html) reviews the Graphing front-end
	FlowViewer, which supports more extended customisation/analysis than FlowScan/CUFlow.

Interestingly enough, installing the difficult to understand tool ([FlowViewer](netflow/flow.flowviewer.html))
is faster with fewer difficult bits to put together.
	
### <a name="5"></a>5. Reference Resource

Some pointers of places that have lists of available netflow analysis (or other) tools.

- [FloMA: Pointers and Software](http://www.switch.ch/network/projects/completed/TF-NGN/floma/software.html)