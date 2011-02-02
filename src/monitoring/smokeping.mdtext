## Smokeping

The standard installation of Smokeping provides two categories of charts

- Charts (Loss, by Max, by Median, Std Deviation)
- Hosts

We use smokeping to monitor network latency for 5 disparate sites, using
3 types of network connections (2 x Leased VPN lines, 1 x Internet link)

We do not touch the "Charts" section but use a separate menu (category) for
various 'connectivity' points.

- Link Category
- Security Zones
- Geographical Region

### Link Category

Latency on our WAN links effect performance of our Line of Business Applications.

To capture a broad view of the network performance, we use a general menu to capture
the performance of each link, to quickly view bandwidth utilisation on the link
as opposed to the branch of the link.

For example, if Leased Line #1 has low latency but within that link end-point #4
is showing performance problems, we can isolate diagnostics to the environment 
unique to end-point #4.

Menu item for each Link Category and sub-items there for each end-point in the link.

For example: Menu item for Leased Line #1 and a sub-item for each end-point on that
leased line.

<pre class="manpage">
- Charts
  VPN Link #1
  - end-point #1
  - end-point #2
  - end-point #3
- VPN Link #2
</pre>

### Security Zones

We operate three security zones in our network, Internal, DMZ, PSN, performance of some 
of the servers on the DMZ is related to data feed in and out of those servers.
By monitoring responsiveness of hosts using smokeping we can note overutilisation
of these hosts.

<pre class="manpage">
- Site Inet
  Site DMZ
  - MX Proxy 
  - DNS Cache Proxy
- Site PSN
- Site Servers
</pre>

### Geographical Region

For remote sites, it is good to have a Menu specific to that site which captures data
for the separate Links, as well as any particular hosts on that site that we
explicitly monitor.

This gives a quick overview of performance to the site, and may replicate data already
present in earlier Menus.

<pre class="manpage">
- Remote Site
  - VPN Link #1
  - VPN Link #2
  - Endpoint 
  - File Server
  - Print Server
</pre>