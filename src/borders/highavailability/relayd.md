## Load Balancing

OpenBSD supports load balancing in two scenarios:

- $!manpage("carp")!$'d hosts

- off-host addresses's
    
In practise we use load-balancing such that we can use
commodity desktop machines to provide high availability for
MX Proxying, DNS Proxying, NTP Proxying    

### Load Balancing on $!manpage("carp")!$ 'd hosts
    
carp was designed with support for load balancing between carp'd hosts
and directly supports:  

-   IP Balancing
-   ARP Balancing
    
In addition to the built-in support, OpenBSD supports load balancing 
of Firewalls (OpenBSD 4.6 onwards) on carp interfaces using

-   $!manpage("pfsync",4)!$ 


### Load Balancing external address's

OpenBSD's base install supports <a href="../monitoring/osi.html">ISO Level 7</a> load balancing using:

-  $!manpage("relayd",8)!$  (http, tcp, other)
    
Standard tools available for Open Source Systems include:

- <a href="http://www.kamailio.org/">kamailio/OpenSER</a> (SIP)

- <a href="http://haproxy.1wt.eu">haproxy</a> (tcp, http)

More advanced, and complex, load balancing services are available 
but are not discussed further here.

#### Load Balancing with $!manpage("relayd",8)!$ 

We focus on OpenBSD's $!manpage("relayd",8)!$ 

The Relay Daemon provides:

-   Layer 7, Application Level, Load Balancing
-   Parent Process
-   HCE: Host Check Engine
-   PFE: Packet Filter Engine
-   Relay Engine

##### Layer 7, Application Level, Load Balancing

This provides:

-   Man-in-the-middle approach
-   allows packet processing
    
##### Parent Process

Using a parent process, with 'root' privileges, is configured
in OpenBSD with a userlevel application for making safe
changes to the relay schedule.

-   Handle configuration loading and reloading
-   Handle external script execution
-   Handle carp demotion requests    
    
##### HCE: Host Check Engine

The Host Check Engine is a methodology to verify that the
target host service is functional, before routing traffic
to the host.

-   Mono-process, fully asynchronous checks
-   Schedule checks and notify PFE of state transitions
    
##### PFE: PF Engine

The Packet Filter Engine allows integration with the OpenBSD
Packet Filter.

-   Create and destroy PF rules
-   Update PF tables based on HCE notifications
    
##### Relay Engine

-   Create listening sockets for services
-   Filter protocols before relaying

## <a name="related">Related Links</a>

- Calomel.org's [Relayd Proxy](
https://calomel.org/relayd.html)
- Me in IT's
[OpenBSD loadbalancing and failover with relayd, pf and carp](
http://meinit.nl/openbsd-loadbalancing-and-failover-relayd-pf-and-carp)