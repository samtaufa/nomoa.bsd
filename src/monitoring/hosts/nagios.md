## Network monitoring with Nagios and OpenBSD

&#91;Ref: OpenBSD 4.4, Nagios 3.0.3]

Required components for a full install of nagios is available in 
OpenBSD packages

<strong>Warning</strong> there seems to be 3 active major release of nagios 
v1, v2, v3. Google is probably not going to help with reference documentation 
by users not specific about the versions they are describing.

To be safe: Reference the <a href="http://nagios.sourceforge.net/docs/">Project 
Docs</a>

### Package Install

<pre class="command-line">
pkg_add nagios-web-3.0.3-chroot
</pre>

Installs files in the following path:

<table>
	<tr>
		<th>Path</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>/var/www/etc/nagios</td>
		<td>
		<p>Configuration Files.</p>
		
		Within this path are the configuration files for Nagios.</td>
	</tr>
	<tr>
		<td>
			nagios.cfg
		</td>
		<td>

<pre class="command-line">
cd /var/www/etc/nagios
grep -v "^#" nagios.cfg | grep ".cfg"
</pre>
		
<pre class="screen-output">
cfg_file=/etc/nagios/objects/commands.cfg
cfg_file=/etc/nagios/objects/contacts.cfg
cfg_file=/etc/nagios/objects/timeperiods.cfg
cfg_file=/etc/nagios/objects/templates.cfg
cfg_file=/etc/nagios/objects/localhost.cfg
resource_files=/etc/nagios/resource.cfg
</pre>		
		</td>
	</tr>
	<tr>
		<td>/var/www/nagios</td>
		<td>WWW Nagios Files</td>
	</tr>
	<tr>
		<td>httpd.conf</td>
		<td>
Apache Configuration File:

<p>File: /var/www/conf/httpd.conf</p>

<p>Configure access to the Nagios WWW interface with something
like the following:</p>

<pre class="config-file">
Alias /nagios/ "/var/www/nagios/"

&lt;Directory "/var/www/nagios">
	Options Indexes MultiViews
	AllowOverride None
	Order allow,deny
	Allow from 127.0.0.1 ...
&lt;/Directory>

</pre>		
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
	</tr>
</table>

### Config Syntax Checking

<pre class="command-line">
/usr/local/sbin/nagios -v /var/www/etc/nagios/nagios.cfg
</pre>

#### Stopping and Starting Nagios

Once everything's running Nagios can be start/stopped using the web interface, but even with that option the command-line is quite straight forward.

To stop Nagios:
<pre class="command-line">
kill -HUP `/usr/bin/head -1 /var/run/nagios/nagios.pid`
</pre>

To start Nagios:
<pre class="command-line">
/usr/local/sbin/nagios -d /var/www/etc/nagios/nagios.cfg
</pre>

To manage start | stop from the user interface, select the "Process Info" link for all available options.

### Reference Install Guides

The nagios install on OpenBSD stores the documentation under the web path ./docs/. Once you understand the documentation style, it is rather comprehensive (but may assume you've already successfully completed an install.)

&#91;Ref: <a href="http://www.kernel-panic.it/openbsd/nagios/">Network monitoring with Nagios and OpenBSD</a>] is not specific about the version of OpenBSD or Nagios it is using and due to some errors from following the guid implies that possibly Nagios 2.x was used.
