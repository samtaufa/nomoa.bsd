## Traffic Flow

Traffic flow with relation to processing requirements are in two categories:

- IN, traffic coming into a firewall interface

- OUT, traffic going out a firewall interface

Implementing a __block by default__ ruleset, simplifies the _flow
validation_ process: match ruleset design are:

- passed as expected and 

- blocked otherwise.

<div style="text-align: center">
  <img src='@!urlTo("media/images/fw/fw_traffic_flow.png")!@'  title="Firewall Traffic Flow" />
</div>  

General monitoring of a firewall we are mostly interested in monitoring the traffic moving into and out of the firewall, 
and the most common tools are:

- <a href="#netcat">netcat (nc)</a>

- <a href="#tcpdump">tcpdump</a>

### Network NICs

A common problem while evaluating host configuration changes, 
is the state of routing tables. Misunderstanding about the 
current state of the routing table can lead to redherrings.

Here's a sequence of activities for clearing the various 
related routing 'buffers'.

* flush the routes
* delete arp table
* delete the interface _eth0_ configuration

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

### <a name="netcat">netcat - generating controlled traffic packets</a>

nc(1) - netcat utility, push and listen to TCP/UDP connections on interfaces

__Generating__ and __Recieving__ traffic using netcat provides an environment for
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


### Testing Laboratory

Tests should be engineered to:

- validate behaviour for positive rule match and 
- validate behaviour for negative rule match negative

The Testing laboratory reflects the testing environment for the rules and at minimum requires three physical hosts representing the above diagram
(client, firewall, server.) As flow is only ever between a sender and reciever, the above configuration can cater for firewall systems
gatewaying multiple networks.

<pre class="diagram">
[ client ]      [ <span style="color: red">firewall</span>  ]      [ <span style="color:blue">server</span> ]
|        | <--> | <span style="color: red">        </span>  | <--> | <span style="color:blue">      </span> |
[ host_1 ]      [ <span style="color: red">host 2  </span>  ]      [ <span style="color:blue">host 3</span> ]

</pre>


### Writing Tests

Tests are gleaned from the firewall rules, as moving betweeen rule symantics into flow semantics.

from ruleset: 
<pre class="config-file">
    pass in on $int_if inet proto tcp from < lan > to any tag LAN_INET
</pre>

evolves to flow routes

<pre class="command-line">
    &lt;lan > to dmz {tcp}
    &lt;lan > to inet {tcp}
</pre>

Preparation involves configuring test hosts, servers, and systematically drilling
down the configuration primitives.
