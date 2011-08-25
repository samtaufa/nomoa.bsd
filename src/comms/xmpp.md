## Realtime Communications with XMPP

<div class="toc">

Table of Contents:

<ol>
	<li><a href="#install">Install</a>
		<ul>
			<li><a href="#domains">Jabber Domains</a></li>
			<li><a href="#ssl.encrypt">Encrypting with SSL</a>
				<ol>
					<li><a href="#ssl.generate">Generate SSL Keys</a></li>
					<li><a href="#ssl.config">Configure SSL</a></li>
				</ol>
			</li>
			<li><a href="#startup">Startup</a></li>
		</ul>
	</li>
	<li> <a href="#run">Running eJabberD</a>
		<ul>
			<li><a href="#restart">Restart eJabberID</a></li>
			<li><a href="#admin">Administration</a>
				<ol>
				<li><a href="#admin.web">Web Administration</a></li>
				</ol>
			</li>
			<li><a href="#user.accounts">User Accounts</a>
				<ol>
					<li><a href="#admin.create">Create Admin</a></li>
					<li><a href="#admin.config">Configure Admin</a></li>
				</ol>
			</li>
		</ul>
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
for OpenBSD.

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

<a name="install"></a>

## Install

&#91;DOC: [Installation and Operation Guide](http://www.process-one.net/docs/ejabberd/guide_en.html)]

OpenBSD packages provide the basic install. After the package install, we get an error message:

<pre class="screen-output">
ejabberd-2.1.6p0: ok
Look in /usr/local/share/doc/pkg_readmes for extra documentation.
</pre>

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

<a name="domains"></a>

### Jabber Domains

There are two aspects of domains important to the eJabberD server,

- Host Shortname
- Virtual Domains

#### Host Shortname

&#91;File: /etc/hosts]

Make sure that you have that the shortname *"/bin/hostname -s"* of the erlang 
host is resolveable. 

<pre class="config-file">
127.0.01	  localhost
::1			  localhost
ip-address    myhostname
</pre>

The hostname will be the node name.

#### Virtual Domains

eJabberD can serve XMPP for different (virtual) domains, 
specified with the **hosts** configuration.

<pre class="config-file">
{hosts, ["localhost"]}.
</pre>

The ["text"] is a list so you can have several "hosts" 
such as ["host1", "host2", ...]. The domains is associated 
to the Jabber ID, used by clients (the 2nd part of the Jabber ID, user@domain.)

The following line will create three Jabber Domains, such that you can now have
users for each Jabber Domain.

<pre class="config-file">
{hosts, ["example.com","example.net","example.org"]}.
</pre>

Jabber ID's samt@example.com will be different from samt@example.net

To configure DNS so Jabber clients can automatically point to the
host serving XMPP for the domain, refer to the readme file and
project documentation.

<a name="ssl.encrypt"></a>

### Encrypting with SSL

At this point in the guide, if you start ejabberd you will likely
get something like the below in the log files /var/log/ejabberd/ejabberd.log

<pre class="screen-output">
exited: {"There is a problem in the configuration: 
		the specified file is not readable: /etc/ejabberd/myserver.pem",
       {ejabberd_app, start, [normal, []] } }
</pre>

You can also run ejabberd with error outputs to the console using 

<!--(block|syntax("bash"))-->
/usr/local/sbin/ejabberctl live
<!--(end)-->

The example configuration deployed with the basic install of ejabberd
in OpenBSD presumes that SSL keys have been created for client 
connections. The below will look at creating the SSL keys and deploying
your SSL Configuration.

<a name="ssl.generate"></a>

#### Generate SSL Keys

Use OpenSSL to generate keys.

<!--(block|syntax("bash"))-->
# mkdir -p /etc/ssl/certs
# /usr/sbin/openssl req -new -x509 -newkey rsa:4096 -days 3650 \
       -keyout /etc/ssl/private/server.key \
	   -out /etc/ssl/certs/server.crt

# cp /etc/ssl/certs/server.crt /etc/ssl/server.pem
# /usr/sbin/openssl rsa -in /etc/ssl/private/server.key -out /etc/ssl/private/server.key.pem
# cat /etc/ssl/private/server.key.pem >> /etc/ssl/server.pem
<!--(end)-->

