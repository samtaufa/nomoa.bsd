# At the Console

&#91;Ref: OpenBSD 5.0, Nagios 3.3.1, [Nagios Core 3.x Manuals](http://nagios.sourceforge.net/docs/nagioscore/3/en/toc.html)]

<div class="toc">

Table of Contents

<ol>
	<li>Command Object
		<ul>
			<li>Macros</li>
			<li>Reference</li>
		</ul>
	</li>
	<li>State Check
		<ul>
			<li>Host</li>
			<li>Service</li>
		</ul>
	</li>
</ol>

</div>

At the command-line, we'll find a direct way of verifying whether your
Nagios box can communicate with the external node. It always troubled
me how "black-box" the nagios install seemed, until I realised that
one step towards better understanding of what Nagios is "seeing"
is to monitor the log files, **and** launch/execute the nagios
tools from the command-line.

## Command Object

Nagios is a modular system where much of the functionality is through execution
of external utilities. The use of these utilities are defined in the *command object*
which is commonly specified in the file: *command.cfg*

<blockquote>
Commands that can be defined include service checks, service notifications, service event handlers, host checks, host notifications, and host event handlers.
</blockquote>

The standard format of the command object is:

<pre class="config-file">
define command{ 
	command_name command_name 
	command_line command_line 
} 
</pre>

Where the command_line represents what would be executed at the *console command-line* with
the expected results being OK for success.

<blockquote>
<p><strong>command_line</strong>: ... Before the command line is executed, all valid macros are replaced with their respective values.</p>

<p>If you want to pass arguments to commands during runtime, you can use $ARGn$ macros in the command_line directive of the command definition and then separate individual arguments from the command name (and from each other) using bang (!) characters in the object definition directive (host check command, service event handler command, etc) that references the command. More information on how arguments in command definitions are processed during runtime can be found in the documentation on macros.</p>
</blockquote>

For example, the standard check for host alive (ping) is defined as:

<pre class="config-file">
define command{
	command_name 	check-host-alive
	command_line	$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5
}
</pre>

To verify the appropriate command-line options for a command, review the documentation
for that command:

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping --help
<!--(end)-->

An understanding of the purpose and configuratio not the command is important
to understanding the results you get from Nagios.

### Macros

The command_line demonstrates the use of *macros* in Nagios, and the two above
$USER1$, and $HOSTADDRESS$ demonstrate two types of macros:

- 	$USER1$ defined by the configuration
-	$HOSTADDRESS$ defined by the object

#### Configuration Defined

File excerpt: nagios.cfg

<pre class="config-file">
resource_file=/etc/nagios/resource.cfg
</pre>

File excerpt: resource.cfg

<pre class="config-file">
# You can define $USERx$ macros in this file, which can in turn be used
# in command definitions in your host config file(s). $USERx$ macros are
# useful for storing sensitive information such as usernames, passwords,
# etc. 

# Nagios supports up to 32 $USERx$ macros ($USER1$ through $USER32$)

# Sets $USER1$ to be the path to the plugins
$USER1$=/usr/local/libexec/nagios

#Sets $USER2$ to be the path to event handlers
#$USER2$=/usr/local/libexec/nagios/eventhandlers

#$USER3$=someuser
#$USER4$=somepassword
</pre>

#### Object Defined

&#91;Ref: [Object Definitions](http://nagios.sourceforge.net/docs/nagioscore/3/en/objectdefinitions.html)]

