## Load Balancing

$!OpenBSD!$ base OS support's load-balancing traffic in and out, 
using CARP and pfsync in an active-active firewall, such that it can 
'share' traffic processing amongst servers. Likewise, the base $!manpage("relayd")!$
allows $!OpenBSD!$ to load-balance traffic coming into an $!OpenBSD!$  $!manpage("relayd")!$
gateway to distribute the traffic amongst off-host servers.

$!Image("ha_relayd.png", title="High Availability - Load Balancing", klass="imgcenter")!$

Traffic 'sharing' is transparent to the source and destination. The
the interdepence of those servers determine the complexity required 
for deployment. For example, services with no interdepence between 
multiple servers (such as static web sites, download servers, MX Proxies) 
can be readily scaled through adding more boxes to the service pool.
    
In practise we use $!manpage("relayd")!$ load-balancing such that we can use
commodity desktop machines to provide high availability for:

-   [MX / Mail Server](../../comms/www.html)
-   DNS Server
-   NTP Server

### Load Balancing on $!manpage("carp")!$ 'd hosts
    
carp was designed with support for load balancing between carp'd hosts
and directly supports:  

-   IP Balancing
-   ARP Balancing
    
In addition to the built-in support, OpenBSD supports load balancing 
of Firewalls (OpenBSD 4.6 onwards) on carp interfaces using

-   $!manpage("pfsync",4)!$ 


### Load Balancing off-host address's

In this context, we are referring to a Man in the Middle host, load
balancing services provisioned on other hosts.

$!Image("ha_relayd.png", title="High Availability - Load Balancing", klass="imgcenter")!$

OpenBSD's base install supports ISO Level 7 load balancing using 
$!manpage("relayd",8)!$  (http, tcp, other)
    
Open Source tools for load balancing include:

-   [kamailio/OpenSER](http://www.kamailio.org/ 
    "Session Initiation Protocol - used in Voice Over IP") - SIP
-   [haproxy](http://haproxy.1wt.eu) - tcp, http
-   [nginx](http://nginx.org/ title "Engine X") - http, https, pop3, imap, smtp

The Relay Daemon provides:

-   Layer 7, Application Level, Load Balancing
-   Parent Process
-   HCE: Host Check Engine
-   PFE: Packet Filter Engine
-   Relay Engine

#### Layer 7, Application Level, Load Balancing

This provides:

-   Man-in-the-middle approach
-   allows packet processing
    
#### Parent Process

Using a parent process, with 'root' privileges, is configured
in OpenBSD with a userlevel application for making safe
changes to the relay schedule.

-   Handle configuration loading and reloading
-   Handle external script execution
-   Handle carp demotion requests    
    
#### HCE: Host Check Engine

The Host Check Engine is a methodology to verify that the
target host service is functional, before routing traffic
to the host.

-   Mono-process, fully asynchronous checks
-   Schedule checks and notify PFE of state transitions
    
#### PFE: PF Engine

The Packet Filter Engine allows integration with the OpenBSD
Packet Filter.

-   Create and destroy PF rules
-   Update PF tables based on HCE notifications
    
#### Relay Engine

-   Create listening sockets for services
-   Filter protocols before relaying

### <a name="related">Related Links</a>

- Calomel.org's [Relayd Proxy](https://calomel.org/relayd.html)
- Me in IT's
[OpenBSD loadbalancing and failover with relayd, pf and carp](
http://meinit.nl/openbsd-loadbalancing-and-failover-relayd-pf-and-carp)