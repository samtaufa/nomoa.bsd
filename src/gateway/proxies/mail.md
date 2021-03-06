## Mail Proxy 

[OpenBSD 4.7, Postfix 2.7]

A Mail Proxy provides your mail flow with another layer/fence of defence against
remote intrusion attacks. The Mail Proxy normally stands at your perimeter, 
between the world/internet and your internal services (mail server.)

Postfix is comparatively simple to configure as an MX Proxy. This guide configures a 
basic MX Proxy, with no filtering. For a more 'profound' MX Proxy, refer to the 
[MX Proxy Extended, using Multiple Instances](instances.html).

$!Image("mail/smtp_proxy.png", title="SMTP Proxy", klass="imgcenter")!$

For a our mail proxy server, the effected configuration files are:

&#91;Ref: postconf(5)]

<ul>
    <li>/etc/postfix/<a href="#main.cf">main.cf</a></li>
    <li>/etc/postfix/<a href="#mynetworks">mynetworks</a></li>
    <li>/etc/postfix/<a href="#aliases">aliases</a></li>
    <li>/etc/postfix/<a href="#relaydomains">relaydomains</a></li>
    <li>/etc/postfix/<a href="#transport">transport</a></li>
</ul>

<a name="main.cf"></a>

### main.cf

The effected files, shown above, are referenced in the Postfix main.cf file, further documented
in postconf(5)

<pre class="config-file">
myhostname=`be explicit`
mydomain=`be explicit`
mynetworks=/etc/postfix/mynetworks
alias_maps=hash:/etc/postfix/aliases
alias_database=hash:/etc/postfix/aliases
relay_domains=/etc/postfix/relaydomains
transport_maps=hash:/etc/postfix/transport
message_size-limit=20480000
</pre>

In the configuration we explicit set the following:

- 	myhostname
- 	mydomain
- 	message_size_limit

#### myhostname

myhostname (default: see postconf -d output)

The internet hostname of this mail system. The default  is
to use the fully-qualified domain name from gethostname().

Example main.cf entry:

<pre class="config-file">
myhostname=jupiter.example.com
</pre>

Note: after changing main.cf, reload Postfix configuration.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

#### mydomain

mydomain (default: see postconf -d output)

The internet domain name of this mail system.  The default
is to use $myhostname minus the first  component.   $mydomain  
is used as a default value for many other configuration parameters.

Example main.cf entry:

<pre class="config-file">
mydomain=example.com
</pre>

Note: after changing this value, reload Postfix configuration.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

We specify the FQDN (Fully Qualified Domain Name) here.
Being explicit is just a nice way of allowing 'postconf -n' 
to show you the changes specific to this host.

#### message_size_limit

message_size_limit (default: 10240000)

The maximal size in bytes of a message, including envelope
information.

Example main.cf entry:

<pre class="config-file">
message_size-limit=20480000
</pre>

Note: after changing this value, reload Postfix configuration.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

<a name="mynetworks"></a>

### mynetworks

From the manpage:

<pre class="manpage">
mynetworks (default: see postconf -d output)

The  list  of "trusted" SMTP clients that have more privi-
leges than "strangers".

In particular, "trusted" SMTP clients are allowed to relay
mail  through  Postfix.   See the smtpd_recipient_restric-
tions parameter description in the postconf(5) manual.

You can specify the list of "trusted" network addresses by
hand  or  you  can let Postfix do it for you (which is the
default).  See the  description  of  the  mynetworks_style
parameter for more information.

If  you  specify  the  mynetworks  list  by  hand, Postfix
ignores the mynetworks_style setting.

Specify a list of  network  addresses  or  network/netmask
patterns,  separated by commas and/or whitespace. Continue
long lines by starting the next line with whitespace.
</pre>

From the example main.cf entry:

<pre class="config-file">
mynetworks=/etc/postfix/mynetworks
</pre>

File: /etc/postfix/mynetworks

<pre class="config-file">
127.0.0.0/8
10.1.0.2
</pre>

In this example, only the local host and an internal host
(which is our Internal Mail Server) are allowed to relay
through mail server.

Note: /etc/postfix/mynetworks is a simple text file, and needs no 
further post-processing, other than to reload the Postfix 
configuration.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

<a name="aliases"></a>

### aliases

