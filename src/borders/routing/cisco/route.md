Setting and changing routes is a common enough requirement on a network.

Cisco Commands useful for managing routes include:

  - show ip route
  - no ip route IP NETMASK GATEWAY
  - ip route IP NETMASK GATEWAY
  
All commands are functional only inside the 'terminal' configuration prompt "...(config)#"

### show ip route

Let's you see the routing configuration. Related commands include:

For example:
<pre class="command-line">
#show ip route
</pre>

<pre class="screen-output">Default gateway is not set
Host Gateway Last Use Total Uses Interface
ICMP redirect cache is empty
</pre>

For example:
<pre class="command-line">
#show running-config | i routing
</pre>
<pre class="screen-output">no ip routing</pre>

For example:
<pre class="command-line">
#config t
(config)#router ospf 5
</pre>

<pre class="screen-output">IP routing not enabled</pre>


### no ip route IP NETMASK GATEWAY

Removes the routing for IP NETMASK GATEWAY. 

When the no command is used *before* any other configuration-mode command - 
it's the way that you tell a Cisco Switch to unset a setting. 

For example, <i>no ip route x.y.z.q netmask destination</i>. <i>no router bgp ASN</i> would be fairly disastrous, though -
it would take out the "router bgp" clause and all of the neighbor and other statements underneath it. 

To delete a neighbor and re-enter it, use router bgp ASN and then no neighbor x.y.z.q. 

For example:
<pre class="command-line">
(config)# no ip route 192.168.25.0 255.255.255.0 192.168.18.100
</pre>

### ip route IP NETMASK GATEWAY

ip route x.y.z.q NETMASK GATEWAY [metric]

The "ip route" command installs a route to the IP space starting at x.y.z.q and spanning the length 
specified by netmask, pointed towards gateway as a next-hop. Gatewaycan be an interface name 
or IP address. 

The metric tag is optional (which is why it's shown in brackets). 
The netmask used to be optional, but no longer is - and even on routers 
where it is optional it never hurts to be specific! 

For example:
<pre class="command-line">
(config)# ip route 192.168.25.0 255.255.255.0 192.168.25.1
</pre>

### Summary Script

We can now review a summary command-script that deletes and existing route,
adds a new route, shows the route to us, then saves the route to the firmware.

<pre class="command-line">
> enable
# config terminal
(config)# no ip route 192.168.25.0 255.255.255.0 192.168.18.100
(config)# ip route 192.168.25.0 255.255.255.0 192.168.25.1
(config)# show ip route
(config)# end
# copy running-config startup-config
# reload
</pre>
