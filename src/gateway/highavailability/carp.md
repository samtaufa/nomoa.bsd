## Hot Failover with CARP

<div class=toc>

Table of Contents

<ul>
	<li>Sample Configuration
		<ul>
			<li></li>
		</ul></li>
	<li>Configuring CARP
		<ul>
			<li>External NICs</li>
			<li>Internal NICs</li>
			<li>PFSync NICs</li>
			<li>CARP Pseudo Interface</li>
		</ul></li>	
	<li>PF State Synchronisation
		<ul>
			<li>Create the Interface</li>
			<li>Configure It</li>
		</ul></li>
	<li>Configuring PF</li>
	<li>Failing Over
		<ul>
			<li>Forced Physical Failure</li>
			<li>Increase ADVSKEW</li>
			<li>Increase demote count</li>
		</ul></li>
	<li>Related Links</li>
</ul>

</div>

OpenBSD supports a Hot Failover scenario using $!manpage("carp",8)!$ 
(Common Access Redundancy Protocol.) The CARP Protocol
provides a pseudo-device to share a single IP between
multiple hosts. 

$!Image("fw/carp_basic.png", title="Basic CARP Diagram", klass="imgcenter")!$

<blockquote>
<p>
Essentially, CARP provides the ability for one host to assume the network
identity of an other, and a mechanism to decide when that's necessary.
</p>

-- Ryan McBride (dev lead)
</blockquote>

Applications (or services) that can share their state data between 
separate hosts can now use multiple hosts to service clients over
a single IP address. 

Data synchronisation is not part of the CARP protocol. Synchronisation
can occur over the same 'wire' as the CARP protocol, and in our
practise we use a dedicated cross-over cable for configurations
requiring two hosts. A dedicated switch can also be used for
services requiring 3+ hosts. 

The OpenBSD base installation provides a state, data synchronisation 
toolset for:

-   PF Packet Filter using $!manpage("pfsync",4)!$  
    for firewall  state synchronisation.
-   IPSec using $!manpage("sasyncd",8)!$  
    for IPsec SA, SPD  synhronization

