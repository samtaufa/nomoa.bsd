## Routing with bgpd

<div class=toc>
Table of Contents:

<ul>
    <li><a href="#upandrunning">Am I up and Running?</a>
        <ul>
            <li><a href="#run_serve"> What am I serving out?</a>
            <li><a href="#run_connectwho"> Who is connected to me (neighbours)?</a>
            <li><a href="#run_tellme"> What are my neighbours telling me?</a>
        </ul>
    <li>Configuration Samples
        <ul>
            <li><a href="#config_primary">Primary</a>
            <li><a href="#config_satellite_1">Satellite #1</a>
            <li><a href="#config_satellite_2">Satellite #2</a>
        </ul>
</ul>

</div>

[ $!manpage("bgpd",8)!$  | $!manpage("bgpctl",8)!$ ]

These notes are a direct RIP from the above notes, and others
aggregated here to help my depleting memory cells.

OpenBSD supports the Border Gateway Protocol through $!manpage('bgpd',8)!$

<pre class="manpage">
BGPD(8)

$!manpage("bgpd")!$ is a Border Gateway Protocol (BGP) daemon which manages the network
routing tables.  Its main purpose is to exchange information concerning
"network reachability" with other BGP systems.  $!manpage("bgpd")!$ uses the Border
Gateway Protocol, Version 4, as described in RFC 1771.  Please refer to
that document for more information about BGP.
</pre>

Monitoring and managing active bgpd sessions is through 
$!manpage("bgpctl",8)!$ 

<pre class="manpage">
BGPCTL(8)

The $!manpage("bgpctl")!$  program controls the $!manpage('bgpd',8)!$ daemon.
</pre>

The sample network we use to discuss BGPD is shown in the below diagram.

$!Image("bgpd_network.png", title="BGPD Network Diagram", klass="imgcenter")!$

<a name="upandrunning"></a>

### Am I up and Running

A simplified verification whether our BGPD server is up and running is to
check the daemon (/usr/sbin/bgpd) is running using the standard 'process status' $!manpage('ps',1)!$
or using $!manpage('bgpctl')!$.

Basic confirmation of the daemon running can be performed using

<pre class="command-line">
ps auxwww | grep bgpd
</pre>

The next step is to get information from the bgpd daemon.

<pre class="command-line">
bgpctl show summary
</pre>

If BGPD is running, then it will display status information such as the connected
BGPD peers (neighbors).

<pre class="screen-output">
Neighbor                   AS    MsgRcvd    MsgSent  OutQ Up/Down  State/PrfRcvd
CLOUD Supplier           6666      19587      19046     0 3d18h16m      4
</pre>

If BGPD is **not running** you may get an error similar to the below:

<pre class="screen-output">
bgpctl: connect: /var/run/bgpd.sock: No such file or directory
</pre>

When your BGP server is failed, and not running. Review it's start up failure 
by foregrounding the server such as:

<pre class="command-line">
/usr/sbin/bgpd -d
</pre>

The screen display give directions for investigation. For example:

<pre class="command-line">
/usr/sbin/bgpd -d
</pre>
<pre class="screen-output">
/etc/bgpd.conf:19: could not parse address "10.0.323.0/24"
route decision engine ready
config file /etc/bgpd.conf has errors, not reloading
fatal in RDE: rde_dispatch_imsg_ession: pipe closed
kernel routing table decoupled
Terminating
</pre>

The above error directing us to review the config file "/etc/bgpd.conf" line 19 
and specifically the 'address "10.0.323.0/24"

<a name="whereami"></a>

#### Where am I

What network interfaces am I seeing?

Confirm that "bgpd" correctly interpolates your active network interfaces.

<pre class="command-line">
bgpctl show interfaces
</pre>
<pre class="screen-output">
Interface      Nexthop state  Flags          Link state
tun0           ok             UP             link state 2
pflog0         ok             UP             unknown
pfsync0        ok             UP             unknown
carp2          ok             UP             CARP, master
carp1          ok             UP             CARP, master
carp0          ok             UP             CARP, master
lo0            ok             UP             unknown
enc0           invalid                       unknown
em2            ok             UP             Ethernet, active, 1000 MBit/s
em1            ok             UP             Ethernet, active, 1000 MBit/s
nfe0           ok             UP             Ethernet, active, 1000 MBit/s
em0            ok             UP             Ethernet, active, 10 MBit/s
</pre>

If you are using ipsec or tcp md5sig then you may need to review:

<pre class="command-line">
ipsecctl -sa
netstat -rnfencap
</pre>


More information about how the bgpd active session, relavant to the question
include:

- What am I serving out?
- Who is connected to me (neighbours)?
- What are my neighbours telling me?

<a name="run_serve"></a>

### What am I serving out?

The following command should reflect the values specified in your
"network" statements in /etc/bgpd.conf

<pre class="command-line">
bgpctl show network
</pre>
<pre class="screen-output">
flags: S = Static
flags destination
*        0 192.168.18.0/24
*        0 192.168.20.0/24
*        0 192.168.21.0/24
*        0 192.168.22.0/24
*        0 192.168.23.0/24
*        0 192.168.60.0/24
</pre>

<a name="run_connectwho"></a>

### Who is connected to me (neighbours)?

The following command should reflect connection information
related to the "neighbor" statements in your /etc/bgpd.conf

