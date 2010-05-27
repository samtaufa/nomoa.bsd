## Securing Communications.

It's a wild place out on the Internet, and all tools for securing your 
communications, should be this easy and FREE. 

The [OpenBSD FAQ 6 - Networking](http://www.openbsd.org/faq/faq6.html)
is required reading when:

- 1st getting your box connected
- staying connected to anything

The FAQ is a good guide and foundation knowledge that will serve
you well as most services your configure or install will
need Network access.

OpenBSD is at the forefront of standardising secured communications
between hosts. The most public of these forays has been the
<a href="http://www.openssh.org">OpenSSH Project.</a> We reference
some useful notes here, together with notes on other mechanisms
for securing communciations such as:

-   [Encrypted VPN](comms/openvpn.html) using OpenVPN
-   [File Sharing](comms/samba.html), with Samba
-   [OpenSSH Client](comms/ssh.html) notes
-   [Web Caching](comms/www/squid.html), Access Policies with squid
-   [Web Content Filtering](comms/www/dansguardian.html), with dansguardian and squid
-   [SSL Certificates](comms/www/ssl.html), with OpenSSL

We've also had the opportunity to deploy Mail specific configurations, such as Proxy 
Servers and sites using Virtual User Accounts (both using Postfix) :

-   [Proxy Server](mail/postfix/proxy.html)
-   [Virtual User Accounts](mail/postfix/virtual.html)