A few notes about the commands

- 	We want to keep certificates in a directory, /etc/ssl/certs
- 	Generate the Private Key **server.key** and the self-signed certificate **server.crt**
- 	Copy the CRT **server.crt** so we can add information about the key **server.key**
-	Convert the Private Key to RSA output to add to **server.pem**.
-	Add the RSA information to the server.PEM file

<a name="ssl.config"></a>

#### Configure SSL

&#91;File: /etc/ejabberd/ejabberd.cfg]

Configure the eJabberD server to use our generated certificates by
replacing the lines with "/etc/ejabberd/myserver.pem" specifying the PEM created
above: "/etc/ssl/server.pem"

<a name="startup"></a>

### Startup

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

Verify ejabber is working correctly by following the log file (/var/log/ejabberd/ejabberd.log)
or by running ejabberd running in the foreground, such as:

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl live
<!--(end)-->

The log messages are not equivalent to any other logs I've looked at,
but you do need to review them for any error messages that may give 
you a hint to why it may not be working as  you expect.

<a name="restart"></a>

### Restart eJabberD

Whenever you make changes to the server configuration file, 
ensure you restart the server for the configurations to be read.

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl restart
<!--(end)-->

<a name="admin"></a>

### Administration

Two methods are used for administrating your eJabberD server. The command-line
tool **/usr/local/sbin/ejabberctl** and the web interface configured in the
/etc/ejabberd/ejabberd.cfg.

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

To use **ejabberctl**, the daemon server needs to be running.

<a name="admin.web"></a>

#### Web Administration

&#91;Ref: [Installation and Operation Guide](http://www.process-one.net/docs/ejabberd/guide_en.html#htoc77)]

We can now administor the server using http://ejabberd-host:5280:/admin/
where the port-number 5280 is defined by setting for the listening **ejabberd_http** application.

Once you can successfully start your eJabberD server, and can connect
to your web interface, we can provide a more paranoid connection stream
to the web interface with the following configuration change.

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

Restart eJabberD to enable your new configuration.

The web interface is up and running, but we can't login until we've ensured the
accounts and passwords have been created.

<a name="user.accounts"></a>

### User Accounts

User accounts can be created at the web interface (if you have an admin account)
or with the command-line tool **/usr/local/sbin/ejabberctl** if you have **root**
access.

After starting ejabberd, create accounts in the following example:

<pre class="config-file">
/usr/local/sbin/ejabberdctl register user host password
</pre>

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl register samt example.org MyJabberPassword
<!--(end)-->

&#91;Ref: [Create a XMPP Account for Administration](http://www.process-one.net/docs/ejabberd/guide_en.html#initialadmin)]

Before we can administor our new server, we need to configure an Administrator
account.

- Create the Account
- Configure the Account

<a name="admin.create"></a>

#### Create Admin Account

From the above example, and using the demonstration account "administrator"
at Jabber Host "example.org"

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/ejabberdctl register administrator example.org MyAdminPassword
<!--(end)-->

We have the account for administration, but now need to configure
eJabberD to give the user account administrator@example.org admin privileges.

<a name="admin.config"></a>

#### Configure Admin Account

Configure eJabberD through file: /etc/ejabberd/ejabberd.cnf

<pre class="config-file">
{acl, admins, {user, "administrator", "example.org"}}.
{acl, admins, {user, "samt", "example.org"}}.
{access, configure, [{allow, admins}]}.
{access, announce, [{allow, admins}]}.
{access, muc_admin, [{allow, admins}]}.
{access, c2s_shaper, [{none, admins}, {normal, all}]}.
{access, max_user_offline_messages, [{5000, admins},{100, all}]}.
</pre>

-	The **acl** **a**ccess **c**ontrol **l**ist can be multiple lines, for
	multiple user-accounts with the **acl** named "admins". 
- 	The **access** configuration, with the access **configure**.

The above configuration adds "administrator@example.org" to the acl tag **admins** and 
privileges are set for specific modules: configure, announce, etc. 

Ooops, did my account samt@example.org also get **admins** access privileges?