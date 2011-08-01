## Maintaining a live installation

A collection of tool utilisation to assist with monitoring
the performance (?) behaviour of your active Firewall.

<div class="toc">
Table of Contents

<ul>
	<li>State Table Limits</li>
	<li>Queues</li>
</ul>

</div>

Your packets don't go through as you expect, some are dropped,
some are delayed significantly.

### State Table Limits

&#91;Ref: [Hitting the PF state table limit](http://www.packetmischief.ca/2011/02/17/hitting-the-pf-state-table-limit/)]

The PF State tables set the limit of connections that have been authorised, 
and thus limits the number **new** connections that the firewall will
accept. You may have excess bandwidth available, but if there are no free
capacity in the State Tables, then your firewall becomes a bottle-neck.

The configured limits for state information is accessible through $!manpage("pfctl")!$

<!--(block|syntax("bash"))-->
# pfctl -sm
<!--(end)-->
<pre class="screen-output">
states        hard limit    10000   
src-nodes     hard limit    10000
frags         hard limit     5000
tables        hard limit     1000
table-entries hard limit   200000
</pre>

The above limits pre-sets the allocated memory the the defined structures,
such that they are always available, and it also limits growth of the said
data structures. If your firewall traffic exceeds the above settings, then
performance will be effected.

It is now important to monitor the effects of your traffic on the counters
for the above limits. The generic "-s info*" output gives us clues to
where to further investigate potential bottle-necks in our firewall.

<!--(block|syntax("bash"))-->
# pfctl -si
<!--(end)-->
<pre class="screen-output">
Status: Enabled for XXXXXXXXXXXXXXXX          Debug: Urgent

State Table                          Total             Rate
  current entries                       34
  searches                        96379206           15.2/s
  inserts                           726196            0.1/s
  removals                          726162            0.1/s
</pre>

On the above gateway, connected to two infrequently used laptops, 
the *current entries* is very low relative to the *hard limit 10000* above. 
Obviously, the *current entries* will fluxuate due to use,
and on a busier gateway may fluxuate significantly.

&#91;Ref: [Hitting the PF state table limit](http://www.packetmischief.ca/2011/02/17/hitting-the-pf-state-table-limit/),
[Open BSD state hard-limit reached](http://www.waldersten.net/content.php?/archives/57-Open-BSD-state-hard-limit-reached.html)]

An important counter to monitor from *pfctl -si* is the "**memory**"
counter. The same details should be availble through **systat pf**

From an active gateway linking our 6 sites, we get the following from a standard
install, no modification to state tables.

<!--(block|syntax("bash"))-->
# pfctl -si | grep memory
<!--(end)-->
<pre class="screen-output">
  memory                          209230            0.1/s
</pre>

The counter highlights how often PF has failed at least one of the $!manpage("pool",9)!$. 
The higher the number, the higher the frequency of incidences where packets arriving 
at the firewall have most likely been dropped due to one of the hardware limits.

Our above example shows 209,230 times the memory limit was *hit*.

The next review is to check with Kernel memory allocations, using $!manpage("vmstat")!$.
To narrow our search down to the effects on the pf state table we check the entry 
for **pfstatepl**.

Below, we grab the lines with state or Fail (so we can get the column headers)

<!--(block|syntax("bash"))-->
# vmstat -m | grep -E "state|Fail"
<!--(end)-->
<pre class="screen-output">
Name      Size  Requests  Fail   InUse Pgreq Pgrel Npage Hiwat Minpg Maxpg  Idle
pfstatepl  296  213123877 209235  5075  1050     0  1050 1050     0   2308   526
pfstatekeypl 
pfstateitempl
</pre>

**pfstatepl** is the label for memory allocated for the *struct pf_state* 
(/usr/src/sys/net/pf_ioctl.c) The failures do seem to be significant.

### Queues

<!--(block|syntax("bash"))-->
# systat queue
<!--(end)-->


pfctl -vvsi | grep congestion


