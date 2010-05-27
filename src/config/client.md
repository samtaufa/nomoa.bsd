## Client Side Tools


Syncback's client, configurations / tools provide snapshots of the client configuration 
retaining:

* system information

* configuration files

* installed packages

* custom tools (not incorporated by packages)

* custom restoration script

The script /usr/local/sbin/backup.configs is periodically run to collate 
the above information. Periodic execution is normally through __additional entries__ 
for '_root_'

<pre class="config-file">
50      18      *       *       *       /bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
00      19      *       *       *       /bin/sh /usr/local/sbin/backup.configs.sh > /dev/null 2>&amp;1
</pre>

To synchronise hosts hidden behind a firewall zone use
_backup.peer.configs.sh_ which is generally executed periodically through 
crontab entries for the _'$CONTROL' user account._

<pre class="config-file">
30      23      *       *       *       /bin/sh /usr/local/sbin/backup.peer.configs.sh 2> /dev/null
</pre>

### System Information

Basic information about the system are stored as text files in /etc.

<ul>
    <li>/etc/<a href="#myuname">myuname</a></li>
    <li>/etc/<a href="#packagelist">packagelist.txt</a></li>
    <li>/etc/<a href="#backup.configs">backup.configs</a></li>
    <li>/etc/backup.peer.name</li>
    <li>/etc/backup.peer.ip</li>
</ul>

Standard command-line installation commands

<pre class="command-line">
sudo /usr/bin/uname -a > /etc/myuname
sudo ls -1 /var/db/pkg > /etc/packagelist.txt

sudo chmod 644 /etc/myuname
sudo chmod 644 /etc/packagelist.txt
</pre>

<a name="myuname"></a>

#### myuname

This text-file contains standard system information that is used during the restoration process
to identify the below OS items

<ul>
    <li> OS Release (e.g. 4.4, 4.5, etc)
    <li> Machine (Architecture) Type (e.g. AMD, i386)
    <li> Hostname
</ul>

File is generated using:
<pre class="command-line">
sudo /usr/bin/uname -a > /etc/myuname
</pre>

<a name="packagelist"></a>

#### packagelist.txt

This text-file contains a line-separated list of "installed" packages. This list is used during the 
restoration process to ensure pristine copies of each package is installed.

File is generated in a recurring cron jobs using: 

<pre class="command-line">
/bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
</pre>

A cron entry would look something like the below

<pre class="config-file">
50      18      *       *       *       /bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
</pre>

<a name="backup.configs"></a>

#### backup.configs

This text-file contains a line-separated list of "files or directories" to be archived by the /usr/local/sbin/backup.configs.sh script


File: /etc/backup.configs

<pre class="config-file">
/etc
/var/cron/tabs
/var/cron/atjobs
/var/cron/at.deny
/var/cron/cron.deny
/usr/local/sbin/archlogs
/usr/local/sbin/authsummary
/usr/local/sbin/sysstatus
/usr/local/sbin/backup.configs.sh
/usr/local/sbin/backup.peer.configs.sh
/home/control/.ssh/
/home/userX/.ssh/
/home/userY/.ssh/
</pre>


#### backup.peer.name

_Applicable to CARP'd firewalls where the backup host may not be visible from the control host._

File will contain the `hostname -s` short name of the peer host.

#### backup.peer.ip

_Applicable to CARP'd firewalls where the backup host may not be visible from the control host._

File will contain the IP Address of the peer host, in general this will by the pfsync interface IP Address.


### Configuration Files

The location of configuration files are recorded in the above file /etc/backup.configs.

A Generic Base install of OpenBSD will store the majority of operational configuration files these listed folders, 

    - /etc
        
    - /var/cron/

<pre class="config-file">
/etc
/var/cron/tabs
/var/cron/atjobs
/var/cron/at.deny
/var/cron/cron.deny
/home/control/.ssh/
/home/userX/.ssh/
/home/userY/.ssh/
</pre>

Depending on the tools enabled, further configuration directories may be included such as custom
installations using:

    - Apache

<pre class="config-file">
/var/www/conf
/var/www/etc
/var/www/users
</pre>

    - Postfix

<pre class="config-file">
/var/spool/postfix/etc
</pre>

    - BIND 

<pre class="config-file">
/var/named/etc
/var/named/master
/var/named/slave
</pre>

The important issue is to be aware of the tools you are using to ensure that appropriate
configuration files are archived.

### Custom Tools (not incorporated by packages)

Custom tools can be anywhere in the file system, the key issue is to ensure that these files are accurately recorded (archived)
in the /etc/backup.configs text file.

For example: 
<pre class="config-file">
/usr/local/sbin/archlogs
/usr/local/sbin/authsummary
/usr/local/sbin/sysstatus
/usr/local/sbin/backup.configs.sh
/usr/local/sbin/backup.peer.configs.sh
</pre>

### Custom Restoration Scripts

Where custom configuration settings are required, it is best to record the 'creation' method in the file

<pre class="command-line">
/usr/local/sbin/dr-customisations.sh
</pre>

Customisations may include creating links, special directories and log files.

The above script will then be automatically executed (to complete any customisations) during a restore process for the 
host configuration.

Sample instructions may include:
<pre class="config-file">
#!/bin/sh

# if squid installed, initialise cache
if grep -q "squid" /etc/packagelist.txt ; then
    echo
    echo "Configure Script: Running 'squid -z' to initialise caches..."
    sleep 1
    squid -z
    echo "done."
fi

if grep -q "clamsmtp" /etc/packagelist.txt ; then
    echo
    echo "Configure clamsmtp"
    touch /var/log/clamd.log
    touch /var/log/freshclam.log
    chown _clamav:_clamav /var/log/clamd.log
    chown _clamav:_clamav /var/log/freshclam.log
    echo "done."
fi

if grep -q "python-3" /etc/packagelist.txt ; then
    echo
    echo "Configure python-3"
    ln -sf /usr/local/bin/python3 /usr/local/bin/python
    ln -sf /usr/local/bin/python3-config /usr/local/bin/python-config
    ln -sf /usr/local/bin/pydoc3  /usr/local/bin/pydoc
    echo "done."
fi

if grep -q "python-2.5" /etc/packagelist.txt ; then
    echo
    echo "Configure python-2.5"
    ln -sf /usr/local/bin/python2.5 /usr/local/bin/python
    ln -sf /usr/local/bin/python2.5-config /usr/local/bin/python-config
    ln -sf /usr/local/bin/pydoc2.5  /usr/local/bin/pydoc
    echo "done."
fi

if grep -q "python-2.6" /etc/packagelist.txt ; then
    echo
    echo "Configure python-2.6"
    ln -sf /usr/local/bin/python2.6 /usr/local/bin/python
    ln -sf /usr/local/bin/python2.6-config /usr/local/bin/python-config
    ln -sf /usr/local/bin/pydoc2.6  /usr/local/bin/pydoc
    echo "done."
fi

if [ -x /usr/local/sbin/postfix-vmail ]; then
    echo
    echo "Configure postfix vmail"
    /usr/local/sbin/postfix-vmail
    echo "done."
fi

if [ -x /usr/local/sbin/dr-postrestore.sh ]; then
    echo
    echo "Execute Post Restore Script"
    /usr/local/sbin/dr-postrestore.sh
    echo "done."
fi
</pre>
