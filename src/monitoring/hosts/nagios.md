# Network monitoring with Nagios and OpenBSD

&#91;Ref: OpenBSD 5.0, Nagios 3.3.1, [Nagios Core 3.x Manuals](http://nagios.sourceforge.net/docs/nagioscore/3/en/toc.html)]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#install">Install</a>
		<ul>
			<li><a href="#basics">Basics</a></li>
		</ul>
	</li>
	<li><a href="#gui">Graphical Interface</a>
		<ul>
			<li>Securing Transport</li>
			<li>User</li>
		</ul>
	</li>
	<li><a href="#config">Configuration</a>
		<ul>
			<li><a href="#contacts">Contact Details</a></li>
			<li><a href="#hosts">Hosts</a></li>
			<li><a href="#services">Services</a></li>
			<li><a href="#groups">Groups</a></li>
		</ul>	
	</li>
	<li><a href="#snmp">SNMP</a>
	</li>
</ol>

</div>

After you've hounded the web for how to install and configure Nagios for
your system, make sure to check-out the definitive documents from
the [Project Docs](http://nagios.sourceforge.net/docs/) Take careful 
note that many documents you get on the internet may refer to older
versions of the software and will likely not work with your install

<a name="install"></a>

## Install

Install the binary package of your choice from Packages.

<pre class="command-line">
pkg_add nagios-web-3.3.1-chroot
</pre>

The install process will copy the files to your system and configure
them in at least the following areas:

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>/var/www/etc/nagios</td>
		<td>
		<p>Configuration Files.</p>
		
		In General, the main configuration file nagios.cfg is in the root, and item specific
		files in in the sub-directory /objects.
		</td>
	</tr>
	<tr>
		<td>nagios.cfg</td>
		<td>
		The default configuration file loaded by Nagios, *nagios.cfg* is in the root, 
		and item specific files in in the sub-directory /objects.
		</td>
	</tr>	
	<tr>
		<td>/var/www/nagios</td>
		<td>WWW Nagios Files</td>
	</tr>
	<tr>
		<td>/var/www/cgi-bin/nagios</td>
		<td>WWW CGI BIN Nagios Files</td>
	</tr>
	<tr>
		<td>/usr/local/libexec/nagios</td>
		<td>Utilities executed by Nagios to check things,
		such as check_icmp, check_http</td>
	</tr>
	<tr>
		<td>/usr/local/share/examples/nagios</td>
		<td>Further example configuration files</td>
	</tr>
</table>

In addition, we will create our Apache configuration in the following path.

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>/var/www/conf/modules</td>
		<td>Apache is configured to load all files in this directory as part
		of it's configuration. We will $!manpage("ln",1)!$ our configuration file
		into this path from /var/www/conf/modules.sample</td>
	</tr>
</table>

It is important that you note all the packages that are installed,
and ensure you complete the package install instructions.

To ensure that nagios is launched at each restart of your host,
refer the install screen-output, and update your rc.conf.local 
file to include something such as the below: $!manpage("rc.d",8)!$,
$!manpage("rc.conf",8)!$

File: /etc/rc.conf.local

<pre class="config-file">
pkg_scripts="nagios"
</pre>

<a name="basics"></a>

### Basics

Before we start looking at changing the configuration settings for Nagios,
some basic commands for starting and stopping nagios services.

- [Syntax Check](#syntax)
- [Log Review](#log)
- [Stop](#stop)
- [Start](#start)
- [Basic Configuration](#basic.config) 

<a name="syntax"></a>

#### Syntax Check

After/when making changes, you can make a quick check whether Nagios
'accepts' the syntax of your configuration.

<pre class="command-line">
/usr/local/sbin/nagios -v /var/www/etc/nagios/nagios.cfg
</pre>

Take care with the screen-output and resolve errors, where possible
solve the warning messages as well.

<a name="log"></a>

#### Log Review

Our install logs output to /var/log/nagios/nagios.log.

<!--(block|syntax("bash"))-->
egrep "(^log_|^debug)" /var/www/etc/nagios/nagios.cfg
<!--(end)-->

<pre class="screen-output">
log_file=/var/log/nagios/nagios.log
...
debug_level=0
debug_verbosity=1
debug_file=/var/nagios/nagios.debug
</pre>

It is important during the install, and system checks that you monitor the log file
and consider increasing the *debug_level*.

Another important file is the status file, which (?) contains the current
evaluation by nagios of our configuration files:

<!--(block|syntax("bash"))-->
grep ^status_ /var/www/etc/nagios/nagios.cfg
<!--(end)-->
<pre class="screen-output">
status_file=/var/nagios/status.dat
</pre>

<a name="stop"></a>

#### Stop

Once everything's running Nagios can be start/stopped using the web interface, 
but even with that option the command-line is quite straight forward.

To stop Nagios:

<pre class="command-line">
kill -KILL `/usr/bin/head -1 /var/run/nagios/nagios.pid`
</pre>

<a name="start"></a>

#### Start
To start Nagios:

<pre class="command-line">
/usr/local/sbin/nagios -d /var/www/etc/nagios/nagios.cfg
</pre>

To manage start | stop from the [GUI user interface](#gui), 
select the "Process Info" link for all available options.

<a name="restart"></a>

#### Restart

Restart Nagios by $!manpage("kill",1)!$ sending it the *HUP* - Hang Up
signal to reload it's configuration file:

<pre class="command-line">
kill -HUP `/usr/bin/head -1 /var/run/nagios/nagios.pid`
</pre>

<a name="basic.config"></a>

#### Basic Configuration

As noted above, the default/sample configuration for Nagios execution
is in /var/www/etc/nagios.

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>ngaios.cfg</td>
		<td>
		The default configuration file loaded by Nagios, *nagios.cfg* is in the root, 
		and item specific files in in the sub-directory /objects.
		</td>
	</tr>
	<tr>
		<td>
			cgi.cfg
		</td>
		<td>
		Configuration for the Web Interface.
		</td>
	</tr>
	<tr>
		<td>
			objects/*.cfg
		</td>
		<td>
		Configuration files defining object attributes and behaviour.
		</td>
	</tr>
</table>

We review more specifics on the [web configuration](#gui) settings [below](#gui),
and delve here into some basics about the other Nagios configuration settings.
The broad breakdown of the configuration files is:

-	[nagios.cfg](#nagios.cfg) loads the other configuration files
-	[objects/](#objects) stores config files for nagios objects
-	[templates](#templates) are definitions of objects, that can
	be re-used by other objects.

In essence, you could have all your configuration in one text file
that rules them all(tm) and we choose to break them up for our own
aesthetics. Choose your object filenames for what fits best for
your configuration.

For a graphical visualisation of how an example [configuration's files
are inter-related](http://nagios.sourceforge.net/download/contrib/documentation/misc/config_diagrams/nagios-config.png)
 refer to the list of [diagrams at the Nagios Wiki](http://wiki.nagios.org/index.php/Charts_%26_Diagrams).

<a name="nagios.cfg"></a>

##### nagios.cfg

&#91;Ref: [Nagios Core - Main Configuration File Options](http://nagios.sourceforge.net/docs/nagioscore/3/en/configmain.html)]

The sample nagios.cfg file is well documented and is used
to reference (load) other configuration files.

<pre class="command-line">
grep -v "^#" /var/www/etc/nagios/nagios.cfg | grep ".cfg"
</pre>
		
<pre class="screen-output">
cfg_file=/etc/nagios/objects/commands.cfg
cfg_file=/etc/nagios/objects/contacts.cfg
cfg_file=/etc/nagios/objects/timeperiods.cfg
cfg_file=/etc/nagios/objects/templates.cfg
cfg_file=/etc/nagios/objects/localhost.cfg
resource_files=/etc/nagios/resource.cfg
</pre>		

*cfg_file* specifies an [object configuration file](http://nagios.sourceforge.net/docs/nagioscore/3/en/configobject.html)
containing object definitions (hosts, host groups, contacts, contact groups,
services, commands, etc.)

Get more information about the parameters through reading
the comments in the configuration file, or documentation.

<a name="objects/"></a>

##### objects

Objects, as referenced in the above example is separated into
files that generally identify the objects defined within them.

But, the examples also show you in *localhost.cfg* that you can
have a multitude of *object* types within a single file.

<a name="templates"></a>

##### Templates

&#91;Ref [Object Inheritance](http://nagios.sourceforge.net/docs/nagioscore/3/en/objectinheritance.html) 
[Object Definitions](http://nagios.sourceforge.net/docs/nagioscore/3/en/objectdefinitions.html)]

Nagios objects support inheritance, such that one practical use
of inheritance is to use *incomplete* object definitions as the
foundation (pre-defined defaults) on which to complete your *object*.

By default, all Nagios objects are *registered*, to use a partially defined
(incomplete) object then use

<pre class="config-file">
	register			0		; DONT REGISTER - ITS NOT A REAL XXXX, JUST A TEMPLATE
</pre>

The basic install stores a good number of templates (incomplete objects) in the config
file *objects/templates.cfg*, but it can be in any of your configuration files.
Because of *inheritance*, any object can be used as the foundation for customisation
for a new object.

For example, the template for *openbsd-server*

File: /var/www/etc/nagios/objects/templates.cfg

<pre class="config-file">
define host{
	name					openbsd-server
	use						generic-host
	check_period			24x7
	check_interval			5		; check every 5 minutes under normal conditions
	retry_interval			1		; check the service every ONE minute until a hard state can be determined
	max_check_attempts		10
	check_command			check-host-alive
	notification_period		workhours
	notification_interval	120
	notification_options	d,u,r	; send notifications about down, unknown, recovery events
	contact_groups			admins
	register				0		; DONT REGISTER - ITS NOT A REAL HOST, JUST A TEMPLATE
	}
</pre>

The *openbsd-server* template, extends or specifies particular details extending
the template *generic-host*, through the keyword *use*

<pre class="config-file">
	use						generic-host
</pre>

Identify the object instance through the property: *name*

<pre class="config-file">
	name					openbsd-server
</pre>

Each template *name* must be unique amongst objects of the same type.

<pre class="config-file">
	notification_period		workhours
</pre>

As with the *use* keyword, several parameters can reference other objects,
and one in particular that is important for our basic install, is the
*notification_period workhours* which is defined elsewhere. 

<pre class="screen-output">
<strong>notification_period:</strong> 	... the short name of the time period during which notifications 
of events for this host can be sent out to contacts. If a host goes down, becomes unreachable, or recoveries 
during a time which is not covered by the time period, no notifications will be sent out.
</pre>

So, it's important for our test install because we need to know that
*notifications* (whatever that is) isn't going to work if we're outside
the notification_period.

File: /var/www/etc/nagios/objects/timeperiods.cfg

<pre class="config-file">
define timeperiod{
	timeperiod_name workhours
	alias			Normal Work Hours
	monday			09:00-17:00
	tuesday			09:00-17:00
	wednesday		09:00-17:00
	thursday		09:00-17:00
	friday			09:00-17:00
	}
</pre>
 
Below we show a template definition of the object type *service* and we note
two *service* objects: *ping-service* which we are defining below, and *generic-service*
which is defined elsewhere in the configuration file.

File: /var/www/etc/nagios/objects/templates.cfg

<pre class="config-file">
define service{
	name					ping-service
	use						generic-service
	normal_check_interval	5 		; check every 5 minutes under normal conditions
	retry_check_interval    1		; re-check the service every ONE minute until a hard state can be determined
	notification_options	w,u,c,r	; send notifications about warning, unknown, critical, recovery events
	register				0		; DONT REGISTER - ITS NOT A REAL SERVICE, JUST A TEMPLATE
	}
</pre>

Summary: Any *object* can be used as a template but in
particular, an object can be explicitly set as a template (i.e. not
usable directly) through the simple object item *register 0*:

<a name="gui"></a>

## Graphical Interface

The Nagios Graphical User Interface(GUI) is through a web system, and
we'll discuss configuring that using OpenBSD's default Apache Web Server.
There are dependencies required for the GUI to work, such as PHP, and
we'll expect that all of that was installed and configured successfully.
If you have problems with the GUI, you may need to review the installation
of the above dependencies whether you have configured them correctly.

The files for the nagios web interface are installed in /var/www/nagios **and**
/var/www/cgi-bin/nagios. To configure Apache to access the user-interface, 
we modify Apache's configuration such as the following:

File: /var/www/conf/modules.sample/nagios.conf

<pre class="config-file">
Alias /nagios/ "/var/www/nagios/"

&lt;Directory "/var/www/nagios">
	SetEnv TZ "Pacific/Tongatapu"
	Options Indexes MultiViews
	AllowOverride None
	Order allow,deny
	Allow from 127.0.0.1

	AuthName "Nagios Access"
	AllowOverride None
	AuthType Basic
	AuthUserFile /var/www/etc/nagios/web.password.file
	Require valid-user	
&lt;/Directory>

ScriptAlias /cgi-bin/nagios "/var/www/cgi-bin/nagios"

&lt;Directory "/var/www/cgi-bin/nagios">
	SSLRequireSSL
	Options ExecCGI
	Order allow,deny
	Allow from 127.0.0.1
	
	AuthName "Nagios Access"
	AllowOverride None
	AuthType Basic
	AuthUserFile /var/www/etc/nagios/web.password.file
	Require valid-user
&lt;/Directory>

</pre>		

<pre class="command-line">
ln -s /var/www/conf/modules.sample/nagios.conf /var/www/conf/modules/nagios.conf
</pre>

Because the GUI will expose some critical infrastructure, we'll partially
secure the system by locking it down to approved machines in the above
**Allow from 127.0.0.1**. Add your IP-Address here so you can look at the GUI.

After making the above changes and restarting Apache, you should be able to
view the base page (although no host status update/information will be
functional yet.)

### Securing Transport

To add more paranoia to securing our GUI Web interface, we'll enable SSL
for our nagios pages. Reviewing the OpenBSD/Apache configuration we find 
the 'default' file names for SSL Certificates.

<!--(block|syntax("bash"))-->
# grep ^SSLCertificate /var/www/conf/httpd.conf
<!--(end)-->

<pre class="screen-output">
SSLCertificateFile    /etc/ssl/server.crt
SSLCertificateKeyFile /etc/ssl/private/server.key
</pre>

Use OpenSSL to generate keys.

<pre class="command-line">
# /usr/sbin/openssl req -new -x509 -newkey rsa:4096 -days 3650 \
       -keyout /etc/ssl/private/server.key.protected \
	   -out /etc/ssl/server.crt
</pre>
<pre class="screen-output">
Generating a 4096 bit RSA private key
...  ++
writing new private key to '/etc/ssl/private/server.key.protected'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
</pre>

In OpenBSD, the above generates a private key that is pass phrase protected.
To generate a key without the pass phrase, we run the below command.

<pre class="command-line">
# /usr/sbin/openssl rsa -in /etc/ssl/private/server.key.protected -out /etc/ssl/private/server.key
</pre>
<pre class="screen-output">
Enter pass phrase for /etc/ssl/private/server.key.protected:
writing RSA key
</pre>

We can now use *httpd_flags="-DSSL"* in /etc/rc.conf.local to configure the startup
for our website.

Re/Start Apache using -DSSL (e.g. httpd -DSSL), for example:

<pre class="command-line">
# apachectl stop
# httpd -DSSL
</pre>

Our Nagios GUI is now available at https://nagios-host/nagios/, tightening up security access to
the site.

Unfortunately, when you go there now you will *again* not be given access to data at the site, and 
you will get pages with:

<pre style="color:red; font-weight:bold">
	It appears as though you do not have permission to view information of ...
</pre>

### Web Interface User

&#91;Ref: [CGI Configuration File Options](http://nagios.sourceforge.net/docs/nagioscore/3/en/configcgi.html)]

We want to configure at least one web user account to access the full 
features of the [Graphical User Interface](#gui), from there you can
decide on less featured web-accounts.

- Specify the nagios web user account, access privileges
- Create the web user account

The configuration file is specified in the nagios web file config.inc.php

<!--(block|syntax("bash"))-->
grep cgi_config_file /var/www/nagios/config.inc.php
<!--(end)-->
<pre class="screen-output">
$cfg['cgi_config_file']='/etc/nagios/cgi.cfg'; // location of the CGI config file
</pre>

The above reference is in the chrooted environment (because that's the package
we've installed, and the chroot base is /var/www

File: /var/www/etc/nagios/cgi.cfg

<pre class="config-file">
use_authentication=1
authorized_for_system_information=nagiosadmin, samt
authorized_for_configuration_information=nagiosadmin, samt
authorized_for_system_commands=nagiosadmin, samt
authorized_for_all_services=nagiosadmin, samt
authorized_for_all_hosts=nagiosadmin, samt
authorized_for_all_service_commands=nagiosadmin, samt
authorized_for_all_host_commands=nagiosadmin, samt
</pre>

The above lists some of the access control directives where
the default install posits a user-account *nagiosadmin*.
*cgi.cfg* has descriptive comments to clarify the purpose
of the above directives.

We need to specify a username/password that apache can 
authenticate (*use_authentication=1*) and pass to nagios.

<!--(block|syntax("bash"))-->
htpasswd -c /var/www/etc/nagios/web.password.file samt
<!--(end)-->
<pre class="screen-output">
New password:
Re-type new password:
Adding password for user samt
</pre>

We use "-c" at the first run to create the file, but then
afterwards no longer need it (i.e. for any further users.)

Please read the cgi.cfg comments for descriptions of the 
access controls and specify your users.

<a name="config"></a>

## Configuration

&#91;[Using Nagios to Monitor Networks](http://www.debian-administration.org/articles/299)]

After the basics for managing your Nagios configuration, we'll set up two
basic items, largely so we can see whether our installation is working.
The more complicated nature of your network is left as your exercise.

- [Contact Details](#contacts)
- [Hosts](#hosts) to Monitor
- [Services](#services) to Monitor

<a name="contacts"></a>

### Contact Details

We create contact details in Nagios, as separate from the
GUI User Interface, to specify details of whom and how to
contact people when Nagios detects various events relating
to the Systems (hosts, and or services) we are monitoring.

A basic config is as below

File: /var/www/etc/nagios/objects/contacts.cfg

<pre class="config-file">
define contact{
    contact_name                    samt
	use                             generic-contact
    alias                           Samiuela Taufa
    email                           samt@example.com
    pager                           &lt;my-mobile-number>
    }

define contact{
    contact_name                    fred
	use                             generic-contact
    alias                           Free Dom
    email                           fred@example.com
    pager                           &lt;fred-mobile-number>
    }
</pre>

*generic-contact* is a contact template (with *register* set to 0) defined 
in *templates.cfg* and gives us a "defined" set of contact settings,
which we use as the foundation of all settings for our contact, and then 
refine with our above specific settings.

Now, unless you really are paranoid and are doing this install
because you're the only System Administrator in your shop, then
you most likely have your "ownership" of servers separated between
different admins (contacts).

Because ownership of systems is generally divided into groups, we
now use a contactgroup that we can assign to events.

File: /var/www/etc/nagios/objects/contacts.cfg

<pre class="config-file">
define contactgroup{
    contactgroup_name   edge_admins
    alias               Edge System Administrators
    members             samt
}

define contactgroup{
    contactgroup_name   win_admins
    alias               Windows Administrators
    members             fred
}
</pre>

#### Update nagios.cfg

Ensure that our configuration updates are going to be loaded by nagios
during startup.

File: /var/www/etc/nagios/nagios.cfg

<pre class="config-file">
cfg_file=objects/contacts.cfg
</pre>

<a name="hosts"></a>

### Hosts to Monitor

We want to configure at least one host, so that we can see something
useful in our [Graphical User Interface](#gui)

Path: /var/www/etc/nagios/objects

To simplify things, from our perspective, we're going to start from scratch
with very basic host suport. To define a host to monitor, we need four
different configuration settings

- Host Definitions
- Host Groups

We'll use an existing template for now, and from there define two hosts 
to check, an OpenBSD box and a Windows box.

#### Host Definitions

File: /var/www/etc/nagios/objects/hosts.cfg

<pre class="config-file">
define host{
    use                     openbsd-server
    host_name               firewall
    alias                   Gateway Router
    address                 192.168.0.1
	contact_groups          edge_admins
    }
</pre>

*openbsd-server* template (a host object with *register* set to 0) is defined 
in *templates.cfg* and gives us a "packaged" set of host configuration settings,
which we use as the foundation of all settings for our host, and then 
refine with our above host specific configuration.

We've modified the *contact_groups* to be those we specified in our
*contactgroup* above, *edge_admins*.

Define our Windows Host to Monitor

File: /var/www/etc/nagios/objects/hosts.cfg

<pre class="config-file">
define host{
    use                     windows-server
    host_name               dc
    alias                   Active Directory Domain Controller
    address                 192.168.0.10
	contact_groups          win_admins
    }
</pre>

The *windows-server* template (a host object with *register* set to 0) is defined 
in *templates.cfg* and gives us a "packaged" set of host configuration settings,
which we use as the foundation for our host, and then refine above.

#### Update nagios.cfg

File: /var/www/etc/nagios/nagios.cfg

Ensure Nagios will read our above edited configuration files by verifying
they are specified in nagios.cfg

<pre class="config-file">
cfg_file=objects/hosts.cfg
</pre>

Use the [Syntax Check](#syntax) for a preliminary review if we've entered
our changes correctly. [Restart](#restart) Nagios to have changes take effect.

<a name="services"></a>

### Services to Monitor

&#91;Ref: [Service Definition](http://nagios.sourceforge.net/docs/nagioscore/3/en/objectdefinitions.html#service)]

After the above host definitions, we now specify the events to monitor.
The simplest thing to check is host availability through *ping*.

File: /var/www/etc/nagios/objects/services.cfg

<pre class="config-file">
define service {
	use						ping-service
	service_description		PING
	hostname				firewall, dc
	check_command			check_ping!500.0,40%!1000.0,70%
	first_notification_delay 1
	notification_interval	 720 		; minutes
	}
</pre>

The above service launches the *command object* (specified by check_command). 
This *command object* is defined in commands.cfg as in the below.

File: /var/www/etc/nagios/objects/commands.cfg

<pre class="config-file">
define command {
	command_name	check_ping
	command_line	$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5
	}
</pre>

$USER1$ ? is defined by the installation, whereas $HOSTADDRESS$ and $ARG1$, $ARG2$ 
is determined at runtime.

<!--(block|syntax("bash"))-->
grep "^\$USER" /var/www/etc/nagios/*
<!--(end)-->
<pre class="screen-output">
/var/www/etc/nagios/resource.cfg:$USER1$=/usr/local/libexec/nagios
</pre>

Our PING service uses *check_ping!500.0,40%!1000.0,70%* so we can use the specifications
in commands.cfg, and hosts.cfg to verify that the process will work:

*	$USER1$ is /usr/local/libexec/nagios,
*	$HOSTADDRESS$ is our *host* object *address* such as firewall:192.168.0.1; dc:192.168.0.10
*	Arguments are by "!" command!$ARG1$!$ARG2$

check_ping!500.0,40%!1000.0,70% *translates to the check_command* 

<!--(block|syntax("bash"))-->
$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5
<!--(end)-->

which becomes:

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping -H $HOSTADDRESS$ -w 500.0,40% -c 1000.0,70% -p 5
<!--(end)-->

becomes

<!--(block|syntax("bash"))-->
/usr/local/libexec/nagios/check_ping -H 192.168.0.1  -w 500.0,40% -c 1000.0,70% -p 5
/usr/local/libexec/nagios/check_ping -H 192.168.0.10 -w 500.0,40% -c 1000.0,70% -p 5
<!--(end)-->

Executed from the command-line, a success will show results such as the below:

<pre class="screen-output">
PING OK - Packet loss = 0%, RTA = 0.20 ms|rta=0.205000ms;500.000000;1000.000000;0.000000 pl=0%;47;70;0
</pre>

For more information on the format and execution of check_ping, launch the command at the 
command-line (likewise with other tools in the $USER1$ directory)

#### Update nagios.cfg

File: /var/www/etc/nagios/nagios.cfg

Ensure Nagios will read our above edited configuration files by verifying
they are specified in nagios.cfg

<pre class="config-file">
cfg_file=objects/services.cfg
</pre>

Use the [Syntax Check](#syntax) for a preliminary review if we've entered
our changes correctly. [Restart](#restart) Nagios to have changes take effect.

<a name="groups"></a>

### Groups

Use groups to help organise, simplifies reviewing large volumes of
data, and the configuration files themselves. We're defining
here 'edge-devices' and 'account-admin' which are just
categories for the servers to be listed within the group.

Service/Host Groups also have their own Categories on the 
web interface, so if you judiciously categorise your 
configuration, then you can visually drill through your
hosts/services.

File: /var/www/etc/nagios/objects/hostgroups.cfg

<pre class="config-file">
define hostgroup{
    hostgroup_name  edge-devices
    alias           Edge Devices
    contact_groups  edge_admins
	members			firewall
    }

define hostgroup{
    hostgroup_name  windows-admin
    alias           Account Admin Servers
    contact_groups  win_admins
	members			dc
    }
</pre>

File: /var/www/etc/nagios/objects/servicegroups.cfg

<pre class="config-file">
define servicegroup {
		servicegroup_name					edge-servicegroup
		alias								EDGE-Services
	}

</pre>

#### Update nagios.cfg

File: /var/www/etc/nagios/nagios.cfg

Ensure Nagios will read our above edited configuration files by verifying
they are specified in nagios.cfg

<pre class="config-file">
cfg_file=objects/hostgroups.cfg
cfg_file=objects/servicegroups.cfg
</pre>

#### Update Host/Service Definitions

Now that we have Groups we can allocate hosts/services to, we can specify
either at the group definition, or host definition whichever makes more
sense for you:

Where we have host definition, you can add a *hostgroups XXXX* and
where you we have service definitions, we can add a *servicegroups YYYY*
where

* XXXX is the hostgroup with hostgroup_name XXXX.
* YYYY is the servicgroup with servicegroup_name YYYY.

Use the [Syntax Check](#syntax) for a preliminary review if we've entered
our changes correctly. [Restart](#restart) Nagios to have changes take effect.

<a name="snmp"></a>

## SNMP - Simple Network Management Protocol

A sample configuration for SNMP is shown in the switches.cfg example file.


