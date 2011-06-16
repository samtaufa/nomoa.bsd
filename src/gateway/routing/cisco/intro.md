## Connecting to a Cisco Switch

There are two acceptable methods for connecting to a Cisco Switch, either through SSH 
(if enabled on the switch) or directly through the console port.

When connecting your terminal software make sure to rotate through 
terminal speeds starting with at minimum 9600.The default terminal speed configuration 
of a Cisco Router is probably 9600 8N1 but other configurations may have been set such 
as: 115200 8N1. 

### Administrator Prompt

The console command-line uses two prompts, the 

<ul>
    <li>">" is the user-level prompt, and 
    <li>"#" is the admin user prompt. 
</ul>

Admin access is always available using 'enable' from the terminal/console connection (or after connecting
with a valid ssh user/password.)

<pre class="command-line">
>
> enable
# 
</pre>

'enable' behaves similarly to su root in Unix. Without it, you're privileges are mostly limited to a subset "show" commands.


###Configuration

The Cisco switch holds two configurations, the __running-config__ and the 
__startup-config__. The __running-config__  is the (potentially unsaved) config currently running, and
the __startup-config__ is the persistent configuration that the device starts with. 

<pre class="command-line">
# show running-config
# show startup-config
</pre>

You can make the current configuration persistent by copying the
__running-config__ to the __startup-config__:

<pre class="command-line">
# copy running-config startup-config
</pre>

The Cisco Switch Configuration text files are simply ascii command-line instructions to recreate a configuration.
An example manual configuration of the console/terminal connection is shown below

<pre class="command-line">
# config terminal
(config)# line con 0
(config)# exec-timeout 60 0
(config)# no modem enable
(config)# length 100
(config)# transport preferred none
(config)# speed 115200
# end
# copy running-config startup-config
# show running-config
</pre>

### Archiving Configurations

After configuring the device with an IP address, it is convenient to edit the
configuration locally on your desktop, and copy it accross to the switch every
so often as you work:

Copy the running config to an sshd host

<pre class="command-line">
copy running-config scp:
</pre>

Copy the edited / text from a http host

<pre class="command-line">
config replace http://10.0.0.2:9000/cisco01-config
</pre>

### Displaying Running Configurations

Runtime monitoring with the 'show' command, some interesting options
<ul>
    <li>ver - hardware and software version, summary interfaces, and why the router was last started (or crashed)
    <li>proc - note: >70% utilisation is asking for trouble
    <li>mem - memory utilisation
    <li>running-config | run - Running Configuration
    <li>startup-config | conf - Startup Configuration
    <li>int <strong>interface-name</strong> - Interface details
    <li>ip route - Without any parameters, this will show you all routes in the IP routing table.
    <li>ip route <strong>x.y.z.q</strong> - Shows routing information on one or more of the most specific routes that contain that IP address - however, if you enter an IP address for which no route but the default route (0.0.0.0) exists, the default route will not be shown.
    <li>ip route <strong>x.y.z.q netmask longer-prefixes</strong> - Shows a list of routes that are within the IP range specified by x.y.z.q as a starting point and netmask as a length. The longer-prefixes keyword tells it to find all routes that fall in that range - of all specificities (prefix length = specificity).
    <li>ip bgp  - Without any parameters, this will show you all routes heard via BGP.
    <li>ip bgp <strong>x.y.z.q</strong> - Shows routing information on one or more of the most specific BGP routes that contain that IP address - if you enter an IP address for which no route but the default route (0.0.0.0) exists, the default route will not be shown.
    <li>ip bgp <strong>x.y.z.q netmask longer-prefixes</strong> -  Shows a list of BGP routes that are within the IP range specified by x.y.z.q as a starting point and netmask as a length. The longer-prefixes keyword tells it to find all BGP routes that fall in that range - of all specificities (prefix length = specificity).
    <li>ip bgp reg <strong>regexp</strong> - This shows you all BGP routes matching the regular expression regexp. For example, sho ip bgp reg _1_ shows you all BBN routes.
    <li>ip bgp ?  - You may want to explore the other sho ip bgp commands. Typing sho ip bgp ? will get you a list of them. You can't do any harm with a sho command...
    <li>ip bgp summ
</ul>

### Useful Commands

<pre class="command-line">
# config term
(config)# enter configuration commands
...
...
(config)# end
</pre>
    

-   reload - Restarts the router; it'll ask you to 
    confirm - and whether to save any changes you might have made to the configuration.
-   write - Writes any changes you might have made 
    (copies the running configuration to the startup configuration).
-   write net - Writes the running configuration 
    to a remote tftp server. 


Revert to the startup configuration [using router replace](
http://packetlife.net/blog/2010/may/17/use-configure-replace-instead-of-copy-start-run/).

<pre class="command-line">
# router replace nvram:startup-config
</pre>