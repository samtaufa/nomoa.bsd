## Bridging STP

The idea behind our installation of STP enabled bridging is to increase stability of the network by preventing network loops and maximising shortest path route for packets within the network infrastructure.

The value-add of installing OpenBSD as redundant bridging nodes, is the added security services to be inserted to the infrastructure while maintaining service stability.

### References (man pages):

<ul>
	<li><a href="http://www.openbsd.org/cgi-bin/man.cgi?query=brconfig&apropos=0&sektion=8&manpath=OpenBSD+Current&arch=i386&format=html">brconfig(8)</a>
	<li><a href="http://www.openbsd.org/cgi-bin/man.cgi?query=bridgename.if&apropos=0&sektion=5&manpath=OpenBSD+Current&arch=i386&format=html">hostname.if(5)</a>
</ul>


### Requirements

Preferred environment.

<ul>
	<li>Root STP
	<li>STP enabled managed switches (_switch0_, _switch1_)
	<li>STP enabled bridging nodes (OpenBSD boxes)
</ul>

Although OpenBSD will bridge STP on non-STP switches, reports indicate that failover may be slightly longer (which may be circumvented by using a pfsync between the OpenBSD bridges.)

#### ROOT STP Node

First things first, decide which node is going to be your root node. Factors that may be involved in selecting the designated root node may include:

<ul>
	<li>high availability of the node
	<li>cost of transport to and from this node to other nodes on the STP
	<li>capacity of node to manage STP ROOT duties
</ul>

Keep this box ON.

### Bridging Nodes

Our installations will have two redundant bridges (_fwbridge01_, _fwbridge02_) between separate networks __LAN A__, and __LAN B__. __LAN A__ is internally using switch01, while __LAN B__ is internally using _switch02_. We want to redundantly bridge the two networks together.

Each box will be using network cards _em0_, and _em1_. Each box will wire _em0_ to _fwbridge01_,  and _em1_ to _fwbridge02_.

<div style="text-align: center">
    <img src="STPNetworkSample.png" title="STP Network Sample" />
</div>

#### Enable bridging on the OpenBSD box

Common configuration for both _fwbridge0_ and _fwbridge1_ boxes

	# file: /etc/hostname.em0
	up description "Link to Switch 1"

    


	# file: /etc/hostname.em1
	up description "Link to Switch 2"

    


	# file: /etc/bridgename.bridge0
	add em0
	add em1
	stp em0
	stp em1
	up

    
Unless you really know what you're doing, just let OpenBSD use its sane default settings.

<pre class="command-line">
brconfig(8)
priority num
	Set the spanning priority of this bridge to num. Defaults to
	32768, minimum of 0, maximum of 61440.
</pre>

For example, after setting the root STP _switch0_ to _priority 10_, then we can use _priority 1000_ for _fwbridge0_ and _priority 2000_ for _fwbridge1_.

### Test

A more robust automated testing sequence would be helpful, but in the sad event that one doesn't exist.

A visible test would be to run a continuous feed between the two networks, while visually inspecting the bridge behaviour.

<pre class="command-line">
client-on-B\> cat /dev/zero | nc client-on-A 2022
</pre>

<pre class="command-line">
client-on-A\> sudo nc -l 2022
client-on-A\>sudo tcpdump -nettv -i eth0 port 2022
</pre>

An audible test would be to stream an audio stream from one network while listening to it using and audio-player on the second network.

### Gotchas

Random thoughts on what grabbed me while I was playing around with the STP configuraiton.

<ul>
    <li>STP Root. You really want the stp root to be something that is almost
    always _ON_ and available.

        <ul><li>When the STP root goes offline, it can take more than a minute for
        STP elections to finalise on the next root node. </li></ul>

    <li>Bridge ID. Online documentation reference bridge id. In practise the
    Bridge ID is a concatenation of the node _priority_ and ethernet address.
    Make sure you take a look at the _priority_ of your bridge as you can do
    little about the ethernet address.

    <li>Linksys SRW2024P has a wierd requirement for priority to be in
    increments of 4096

</ul>

### Access to the Box

Access to the box is through a NIC connected to a live switch. For the redundancy of our above diagram each bridge connects to a different switch and grabs an IP through DHCP (we can manually configure DHCP and DNS to give a unique IP / DNS configuration.)

The above diagram design links switch1 with fwbridge1, switch2 with fwbridge2.

### Firewall State

We are using pfsync to ensure firewall state is kept, for faster failover.

