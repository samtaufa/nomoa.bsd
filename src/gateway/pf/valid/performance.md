## Performance Measurement

Performance measurement serves two purposes, to monitor current performance for 
irregularities and to push the boundaries of existing systems to review acceptable
performance metrics.

Various tools are available in base and ports for this purpose.

<div class="toc">

Table of Contents

<li><a href="performance.html">Performance / Throughput</a>
    <ul>
        <li><a href="#netstat">netstat</a>
        <li><a href="#pfstat">pfstat from ports/net</a>
        <li><a href="#tcpbench">tcpbench</a>
        <li><a href="#tcpblast">tcpblast from ports/benchmarks</a>
        <li><a href="#netpipe">netpipe from ports/benchmarks</a>
    </ul>
</li>

</div>

### <a name="netstat"></a> netstat

<pre class="command-line">
netstat -s -p carp
</pre>

<pre class="manpage">
-s  Show per-protocol statistics.  If this option is repeated,
    counters with a value of zero are suppressed.
-p protocol
    Restrict the output to protocol, which is either a well-known
    name for a protocol or an alias for it.  Some protocol names and
    aliases are listed in the file /etc/protocols.  The program will
    complain if protocol is unknown.  If the -s option is specified,
    the per-protocol statistics are displayed.  Otherwise the states
    of the matching sockets are shown.
</pre>

    
### <a name="pfstat"></a>pfstat - graphing PF performance data

The pfstat utility can be used to collect and graph statistics exported
through the /dev/pf pseudo-device. pfstat can be installed from the
OpenBSD ports collection, or downloaded from the pfstat website.

pfstat requires the PF "loginterface" global configuration directive to be
set in the pf.conf configuration file. This directive enables statistics 
collection for one of the physical interfaces in the firewall. The following 
pf.conf entry will collect statistics on the hme0 interface:

<pre class="config-file">set loginterface hme0</pre>

Once statistics collecting is enabled, the pfstat utility can be invoked with
the "-q" option. This will query the current value of each statistics counter, 
and printed the result to standard out:

<pre class="command-line">
$ pfstat -q
</pre>

<pre class="screen-output">
1101400143 1101219586 483226347 25637411 0 0 496899 
3866 325988 0 0 0 0 0 6 1692642 17030 17024 879499 0 2 0 0 0
</pre>

pfstat uses this data to generate historical utilization graphs, so the data should
be collected at periodic intervals if graphs are desired. The following cron job 
will collect statistics every five minutes, and write the results to "/var/log/pfstat/pfstat":

<pre class="config-file">*/5 * * * * /usr/local/bin/pfstat -q >> /var/log/pfstat/pfstat</pre>

To graph the data that is collected, a pfstat configuration file needs to be created. 
This file describes the graphs to generate, how to display the data, and where to
store the output. The following example shows the pfstat configuration required
to graph state table data:

<pre class="config-file">image "/home/matty/pfstat/images/state_table.jpg" {
     from 3 months to now
     width 800 height 300
     left
        graph states_entries  label "state table entries"   color 0 255 0,
        graph states_searches label "state table searches"  color 255 0 0,
        graph states_inserts  label "state table insertions"   color 0 0 255,
        graph states_removals label "state table removals"  color 0 0 0
}
</pre>

The pfstat configuration file contains one or more "image" directives. Each image 
directive is followed by the file name of the image to generate, and a set of curly 
braces to control the attributes of the image. The "from" and "to" keywords select 
the time interval to graph. The value that follows the "from" keyword contains an
integer value and a time frame (minutes, hours, days, weeks, months, years) to control
how far back pfstat will go when processing data. The "to" keyword controls how
pfstat processes new data elements, and the special key word "now" indicates the 
current time.

The "height" and "width" directives set the size, in pixels, for the height and width of 
the image to be output. Two directives determine the horizontal alignment of text
descriptions: "left" aligns text on the left side of the graph and "right" aligns text on
the right side. The "graph" statements control which data is graphed, the label assigned
to the graph, and the colors used to create the entries on the graph. As of pfstat 
version 1.7, pfstat can graph packets, bytes, state table information, and several 
miscellaneous packet counters. The full list of options that can be passed to the 
"graph" directive are described in the pfstat(8) man page.

