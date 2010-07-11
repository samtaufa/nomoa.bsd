## Traffic Flow

In most cases, firewalls function as a gateway between two end-points.
Network traffic flows through the firewall.

- IN, traffic coming into a firewall interface
- OUT, traffic going out a firewall interface

<div style="text-align: center">
    $!Image("fw/fw_traffic_flow.png", title="Firewall - Traffic Flow")!$
</div>

Our objective pre-deployment, and during investigations, is to validate
that our understanding of a given ruleset behaves as expected.
Implementing a **block by default** ruleset, simplifies the *flow
validation* process: 

**match ruleset design** are:

- passed as expected and 
- blocked otherwise.
 
Corporate Policies are embedded as our "ruleset". Two tools
very useful in generating and monitoring traffic flow are:

-   [netcat](#netcat) (nc)
-   [tcpdump](#tcpdump)

### Test Environment

Tests should be engineered to:

- validate behaviour for positive rule match and 
- validate behaviour for negative rule match negative

The Test environment needs to simulate the actual gateway
function for the firewall. At minimum the environment will
require three hosts representing:

a.  The firewall/gateway
b.  Hosts to one side of the firewall/gateway
c.  Hosts on the *other side* of the firewall/gateway

<div style="text-align: center">
    $!Image("fw/fw_flow_lab.png", title="Firewall - Traffic Flow")!$
</div>

### Writing Tests

Tests are gleaned from the proposed firewall rules, as moving betweeen 
rule symantics into flow semantics.

from ruleset: 
<pre class="config-file">
pass in on $int_if inet proto tcp from &lt;lan> to any
pass out on $ext_if
</pre>

evolves to flow routes

<pre class="screen-output">
&lt;lan> to dmz {tcp}
&lt;lan> to inet {tcp}
</pre>

The firewall/gateways should remain essentially static during the test
and various changes will be needed on the Internal and External hosts
to simulate the appropriate IP Addresses to validate the rulesets

During IP Address and routing changes on the hosts, ensure route states
are cleared (or the hosts restarted) to minimise errors caused by
stagnant routing information.

### <a name="netcat">netcat - generating controlled traffic packets</a>

nc(1) - netcat utility, push and listen to TCP/UDP connections on interfaces

**Generating** and **Recieving** traffic using netcat provides an environment for
controlled traffic flow that can be monitored, validated.

<blockquote>
The nc (or netcat) utility is used for just about anything under the sun
involving TCP or UDP.  It can open TCP connections, send UDP packets,
listen on arbitrary TCP and UDP ports, do port scanning, and deal with
both IPv4 and IPv6.  Unlike telnet(1), nc scripts nicely, and separates
error messages onto standard error instead of sending them to standard
output, as telnet(1) does with some.
</blockquote>

The simplest test of traffic flow is to run netcat on a 'client' to one side of the firewall and a recieving/
listening netcat 'server' on the opposite side of the firewall.

#### TCP packets

We use the _destination-ip_ and the _port-number_ explicitly to allow us to
use aliases on the destination host (simplifies testing)

Server
<pre class="command-line">
nc -4kl destination-ip port-number
</pre>


Client

<pre class="command-line">
nc -4vvvu destination-ip port-number
</pre>


#### UDP packets

There seems to be something perculiar with using -k. When using -k be explicit in the destination ip. When destination-ip is not
explicit, then it may not as work expected with -k.

Server
<pre class="command-line">
nc -4vvvvvklu destination-ip port-number
</pre>

Client
<pre class="command-line">
nc -4vvvvvu destination-ip port-number
</pre>


### <a name="tcpdump">tcpdump - monitoring logged packets</a>

PF can record network packet headers and data when the log key word is used with a rule. 
When a packet matches a rule with the log key word, the headers
and packet body are sent to the pflog pseudo-device. Once a packet is logged to the pflog 
pseudo-device, The tcpdump utility can be used to print the packet's contents in real time:

<pre class="command-line">
sudo tcpdump -netttvvi pflog0
</pre>

<pre class="screen-output">
Dec 03 15:31:17.263703 rule 5/(match) [uid 0, pid 24100] 
  block in on em1: 192.168.18.19.1055 > 192.168.18.255.1100: udp 99 (ttl 128, id 12204, len 127)
</pre>


### Network NICs

A common problem while evaluating host configuration changes, 
is the state of routing tables. Misunderstanding about the 
current state of the routing table can lead to redherrings.
(false redirections.)

Here's a sequence of activities for clearing the various 
related routing 'buffers'.

*   flush the routes
*   delete arp table
*   delete the interface _eth0_ configuration

<pre class="command-line">
sudo route flush -inet
sudo arp -ad
sudo ifconfig eth0 delete
</pre>

Then you can re-enable things again.

* configure the interface
* configure the route

<pre class="command-line">
sudo ifconfig eth0 __.__.__.__  netmask __.__.__.__
sudo route add default __.__.__.__
</pre>


