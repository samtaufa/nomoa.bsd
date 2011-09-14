## Realtime Communications with XMPP

<div class="toc">

Table of Contents:

<ol>
	<li><a href="#install">Install</a></li>
	<li><a href="#config">Configuration</a>
		<ul>
			<li><a href="#ssl.encrypt">Encrypting with SSL</a></li>
			<li><a href="#startup">Host Startup</a></li>
		</ul>
	</li>
	<li> <a href="#run">Running eJabberD</a>
		<ul>
			<li><a href="#restart">Restart</a></li>
			<li><a href="#admin">Administration</a></li>
		</ul>
	</li>
	<li> <a href="#user.accounts">Accounts</a>
		<ul>
			<li><a href="#admins">Admins</a></li>
		</ul>
	</li>
	<li> <a href="#domain">Domain Name Service (DNS)</a>
	</li>
</ol>

</div>

&#91;Ref: $!OpenBSD!$ 4.9, [ejabberd](http://www.process-one.net/en/ejabberd/)
 2.1.6, [XMPP](http://xmpp.org/about-xmpp/)]

<blockquote>
E<strong>x</strong>tensible <strong>M</strong>essaging and <strong>P</strong>resence <strong>P</strong>rotocol (XMPP.) 
Real-time communication, which powers a wide range of applications including 
instant messaging, presence, multi-party chat, voice and video calls, collaboration, 
lightweight middleware, content syndication, and generalized routing of XML data.
</blockquote>

Augmenting the documentation provided by the [eJabberD project](http://www.process-one.net/en/ejabberd/)
and the OpenBSD Ports Package for ejabberd.

<blockquote>
ejabberd is a distributed, fault-tolerant technology that allows the creation of large-scale 
instant messaging applications. The server can reliably support thousands of simultaneous users 
on a single node and has been designed to provide exceptional standards of fault tolerance. 
As an open source technology, based on industry-standards, ejabberd can be used to build bespoke 
solutions very cost effectively
</blockquote>

The $!OpenBSD!$ Ports system provide a range of tools as servers and
clients for Jabber/XMPP, a protocol for message exchanges. 
[eJabberD project](http://www.process-one.net/en/ejabberd/)
is the server we discuss in this installation guide.

To run your server, customise the server configuration for your site,
start eJabberD and manage user accounts.

Documentation is plentiful online, but more importantly much is available
in the package install as text files or html installed documentation.

Note: erlang lines end with a period "."

This guide augments better guides with how we got things up and running.

- Installing the Software
- Basic Server Configuration
- Make sure the server runs
- Creating Accounts
- Play

<a name="install"></a>

## Install

&#91;DOC: [Installation and Operation Guide](http://www.process-one.net/docs/ejabberd/guide_en.html)]

OpenBSD packages provide the basic install. After the package install, we get an error message:

<pre class="screen-output">
ejabberd-2.1.6p0: ok
Look in /usr/local/share/doc/pkg_readmes for extra documentation.
</pre>

The Package Documentation is divided into the following sections:

- Migration
- Configuration
	* DNS
	* Configuration file
- Running
- Administration
- Using SSL
- Hostname resolving

It's worth reading now, and it's worth reading even if you get something working
using these guides.

If you get a warning message such as:

<pre class="screen-output">
useradd: Warning: home directory `/var/db/ejabberd' doesn't exist, 
   and -m was not specified
</pre>

Install a later version of the package, or fix it by 
finding out what the ejabberd username/group happens to be.

<!--(block|syntax("bash"))-->
grep ejabberd /etc/passwd
<!--(end)-->
<pre class="screen-output">
_ejabberd:*:594:594:ejabberd account:/var/db/ejabberd:/bin/sh
</pre>

The user-id is _ejabberd and after looking at /etc/groups for group-id 594,
we find the group-id is also _ejabberd, so we can now set the correct permissions
for the /var/db/ejabberd path.

<!--(block|syntax("bash"))-->
chown -R _ejabberd:_ejabberd /var/db/ejabberd
<!--(end)-->

<a name="config"></a>

## Configuration

For our basic server, we have accounts from separate groups,
and we'll separate them by their login @domains.

There are two aspects of domains important to the eJabberD server,

- Host Shortname
- Virtual Domains

#### Host Shortname

&#91;File: /etc/hosts]

Userland control of the daemon is through "ejabberdctl." Using it to start
the daemon, it uses the host shortname *"/bin/hostname -s"* to set the
daemon's *node-name* so it is important to make sure this is **resolv**able. 
On the physical host, the simplest solution is to make sure the above 
/bin/hostname -s is registered in your /etc/hosts file: 

<pre class="config-file">
127.0.01	  localhost
::1			  localhost
ip-address    myhostname
</pre>

Likewise, if you have multiple ejabberd hosts, than the shortnames should
either be resolvable through DNS, or on the said hosts /etc/hosts file.

The hostname is the default *node name*.

#### Virtual Domains

XMPP accounts are generally of the form user@domain, as such
our eJabberD can serve XMPP for different (virtual) domains, 
specified with the **hosts** configuration in:

File: /etc/ejabberd/ejabberd.cfg.

<pre class="config-file">
{hosts, ["localhost"]}.
</pre>

A Quick Guide for the erlang syntax for configuring ejabberd.cfg is shown at
the top of the file, in particular:

<pre class="screen-output">
%%%  - A tuple has a fixed definition, its elements are
%%%    enclosed in {}, and separated with commas:
%%%      {loglevel, 4}.
%%%
%%%  - A  list can have as many elements as you want,
%%%    and is enclosed in [], for example:
%%%      [http_poll, web_admin, tls]
...
%%%  - This term includes a tuple, a keyword, a list, and two strings:
%%%      {hosts, ["jabber.example.net", "im.example.com"]}.
%%%
</pre>

As per the documentation, another example, that we'll use through this guide
creates three domains to be supported by this server:

<pre class="config-file">
{hosts, ["example.com","example.net","example.org"]}.
</pre>

With the above domains, legitimate Jabber ID's samt@example.com will 
be different from samt@example.net

DNS configuration is discussed later.

<a name="ssl.encrypt"></a>

### Encrypting with SSL

At this point in the guide, if you start ejabberd you will likely
get something like the below **ERROR** in the log files 
/var/log/ejabberd/ejabberd.log

<pre class="screen-output">
exited: {"There is a problem in the configuration: 
		the specified file is not readable: /etc/ejabberd/myserver.pem",
       {ejabberd_app, start, [normal, []] } }
</pre>

This is documented in the pkg_readmes/ejabberd. The example configuration 
deployed with the package install of ejabberd in OpenBSD presumes that 
SSL keys have been created for client connections. 

Below we create the SSL keys and configure for deployment, deploying your SSL Configuration.

Check pkg_readmes/ejabberd

<a name="ssl.generate"></a>

#### Generate SSL Keys

Again, this part is well documented online, and in the pkg-readmes.
As an alternative, my instructions place the SSL certificates in what makes sense for my installs.

Use OpenSSL to generate keys.

<pre class="command-line">
# mkdir -p /etc/ssl/certs
# /usr/sbin/openssl req -new -x509 -newkey rsa:4096 -days 3650 \
       -keyout /etc/ssl/private/server.key \
	   -out /etc/ssl/certs/server.crt

# cp /etc/ssl/certs/server.crt /etc/ssl/server.pem
# /usr/sbin/openssl rsa -in /etc/ssl/private/server.key -out /etc/ssl/private/server.key.pem
# cat /etc/ssl/private/server.key.pem >> /etc/ssl/server.pem
</pre>

A few notes about the commands

- 	00 **/etc/ssl/certs**: We want to keep certificates in a directory, /etc/ssl/certs
- 	01 **req -new -x509 -newkey**: Generate the Private Key **server.key** and the self-signed certificate **server.crt**
- 	05 **/etc/ssl/server.pem**: Copy the CRT **server.crt** so we can add information about the key **server.key**
-	06 **/etc/ssl/private/server.key.pem**: Convert the Private Key to RSA output.
-	07 **/etc/ssl/server.pem**: Add the RSA Formatted Key information to the **server.pem** file

Effectively, we now have a single file which contains both the Certificate we serve to clients,
and the Private Key, used within the ejabberd daemon.

<a name="ssl.config"></a>

#### Configure SSL

&#91;File: /etc/ejabberd/ejabberd.cfg]

Configure the eJabberD server to use our generated certificates by
replacing the lines with "/etc/ejabberd/myserver.pem" specifying the PEM created
above: "/etc/ssl/server.pem"

<a name="startup"></a>

### Host Startup

&#91;File: /etc/rc.local]

To start ejabberd with each restart of the host, add something like the below to
the file: /etc/rc.local

<pre class="config-file">
if [ -x /usr/local/sbin/ejabberdctl ]; then
	echo -n ' ejabberd'; /usr/local/sbin/ejabberdctl start
fi
</pre>

<a name="run"></a>

## Running eJabberD

With the above configurations completed, we should be able to successfully start 
eJabberD without error messages.

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl start
<!--(end)-->

Verify ejabberd is working correctly by following the log files at /var/log/ejabberd/:

-	*ejabberd.log*, and 
-	*erlang.log* 

or by running ejabberd running in the foreground, such as:

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl live
<!--(end)-->

### Error Logs

{Ref: /var/log/ejabberd/[ejabberd.log,erlang.log]}.

ejabberd's log output are *erlang*ish(?) and not equivalent other logs 
I'm familiar with, but you do need to review them. Error and Warning messages
in the logs will quickly guide you to solving configuration and performance
errors.

 for any error messages that may give 
you a hint to why it may not be working as  you expect.

If you're log file doesn't exist, then it is likely that ejabberd did
not get far enough in the start up process to even begin logging.
You might find more information in the log files for erlang,
/var/log/ejabberd/erlang.log.

If the server is starting successfully, you will get a stream of messages
running through the standard log output.

Excerpt: /var/log/ejabberd/erlang.log

<pre class="config-file">
=PROGRESS REPORT==== ...
          supervisor:  { ... }
		     started:  [{ ...
			           }]
</pre>

Excerpt: /var/log/ejabberd/ejabberd.log

<pre class="config-file">
=INFO REPORT==== ...
I(<xxx>:ejabberd_listener:xxx) : Reusing listening port for xxxx
=INFO REPORT==== ...
I(<xxx>:ejabberd_listener:xxx) : ejabberd 2.1.6 is started in the node ejabberd@myhost
</pre>


<a name="restart"></a>

### Restart eJabberD

As we modify our configuration file, to get our server up and running
correctly, you must [restart ejabberd](#restart) after each change for that 
change to be enabled. To restart ejabberd, use something such
as the below:

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl restart
<!--(end)-->


<a name="admins"></a>

### Administration

Two methods are used for administrating your eJabberD server. 

-	The command-line tool **/usr/local/sbin/ejabberctl** and the 
-	web interface configured in the /etc/ejabberd/ejabberd.cfg.

#### ejabberctl

To use **ejabberctl**, the daemon server needs to be running. Once ejabberd is running,
you can get a quick outline of command-line options by executing ejabberdctl.

<pre class="command-line">
$ sudo /usr/local/sbin/ejabberdctl
</pre>
<pre class="screen-output">
Usage: ejabberdctl [--node nodename] [--auth user host password] command [options]

Available commands in this ejabberd node:
  backup 
  connected_users
  ...
  register user host password
  ...
  unregister user host
</pre>

The command pairs used during the install are register/unregister, and start/stop.

<a name="admin.web"></a>

#### Web Administration

{Ref: [Installation and Operation Guide](http://www.process-one.net/docs/ejabberd/guide_en.html#htoc77)}.

The default web interface will be at http://server-ip:5280/admin/ which is specified in the
configuration file as in the below:

Extract: /etc/ejabberd/ejabberd.cfg

<pre class="config-file">
{listen,
	[
	%% ... stuff left-out
		{5280, ejabberd_http, [
				captcha,
				http_bind,
				http_poll,
				web_admin
			]},
	%% ... stuff left-out
]}.
</pre>

In production, we can escalate our level of paranoia, by using https
for web connection instead of the clear-text http by adding an additional
port for web-administration as in the below example: 

Extract: /etc/ejabberd/ejabberd.cfg

<pre class="config-file">
{listen,
	[
	%% ... stuff left-out
		{{5282, "ip-address"}, ejabberd_http, [
				captcha,
				http_bind,
				http_poll,
				web_admin,
				tls, {certfile, "/etc/ssl/server.pem"}
			]},
	%% ... stuff left-out
]}.
</pre>

Once successful, you can replace the 5280 configuration with the 5282 SSL configuration.
The 5282 service, is http, but uses TLS (Transport Layer Security.)

[Restart eJabberD](#restart) to enable your new configuration.

The web interface is up and running, but we can't login until we've ensured the
accounts and passwords have been created.

<a name="user.accounts"></a>

### User Accounts

ejabberd provide two interfaces for creating, managing accounts:

- the ejabberdctl command-line, or
- web interface

{Ref: [Create a XMPP Account for Administration](
http://www.process-one.net/docs/ejabberd/guide_en.html#initialadmin)}.

Before we can administor our new server, we need to configure an Administrator
account.

- Specify Admin Account
- Create Accounts

<a name="admin.config"></a>

#### Specify Admin Account

We specify which user-accounts we want to have administration 
privileges through access controls in the configuration file: 
/etc/ejabberd/ejabberd.cfg.

Again, we're differentiating this documentation from the standard,
to let us think through the process. The example files will use
the acl **admin** and we're going to use **admins** (with an "s"
for plural)

Excerpt: /etc/ejabberd.cfg

<pre class="config-file">
{acl, admins, {user, "administrator", "example.org"}}.
{acl, admins, {user, "samt", "example.org"}}.
</pre>

We're specifying an acl named **admins**, of the type "user" with two users,
administrator@example.org, and samt@example.org.

<pre class="config-file">
{access, configure, [{allow, admins}]}.
{access, announce, [{allow, admins}]}.
{access, muc_admin, [{allow, admins}]}.
{access, c2s_shaper, [{none, admins}, {normal, all}]}.
{access, max_user_offline_messages, [{5000, admins},{100, all}]}.
</pre>

For the acl **admins** we are providing **access** privileges for the
modules configure, announce, muc_admin. For other modules that
allow options, we provide elevated privileges for admins.

Ooops, did my account samt@example.org also get **admins** access privileges?

[Restart ejabberd](#restart) to load changes into the running server.

<a name="admin.create"></a>

#### Create Accounts

From the above example, and using the demonstration account "administrator"
at Jabber Host "example.org"

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl register administrator example.org MyAdminPassword
$ sudo /usr/local/sbin/ejabberdctl register samt example.org MyOtherPassword
$ sudo /usr/local/sbin/ejabberdctl register samt example.net MyNetPassword
$ sudo /usr/local/sbin/ejabberdctl register samt example.com MyComPassword
<!--(end)-->

We've created 4 different accounts, 2 have been given **admins** privileges,
whilst the other 2 are just regular user accounts (although on different domains.)
(done)

#### Logging In

Before attempting use of a jabber client, we'll try to connect to our server through
the web interface. Our tests will be to the admin/ section of the interface. Use your
Internet Browser to connect to your server.

http://server-ip:5280/admin/

You're browser should prompt for a  username/password. Remember, you must use the full
jabber-id (username@domain). For example, my admin user details are: samt@example.org.

Excerpt: /var/log/ejabberd/ejabberd.log

<pre class="config-file">
=INFO REPORT==== ...
I(<xxx>:ejabberd_app:xxx) : ejabberd 2.1.6 is started in the node ejabberd@myhost

=INFO REPORT==== ...
I(<xxx>:ejabberd_listener:xxx) : (#Port<xxx>) Accepted connection {{client-ip},port} -> {{server-ip},5280}

=INFO REPORT==== ...
I(<xxx>:ejabberd_http:xxx) : started: {gen_tcp,#Port<xxx>>}
</pre>

An incorrect account creation may result in errors such as

<pre class="config-file">
=INFO REPORT==== ...
I(<xxx>:ejabberd_webadmin:xxx) : Access of "username@domain" from "client-ip" failed with error: "bad-password"

=INFO REPORT==== ...
I(<xxx>:ejabberd_webadmin:xxx) : Access of "username" from "client-ip" failed with error: "inexistent-account"
</pre>

The log entries seem mysterious, at first, but after isolating the "error/warning" messages. The errors
are mostly self-explanatory.

Client connection configuration is left as an exercise.

<a name="domain"></a>

## Domain Name Service (DNS)

{Ref: [Setting DNS SRV Records](http://www.jabberdoc.org/section05#5_7) [Fix DNS SRV](http://www.ejabberd.im/fix-dns-srv)}.

Remember that message after you installed the OpenBSD ejabberd server ?

<pre class="screen-output">
ejabberd-2.1.6p0: ok
Look in /usr/local/share/doc/pkg_readmes for extra documentation.
</pre>

Our installation at the moment will work, but client connections require manually
configuring the client's "server config." What we prefer, is that when a user 
enter's his/her name into their favourite Jabber/XMPP client (such as Jitsi) 
all they need to enter is their user-account name, and the client uses the DNS
record for example.org to find out where the ejabberd server is running.

If you have your domain name example.org resolving to the IP-Address of the
host running ejabberd, then you don't have to worry about DNS entries, 
otherwise, use the example from the jabberdoc's and pkg_readmes

<pre class="screen-output">
SRV records for your server can make your life easer. Example
records:
  _jabber._tcp.example.org.        SRV 5 0 5269 host.example.org.
  _xmpp-server._tcp.example.org    SRV 5 0 5269 host.example.org.
  _xmpp-client._tcp.example.org    SRV 5 0 5222 host.example.org.
</pre>
