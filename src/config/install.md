Syncback is comprised of two major components, a client side component for archiving configuration settings and
the server side component to aggregate and sanitise, archive changes.

## <a href="#client">Client Side Syncback</a>


The client tools provide snapshots of the client configuration 
retaining:

    * system information

    * configuration files

    * installed packages

    * custom tools (not incorporated by packages)

    * custom restoration script

    
## <a href="#server">Server Side Syncback</a>


The server side component is compromised of various items:

    - The syncback python script
    - The syncback configuration files
    - The syncback sanitation process

## <a name="client">Client Side Syncback</a>

### The syncback shell script


The syncback shell script is current called:
    
    - backup.configs.sh
    
Various earlier renditions it was called 

    - syncback.backup.sh 

### The syncback configuration files

The syncback configuration files are called:

    - /etc/backup.configs
    - /etc/syncback.localhost.exclude.conf
    
Earlier editions used

    - /etc/backup.conf (deprecated)

Various examples of the configurations are included below (please note that the script
fails without adequate errors if the last line is a blank line, i.e. ensure the last line is
<i>a valid path</i>.)

#### Sample OpenBSD configuration

<pre class="config-file">
/etc
/var/cron/tabs
/var/cron/atjobs
/var/cron/at.deny
/var/cron/cron.deny
/usr/local/sbin/backup.configs.sh
/home/aldo/.ssh/
/home/samt/.ssh/
/home/user3/.ssh/
</pre>

#### Sample Ubuntu Unix configuration

<pre class="config-file">
/etc
/var/spool/cron
/usr/local/sbin/syncback.backup.sh
/home/control/.ssh/
/home/aldo/.ssh/
/home/samt/.ssh/
/home/user3/.ssh/
</pre>

Linux archives also support excluding specific files that retain host specific configuration information (Unique Identifiers) that
can render restoration to a new machine unuseable.

file: /etc/syncback.localhost.exclude.conf

<pre class="config-file">
/etc/fstab
/etc/fstab.pre-uuid
/etc/iftab
/etc/blkid.tab
/etc/blkid.tab.old
/etc/X11
/etc/libvirt/qemu/networks/default.xml
/etc/lvm/cache
/etc/udev/rules.d/20-names.rules
/etc/udev/rules.d/60-persistent-storage.rules
/etc/udev/rules.d/70-persistent-net.rules
/etc/udev/rules.d/70-persistent-cd.rules
/etc/udev/rules.d/75-persistent-net-generator.rules
/etc/udev/rules.d/80-programs.rules
/etc/udev/rules.d/90-modprobe.rules
</pre>

### Cron Job to Automate runs

The syncback process needs root privileges to access and archive files and root's cron is the perfect
place for setting up automated runs of the process.

<pre class="config-file">
00      19      *       *       *       /bin/sh /usr/local/sbin/backup.configs.sh > /dev/null 2>&amp;1
</pre>

Referring to the source

$ !showsrc.py("../syncback/scripts/backup.configs.sh")!$

## <a name="server">Server Side Syncback</a>

### Server side

Install the python script on the central repository, refer to the README.INSTALL document for further
details.

EML's syncback central host is <b>sydctl001</b>

After installation, create the configuration file:

### Configuration File

The configuration file is at /etc/syncback.conf

$ !showsrc.py("../syncback/examples/config.py")!$


Syncback's README.INSTALL.

$ !showsrc.py("../syncback/README.INSTALL")!$


