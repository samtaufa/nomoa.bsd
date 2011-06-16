## Other

Some random notes garnered from trolling the mail achives etc.

<div class="toc">

Table of Contents

<ol>
	<li><a href="#lb">Load Balancing</a></li>
</ol>

</div>

### <a name="lb"></a> Load Balancing

&#91;Ref: [PF: Address Pools and Load Balancing](http://www.openbsd.org/faq/pf/pools.html)

Scenario: You have two or more external connections you wish to 
more effectively utilise by sharing the external traffic across
those links. 

Packet Filter provides the **route-to** filter option which 
supports load distribution using either: *random*, *round-robin*, or
*source-hash*. 

The connections are not equivalent, one of these links is preferable. 
How can we show this 'preference' in PF's *current* algorithms?

<pre class="manpage">
route    	= ( "route-to" | "reply-to" | "dup-to" )
			( routehost | "{" routehost-list "}" )
			[ pooltype ]
pooltype    = ( "bitmask" | "random" |
			"source-hash" [ ( hex-key | string-key ) ] |
			"round-robin" ) [ sticky-address ]
</pre>

PF's route-to (when state is created for the packet) will designate
the route for all packets matching the same connection (session.)
We can simulate variants on the default pooltype such as below,

<pre class="config-file">
route-to { ($ext1_if $ext1_nexthop) ($ext1_if $ext1_nexthop) ($ext1_if $ext1_nexthop) \
	($ext2_if $ext2_nexthop) } round-robin
</pre>

where we route 3:1 packet sessions between ext1:ext2. That will obviously not equate
to 3:1 bandwidth utilisation.