<pre class="command-line">
bgpctl show neighbor
</pre>
<pre class="screen-output">
BGP neighbor is 172.20.10.1, remote AS 6666
 Description: CLOUD Supplier
  BGP version 4, remote router-id 172.20.10.1
  BGP state = Established, up for 3d18h17m
  Last read 00:00:10, holdtime 90s, keepalive interval 30s
  Neighbor capabilities:
    Multiprotocol extensions: IPv4 Unicast
    Route Refresh

  Message statistics:
                  Sent       Received
  Opens                    6          6
  Notifications            1          4
  Updates                  2         50
  Keepalives           19039      19530
  Route Refresh            0          0
  Total                19048      19590

  Update statistics:
                  Sent       Received
  Updates                  6         24
  Withdraws                0         20

  Local host:           172.20.10.2, Local port:  12650
  Remote host:          172.20.10.1, Remote port:   179
</pre>

Things to look-out for include;

- **Neighbor IP Address mismatch**, are the src/dst IP addresses on the
	neighbor servers correct (vis-a-vis).
- **AS numbers are correct**, are the src/dst AS numbers on the
	neighbor servers correct (vis-a-vis).
	
<a name="run_tellme"></a>

### What are my neighbours telling me?

<pre class="command-line">
bgpctl show ip bgp
</pre>

The above command gives us the following information:

<ul>
    <li> *> - gives us routing information from external sources
    <li> origin :  where the routing is coming from
    <li> AI*> - what we are pushing out
</ul>

<pre class="screen-output">
bgpctl show ip bgp
flags: * = Valid, > = Selected, I = via IBGP, A = Announced
origin: i = IGP, e = EGP, ? = Incomplete

flags destination         gateway          lpref   med aspath origin
*>    192.168.14.0/24     172.20.10.1        100     0 6666 65002 i
AI*>  192.168.18.0/24     0.0.0.0            100     0 i
AI*>  192.168.20.0/24     0.0.0.0            100     0 i
AI*>  192.168.21.0/24     0.0.0.0            100     0 i
AI*>  192.168.22.0/24     0.0.0.0            100     0 i
AI*>  192.168.23.0/24     0.0.0.0            100     0 i
*>    192.168.24.0/24     172.20.10.1        100     0 6666 65003 i
AI*>  192.168.60.0/24     0.0.0.0            100     0 i
</pre>


## Configuration Samples

Some sample configuration files that reflect the output information shown above (where all sites are linked 
through an intermediary "CLOUD Supplier"

<ul>
    <li><a href="#config_primary">Primary</a>
    <li><a href="#config_satellite_1">Satellite #1</a>
    <li><a href="#config_satellite_2">Satellite #2</a>
</ul>

The scenario is three sites connecting through a 3rd party.

This 3rd party could have been the primary site if desired.

<a name="config_primary"></a>

### Configuration: PRIMARY

<pre class="config-file">
# 
# SITE - PRIMARY
#
AS 65001
router-id 172.20.10.2
network         192.168.18.0/24
network         192.168.20.0/24
network         192.168.21.0/24
network         192.168.22.0/24
network         192.168.23.0/24
network         192.168.60.0/24

neighbor 172.20.10.1 {
        announce        IPv4 unicast
        remote-as       6666
        depend on carp0
        descr           CLOUD Supplier
        local-address   172.20.10.2
}

deny from any
allow from any inet prefixlen 8 - 24
deny from any prefix 0.0.0.0/0

deny from any prefix 10.0.0.0/8 prefixlen >= 8
deny from any prefix 169.254.0.0/16 prefixlen >= 16
deny from any prefix 192.0.2.0/24 prefixlen >= 24
deny from any prefix 224.0.0.0/4 prefixlen >= 4
</pre>

<a name="config_satellite_1"></a>

### Configuration: Satellite Site # 2

<pre class="config-file">
# 
# SITE - Satellite #1
#
AS 65002
router-id 172.20.10.14
network         192.168.14.0/24

neighbor 172.20.10.13 {
        announce        IPv4 unicast
        remote-as       6666
        descr           CLOUD Supplier
        local-address   172.20.10.14
}

deny from any
allow from any inet prefixlen 8 - 24

deny from any prefix 0.0.0.0/0

deny from any prefix 10.0.0.0/8 prefixlen >= 8
deny from any prefix 169.254.0.0/16 prefixlen >= 16
deny from any prefix 192.0.2.0/24 prefixlen >= 24
deny from any prefix 224.0.0.0/4 prefixlen >= 4
deny from any prefix 240.0.0.0/4 prefixlen >= 4
</pre>

<a name="config_satellite_2"></a>

### Configuration: Satellite Site #2

<pre class="config-file">
# 
# SITE - Satellite #1
#
AS 65003
router-id 172.20.10.14
network         192.168.24.0/24
neighbor 172.20.10.9 {
        announce        IPv4 unicast
        remote-as       6666
        descr           CLOUD Supplier
        depend on carp0
        local-address   172.20.10.10
}
deny from any
allow from any inet prefixlen 8 - 24
deny from any prefix 0.0.0.0/0
deny from any prefix 10.0.0.0/8 prefixlen >= 8
deny from any prefix 169.254.0.0/16 prefixlen >= 16
deny from any prefix 192.0.2.0/24 prefixlen >= 24
deny from any prefix 224.0.0.0/4 prefixlen >= 4
deny from any prefix 240.0.0.0/4 prefixlen >= 4
</pre>