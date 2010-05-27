[ref: <a href="http://openbsd.oganer.net/papers/linuxtag06-network.pdf">Routing with OpenBSD using OpenOSPFD and OpenBGPD</a> ]

The Internet is split into regions called Autonomous Systems (AS). Each AS is under the control of a single administrative entity
(e.g. ISP, University et. al.) The edge routers of these AS use an Exterior Gateway Protocol (EGP) to announce/exchange
routing information between AS. _BGP4, the current Border Gateway Protocol is the only EGP in widespread use._
Routers within an AS use an Interior Gateway Protocol to exchange local routing information. There are
different IGPs. OSPF, IS-IS, and RIP are the most commonly used. It is possible, and not uncommon
to have multiple IGPs running inside one AS.

### Border Gateway Protocol (BGP)

The Border Gateway Protocol (BGP) is a path distance vector protocol. BGP is used to exchange
routing information between AS. It is probably the most import core infrastructure protocol
of the Internet. BGP routers use persistent TCP connections to connect to the direct neighbors.
Updates are only exchanged with these direct neighbors and these neighbors decide for them
self if this update needs to be sent to further routers. 

BGP has sophisticated filtering capabilities to control the traffic flow, only one route out of
a number available can be active.

### What Does a Router Do?

A router forwards packets between networks, one hop closer to its intended destination. The destination may be either a host on a directly connected network (i.e. the router can perform direct delivery) or it may need to forward the IP datagram on to another router (i.e. the next hop in the delivery process). 

### Routing Information Base
Each router has its own Routing Table or Routing Information Base (RIB), which lists all of the networks that are known to this router. Each entry (or route) within the routing table specifies a network address, a netmask and the IP address of the next hop. The interface(s) that the IP datagrams could be delivered through are also identified. A measure of desirability or a routing metric is also associated with each route. 

Routes are installed into the routing table from various sources - they may be manually (statically) configured, or they may be learned via the use of a dynamic routing protocol (more on this in a later lecture!) Routes corresponding to directly connected networks are normally automatically configured when an IP address (and corresponding netmask) is assigned to a network interface. 

#### Forwarding Information Base
It is possible (in fact it is quite common) for a router to know about multiple routes to the same destination network. As a result most routers create a Forwarding Information Base (FIB) which contains the preferred or selected route(s) for each known network. This is effectively a subset of the information stored within the routing table. Routing decisions are made based on the information stored within a router's FIB, reducing the overhead associated with making a routing decision. 

Normally the route installed in the FIB is based on the path that has the "best metric" and is currently available, although it is also possible to have a router balance the load across a number of paths. 

Whilst the routing decision is simple (it has to be because it has to be made for every packet), the development of the routing table and FIB can be quite complicated. In later lectures, we are going to examine a number of the routing protocols that are used to construct these tables. 

#### Routing vs. Switching (or Bridging)

In principle, routing and switching both perform the same sort of task. 

Switches base the forwarding decision on the destination header in the link level header (in the outer layer of encapsulation). Routers base the forwarding decision on the destination header in the network level header (in the next layer of encapsulation). This effectively unlinks the addressing and delivery from the physical network. 
 
Reasons for this "two layer" addressing scheme include: 

- Link level addresses were never allocated in geographical groups, so routing tables would be huge (no summarisation possible) and
- It would be difficult to control where broadcasts reached.
   
If link level addresses had been allocated in "networks" as IP addresses had been, it may have been possible to avoid one level of encapsulation. 
