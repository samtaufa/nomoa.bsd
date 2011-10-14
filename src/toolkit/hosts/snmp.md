# SNMP - Simple Network Management Protocol

&#91;Ref: OpenBSD 4.9 net-snmp 5.6.1]

<!--(block|syntax("bash"))-->
pkg_add net-snmp-5.6.1.tgz
<!--(end)-->
<pre class="screen-output">
To have snmpd start at boot time, you must edit /etc/snmp/snmpd.conf
and add the following lines to /etc/rc.local:

if [ -ex /usr/local/sbin/snmpd ]; then
    echo -n ' snmpd';  /usr/local/sbin/snmpd
fi

This will start snmpd and use /etc/snmp/snmpd.conf for the configuration.
The snmpconf tool can be used to help edit your configuration files. See
snmpconf(1), snmpd(8), and snmpd.conf(5) for more options.
</pre>

&#91;Ref: OpenBSD 5.0 net-snmp 5.7p0]

<!--(block|syntax("bash"))-->
pkg_add net-snmp-5.7p0.tgz
<!--(end)-->
<pre class="screen-output">
The following new rcscripts were installed: /etc/rc.d/netsnmpd /etc/rc.d/netsnmptrapd
</pre>

Note that the 5.0 package release radically changes where configuration files will be
stored relative to 4.9.

Preliminary notes before I can draft up 'something'

[README.snmpv3](http://www.net-snmp.org/docs/README.snmpv3.html)

There's a readme file for SNMPv3. We want to use SNMPv3 exclusively, so 
let's just do it that way, [read the docs](http://www.net-snmp.org/docs/readmefiles.html).

## Configuration

Create a basic configuration for you system using *snmpconf*, backup

## User Accounts

<!--(block|syntax("bash"))-->
net-snmp-config --create-snmpv3-user -a "rwUserPassword" rwUserName
<!--(end)-->
<pre class="screen-output">
adding the following line to /var/net-snmp/snmpd.conf
   createUser rwUserName MD5 "rwUserPassword" DES
adding the following line to /usr/local/share/snmp/snmpd.conf
   rwuser rwUserName
</pre>

<!--(block|syntax("bash"))-->
net-snmp-config --create-snmpv3-user -ro -a "roUserPassword" roUserName
<!--(end)-->
<pre class="screen-output">
adding the following line to /var/net-snmp/snmpd.conf
   createUser roUserName MD5 "roUserPassword" DES
adding the following line to /usr/local/share/snmp/snmpd.conf
   rouser roUserName
</pre>

Start/Re-Start SNMPD

<!--(block|syntax("bash"))-->
/usr/local/sbin/snmpd
<!--(end)-->

Verify/Test the account is activated correctly
