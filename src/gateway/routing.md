## Routing and OpenBSD

<div class="toc">

Table of Contents

<ul>
	<li>What does a Router Do</li>
	<li>Autonomous Systems (AS)</li>
	<li>Border Gateway Protocol</li>
	<li>Routing Information Base</li>
</ul>

</div>

Gateway devices route traffic between networks. OpenBSD's GENERIC/default
kernel supports IP Forwarding (routing) but requires explicitly being enabled.  
There are a number of notes from the project, and you can start
exploring the topic with the [FAQ Networking](http://www.openbsd.org/faq/faq6.html)
and in this context, the section [Setting up your OpenBSD box as a gateway](
http://www.openbsd.org/faq/faq6.html#Setup.forward)

Much of this document is a rehash (if not outright copying from) 
[Routing with OpenBSD using OpenOSPFD and OpenBGPD](
http://openbsd.oganer.net/papers/linuxtag06-network.pdf)
which is quite [succinct]("" "Clear, precise expression in few words") 
and there are plenty of Internet accessible documents to
help you with 'routing' such as the WikiPedia articles 
intersperesed here.

### What Does a Router Do?

A router forwards packets between networks, one hop closer to its intended destination. The destination may be either a host on a directly connected network (i.e. the router can perform direct delivery) or it may need to forward the IP datagram on to another router (i.e. the next hop in the delivery process). 

[Wikipedia Reference](http://en.wikipedia.org/wiki/Router)

<blockquote>
When each router receives a packet, it searches its routing table to find the best match between the destination IP address of the packet and one of the network addresses in the routing table. Once a match is found, the packet is encapsulated in the Layer 2 data link frame for that outgoing interface. A router does not look into the actual data contents that the packet carries, but only at the layer 3 addresses to make a forwarding decision, plus optionally other information in the header for hint on, for example, QoS. 
</blockquote>

#### Routing vs. Switching (or Bridging)

In principle, routing and switching both perform the same sort of task 
(forwarding traffic between two physically separated networks.) 

[Switches](http://en.wikipedia.org/wiki/Network_Switch) base the forwarding decision on the destination header in the [Link Level](http://en.wikipedia.org/wiki/Link_Layer) header (in the outer layer of encapsulation). Routers base the forwarding decision on the destination header in the network level header (in the next layer of encapsulation). 

### Autonomous Systems (AS)

As routing became more and more complicated for the backbone of the
Internet, the solution that evolved was to designate network segments
as "autonomous" with a structured way of sharing independent 
network information. An **Autonomous System (AS)** administers
a network(s) of routable IP Addresses, with clearly defined
routing policy to other AS (the Internet.)

### Border Gateway Protocol (BGP)

BGP is the clearly defined(?) policy between AS for sharing routing
information.

BGP routers use persistent TCP connections to connect to the direct neighbors.
Updates are only exchanged with these direct neighbors and these neighbors decide for them
self if this update needs to be sent to further routers. 

BGP has sophisticated filtering capabilities to control the traffic flow, only one route out of
a number available can be active.

### Routing Information Base

&#91;Ref: [Wikipedia](http://en.wikipedia.org/wiki/Routing_Information_Base)

<blockquote>
A routing table, or Routing Information Base (RIB), is a data structure in the form of a table-like object stored in a router or a networked computer that lists the routes to particular network destinations, and in some cases, metrics associated with those routes. The routing table contains information about the topology of the network immediately around it. The construction of routing tables is the primary goal of routing protocols. 
</blockquote>

Routes are installed into the routing table from various sources - they may be manually (statically) configured, or they may be learned via the use of a dynamic routing protocol (more on this in a later lecture!) Routes corresponding to directly connected networks are normally automatically configured when an IP address (and corresponding netmask) is assigned to a network interface. 

#### Forwarding Information Base

It is possible (in fact it is quite common) for a router to know about multiple routes to the same destination network. As a result most routers create a Forwarding Information Base (FIB) which contains the preferred or selected route(s) for each known network. This is effectively a subset of the information stored within the routing table. Routing decisions are made based on the information stored within a router's FIB, reducing the overhead associated with making a routing decision. 

Normally the route installed in the FIB is based on the path that has the "best metric" and is currently available, although it is also possible to have a router balance the load across a number of paths. 