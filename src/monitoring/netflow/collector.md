## Collector Flow-Tools

&#91;Ref: OpenBSD 4.8 amd64, 4.9 amd64 & i386]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#1">Install</a></li>
	<li><a href="#2">Data Path</a></li>
	<li><a href="#3">Capturing netflow data</a>
		<ul>
			<li>Validating Trafffic Flow</li>
			<li>Start Capturing on Host Boot</li>
		</ul>
	</li>
	<li><a href="#4">Storage Requirements</a></li>
</ol>

</div>

&#91;Ref: [flow-tools](http://code.google.com/p/flow-tools/),  <a href="http://networkflowanalysis.com" title="Michael W. Lucas' book 'Network Flow Analysis'">Network Flow Analysis.</a>]

Netflow collector(s) capture data exported from netflow [sensors](sensor.html)
and archive them to disk.

This guide will look at installing a collector, configuring the collector (setting
paths etc) and testing the capture process. For those wondering about the storage
requirements, a sample storage use is shown below.

We capture netflow data using [flow-tools](http://code.google.com/p/flow-tools/). 

<blockquote>
a library and a collection of programs used to collect, send, process, 
and generate reports from NetFlow data. The tools can be used together on a 
single server or distributed to multiple servers for large deployments.
</blockquote>

$!Image("monitoring/netflow_collector.png", title="Netflow Architecture", klass="imgcenter")!$

The above diagram shows the flow of data from 3 sensors, to a collector 
(which we are using OpenBSD for, and the collector archiving that data
onto disk. The sensors can be appliances or full computers acting as routers
or anything that manages network flow that is of interest to our
collector.

The data we want to collect are ["netflow"](netflow.html) packets with 
traffic information exported from the ["sensors"](sensors.html).

Our sample collector configuration will use the following sample network
layout.

<table>
    <tr>
        <th>Item</th><th>Details</th><th>Description</th>
    </tr><tr>
        <td>Sensor IP-Address</td>
        <td>10.0.0.1</td>
        <td>The IP-Address from where **sensor will broadcast** netflow packets.
        The IP-Address will also be used by the **collector to identify**
        traffic origination (which sensor broadcast which netflow packet.)</td>
    </tr><tr>
        <td>Collector IP-Address</td>
        <td>10.0.0.2</td>
        <td>The Collector IP-Address where the netflow packets will be
        captured. This IP-Address is used by the **sensor to direct** the UDP 
        packet.</td>
    </tr><tr>
        <td>UDP Port</td>
        <td>12345</td>
        <td>The UDP port number on which netflow packets are sent. By using 
        different UDP ports for different sensors, a collector can alternatively
        differentiate multiple sensors.</td>
    </tr>
</table>

#### Time Configuration

Network analysis is a time sensitive venture, make sure that the clocks on 
your sensors and collectors are synchronised or you will confuse everyone
with the timelines of your logs, analysis, reports.

#### Sensing the Sensor

It is also useful to determine that the sensor data is reaching your collector's
network interface before installing a collector. A simple tcpdump invocation
should be sufficient to let you see whether traffic is coming from your
sensor's ip address, to the collector's ip address at the specified port.

<pre class="command-line">
# tcpdump -nettti bnx0 udp and port 12345
</pre>

Where bnx0 is the network interface configured with IP Address 10.0.0.2

### <a name="1"></a> 1. Install

Install [flow-tools](http://code.google.com/p/flow-tools/) from the
[OpenBSD Packages](http://www.openbsd.org/faq/faq15.html#PkgMgmt).

<pre class="command-line">
$ sudo pkg_add flow-tools
</pre>

Dependencies the installation may install as well:

-   python
-   bzip2
-   sqlite3

### <a name="2"></a> 2. Data Paths

Our installation will use the following paths.

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>/etc/cfg</td>
		<td>
        
        Configuration files for netflow-tools copied from samples  at 
		/usr/local/share/examples/flow-tools/cfg including: 
		<ul>
			<li>filter.cfg</li>
			<li>stat.cfg - flow report definitions</li>
		</ul>
        		
<pre class="command-line">
# cp -R /usr/local/share/examples/flow-tools/cfg /etc
</pre>

		A lot confused about the filter/stat features, and configuration? Michael W. Lucas' book ["Network Flow Analysis"](
        http://networkflowanalysis.com) provides a number of example uses, and modifications to the above configuration
		files to help you gain a better view of your network traffic.
		</td>
	</tr>
	<tr>
		<td>/var/netflow</td>
		<td>BASE Storage Location, all subsequent paths are
		    rooted in this path. In production you might prefer /var/netflow 
            as a separate partition with lots of space to ensure it
            doesn't mangle other work on the collector box.
            
            Refer to the sample storage utilisation below for a
            guesstimate of what you may need? But, run your collector
            to get a better understanding of your own requirements.</td>
	</tr>
	<tr>
		<td>sensorXY</td>
		<td>/var/netflow/sensorXY is the Netflow capture directory, 
        where *sensorXY* is the label and name for your sensor, which
        we reflect as the directory for netflow data exported from the
        sensor. Sample sensor names: wangateway, router1, finance_rtr</td>
	</tr>
</table>

Michael's [book](http://networkflowanalysis.com "Network Flow Analysis") 
is invaluable in your learning toolkit for an exhaustive set of tests, invaluable
for validating software configuration is fully operational. 

For our install paths, we need to create some directories.

<pre class="command-line">
# mkdir -p /var/netflow/sensorXY
# cp -R /usr/local/share/examples/flow-tools/cfg /etc
</pre>

### <a name="3"></a> 3. Capturing netflow data

&#91;Ref: [flow-capture](http://code.google.com/p/flow-tools/wiki/ManFlowCapture)


<table>
    <tr>
        <th>Item</th><th>Details</th>
    </tr><tr>
        <td>Sensor IP-Address</td>
        <td>10.0.0.1</td>
    </tr><tr>
        <td>Collector IP-Address</td>
        <td>10.0.0.2</td>
    </tr><tr>
        <td>UDP Port</td>
        <td>12345</td>
    </tr>
</table>

Sensor data is collected using [flow-capture](http://code.google.com/p/flow-tools/wiki/ManFlowCapture)
which listens on the network interface (IP-Address) sensor specified 'destination address' and UDP port.
The command-line capture process would be like the following,

<pre class="command-line">
# flow-capture -p /var/run/flow-capture.pid -n 287 -w /var/netflow/sensorXY \
	-S 5 10.0.0.2/10.0.0.1/12345
</pre>

which you can use to quickly review whether the tools are installed, and working
correctly.

If the program installed correctly, and your sensor is sending your collector
the netflow packet, you should be able (after executing flow-capture) to
watch the work directory for data files, such as with:

<!--(block | syntax("bash"))-->
$ ls /var/netflow/sensorXY/2012/2012-08/2012-08-12/
<!--(end)-->

<pre class="screen-output">
tmp-v05.2012-08-12.153413+1000
</pre>

More details on using [flow-capture](http://code.google.com/p/flow-tools/wiki/ManFlowCapture) 
are also available at the manpage, 

<pre class="manpage">
flow-capture options localip/remoteip/port
</pre>

Port 12345 is quite arbitrary for testing purposes, and you can use something more
sane to your configuration.

<pre class="manpage">
-p pidfile Configure the process ID file

-n rotations the number of times a new file per day. 

-S stat_interval log a timestamped message every stat_interval minutes indicating 
counters such as the number of flows received, packets processed, 
and lost flows. 

-w workdir set the workdir to /var/netflow. 
</pre>

-n 287 is about every 5 minutes. 

-S 5 is set for 5 minutes, per 
    <a href="http://networkflowanalysis.com">Michael W. Lucas' book "Network Flow Analysis."</a>
    notes the expected standard by supplementary analysis tools.


#### Validating Traffic Flow

A few quick ways of verifying, monitoring behaviour of the flow-capture process
is by reviewing the:

- Log files generated by flow-capture 
- Log messages generated by flow-capture
- Traffic flow (tcpdump)

##### Log Files

When flow-capture is working correctly, data files will be stored in the 
specified directory, with data split into date folders, such as:

/var/netflow/sensorXY/YYYY/YYYY-MM/YYYY-MM-DD

The file naming convention for the incremental files are:

- tmp-v05.YYY-MM-DD.HHMMSS+UTCTZ
- ft-v05.YY-MM-DD.HHMMSS+UTCTZ

Where ft signifies the log file is complete, and tmp signifies the log file
is temporary/incomplete.

##### Log messages

flow-capture logs its messages, errors to syslog's /var/log/messages
which can be monitored.

#### Start Capturing on Host Boot

To ensure flow-capture is started at each host start-up, we need to start
the server using the $!manpage("rc",8)!$ command script for system startup. 
The following is a sample script for inclusion in /etc/rc.local

File extract: /etc/rc.local

<pre class="config-file">
CAPTURE=/usr/local/bin/flow-capture
FLOWPID=/var/run/flow-capture.pid
DATA=/var/netflow
SENSOR=sensorXY
ipa_collector=XXX.XXX.XXX.XXX
ipa_sensor=XXX.XXX.XXX.XXX
port=12345

if [ -x ${FLOWCAPTURE} ]; then
	printf ' flow-capture'; ${CAPTURE} -p ${FLOWPID} -n 287 -w ${DATA}/${SENSOR} \
		-S 5 ${ipa_collector}/${ipa_sensor}/${port} && \
		echo "\t\t [OK]" || echo "\t\t [Failed]";
fi
</pre>

In our example, we are overly verbose hopefully to clarify the
command-line options for flow-capture, but also so we can
easily replicate the script should we use multiple hosts, or
have multiple sensors we wish to capture.

### <a name="4"></a> 4. Storage Requirements

How much disk space is required ? How long is a piece of string ?

2 months of data collection on 2 devices reveals the below, but
all it really says is that storage

<table>
	<tr><th>Device</th><th>Storage Requirements</th></tr>
	<tr><td>WAN Gateway</td><td>751Mb</td></tr>
	<tr><td>Internet Gateway</td><td>1002Mb</td></tr>
</table>	
	
Storage requirements are not onerous for today's standard 
hard drives clearing 1Tb.