For more detailed discussions of Redundant Firewalls, and configurations
using CARP, refer to [Ryan McBride](http://kerneltrap.org/node/2873)'s 
[Firewall Failover with pfsync and CARP](http://www.countersiege.com/doc/pfsync-carp/) 
the [Related Links](#related) below and the [$!manpage("man")!$(ual)] pages.

In practise? We use $!manpage("carp")!$ on our firewalls to provide 
high-availability and:

1.  Augment high-end servers with commodity desktops
2.  Replace expensive equipment (closed/hugely expensive solutions) with
    (affordable) commodity desktops

Always refer to the [$!manpage("man")!$(ual)] pages.

###  Sample Configuration

The following is a basic configuration sample for creating a redundant 
firewall pair using CARP and pfsync.

<table>
  <tr><th>Nominal</th><th>Purpose</th>
  </tr>
  <tr>
    <td>ethX</td>
    <td>used in place of actual interface reference, such as em0.</td>
  </tr>
  <tr>
    <td>IP: 10.0.0.1</td>
    <td>Public facing firewall IP. Use carp0 on shared interface.</td>
  </tr>
  <tr>
    <td>IP: 192.168.100.1</td>
    <td>Private facing firewall IP. Use carp1 on shared interface.</td>
  </tr>
  <tr>
    <td>Hosts</td>
    <td>
    <p>Gateway A @ 172.16.1.1</p>
    <p>Gateway B @ 172.16.1.2</p>
    </td>
  </tr>
</table>

$!Image("fw/carp_basic_ips.png", title="Basic CARP Diagram - IP Addresses included", klass="imgcenter")!$
  

There are two parts to configuring hot failover:

*   Configuring CARP
    - Physical Network Interface
    - CARP Pseudo Interface
    - CARP State Synchronisation
*   Configuring PF Firewall

Configuring CARP involves configuring the interfaces on either end 
of the gateway/firewall (eth0 with carp0, and eth1 with carp1.) The 3rd 
interface to configure (eth2 with pfsync0) is used for synchronising PF 
firewall status information.

$!Image("fw/carp_basic_ips.png", title="Basic CARP Diagram - IP Addresses included", klass="imgcenter")!$

### Configuring CARP

Since two of the NICs on our server will be sharing the IP address 
through CARP, we need to have the physical NICs initiated, but not 
necessarily configured. CARP will work without assigning an IP address 
to carp'd NICS.

#### Physical Network Interface

##### 'External' NICs

Shared CARP IP: vhid 1: 10.0.0.1

It is usually sufficient to have an "up" command in the hostname.interface
configuration, but where possible: assigning an IP address to the firewall
will allow direct connection to the 'backup' firewall without needing
to jump through the 'master' firewall.

$!Image("fw/carp_basic_external.png", title="Basic CARP Diagram - External Link", klass="imgcenter")!$

Gateway A:/etc/hostname.eth0
  
<pre class="config-file">
inet 10.0.0.11 255.255.255.0 10.0.0.255
</pre>

Gateway B:/etc/hostname.eth0
  
<pre class="config-file">
inet 10.0.0.12 255.255.255.0 10.0.0.255
</pre>        

Other important items that may be relevant within the Interface 
configuration are whether you need to specify metrics or
media options.

##### Internal NICs

Shared CARP IP through vhid 2: 192.168.100.1

$!Image("fw/carp_basic_internal.png", title="Basic CARP Diagram - Internal Link", klass="imgcenter")!$

Gateway A:/etc/hostname.eth1
  
<pre class="config-file">
inet 192.168.100.11 255.255.255.0 192.168.100.255
</pre>

Gateway B:/etc/hostname.eth1
  
<pre class="config-file">
inet 192.168.100.12 255.255.255.0 192.168.100.255
</pre>

##### Synchronisation NICs

The third NIC will be used by pfsync0 and the IP address is directly set.

$!Image("fw/carp_pfsync.png", title="Basic CARP Diagram - PF Sync Interface", klass="imgcenter")!$


Gateway A:/etc/hostname.eth2
  
<pre class="config-file">
inet 172.16.1.1 255.255.255.0 172.16.1.255
</pre>

Gateway B:/etc/hostname.eth2
  
<pre class="config-file">
inet 172.16.1.2 255.255.255.0 172.16.1.255
</pre>

#### CARP Pseudo Interface

To set $!manpage("carp",8)!$ up, we 

-   enable receipt of CARP packets, 
-   create the interface, and 
-   configure it.

<table>
  <tr><th>Nominal</th><th>Purpose</th></tr>
  <tr>
    <td>vhid</td>
    <td>_Virtual Host ID_ is a unique number used to identify the group to other nodes on the network (1 ~ 255)</td>
  </tr>
  <tr>
    <td>pass</td>
    <td>The password is unique for each group</td>
  </tr>
  <tr>
    <td>carpdev</td>
    <td>Optional paremeter specifying the network interface that belongs to the above group?</td>
  </tr>
  <tr>
    <td>advbase</td>
    <td>Optional parameter specifying how often , in seconds, to advertise that we're a member of the group</td>
  </tr>
  <tr>
    <td>advskew</td>
    <td>Lowest number becomes the master. Failover (with net.inet.carp.preempt=1) forces value to 240</td>
  </tr>
  <tr>
    <td>IP Address</td>
    <td>The  unique shared ip address for the group.</td>
  </tr>
  <tr>
    <td>balancing _mode_ </td>
    <td>optional load balancing modes: [ arp | ip | ip-stealth | ip-unicast ]</td>
  </tr>
  <tr>
    <td colspan="2" align="center">ifconfig(8), carp(4), FAQ - Firewall Redundancy with CARP and pfsync.</td>
  </tr>
</table>

##### enable CARP packets

<pre class="command-line">
sudo sysctl -w net.inet.carp.allow=1
sudo sysctl -w net.inet.carp.preempt=1
sudo sysctl -w net.inet.carp.log=1
</pre>

To make sure this is set between system restarts.

File: /etc/sysctl.conf

<pre class="config-file">
net.inet.carp.allow=1
net.inet.carp.preempt=1
net.inet.carp.log=1
</pre>


<table>
  <tr><th>Nominal</th><th>Purpose</th></tr>
  <tr>
    <td>net.inet.carp.allow</td>
    <td>accept incoming CARP packets or not. Default is yes, and not in /etc/sysctl.conf</td>
  </tr>
  <tr>
    <td>net.inet.carp.preempt</td>
    <td>Allow hosts within group to preempt the master. Sets failover of all CARP interfaces on the failure of one interface. Disabled by default.</td>
  </tr>
  <tr>
    <td>net.inet.carp.log</td>
    <td>Log bad CARP packets.</td>
  </tr>
  <tr>
    <td>net.inet.carp.arpbalance</td>
    <td>Load balance traffic across group hosts. Default is disabled.</td>
  </tr>
</table>

Remember, we've allowed the carp packets into the system, but when we turn
on PF, we normally block everything by default and need to explicitly allow
carp packets in.

##### create the interface

<pre class="command-line">
sudo ifconfig carp0 create
</pre>

To make the change permanent, create an /etc/hostname.carp0 file with the
appropriate details.

##### configure it.

A simple configuration is such as the below from the command-line

<pre class="command-line">
sudo ifconfig 
carp0 vhid 1 pass secretpassword carpdev eth0 advskew 100 10.0.0.1
</pre>


To make sure this is set between system restarts.

File: /etc/hostname.carp0

<pre class="config-file">
inet 10.0.0.1 255.255.255.0 vhid1 pass secretpassword carpdev eth0 advskew 100
</pre>

$!Image("fw/carp_basic_external.png", title="Basic CARP Diagram - External Link", klass="imgcenter")!$


Gateway A:/etc/hostname.carp0 (text should be a single line)
  
<pre class="config-file">
inet 10.0.0.1 255.255.255.0 10.0.0.255 vhid 1 
    pass secretpassword carpdev eth0 advskew 50 state 
    MASTER description "OUTSIDE"
</pre>

Gateway B:/etc/hostname.carp0 (text should be a single line)
  
<pre class="config-file">
inet 10.0.0.1 255.255.255.0 10.0.0.255 vhid 1 
    pass secretpassword carpdev bge0 advskew 100 state 
    BACKUP description "OUTSIDE
</pre>

$!Image("fw/carp_basic_internal.png", title="Basic CARP Diagram - Internal Link", klass="imgcenter")!$

Gateway A:/etc/hostname.carp1 (text should be a single line)
  
<pre class="config-file">
inet 192.168.100.1 255.255.255.0 192.168.100.255 vhid 2 
    pass anothersecretpassword carpdev eth1 advskew 50 state 
    MASTER description "INSIDE"
</pre>


Gateway B:/etc/hostname.carp1 (text should be a single line)

<pre class="config-file">
inet 192.168.100.1 255.255.255.0 192.168.100.255 vhid 2 
    pass anothersecretpassword carpdev eth1 advskew 100 state 
    BACKUP description "INSIDE"
</pre>


#### CARP State Synchronisation

The physical interface is managed, as per above, the pseudo synchronisation
interface requires.

-   create the interface, and 
-   configure it.

$!Image("fw/carp_pfsync.png", title="Basic CARP Diagram - PF Sync Interface", klass="imgcenter")!$

#### create the interface

Create the interface using ifconfig 'create'.

<pre class="command-line">
sudo ifconfig pfsync0 create
</pre>

#### configure it

Configure the pfsync interface as your normally do with other
network interfaces (in /etc/hostname.pfsync0) with additional
commands relevant to pf synchronisation.

<pre class="command-line">
sudo ifconfig pfsync0 syncdev eth2
</pre>

<table>
  <tr><th>Nominal</th><th>Purpose</th></tr>
  <tr>
    <td>pfsyncN</td>
    <td>The name of the pfsync(4) interface used to send pfsync updates out</td>
  </tr>
  <tr>
    <td>syncdev</td>
    <td>The name of hte physical interface used to send pfsync updates out.</td>
  </tr>
  <tr>
    <td>syncpeer</td>
    <td>Optional IP address of a host to exchange pfsync updates with. By default, pfsync updates multicast on the local network. This option changes that behaviour to unicast the update to the specified syncpeer.</td>
  </tr>
</table>

To make sure this is set between system restarts.

Gateway A:/etc/hostname.pfsync0

<pre class="config-file">
up syncdev eth2 syncpeer 172.16.1.2
</pre>


Gateway B:/etc/hostname.pfsync0

<pre class="config-file">
up syncdev eth2 syncpeer 172.16.1.1
</pre>

The use of syncpeer is relevant in a two host CARP configuration,
and especially when the synchronisation wire is shared with
other devices (i.e. insecure.)

### Configuring PF Firewall

We need to ensure that the $!manpage("pfsync")!$ and 
$!manpage("carp")!$ protocols are allowed in and out
on the relevant interface.

<pre class="config-file">
pass on { eth0 eth1 } proto carp keep state (no-sync)
pass quick on eth2 proto pfsync keep state (no-sync)
</pre>

### Failing Over

The $!manpage('carp')!$ system monitors at least three mechanisms
to determine whether the CARP interface should be in the MASTER
or BACKUP state.

Exploring these, is a good way of gaining better understanding
of how and why your hosts will fail between each other.

-	Forced Physical Failure
-	Advertising SKEW
-	DEMOTE Counter

#### Forced Physical Failure

&#91;Ref: $!manpage('carp')!$, $!manpage('ifconfig')!$]

Disabling a CARP Interface can be achieved through physically
disconnecting the interface, or by using the $!manpage('ifconfig')!$
utility to disable the interface.

`ifconfig carp0 down`

#### Increase ADVSKEW

&#91;Ref: $!manpage('carp')!$, $!manpage('ifconfig')!$]

Another method for failing an carp interface, is to change the
frequency of carp advertisements (the most frequent gaining
MASTER status.) Increasing the time between carp advertisements
allows another CARP host to take over MASTER status.

Use something like:

<pre class="command-line">
ifconfig carp0 advskew 254
</pre>

Obviously, if you want to return the node back to MASTER, then
you can reset the advertising skew *advskew* to a number lower
than the *advskew* on the other server.

Advantage: Interface is still functional.

#### Increase demote count

&#91;Ref: From $!manpage('ifconfig')!$]

<pre class="manpage">
ifconfig -g group-name [[-]carpdemote [number]]

-g group-name
		Specify the group.
		
carpdemote [number]
		Increase $!manpage('carp',4)!$ demote count for given interface group by
		number. If number is omitted, it is increased by 1.

-carpdemote [number]
		Decrease $!manpage('carp',4)!$ demote count for given interface group by
		number. If number is omitted, it is decreased by 1.
</pre>

Demote works on carp groups, so to sample our carp0 interface we need it in 
a group, with something like the below:

<pre class="command-line">
ifconfig carp0 group test
</pre>

From which we can now confirm the carp demote count using

<pre class="command-line">
ifconfig -g test
</pre>
<pre class="screen-output">
test: carp demote count 0
</pre>

We can increase the demote count, using the above sample as in:

<pre class="command-line">
ifconfig -g test carpdemote 50
ifconfig -g test
</pre>
<pre class="screen-output">
test: carp demote count 50
</pre>

Advantage: Interface is still functional.

## <a name="related">Related Links</a>

There are various links, some listed below, with more indepth discussion
of the CARP protocol, and underpinnings.

-	[PF: Firewall Redundancy with CARP and pfsync](http://www.openbsd.org/faq/pf/carp.html)
-   Calomel.org's [CARP Firewall Failover for OpenBSD](
    https://calomel.org/pf_carp.html)
-   Ryan McBride @ Countersiege [Firewall Failover with pfsync and CARP](
    http://www.countersiege.com/doc/pfsync-carp/)
-   Daniel Mazzocchio's [Redundant Firewalls with OpenBSD,
    CARP and pfsync](http://www.kernel-panic.it/openbsd/carp/index.html)
-   Me in IT's
    [OpenBSD loadbalancing and failover with relayd, pf and carp](
    http://meinit.nl/openbsd-loadbalancing-and-failover-relayd-pf-and-carp)
-   packetmischief's [OpenBSD CARP](http://www.packetmischief.ca/openbsd/doc/carp.html)
