## The <a href="http://www.openbsd.org">OpenBSD</a> Packet Filter 

<div style="float:right">

Table of Contents

<ul>
    <li>Installation
        <ul>
            <li><a href="#activate">Activate</a>
            <li><a href="#verify">Verify</a>
        </ul>
    </li>
    <li><a href="pf/ruleset.html">Ruleset Review</a>
        <ul>
            <li>$!manpage("pfctl",8)!$  - control the packet filter (PF) device
        </ul>
    </li>
    <li><a href="pf/performance.html">Performance / Throughput</a>
        <ul>
            <li>tcpbench from base
            <li> tcpblast from ports/benchmarks
        </ul>
    </li>
    <li><a href="pf/flow.html">Traffic Flow</a>
        <ul>
            <li> nc(1) - netcat utility, push and listen to TCP/UDP connections on interfaces
            <li> route, arp tables
            <li>tcpdump(8) - watch the traffic behaviour on route-flow interfaces
                <ul>
                    <li> pflog0
                    <li> Interface/CARP-in
                    <li> Interface/CARP-out
                    <li> source host
                    <li> destination host
                </ul>
            </li>
        </ul>
    <li><a href="pf/other.html">Other Tools</a>
</ul>

</div>


[$!manpage("pf",4)!$ ] 
maintained <a href="http://www.openbsd.org/faq/pf/index.html">documented</a> by the <a href="http://www.openbsd.org">OpenBSD</a> developers.

<blockquote>Packet Filter (from here on referred to as PF) is OpenBSD's system 
for filtering TCP/IP traffic and doing Network Address Translation. 
PF is also capable of normalizing and conditioning TCP/IP traffic and 
providing bandwidth control and packet prioritization. PF has been a 
part of the GENERIC OpenBSD kernel since OpenBSD 3.0. Previous 
OpenBSD releases used a different firewall/NAT package which is 
no longer supported. 
<a href="http://www.openbsd.org/faq/pf/index.html">PF FAQ</a></blockquote>

These notes assist in the installation, maintenance, monitoring of PF. As PF is in continual
development, enhancements these notes should continue to evolve and you should 
re-affirm your knowledge through the man pages or release notes.

### <a name="activate"><a href="http://www.openbsd.org/faq/pf/config.html">Activate</a></a>

To activate PF at boot, review the file: /etc/$!manpage("rc.conf.local",8)!$, 
and ensure the below activation line exists: (default post 4.6)

<pre class="screen-output">
pf=YES
</pre>


Reboot your system to have it take effect. 

You can also manually activate and deactivate PF by using the pfctl(8) program: 

<pre class="command-line">
# pfctl -e
# pfctl -d
</pre>




to enable and disable, respectively. Note that this just enables or disables PF, 
it doesn't actually load a ruleset. The ruleset must be loaded separately, either 
before or after PF is enabled. 

### <a name="verify">Verify</a>

To verify that PF is operational, use pfctl such as:

<pre class="command-line">
% sudo pfctl -s info
</pre>


<pre class="screen-output">
Status: Enabled for 453 days 00:57:16         Debug: Urgent

State Table                          Total             Rate
  current entries                     1307
  searches                     12904357761          329.7/s
  inserts                        139538242            3.6/s
  removals                       139536935            3.6/s
Counters
  match                          303907295            7.8/s
  bad-offset                             0            0.0/s
  fragment                               0            0.0/s
  short                                415            0.0/s
  normalize                             28            0.0/s
  memory                              1486            0.0/s
  bad-timestamp                          0            0.0/s
  congestion                          3063            0.0/s
  ip-option                            394            0.0/s
  proto-cksum                            0            0.0/s
  state-mismatch                     51221            0.0/s
  state-insert                           0            0.0/s
  state-limit                            0            0.0/s
  src-limit                              0            0.0/s
  synproxy                               0            0.0/s
</pre>

### Key Notes:

<ul>
    <li><a href="http://www.openbsd.org/faq/pf/index.html">PF FAQ</a> always documents RELEASE
    <li>_keep state_ became default rule behavior circa release 4.1
    <li>nat/rdr/binat rules are evaluated before pass rules (up to 4.6)
    <li>4.7+ nat/rdr/binat rules are now 'actions' on regular rules, separate execution no longer exists.
    
<blockquote>
Date: Tue, 1 Sep 2009 17:12:37 +0200
From: Henning Brauer < henning@openbsd.org >
To: misc@openbsd.org
Subject: pf changes

seperate rules for nat, rdr etc are gone.

nat and rdr become actions on regular rules.

simple rulesets are converted like this:

<pre class="config-file">
nat on $ext_if to ($ext_if)
</pre>
becomes
<pre class="config-file">
match out on $ext-if nat-to ($ext_if)
</pre>

more complex rulesets require some thought. since the weird
difference in matching order is gone (nat/rdr were first match) you
might have to reverse things and use your brains  :) 

the new NAT code is very very very flexible. every matching "match"
rule changes the adress on the fly (not really, but that is what it
looks like for subsequent rules), and you can nat or rdr multiple times.
for pass rules, only the last matching one matters.

so given
<pre class="config-file">
match out on $ext_if nat-to 1.2.3.4
match out on $ext_if to 1.2.3.4 nat-to 5.6.7.8
</pre>
both rules will match and 5.6.7.8 will be the new src address.

however, with
<pre class="config-file">
pass out on $ext_if nat-to 1.2.3.4
pass out on $ext_if nat-to 5.6.7.8
</pre>

ONLY the second one matters for NAT. same semantic that match rules
have for a lot of other stuff (altq, rtable, log, scrub).

the core logic, that relies on the big state table rewrite ryan and I
(with help from otehr developers of course) did last year, allows for
nat and rdr in any direction, but for now we prevent that in pfctl and
force nat outbound and rdr inbound, there are nontrivial implications
for the routing afterwards - if you rdr outbound, the packet will go
out on the interface it was seen on, even if the route for the address
rdr'd to actually points to a different interface. with NAT there are
similiar implications for the return traffic. since they are useful
nontheless I tend to remove the check in pfctl and document the
implications, but one thing after each other.

the diff is over 3000 lines, and makes pf about 800 lines smaller
than it was before. more cleanup is possible on top of this, but as
said before, one step at a time.

to add another data point how important hackathons are... this was
almost entirely written at c2k9 in edmonton and "finished" (minus a
few bugs fixed later) the week thereafter on bob's couch. while the
diff was almost entirely written by me, getting this actually into the
tree was a concerted effort by many developers. claudio adjusted ftp-proxy,
sthen ported that adjustment over to tftp-proxy, reyk adjusted relayd.
many people were testing a lot, I'm sure I forget a few, but at least
krw, sthen, claudio, reyk, dhill and dlg (who was insane enough to
throw this on production firewalls with significant importance) helped
a lot. igor did most of the manpage work. theo helped getting it in, a
lot. thanks guys.

and now it is your time. test this as much as you can, to avoid
surprises in 4.7, and bugs showing up after release... we really want
to find them beforehands, right?    
    </blockquote>
</ul>
