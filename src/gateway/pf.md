## The <a href="http://www.openbsd.org">OpenBSD</a> Packet Filter 

<div class="toc">

Table of Contents

<ul>
	<li><a href="#confirm">Confirmation</a></li>
    <li><a href="#policy">Firewall Policy</a></li>
	<li><a href="#verify">Verifiability</a></li>
    <li><a href="#notes">Side Notes</a></li>
    <li><a href="#reference">References</a></li>
</ul>

</div>

Building an OpenBSD Firewall is based on the Packet Filter Engine $!manpage("pf",4)!$  and 
is well documented in manpages, with additional project documentation
in the [PF FAQ](http://www.openbsd.org/faq/pf/index.html). There
are even [Tutorial](http://home.nuug.no/~peter/pf/) Sessions at various conferences.

These notes assist in the maintenance, monitoring of PF.

At this point, do not be ashamed to purchase a book on Packet Filtering and
OpenBSD. You can learn from your own mistakes, and make your own investigations
on the Internet and on these pages, but you can also save yourself a lot
of grief by buying the knowledge of those who've spent some quality effort
to document real-life use of PF, with experience in diverse applications.

What ever you do from here, you really do need to read a series of free resources
published by Daniel Hartmeier on [Undeadly](http://undeadly.org):

-	[PF: Testing your Firewall](http://undeadly.org/cgi?action=article&sid=20060928081238), 
-	[Firewall Rule Optimization](http://undeadly.org/cgi?action=article&sid=20060927091645), 
-	[Firewall Management](http://undeadly.org/cgi?action=article&sid=20060929080943)

<div class="image">
    $!Image("fw/fw_traffic_flow.png", title="Firewall - Traffic Flow")!$
</div>

<blockquote>
<p>Packet Filter (from here on referred to as PF) is OpenBSD's system 
for filtering TCP/IP traffic and doing Network Address Translation. 
PF is also capable of normalizing and conditioning TCP/IP traffic and 
providing bandwidth control and packet prioritization. PF has been a 
part of the GENERIC OpenBSD kernel since OpenBSD 3.0. Previous 
OpenBSD releases used a different firewall/NAT package which is 
no longer supported. </p>

-- <a href="http://www.openbsd.org/faq/pf/index.html">PF FAQ</a>
</blockquote>

### <a name="confirm">Confirmation</a>

To verify that PF is operational, use pfctl such as:

<pre class="command-line">
sudo pfctl -s info
</pre>

<pre class="screen-output">
Status: Enabled for 453 days 00:57:16         Debug: Urgent

...
</pre>

This in no way tells us whether we've configured it correctly, just that the
PF Engine is running.

### <a name="policy">Firewall Policy</a>

Before we can verify our firewalls performance, we need a measure of the "expected 
behaviour." 

The design and performance characteristics can be documented in the Firewall
Policy Document. One approach to writing a Policy Document is with the following
outline:

- The Policy
- The Regulations
- The Controls


<div class="image">
    $!Image("fw/fw_policy.png", title="Firewall - Traffic Flow")!$
</div>

<blockquote><h5>A well-defined filtering policy</h5>

<p>The filtering policy is an informal specification of what the firewall is supposed to do. 
A ruleset, like a program, is the implementation of a specification, a set of formal instructions 
executed by a machine. In order to write a program, you need to define what it should do.
</p>

Daniel Hartmeier's <a href="http://undeadly.org/cgi?action=article&sid=20060928081238">PF: Testing your Firewall</a>
</blockquote>

A Policy, is a generalised statement whereas the regulations and controls are more
specific.

In our context the Policy document serves as a communications tool:

1. Between Firewall Administrators and the business, outlining in a broad brush 
    of how the firewalls will persist as a gateway between the organisation and external IT services.
2.  Between the design team and testers, implementors, maintainers of specifics to be addressed by the Firewall.
3.  Between the IT organisation and auditors.
4.  For the Change Management Process.

In practise, our Firewall Policy document is divided into these major groups:

- Broad Description
- Regulation and Controls
- Implementation - Production Ruleset
- Change 

#### Broad Description

As a communications tool, the Policy Document will many times sit in front 
of non-technical people with little or no technology background, let alone
understanding of what a Firewall does.

A brief, broad description, at the beginning of each of our Policy Documents
draws a generalised overview of the the function and purpose of a firewall
for the benefit of non-technical staff.

The description covers the non-technical overview of a firewall, as well
as outlining the major categories of source and destination traffic.

For example;

<blockquote>
<p>blurb ... diagram ... blurb</p>

<p>The Firewall <b>blocks</b> and logs all traffic <strong>by default</strong>.
Only explicitly approved traffic is allowed to enter or leave the firewall. 
Approved traffic is labelled for the purpose of its approval.</p>

<p>The below Regulations and Controls describe which IP Traffic is allowed through the 
firewall, and the rationale for it's approval.</p>
</blockquote>

#### Regulation and Controls

Regulations describe the generalised restrictions and the Controls 
provide more specific implementation requirements.

As per Daniel's recommendations above, the text is descriptive and sufficient to
develop firewall rulesets, without being a full syntax. 

For example:

<blockquote>
<h5>2.1 Internal Interface (LAN_)</h5>

<p>All network traffic entering and exiting from the Internal
interface is regulated.</p>

<P>Traffic exiting through the Internal Interface must be
previously accepted with an incoming filter (administered
at the "incoming" interface) and is tagged with a label that 
ends with "<strong>_LAN</strong>".</p>

<p>Only approved network traffic is allowed to enter the Firewall,
and is labelled with a tag beginning with "<strong>LAN_</strong>" which 
designates it has been approved <b>from the LAN</b> facing interface.</p>

<h5>2.1.1 Demilitarised Zone (DMZ)</h5>

<p>Traffic destined for the Demilitarised Zone
is labelled with the tag: <strong>LAN_DMZ</strong></p>

<p>Control: Allow from Exchange Server to MX Proxies on the smtp port (tcp)</p>

<p>Rationale: Allow mail submission to the MX Proxy from the Corporate
Microsoft Exchange Server. This is required to get our e-mail out.</p>
</blockquote>

Note: We have explicitly specified the protocol and port in our Control documents
to prevent ambiguity in this specific event. You may differ in your determination
on how explicit to be with your control statement.

#### Implementation - Production Ruleset

Required by our Change Management Process, good for keeping us on our toes
that we are actually keeping track of changes (per why and not necessarily
what.)

The actual ruleset, periodically downloaded from the live server.

For example, a rule that implements the above controls may look something
like the below.

<pre class="config-file">
pass in on $lan_if inet proto tcp from &lt;ms_exchange> to &lt;mx_proxies> port smtp
</pre>

Our Control explicitly specifies the protocol (tcp) and port (smtp) as per
document requirements.

#### Standard Change

If your Policy Document is involved in a "Change Committee" process,
that it may benefit you to clearly highlight operational activities that can 
be pre-approved changes for the Firewall Rules. You don't want to
always have to go back to a "Change Committee" for trivial
changes that do not diminish from the regulations and controls
set in the above document.

Example A:

From the above Regulation and Control example, our organisation
expands to using 2 Exchange Servers, or 2 MX Proxies. There is
no change in controls or regulations, and you should be able
to add more hosts (ip addresses) to either the table
&lt;msexchange> and &lt;mx_proxies> without having to wait
for another Change Committee meeting.

Example B:

A Policy Document regulates the number of external sites accessible
by FTP. 

The Controls are implemented through use of a table <ext_ftpsites>

Another FTP site is requisitioned by the company for some purpose.
Without needing to go to a Change Committee, we can add the new
FTP site to the approved list (no change in policy, regulation, or
control is made) and we log with the change record of the firewall
document the business case (job #) that prompted the additional
IP address in the table <ext-ftpsites>  

### <a name="verify">Verifiability</a>

These notes evolve our experience evolving a deployment that is verifiable for policy and
performance compliance. 

With a good Policy Document in place, and a ruleset implemented
to the document, we are now ready to generate some traffic to
verify confirm compliance to the document, and likewise find
any deficiencies in our knowledge or the requirements documentation.

Our [Traffic Flow](pf/valid/flow.html) expands more into the specific
traffic flows, and how to generate and monitor traffic to ensure
our understanding of the ruleset and policy document is accurate.

The following links expands further on how to verify and maintain
your rulesets.

- [pfctl](pf/valid/pfctl.html)
- [Traffic Flow](pf/valid/flow.html)
- [Performance](pf/valid/performance.html)
- [Tools](pf/valid/other.html)

### <a name="notes">Side Notes</a>:

-   *keep state* became default rule behavior circa release 4.1
-   nat/rdr/binat rules are evaluated before pass rules (up to 4.6)
-   nat/rdr/binat rules are now 'actions' on regular rules (4.7 onwards) separate execution no longer exists.

### <a name="reference">References</a>:

-   The [Packet Filter FAQ](http://www.openbsd.org/faq/pf/index.html) always documents RELEASE
-	Articles
	[PF: Testing your Firewall](http://undeadly.org/cgi?action=article&sid=20060928081238) | 
	[Firewall Rule Optimization](http://undeadly.org/cgi?action=article&sid=20060927091645) |
	[Firewall Management](http://undeadly.org/cgi?action=article&sid=20060929080943) by Daniel Hartmeier's @ Undeadly 
-   [Book: Building Firewalls with OpenBSD and PF, 2nd ed.](http://www.amazon.com/Building-Firewalls-OpenBSD-PF-2nd/product-reviews/8391665119)
-	[Book: Absolute OpenBSD: UNIX for the Practical Paranoid](http://www.amazon.com/Absolute-OpenBSD-UNIX-Practical-Paranoid/dp/1886411999/ref=cm_cr_pr_sims_t)