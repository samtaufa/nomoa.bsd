## Border and Gateway Systems

OpenBSD is a known quantity for Border Systems (between 
your organisation and the outside world.

To serve as a Border/Gateway host, OpenBSD provides some
nice features, well known is it's high availability
hot failover firewall mechanism based on:

- OpenBSD's <a href="http://www.openbsd.org/faq/pf/">PF Packet Filter</a> Firewall, and

- <a href="http://www.openbsd.org/faq/pf/carp.html">CARP</a>

These notes will not help you build a secure system,
but will hopefully provide some strategy for monitoring
or debugging your configuration.