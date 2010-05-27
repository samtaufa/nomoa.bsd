##  High Availability Servers

High Availability Servers are generally defined within the
business context, and may include scenarios for 'high
availability' such as:

- Warm failover
- Load Balancing
- Hot failover

Although 'design papers' prefer that 'server grade' equipment
be used on all 'server systems' we generally do not have that
flexibility, and $!OpenBSD!$ high avalability technologies are 
'service grade' agnostic and designed to take effective use of
disparate systems (i.e. the High Availability tools 
are designed to allow lower-end equipment to augment, supplement 
services by higher end/priced equipment, or completely replace
them.)

### Warm Failover

This is the simplest solution to install, though potentially most
difficult to maintain or verify. In the warm failover system we
build System-B as a copy of the live System-A and deploy these
systems.

<img src='@!urlTo("media/images/ha_warm.png")!@' title="Warm Fail Over">

Advantage: Simplest to roll-out

Disadvantage: Requires manual intervention in failover scenario.

Two methods exist for switching from a failed Server-A to warm Server-B.

#### a. Physical Access - Disconnect / Connect Cabling
Service recovery will be to unplug the failed system Server-A and plug 
in the warm functioning system Server-B. Due to contention on the network 
for IP addresses, both Server-A and Server-B the systems cannot be 'live' 
by using only a duplicate of the existing system. 

- Advantage: Simplest System to roll out, minimal technical requirements.
- Disadvantage: physical access required to equipment, inability to maintain duplicate system.

#### b. Remote Access - Disconnect / Connect Network Connection

To allow both Server-A and Server-B to be both physically connected, at least the IP addresses on the servers need to be different and 'switching' Server-B into "live" mode will require a system administrator to log onto and disable relevant IP configurations on Server-A and enable correct configuration on Server-B

- Advantage: systems are warm, only remote access required
- Disadvantage: slightly more complicated than earlier option to implement, if Server-A has failed, then physical access will be required to ensure it is disconnected

A variant of option (b) would be to retain the IP addresses but use the border firewalls to route to what is selected as the 'live' system.

Examples for these options would be to roll-out commodity boxes, 
with current software as failover for aging systems.

### Load Balancing

$!OpenBSD!$ base OS support's load-balancing traffic in and out, 
such that it can 'share' traffic amongst servers. Additional
load-balancing tools are available through the Ports Package
Collection.

<img src='@!urlTo("media/images/ha_loadbalance.png")!@'>

Traffic 'sharing' is transparent to the destination servers,
and the interdepence of those servers determine
the complexity required for deployment. Services with no
interdepence between multiple servers (such as static web
sites, download servers, MX Proxies) can be readily scaled
through adding more boxes to the service pool.

Advantage: Increases the capacity of your service linearly depending on 
number of additional servers added to the 'pool.'

Likewise, hosts can be removed or maintained while service is 
provisioned via other servers in the 'load pool.'

### Hot Failover

The Hot Failover of hosts is supported by OpenBSD for [Firewalls 
using CARP.](highavailability/carp.html)

Servers in the 'hot failover pool' use a sharing system for their public IPs. 
One host is selected as the 'master' host services all requests, while the 
rest of the machines are 'live' standby. Any failure on the 'master' host 
to service IP traffic is immediately noticed by other servers and another 
server 'takes over' further IP traffic.