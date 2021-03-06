## Flow Views

&#91;Ref: [flow-tools](http://code.google.com/p/flow-tools/),  <a href="http://networkflowanalysis.com" title="Michael W. Lucas' book 'Network Flow Analysis'">Network Flow Analysis.</a>]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#sample">Sample Analysis</a></li>
	<li><a href="#summary">Summary View</a></li>
</ol>

</div>

The most flexible, and difficult way to view your netflow
data is to use the console tools from flow-tools. These console 
tools can be linked together (using the output of one utility as
input to the next) to make detailed analysis/extraction of traffic
data.

### <a name="sample"></a> 1. Sample Analysis

A simplified view, or raw dump of the netflow, is to take a point-in-time
view through one of the 5-minute incremented log files. We'll use
flow-cat and flow-print to take a look at one of the files.

<pre class="command-line">
# flow-cat ft-v05.2011-02-14.175500+1100 | flow-print | head -10
</pre>
<pre class="screen-output">
srcIP            dstIP            prot  srcPort  dstPort  octets      packets
192.168.20.61    10.1.0.7         6     1117     1116     48          1
10.1.0.7         192.168.20.61    6     1116     1117     40          1
192.168.20.61    10.1.0.7         6     1117     1116     48          1
10.1.0.7         192.168.20.61    6     1116     1117     40          1
192.168.110.33   10.0.0..38    17    10830    53       432         6
10.0.0..38    192.168.110.33   17    53       10830    168         3
192.168.110.33   10.0.0..38    17    10830    53       432         6
192.168.144.104  192.168.18.65    6     2680     1116     393         5
192.168.18.65    192.168.144.104  6     1116     2680     128         3
</pre>

The above is displaying traffic between hosts on either side of the
sensor. In the above screen-output:

-	2 packets were sent from 192.168.20.61 to 10.1.0.7. 
-	2 packets seem to be alternated response
-	6 packets were sent from 192.168.110.33 to 10.0.0..38 
-	3 packet response?
-	6 packets were sent from 192.168.110.33 to 10.0.0..38 
-	5 packets were sent from 192.168.144.104 to 192.168.18.65
-	3 packet response?

Some interesting facts are already visible, with the use of different
protocols in the communications.

-	Protocol 6 - "TCP Protocol"
-	Protocol 17 - "UDP Protocol"

&#91;Ref: [Iana IPv4 Protocol Numbers](http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml)]

192.168.110.33 and 10.0.0..38 seem to be:

-	exchanging Domain Name Services(DNS) (port 53) queries. 
-	432 octets (bytes) to make the request, and 
-	168 octets (bytes) for the response.

### <a name="summary"></a> 2. Summary View

Summary information on the packets in the log file can be viewed
using flow-print

<pre class="command-line">
# flow-print -p < ft-v05.2011-02-14.175500+1100 | head -20
</pre>

<pre class="screen-output">
#
# mode:                 normal
# capture hostname:     hostname.example.com
# capture start:        Mon, 14 Feb 2011 17:55:00 +1100
# capture end:          Mon, 14 Feb 2011 18:00:00 +1100
# capture period:       300 seconds
# compress:             on
# byte order:           little
# stream version:       3
# export version:       5
# lost flows:           0
# corrupt packets:      0
# sequencer resets:     0
# capture flows:        4680
#
srcIP            dstIP            prot  srcPort  dstPort  octets      packets
192.168.20.61    10.1.0.7         6     1117     1116     48          1
10.1.0.7         192.168.20.61    6     1116     1117     40          1
192.168.20.61    10.1.0.7         6     1117     1116     48          1
10.1.0.7         192.168.20.61    6     1116     1117     40          1
</pre>

The log file is a 5 minute segment of the traffic through hostname.example.com

Although the range of console tools allows very detailed analysis of the 
network data flow, it also requires a <a title="aka non-intuitive">deeper knowledge</a>
of network flow, and
the flow-tools kit itself. Pretty charts seems to impress and impart information(?),
which is why such tools have evolved around flow-tools.

Get the book [Network Flow Analysis](
http://networkflowanalysis.com "Michael W. Lucas' book 'Network Flow Analysis'")
The book shows you how to use the flow-tools commands, how they can be applied (why?)
where and a good start to envisioning your prowess bringing world-peace 
(or at least do so in your own network.)