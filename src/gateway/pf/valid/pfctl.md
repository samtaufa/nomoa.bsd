## pfctl - Packet Filter Engine, userland tool

The userland tool for injecting and inspecting data in the Packet Filter
is $!manpage("pfctl",8)!$.

<pre class="manpage">
NAME
     pfctl - control the packet filter (PF) device

DESCRIPTION
     The pfctl utility communicates with the packet filter device using the
     ioctl interface described in $!manpage("pf",4)!$ .  It allows ruleset and parameter
     configuration and retrieval of status information from the packet filter.
</pre>

<div class="toc">

<p>
Table of Contents
</p>

<ul>
	<li>Basic Invocation</li>
	<li>Common Invocations
		<ul>
			<li>Load/Parse Rulesets</li>
			<li>Showing current state</li>
			<li>Show more details</li>
			<li>Tables</li>
			<li>Flush Configuration</li>
			<li>Killing State</li>
		</ul>
	</li>
	<li>Interesting Invocations</li>
</ul>

</div>

As your curiosity level with $!manpage("pf")!$ increases, (also known as
"not knowing, what's going on") $!manpage("pfctl")!$ is the tool to use for
inspecting how $!manpage("pf")!$ has viewed your ruleset (-s rules)
and discover active details about the packet filter.

-   rules
-   tables

Work in Progress --- 

1.  What are some very basic commands
2.  What are very commonly used commands
3.  What are some additional interesting commands

### Basic Invocation

1.  Start: **pfctl -e**
2.  Stop: **pfctl -d**
3.  Start with a ruleset file **pfctl -ef /etc/pf.conf**
4.  Check ruleset **pfctl -nf /etc/pf.conf**
5.  Reload ruleset file **pfctl -f /etc/pf.conf**

### Common Invocations

Below are the more common uses of pfctl in my context

#### Load/Parse rulesets

Feeding the PF Engine is simplified using pfctl's "-f" option
for specifying a file with PF rules.

<pre class="manpage">
-f file
	 Load the rules contained in file.  This file may contain macros,
	 tables, options, and normalization, queueing, translation, and
	 filtering rules.  With the exception of macros and tables, the
	 statements must appear in that order.
</pre>

Common invocations using "-f" include:

<pre class="command-line">
-f /etc/pf.conf     Load the pf.conf file
-nf /etc/pf.conf    Parse the file, but don't load it
-Nf /etc/pf.conf    Load only the NAT rules from the file
-Rf /etc/pf.conf    Load only the filter rules from the file
</pre>

As such, my most common invocation is to 'parse' a modified ruleset
using "pfctl -nf /etc/pf.conf" where the rules are not loaded but
are checked for syntax and some logic.

Similarly, because of Unix's piping capabilities, we can
verify and inject a new PF directive from the command line such as:

<pre class="command-line">
# echo "pass on eth0 from any to any port 80" | pfctl -nf -
</pre>
<pre class="screen-output">
stdin:1: port only applies to tcp/udp
stdin:1: skipping rule due to errors
stdin:1: rule expands to no valid combination
</pre>

The above shows pfctl parsing the console input, and finding
errors, which can be corrected in the below update to the 
rule (read: add "proto tcp").

<pre class="command-line">
# echo "pass on eth0 <strong>proto tcp</strong> from any to any port 80" | pfctl -nf -
</pre>
<pre class="screen-output">
&nbsp;
</pre>

Note: No output indicates success.

**Warning**: note that "-f" loads the ruleset to replace the existing ruleset. If you 
intend to use the command-line to *"add rules"*, consider something as the below:

- Insert a new rule at *the beginning* of the existing ruleset

<pre class="command-line">
(echo "block all"; pfctl -sr) | pfctl -f -
 </pre>

-   Insert a new rule at *the end* of the current ruleset

<pre class="command-line">
(pfctl -sr; echo "pass quick on lo0") | pfctl -f -
</pre>

#### Showing current state

We can view PF's interpretation, by using the "-s rules"

<pre class="manpage">
-s modifier
    Show the filter parameters specified by modifier (may be
    abbreviated):
</pre>

You create rules following the manual pages $!manpage("pf.conf")!$ and the
FAQ, but you are still uncertain that you and the Packet Filter understand the
same thing from manuals.

<pre class="manpage">
-s rules    Show the currently loaded filter rules.  When used
            together with -v, the per-rule statistics (number
            of evaluations, packets and bytes) are also shown.
            Note that the ``skip step'' optimization done
            automatically by the kernel will skip evaluation
            of rules where possible.  Packets passed
            statefully are counted in the rule that created
            the state (even though the rule isn't evaluated
            more than once for the entire connection).
</pre>

For an example, to use the default ruleset (/etc/pf.conf) as an example

<pre class="config-file">
set skip on lo
pass            # to establish keep-state
block in on ! lo0 proto tcp to port 6000:6010
</pre>


<pre class="command-line">
pfctl -s rules
</pre>
<pre class="screen-output">
pass all flags S/SA keep state
block drop in on ! lo0 proto tcp from any to any port 6000:6010
</pre>