Once the configuration file is created, we can execute pfstat, and pass the configuration 
and data file as arguments to the "-c" and "-d" options:

<pre class="command-line">
$ pfstat -c /etc/pfstat/pfstat.conf -d /var/log/pfstat/pfstat >/dev/null
</pre>


### <a name="tcpbench"></a>tcpbench
    
 $!manpage("tcpbench",1)!$ 
 is a small tool that performs throughput benchmarking and 
 concurrent sampling of kernel network variables.

 tcpbench is run as a client/server pair.  The server must be invoked with
 the -s flag, which will cause it to listen for incoming connections.  The
 client must be invoked with the hostname of a listening server to connect
 to.

 Once connected, the client will send TCP traffic as fast as possible to
 the server.  Both the client and server will periodically display
 throughput statistics along with any kernel variables the user has se-
 lected to sample (using the -k option).  A list of available kernel vari-
 ables may be obtained using the -l option.

On the Server Side

<pre class="command-line">
tcpbench -s
</pre>

On the Client Side
<pre class="command-line">
tcpbench server-ip
</pre>


### <a name="tcpblast"></a>tcpblast

tcpblast from ports/benchmarks
measure the throughput of a TCP connection
TCPBLAST measures the throughput of a tcp connection via the discard
service of inetd.

Maintainer: The OpenBSD ports mailing-list &lt;ports@openbsd.org>

<pre class="manpage">
usage: tcpblast [-4] [-6] destination nblkocks
blocksize: 1024 bytes 1
</pre>

### <a name="netpipe">netpipe</a>

NetPIPE is a protocol independent performance tool that encapsulates
the best of ttcp and netperf and visually represents the network
performance under a variety of conditions. By taking the end-to-end
application view of a network, NetPIPE clearly shows the overhead
associated with different protocol layers. Netpipe answers such
questions as: how soon will a given data block of size k arrive at its
destination? Which network and protocol will transmit size k blocks
the fastest? What is a given network's effective maximum throughput
and saturation level?  Does there exist a block size k for which the
throughput is maximized? How much communication overhead is due to the
network communication protocol layer(s)? How quickly will a small (&lt; 1
kbyte) control message arrive, and which network and protocol are best
for this purpose?

For a paper fully describing NetPIPE and sample investigation of
network performance issues using NetPIPE, see
<a href="http://www.scl.ameslab.gov/netpipe/paper/full.html">http://www.scl.ameslab.gov/netpipe/paper/full.html</a>.

Typical use for  TCP  involves  running  the  TCP  NetPIPE
receiver on one system with the command

<pre class="command-line">
NPtcp -r
</pre>


and  running the TCP NetPIPE transmitter on another system
with the command

<pre class="command-line">
NPtcp -t -h receiver_hostname -o output_filename -P
</pre>


If any options are used that  modify  the  test  protocol,
including -i, -l, -p, -s, and -u, those parameters must be
used on both the transmitter and the receiver, or the test
will not run properly.

#### TESTING METHODOLOGY

NetPIPE  tests  network performance by sending a number of
messages at each block size, starting from the lower bound
on  message  size.   NetPIPE  increments  the message size
until the upper bound on message size is  reached  or  the
time  to  transmit  a block exceeds one second, which ever
occurs first.

NetPIPE's output file may be graphed with a  program  such
as  gnuplot(1) to view the results of the test.  NetPIPE's
output file contains five columns: time  to  transfer  the
block, bits per second, bits in block, bytes in block, and
variance.  These columns may be graphed to  represent  and
compare  the network's performance.  For example, the net-
work signature graph can be created by graphing time  ver-
sus  bits per second.  Sample gnuplot(1) commands for such
a graph would be

<pre class="config-file">
set logscale x

plot "NetPIPE.out" using 1:2
</pre>

The more traditional throughput versus  block  size  graph
can  be  created by graphing bytes versus bits per second.
Sample gnuplot(1) commands for such a graph would be

<pre class="config-file">
set logscale x

plot "NetPIPE.out" using 4:2
</pre>