Create the file(s) specified in main.cf for _alias\_database_ 
and _alias\_maps_.  Edit the file accordingly, such as the below
configuration to send 'root' messages to a local user '__monitor'.

#### alias_maps

From the manpage:

<pre class="manpage">
alias_maps (default: see postconf -d output)

The alias databases that are used for  local(8)  delivery.
See aliases(5) for syntax details.

If   you   change   the  alias  database,  run  "postalias
/etc/aliases" (or wherever your  system  stores  the  mail
alias  file), or simply run "newaliases" to build the 
necessary DBM or DB file.
</pre>

#### alias_database

From the manpage:

<pre class="manpage">
alias_database (default: see postconf -d output)

The alias databases for local(8) delivery that are updated
with "newaliases" or with "sendmail -bi".

This is a separate configuration parameter because not all
the  tables  specified  with  $alias_maps have to be local
files.
</pre>

Example configuration from above __main.cf__ entry:

<pre class="config-file">
alias_database = hash:/etc/postfix/aliases
</pre>

File: /etc/postfix/aliases

<pre class="config-file">
root:   postmaster
</pre>

In this example, all e-mail for the 'root' account is 
sent to the 'postmaster' local account.

After editing the _aliases_ file, make sure to execute the 
appropriate hashing/mapping tool on the text file, for the 
relevant db format specified in the configuration file 
(hash, dbm, etc.)

<pre class="command-line">
/usr/local/sbin/postalias /etc/postfix/aliases
</pre>

Postfix does not yet know to use the above changes, you need
to explicitly instruct Postfix to reload the alias configuration
through the general 'reload' everything command.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>


<a name="relaydomains"></a>

### relaydomains

Create the file specified in main.cf for _relay_domains._ 
This file will contain all the domains managed by the 
Internal Mail Server.


#### relay_domains

From the manpage:

<pre class="manpage">
relay_domains (default: $mydestination)

What destination domains  (and  subdomains  thereof)  this
system  will  relay  mail  to.  Subdomain matching is con-
trolled with the parent_domain_matches_subdomains  parame-
ter.  For  details  about  how  the relay_domains value is
used, see the description of  the  permit_auth_destination
and reject_unauth_destination SMTP recipient restrictions.

Domains that match $relay_domains are delivered  with  the
$relay_transport  mail delivery transport. The SMTP server
validates recipient addresses  with  $relay_recipient_maps
and  rejects  non-existent  recipients. See also the relay
domains address class in the ADDRESS_CLASS_README file.
</pre>

Example configuration from above __main.cf__ entry:

<pre class="config-file">
relay_domains=/etc/postfix/relaydomains
</pre>

File: /etc/postfix/relaydomains

<pre class="config-file">
example.com
example.net
example.org
</pre>

In the above context, we are Proxying a number of domains that 
can be listed as FQDNs or numeric IP addresses. Our domains 
here are example.com, etc.

Note: /etc/postfix/relaydomains is a simple text file, and needs 
no further post-processing, other than to reload the Postfix 
configuration.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

<a name="transport"></a>

### transport

As our mailchain sends messages directly from the Proxy to the Internal Mail Server
we use the _transport_maps_ to explicitly configure the next step in 
inbound e-mail messages.

#### transport_maps

From the manpage:

<pre class="manpage">
transport_maps (default: empty)

Optional   lookup  tables  with  mappings  from  recipient
address to (message delivery transport, next-hop  destination).  
See transport(5) for details.

Specify  zero  or more "type:table" lookup tables.  If you
use this feature with local files, run "postmap /etc/postfix/transport" 
after making a change.
</pre>

Example configuration from above __main.cf__ entry:

<pre class="config-file">
transport_maps = dbm:/etc/postfix/transport
transport_maps = hash:/etc/postfix/transport
</pre>

File: /etc/postfix/transport

<pre class="config-file">
example.com          smtp:[10.1.0.2]
example.net          smtp:[10.1.0.2]
example.org          smtp:[10.1.0.2]
</pre>

For the domains we accept in the __relaydomains__ we forward them through
the transport:smtp to their destination [10.1.0.2]

In the above context, all accepted mail is sent to  a single server, 
(our internal mail server) but can be sent to  various hosts.

Execute postmap after editing the file to ensure changes are readable to Postfix.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

Reload Postfix to enable changes.

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>


Your proxy server should now be ready for transport testing.