The rules inside the PF engine is more specific than what is written in 
PF (a simplistic example) but provides a simple overview of how you can use
pfctl to review your understanding, against how the PF engine is interpreting
it.

<pre class="command-line">
-s nat      Show the currently loaded NAT rules
-s queue    Show the currently loaded queue rules
-s rules    Show the currently loaded filter rules
-s Anchors  Show the currently loaded anchors directly
            attached to the main ruleset.
-s states   Show the contents of the state table.
-s Sources  Show the contents of the source tracking table.
-s info     Show filter information (statistics and counters)
-s labels   Show per-rule statistics.
-s timeouts Show the current global timeouts
-s memory   Show the current pool memory hard limits
-s Tables   Show the list of tables
-s osfp     Show the list of operating system fingerprints
-s Interfaces Show the list of interfaces and interface drivers
            available to PF.
-s all      Show all of the above.
</pre>

##### Show more details

To get more detailed usage data for each show values option, pfctl can be 
invoked with the "-v" (verbose) option. The following example shows how 
to get detailed usage data for each firewall rule:

<pre class="command-line">
% sudo pfctl -v -s rules
</pre>
<pre class="screen-output">
scrub in all no-df fragment reassemble
  [ Evaluations: 373620187  Packets: 179290329  Bytes: 45895535624  States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
scrub out all no-df fragment reassemble
  [ Evaluations: 194329858  Packets: 194329858  Bytes: 58848165945  States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
block drop in log on ! lo0 inet from 127.0.0.0/8 to any
  [ Evaluations: 2934066   Packets: 0         Bytes: 0           States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
</pre>

#### Tables

To optimize ruleset evaluation, tables is an important tool in storing
data for the PF Engine. pfctl provides some useful invocations to let
you monitor and manage tables.

<pre class="command-line">
-s Tables                            Show Tables
-T show -t table-name                Display entries in table 'table-name'
-T show -vt table-name               Display table counters for 'table-name'
-vs Tables                          Display global information
-T add -t table-name ip-address      Add an 'ip-address' to table 'table-name'
-T delete -t table-name ip-address   Delete an 'ip-address' from table 'table-name'
</pre>

#### Flushing Configuration

The general invocation of pfctl to reload the ruleset is 

<pre class="command-line">
pfctl -f /etc/pf.conf
</pre>

pfctl instructs the PF Engine to load a new ruleset from */etc/pf.conf*
and on completion switch from the existing ruleset to the newly
loaded ruleset.

Noted practises use **-F rules -f /etc/pf.conf** which, noted by
dhartmei's article [PF Firewall Management](http://undeadly.org/cgi?action=article&sid=20060929080943)
introduces a moment (between Flusing the rules, and the kernel loading
the new rules) where no rules exist.

We can flush and remove other items from the PF Engine.

<pre class="command-line">
-F nat      Flush the NAT rules
-F queue    Flush the queue rules
-F rules    Flush the filter rules
-F states   Flush the state table (NAT and filter)
-F sources  Flush the sources tracking table
-F info     Flush the filter information 
            (statistics that are not bound to rules)
-F Tables   Flush the tables
-F osfp     Flush the passive operating system signatures
-F all      Flush all of the above            
</pre>

As in the above table, when you've made changes to /etc/pf.conf and are
reloading the ruleset, make sure you flush the appropriate rules (whether
they're changes you've made to nat or filter rules etc.)

**Remember** that you don't want to flush without loading a new set
of replacements.

#### Killing State

&#91;Ref: [PF Firewall Management](http://undeadly.org/cgi?action=article&sid=20060929080943)]

When refreshing firewall rules, you can kill state information 
by explicitly using the "-k | -K" pfctl option.

<pre class="manpage">
-K host | network

-k host | network | label | id

    For example, to kill all of the state entries originating from
    ``host'':

        # pfctl -k host

    A second -k host or -k network option may be specified, which
    will kill all the state entries from the first host/network to
    the second.  To kill all of the state entries from ``host1'' to
    ``host2'':

        # pfctl -k host1 -k host2

    A network prefix length of 0 can be used as a wildcard.  To kill
    all states with the target ``host2'':

        # pfctl -k 0.0.0.0/0 -k host2

    It is also possible to kill states by rule label or state ID.  In
    this mode the first -k argument is used to specify the type of
    the second argument.  The following command would kill all states
    that have been created from rules carrying the label ``foobar'':

        # pfctl -k label -k foobar

    To kill one specific state by its unique state ID (as shown by
    pfctl -s state -vv), use the id modifier and as a second argument
    the state ID and optional creator ID.  To kill a state with ID
    4823e84500000003 use:

        # pfctl -k id -k 4823e84500000003

    To kill a state with ID 4823e84500000018 created from a backup
    firewall with hostid 00000002 use:

        # pfctl -k id -k 4823e84500000018/2
</pre>

### Interesting Invocations

Obviously there are some cooler uses of pfctl, want to share?