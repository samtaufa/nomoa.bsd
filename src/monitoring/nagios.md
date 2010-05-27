## Network monitoring with Nagios and OpenBSD

Required components for a full install of nagios is available in OpenBSD packages (4.4 stable with Nagios 3.x used in one install.)

<strong>Warning</strong> there seems to be 3 active major release of nagios v1, v2, v3. Google is probably not going to help with reference documentation by users not specific about the versions they are describing.

To be safe: Reference the <a href="http://nagios.sourceforge.net/docs/">Project Docs</a>


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

[ref: <a href="http://www.kernel-panic.it/openbsd/nagios/">Network monitoring with Nagios and OpenBSD</a>] is not specific about the version of OpenBSD or Nagios it is using and due to some errors from following the guid implies that possibly Nagios 2.x was used.
