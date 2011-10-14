## Publishing netflow data with Sensors

&#91;Ref: OpenBSD 4.8 amd64, 4.9 amd64 & i386]

Sensors on Edge Devices publish netflow data as a directed UDP broadcast.

<div class="toc">

Table of Contents

<ol>
	<li><a href="#1">pflow pseudo-device</a></li>
	<li><a href="#2">Packet Filter (pf)</a></li>
</ol>

</div>

On switching appliances, such as Cisco and Juniper, the sensor is normally installed 
or configurable on the device. Various software tools exist for Unix, including 
[softflowd](http://code.google.com/p/softflowd) which is available in the [OpenBSD
Package Collection](http://www.openbsd.org/faq/faq15.html#Intro).

OpenBSD supports the netflow sensor framework in the default base install
configuration through a pseudo network device $!manpage("pflow",4)!$ 
and the Firewall Packet Filter $!manpage("pf.conf",5)!$. Enabling netflow
sensor publication is through configuration.

$!Image("monitoring/netflow_sensors.png", title="Netflow Architecture", klass="imgcenter")!$

Our sample sensor configuration will use the below interpretation of the above sample network
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

We do not concern ourselves with other sensor devices, and this documentation is
singularly focused on OpenBSD sensors using:

1. $!manpage("pflow",4)!$ pseudo-device, and
2. Packet Filter

#### Time Configuration

Network analysis is a time sensitive venture, make sure that the clocks on 
your sensors and collectors are synchronised or you will confuse everyone
with the timelines of your logs, analysis, reports.

##### <a name="1">1. </a> $!manpage("pflow",4)!$ pseudo-device

&#91;Ref: $!manpage("pflow",4)!$ $!manpage("ifconfig",8)!$]

From the manpage:

<pre class="manpage">
The pflow interface is a pseudo-device which exports pflow accounting
data from the kernel using udp(4) packets.  

...

Only states created by a rule marked with the pflow keyword are exported
by the pflow interface.
</pre>

To configure the pflow pseudo-interface to export netflow data from 
the current machine (10.0.0.1) to an external collector at 
host 10.0.0.2 at port 12345, use a command-line such as the following:

<!--(block | syntax("bash") )-->
$ sudo ifconfig pflow0 flowsrc 10.0.0.1 flowdst 10.0.0.2:12345
<!--(end)-->

To ensure the above command-line is set during each host restart 
set in the interface start up configuration file.

File: /etc/hostname.pflow0

<!--(block | syntax("bash") )-->
flowsrc 10.0.0.1 flowdst 10.0.0.2:12345
<!--(end)-->


##### <a name="2">2. </a>Packet Filter $!manpage("pf.conf",5)!$.

As per the $!manpage("pflow",4)!$ and $!manpage("pf.conf",5)!$
the 'pflow' keyword must be used in the Packet Filter for netflow v5
data to be exported from the 'sensor.'

From the manpage, the pflow keyword:

<pre class="manpage">
pflow
   States created by this rule are exported on the pflow(4) interface.
</pre>

For example, to specify 'pflow' for a specific rule: /etc/pf.conf

<pre class="config-file">
pass in on $myinf keep state pflow
</pre>

To set 'pflow' as the default for all state actions in the ruleset: /etc/pf.conf

<pre class="config-file">
set state-defaults pflow
</pre>
