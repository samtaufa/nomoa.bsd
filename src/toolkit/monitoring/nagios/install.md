# Install

&#91;Ref: OpenBSD 5.0, Nagios 3.3.1, [Nagios Core 3.x Manuals](http://nagios.sourceforge.net/docs/nagioscore/3/en/toc.html)]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#syntax">Syntax Check</a></li>
	<li><a href="#log">Log Review</a></li>
	<li><a href="#stop">Stop</a></li>
	<li><a href="#start">Start</a></li>
	<li><a href="#basic.config">Configuration</a>
	<ul>
		<li><a href="#nagios.cfg">nagios.cfg</a></li>				
		<li><a href="#objects">Objects</a></li>				
		<li><a href="#templates">Templates</a></li>				
	</ul>
	</li>
</ol>

</div>

Install the binary package of your choice from Packages. For our sample
configuration, we're going to choose the 'chroot' package which runs
within the chroot'd environment of OpenBSD's base Apache 1.3x release.

<pre class="command-line">
pkg_add nagios-web-3.3.1-chroot
</pre>

The install, will copy the files to your system and configure

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>/var/www/etc/nagios</td>
		<td>
		<p>Configuration Files.</p>
		
		In General, the file nagios.cfg is in this path root, and item specific
		files are loaded/linked from here. Most configuration options, references
        will be stored in the sub-directory */objects*.
		
		<p>Sample configuration files are copied into /usr/local/share/examples/nagios</p>
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

To complete configuration for Nagios, we will create our Apache 
configurations in the following path.

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

To launch nagios at each restart of your host,
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

&#91;Ref: [Verifying Your Configuration](http://nagios.sourceforge.net/docs/nagioscore/3/en/verifyconfig.html)]

After/when [making changes](http://nagios.sourceforge.net/docs/nagioscore/3/en/config.html), 
perform a quick check.

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