Many of the object primitives define macros that can be used by other
utilities in Nagios. Below is a short list, commonly seen in *commands.cfg*
and you can find more in the [Object Definitions](http://nagios.sourceforge.net/docs/nagioscore/3/en/objectdefinitions.html)
reference documentation.

<table>
	<tr><th>Macro</th>
		<th>Provided by object primitive</th>
	</tr>
	<tr><td>$HOSTNAME$</td>
		<td>host:host_name</td>
	</tr>
	<tr><td>$HOSTALIAS$</td>
		<td>host:alias</td>
	</tr>
	<tr><td>$HOSTADDRESS$</td>
		<td>host:address</td>
	</tr>
	<tr><td>$CONTACTNAME$</td>
		<td>contact:contact_name</td>
	</tr>
	<tr><td>$CONTACTALIAS$</td>
		<td>contact:alias</td>
	</tr>
	<tr><td>$CONTACTEMAIL$</td>
		<td>contact:email</td>
	</tr>
	<tr><td>$CONTACTPAGER$</td>
		<td>contact:pager</td>
	</tr>
	<tr><td>$CONTACTADDRESSx$</td>
		<td>contact:addressx</td>
	</tr>
</table>


### Reference

To specify a command within the *object definition* we use the directive
*check_command*

<pre class="config-file">
define object {
	::::
	check_command	command_name!$ARG1$!$ARG2$
	::::
}
</pre>

We specify arguments to be passed to the *command* separated by exclamation marks:

Where !$ARGn$! is optional

<blockquote>
<strong>check_command</strong>: This directive is used to specify the short name of the command that should be used to check if the host is up or down.
</blockquote>

## State Checks

<blockquote>
the command is used for service or host checks, notifications, or event handlers.
</blockquote>

Once you gain an understanding of the utilities for Nagios to check the
state of services, hosts, the flexibility of your monitoring system
expands dramatically.

The following are simple revisions of some of the more common (?) utilities
as a brief to getting you started on refering to the utilities' documentation
and their relationship to your Nagios objects.

### Host Check

#### PING

&#91;Ref: [Wikipedia:Ping](http://en.wikipedia.org/wiki/Ping)]

A basic check whether a host is up on the network is to perform a
ping against the host.

<blockquote>
Ping is a computer network administration utility used to test the reachability of a host on an Internet Protocol (IP) network and to measure the round-trip time for messages sent from the originating host to a destination computer. The name comes from active sonar terminology.
</blockquote>

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping --help
<!--(end)-->

Help Screen extract:

<pre class="manpage">
Use ping to check connection statistics for a remote host

check_ping -H <host_address> -w <wrta>,<wpl>% -c <crta>,<cpl>% [-p packets] [-t timeout] [-4|-6]

Options:

 -4 Use IPv4 connection
 -6 Use IPv6 connection
 -H host to ping
 -c critical threshold pair
 -w warning threshold pair
 -p number of ICMP ECHO packets to send (Default: 5)
 
 <rta> round trip average (ms) which triggers a <strong>WARNING</strong> or <strong>CRITICAL</strong> state.
 <pl> percentage of packet loss to trigger an alarm state.
</pre>

The check-host-live uses the command-line:

<pre class="config-file">
define command{
	command_name 	check-host-alive
	command_line	$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5
}
</pre>

We can obviously execute at the command-line to verify, view the response.

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5
<!--(end)-->
<pre class="screen-output">
PING OK - Packet loss = 0%, RTA = 0.01 ms|rta=0.014000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;00
</pre>

Other configuration / execution samples:

<pre class="config-file">
define command{
	command_name	check_ping
	command_line	$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5
}

define object {
	::::
	check_command	check_ping<strong>!100.0,20%!500.0,60%</strong>
	::::
}
</pre>

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping -H 127.0.0.1 -w 100.0,20% -c 5000.0,60% -p 5
<!--(end)-->
<pre class="screen-output">
PING OK - Packet loss = 0%, RTA = 0.02 ms|rta=0.017000ms;3000.000000;5000.000000;0.000000 pl=0%;20;60;00
</pre>

### Service Check 

#### SSH

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ssh --help
<!--(end)-->

Help Screen extract:

<pre class="manpage">
Try to connect to an SSH server at specified server and port

check_ssh [-46] [-t <timeout>] [-r <remote version>] [-p port] <host>
</pre>

Example configurations from default package install

<pre class="config-file">
define command{
	command_name	check_ssh
	command_line	$USER1$/check_ssh $ARG1$ $HOSTADDRESS$
}

define object{
	::::
	check_command	check_ssh
	::::
}
</pre>

Example command-line execution:

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ssh localhost
<!--(end)-->
<pre class="screen-output">
SSH OK - OpenSSH_5.9 (protocol 2.0)
</pre>

#### SMTP

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_smtp --help
<!--(end)-->

Help Screen extract:

<pre class="manpage">
This plugin will attempt to open an SMTP connection with the host.

check_smtp -H host [-p port][-e export][-C command][-f from addr]
		[-A authtype -U authuser -P authpass][-w warn][-c crit][-t timeout]
		[-F fqdn][-S][-D days][-v][-4|-6]

Successful connects return STATE_OK, refusals and timeouts return
STATE_CRITICAL, other errors return STATE_UNKNOWN.
</pre>


<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_smtp your-mailserver
<!--(end)-->
<pre class="screen-output">
SMTP OK - 0.002 sec. response time/time=0.002335s;;;0.000000
</pre>

#### NTP

&#91;Ref: mail archive [#1](http://kerneltrap.org/mailarchive/openbsd-misc/2008/5/8/1766904)
| [#2](http://web.archiveorange.com/archive/v/AXWonqJ517zbLFjuXPUv)]

Do not use *check_ntp_peer* to check against [OpenNTPD](http://www.openntpd.org)



The check presumes implementation of 