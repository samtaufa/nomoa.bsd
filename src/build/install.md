## Standardised Install Notes

<div class="toc">

Table of Contents

<ol>
  <li><a href="#submit.dmesg">Submit DMESG</a></li>
  <li><a href="#packages">Packages</a></li>
  <li><a href="#user.accounts">User Accounts</a>
  <li><a href="#system.configuration">System Configuration</a>
      <ul>
          <li> <a href="#sc.newsyslog">newsyslog - Trim Log Files</a></li>
          <li> <a href="#sc.inetd">inetd.conf - Super Daemon</a></li>
          <li> <a href="#sc.pf">pf.conf - Firewall Config</a></li>
          <li> <a href="#sc.sshd">sshd_config - SSH Daemon</a></li>
          <li> <a href="#sc.ssh">ssh_config - ssh client config</a></li>
          <li> <a href="#sc.sysctl">sysctl.conf - System Knobs</a></li>
          <li> <a href="#sc.aliases">aliases - Mail Aliases</a></li>
      </ul></li>
  <li><a href="#auditing">Auditing</a>
      <ul>
          <li> <a href="#a.patch">Patch Review</a></li>
          <li> <a href="#a.nmapscan">nmap scan</a></li>
          <li> <a href="#a.package">Package checklist</a></li>
      </ul></li>
  <li><a href="#maintenance">Maintenance</a></a>
		<ul>
			<li><a href="#m.config.root">As Root</a>
				<ol>
					<li>Generate Package List</li>
					<li>Archive Configuration Files</li>
					<li>Archive Log Files</li>
				</ol>
			</li>
			<li><a href="#m.config.monitor">As Monitor</a>
			</li>
		</ul></li>
</ol>

</div>

&#91;Ref: [FAQ 4 - Installation Guide](http://www.openbsd.org/faq/faq4.html)]

#### <a name="submit.dmesg">Submit DMESG</a>

When you've completed an installation, support the project by submitting
a 'dmesg'

<blockquote>
<b>dmesg</b> displays the contents of the system message buffer.  It is most
commonly used to review system startup messages. It is also very useful 
to the project to get copies of system messages with each new release.
</blockquote>

<pre class="command-line">
(dmesg; sysctl hw.sensors) | mail -s "brand,make/model/cpu of machine" dmesg@openbsd.org
</pre>

or, if the machine does not have e-mail access then save the contents to
a file for sending.

#### <a name="packages">Packages</a>

&#91;Ref: [3. Packages](preview/packagemanagement.html)

Downloading packages for installation seems to be the biggest cause
for time delay during a system build process. But that doesn't mean
you need to mirror the full package tree. Once you've completed
your trial/test installations, you have a list of packages that 
are installed in your configuration (@ /var/db/pkg).

Improve deployment speed (reinstallations) by having your required
installation packages available locally either on the build CDs
or from a networked internal resource (use Apache, it's easier.) 

With packages available locally you can significantly decrease
your full build/restore process to 15 minutes or less.

##### Minimal | Common Configuration

Purposing of hosts differs, so there is no consistent set of tools that
are "appropriate" for each system. However, there are some tools that
might be appropriate for your maintainance of any given host. 

The following a tools that may or may not be useful on your hosts.
The goal is minimal functionality that can be audited (i.e. we can at least
keep tabs of published vulnerability reports.)

-   gnuwatch    - helps with monitoring 
-   nmap        - helps with diagnosing basic configuration, normally removed after
    installation testing is completed.
-   pstree      - helps visualise process states
-   rsync       - required for simplifying large/repetitive file transfers
-   vim no_x11  - Text Editor of choice (choose your own poison)
-   trafshow    - helps with monitoring traffic flow

As per previous section, having your tool selection available locally will 
significantly improve your productivity.

### <a name="user.accounts">User Accounts</a>

The install process asks whether a new user account should be created.

If you are learning OpenBSD, go ahead and create your user accounts 
during the install process, guided by the prompts.

The default settings for this account creation, doesn't fit our normal
user creation process, which we further discuss in the following pages.

- [User Administration documentation](install/useradmin.html).
- [Creating Users](install/usercreate.html)
- [Deleting Users](install/userdelete.html)

### <a name="system.configuration">System Configuration</a>

Things to maximise security and maintainability post production rollout.

#### <a name="sc.newsyslog"></a> newsyslog - Trim Log Files

&#91;Ref: $!manpage("newsyslog",8)!$]

Log files can be your single largest collection of 'growing' files.
Make sure you understand, know where it is stored on your system
(normally /var/log) and you maintain a vigilant watch over the
standard files, and application log files (e.g. Apache in base
will normally retain it's logs in /var/www/logs)

Today's large capacity drives have significant storage capacity 
for most server requirements, but everything is dependent on how
your log maintenance policies, data and log growth. 

Monitor this space.

The below sample works for my lazy approach to scripted scanning
of log files (simple cut-off dates 'monthly'.)

Edit: /etc/newsyslog.conf

<!--( block | syntax("apache") )-->
$!showsrc("build/newsyslog.conf")!$
<!--(end)-->

In the context on some of the servers we continue to manage, we
have additional/different entries such as the below:

For OpenBSD 4.0 ~ 4.6

<pre class="config-file">
/var/log/pflog                          600  12    *    $M1D0 ZB /var/run/pflogd.pid
</pre>

For OpenVPN Hosts

<pre class="config-file">
/var/log/openvpn/status _openvpn:_openvpn 644 12   *    $M1D0 Z
/var/log/openvpn/access _openvpn:_openvpn 644 12   *    $M1D0 Z
</pre>

The OpenVPN configuration updates, are related to standard changes we
make for log file locations in the OpenVPN Server.

#### <a name="sc.inetd"></a> inetd.conf

Remove all unnecessary services listed on inetd.conf.

Take a look at the services listed in inetd.conf and if you don't understand
what it is doing, look it up. If you don't need it, then disable it.
If you need the service, is there another way of securing the service
(such as authentication or data encryption.)

*   disable unnecessary ports | services started with *inetd* , 
    see /etc/inetd.conf
*   secure running services

<pre class="command-line">
grep -v "^#" /etc/inetd.conf | grep -v "^;" | grep -v "^$"
</pre>

On a clean OpenBSD install, the standard available services (to be cleaned) are:

<pre class="screen-output">
ident           stream  tcp     nowait  _identd /usr/libexec/identd     identd -el
ident           stream  tcp6    nowait  _identd /usr/libexec/identd     identd -el
127.0.0.1:comsat dgram  udp     wait    root    /usr/libexec/comsat     comsat
[::1]:comsat    dgram   udp6    wait    root    /usr/libexec/comsat     comsat
daytime         stream  tcp     nowait  root    internal
daytime         stream  tcp6    nowait  root    internal
time            stream  tcp     nowait  root    internal
time            stream  tcp6    nowait  root    internal
</pre>

Remove all service settings and only reconfigure services that are specifically
to be secured and used. Whether the removal of these services, provides any 
additional security is another debate for another forum.

In general, choose services that are secureable daemons with good security
practises, or set as local access only while another secure transport is used
for accessing the server (such as ssh or ssl tunnels.) For example, we
often use pop3 secured as below.

<pre class="command-line">
$ grep -v "^#" /etc/inetd.conf | grep -v "^;" | grep -v "^$"
</pre>
<pre class="screen-output">
127.0.0.1:pop3  stream  tcp     nowait  root    /usr/sbin/popa3d popa3d
</pre>

In the above example, pop3 is available only from the localhost (by
implication a user has to be authenticated onto the host before
they can gain access to pop3, which will again authenticate them.)

Restart the inetd daemon by passing a HUP signal.

<pre class="command-line">
sudo kill -HUP `cat /var/run/inetd.pid`
</pre>

Audit the above changes using the `grep' sequence of commands as well as
using 'nmap' discussed further below.

#### <a name="sc.pf"></a> pf.conf - Packet Filter Configuration

OpenBSD 4.6 and later releases enable the firewall by default. 

Remember to enable IP Forwarding if you intend to release this box as a  firewall.

Refer to the PF FAQ for current details: http://www.openbsd.org/faq/pf/index.html


##### audit - pfctl basic

Show status summary.

<pre class="command-line">
$ sudo /sbin/pfctl -s info | head -1
</pre>

<pre class="screen-output">
Status: Enabled for 45 days 13:33:13          Debug: Urgent
</pre>

Perform a syntax check.

<pre class="command-line">
$ sudo /sbin/pfctl -nf /etc/pf.conf
</pre>

Check any errors that may be displayed.

#### <a name="sc.sshd"></a> sshd_config - SSH Daemon

Release installations should:

* PermitRootLogin=No
* Use Public Keys, no interactive passwords?

File: /etc/ssh/sshd_config

<pre class="command-line">
$ grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"
</pre>

<pre class="screen-output">
Protocol 2
PermitRootLogin no
PasswordAuthentication no
Subsystem       sftp    /usr/libexec/sftp-server
</pre>

##### audit - sshd_config

There are a number of different things that can go wrong with your
sshd configuration that can potentially keep you off your box.
It is important to test remote boxes carefully before fully enabling
changes to your configuration file.

Check /var/log/authlog for current access behaviour.

If you are seeing "sshd[####]: Accepted password for ..."
then your sshd configuration
is using PasswordAuthentication and your user-account may
have a broken public-key/private-key combination.

Basic syntax configuration changes can be validated with the -t
command-line option

<pre class="manpage">
-t      Test mode.  Only check the validity of the configuration file and
         sanity of the keys.  This is useful for updating sshd reliably as
         configuration options may change.
</pre>

<pre class="command-line">
$ sudo /usr/sbin/sshd -t
</pre>

Other changes can have more subtle circumstances. For example,
do not disable password authentication until you are sure that the
public key authentication is working correctly.

Start sshd with the new configuration on another port with something
similar to the below

<pre class="command-line">
$ sudo /usr/sbin/sshd -ddd -p 9999
</pre>

SSHD is now running in the foreground to a user-defined port.
Track access behaviour in /var/log/authlog.

and try connecting to it from your workstation using

<pre class="command-line">
$ ssh -vvv -p 9999 server-name
</pre>

You can track

##### sshd - reload

Force sshd to reload it's configuration by sending it a SIGHUP signal

<pre class="command-line">
kill -HUP `cat /var/run/sshd.pid`
</pre>

#### <a name="sc.ssh"></a> ssh_config - ssh client config

Determine whether you want Agent Forwarding.
<pre class="command-line">
grep -i agent /etc/ssh/ssh_config
</pre>

<pre class="screen-output">
ForwardAgent yes
</pre>

#### <a name="sc.sysctl"></a> sysctl.conf - System Startup Knobs

&#91;Ref: $!manpage("sysctl.conf",5)!$, $!manpage("sysctl",8)!$ ]

Disable unnecessary features.

$!manpage("sysctl.conf",5)!$ contains Kernel State knobs that OpenBSD reads on startup
to set these kernel knobs. The kernel knobs can be manipulated at
run-time using the $!manpage("sysctl",8)!$

* IPv6 = off

If the host is intended as a gateway or firewall, make sure you enable the required
features.

File: /etc/sysctl.conf

<pre class="command-line">
sudo grep -v "^#" /etc/sysctl.conf
</pre>
<pre class="screen-output">
net.inet.ip.forwarding=1        # 1=Permit forwarding (routing) of IPv4 packets
</pre>

##### audit - sysctl.conf

The `only' way to validate the syctl.conf changes are functioning is to restart
the machine and verify each entry update is correct. For example, if the
above net.inet.ip.forwarding entry has been made, then after a restart
a successful change will show the following:

<pre class="command-line">
$ sudo sysctl net.inet.ip.forwarding
</pre>
<pre class="screen-output">
net.inet.ip.forwarding=1
</pre>


#### <a name="sc.aliases"></a> aliases - Mail Aliases

Configure _root_ mail to go to the designated monitoring team account,
in our configuration we use a special user account *__monitor* :

-   OpenBSD sendmail: /etc/mail/aliases
-   OpenBSD postfix: /etc/postfix/aliases

For example, ensure email for the 'root' account is delivered to the *__monitor* account
by editing the alias file as in the below.

<pre class="screen-output">
root:           **monitor**
</pre>

Rebuild the alias hash file using newaliases

-   OpenBSD sendmail: /usr/bin/newaliases
-   OpenBSD postfix: /usr/local/sbin/postalias /etc/postfix/aliases

##### aliases - audit

Prevalidation (without need for checking through the mail server) would include ensuring that
datestamps on the _aliases_ file are prior to the datestamps on the hash file.

<pre class="command-line">
$ ls -al /etc/postfix/aliases*
</pre>
<pre class="screen-output">
-rw-r--r--  1 root  wheel   8832 Oct 22 14:56 /etc/postfix/aliases
-rw-r--r--  1 root  wheel  65536 Oct 22 15:19 /etc/postfix/aliases.db
</pre>


<pre class="command-line">
$ sudo grep -v "^#" /etc/mail/aliases | grep -v "^$" | grep -v "^_" | grep -v "/dev/null"
</pre>
<pre class="screen-output">
MAILER-DAEMON: postmaster
postmaster: root
daemon:     root
ftp-bugs:   root
operator:   root
uucp:       root
www:        root
root:       __monitor
abuse:      root
security:   root
</pre>

### <a name="auditing">Auditing</a>

#### <a name="a.patch">Patch Review</a>

&#91;Ref: [Errata](http://www.openbsd.org/errata48.html) | 
[Current Changelog](http://www.openbsd.org/plus.html)

The best way of keeping tabs of security updates to the OpenBSD ecosystem
is to follow the [mailing lists](http://www.openbsd.org/mail.html).

The web interface for reviewing changes, are a smaller subset of
reported updates normally available in the web [Errata](
http://www.openbsd.org/errata48.html) and [Current Changelog](
http://www.openbsd.org/plus.html).

The Errata pages list updates (and where possible, patches) for Stable releases
of OpenBSD. The url/filename for errata pages are usually in the form
errataXY.html where XY is the major/minor version numbers.

For example:

-	[errata21.html](http://www.openbsd.org/errata21.html)
-	[errata35.html](http://www.openbsd.org/errata35.html)
-	[errata48.html](http://www.openbsd.org/errata48.html)

Changelogs show many of the machine-independent changes between the previous
release and the versioned release. This lists further service/application
specific updates that may be useful in your environment.

For example: 

-	[Current Changelog](http://www.openbsd.org/plus.html) normally has the changes between
	the latest "stable" release and current code development.
-	[plus49.html](http://www.openbsd.org/plus49.html) holds the changes between
    the OpenBSD 4.8 release and OpenBSD 4.9.
-	[plus20.html](http://www.openbsd.org/plus20.html) holds the changes between
    the OpenBSD 4.8 release and OpenBSD 4.9.
	
Note, that not all updates are listed on these pages. For a more complete
list of changes, you can follow the source code updates at source-changes,
or ports-changes [mailing list](http://www.openbsd.org/mail.html).

#### <a name="a.nmapscan">nmap scan</a>

External scan for open ports using nmap. There should be a clear rationale to why any specific port should be kept open.

<pre class="command-line">
$ sudo nmap -vv -A -P0  -d 10.9.10.100
</pre>
<pre class="screen-output">
Starting Nmap 4.53 ( http://insecure.org ) at 2008-06-26 12:48 EST
.--------------- Timing report ---------------
  hostgroups: min 1, max 100000
  rtt-timeouts: init 1000, min 100, max 10000
  max-scan-delay: TCP 1000, UDP 1000
  parallelism: min 0, max 0
  max-retries: 10, host-timeout: 0
.---------------------------------------------
[ ... ]
Host 10.9.10.100 appears to be up ... good.
Interesting ports on 10.9.10.100:
Not shown: 1713 closed ports
Reason: 1713 resets
PORT   STATE SERVICE REASON  VERSION
22/tcp open  ssh     syn-ack OpenSSH 4.8 (protocol 2.0)
MAC Address: 00:1D:09:F1:50:12 (Dell)
Device type: general purpose
Running: OpenBSD 3.X|4.X
OS details: OpenBSD 3.9 - 4.2
OS Fingerprint:
[ ... ]

Uptime: 0.000 days (since Thu Jun 26 12:48:52 2008)
Network Distance: 1 hop
TCP Sequence Prediction: Difficulty=256 (Good luck!)
IP ID Sequence Generation: Randomized
Final times for host: srtt: 281 rttvar: 290  to: 100000
</pre>

### <a name="a.package"></a> Package Checklist

<pre class="command-line">
$ pkg_info
</pre>
<pre class="screen-output">
bzip2-1.0.4         block-sorting file compressor, unencumbered
colorls-4.2         ls that can use color to display file attributes
curl-7.17.1         get files from FTP, Gopher, HTTP or HTTPS servers
gettext-0.16.1      GNU gettext
gnupg-1.4.8         GNU privacy guard - a free PGP replacement
gnuwatch-3.2.7      GNU watch command
libdnet-1.10p2      portable low-level networking library
libiconv-1.9.2p5    character set conversion library
libidn-1.1          internationalized string handling
lua-5.1.2p1         powerful, light-weight programming language
lzo-1.08p1          portable speedy lossless data compression library
multitail-5.0.5     multi-window tail(1) utility
mutt-1.5.17p0       tty-based e-mail client, development version
nmap-4.53           scan ports and fingerprint stack of network hosts
pcre-7.6            perl-compatible regular expression library
pstree-2.27         list processes as a tree
python-2.5.2        interpreted object-oriented programming language
qdbm-1.8.77         high performance embedded database library
rsync-2.6.9         mirroring/synchronization over low bandwidth links
screen-4.0.3p1-static multi-screen window manager
vim-7.1.244p0-no_x11 vi clone, many additional features
wget-1.10.2p1       retrieve files from the web via HTTP, HTTPS and FTP
zsh-4.3.5           Z shell, Bourne shell-compatible
</pre>


### <a name="maintenance"></a> Maintenance

The following are really of no value outside of how I'm doing things, but
I'm putting it together here, because it simplifies my list of things
to review (this one document)

A basic host maintenance configuration, will include archiving:

-   Configuration Files
-   Logs

We handle the above archiving process through a set of scripts that are
executed either as the 'root' user, or as the special 'monitor' account
that we use explicitly for maintenance, monitoring.

#### <a name="m.config.root"></a> As Root

The scripts that we execute as the 'root' user can be automated through
root's cron as in the below:

- Generate a current Package List
- Archive Configuration Files
- Archive Logs

<pre class="config-file">
50  18  *  *  *  /bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
00  19  *  *  *  /bin/sh /usr/local/sbin/backup.configs.sh > /dev/null 2>&amp;1
10  19  *  *  *  /bin/sh /usr/local/sbin/archlogs > /dev/null 2>&amp;1
</pre>


##### Generate a Package List

We maintain a text file list of installed packages in /etc,
so that we can backup this information together with standard
configration file settings.

This text file is used in our Configuration Management approach
to ensure:

-   Local copies of packages related to this host install
    are maintained.
-	Building a Restoration ISO can be scripted to include
    packages from the Package List.
-   Restoration of this host can be scripted (this support
    allows for scrpted re-installation of packages.)

<pre class="command-line">
/bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
</pre>

On a daily schedule, we generate a list of installed packages.

##### Archive Configuration Files

In our *simplified approach* to [configuration management](../config.html), a basic 
script is executed by 'root' to archive files in configuration
paths, such as /etc.

Review our Configuration Archiving for futher details of this
related approach.

-	/var/syncback
-   /usr/local/sbin/backup.configs.sh
-   /etc/backup.configs
-   /etc/backup.configs.exclude

Path: /var/syncback

The destination directory for the archives.

File: /etc/backup.configs

-	Is a line-separated list of files or directories to be archived.

File: /etc/backup.configs.exclude

-	Is a line-separated list of files or directories, not to be archived.

File: backup.configs.sh

<!--(block | syntax("bash") )-->
$!showsrc("build/install/backup.configs.sh")!$
<!--(end)

The sample script may be a bit too verbose, cut it down for your own
needs.

##### Archive Log Files

Install and review the **archlog** script

File: archlogs

<!--(block | syntax("apache") )-->
$!showsrc("build/install/archlogs")!$
<!--(end)-->

The sample script may be a bit too verbose, cut it down for your own
needs.

#### <a name="m.config.monitor"></a> **monitor's cron**


<!--(block | syntax("apache"))-->
20  19  *  *  *  /bin/sh /usr/local/sbin/backup.peer.configs.sh > /dev/null 2>&amp;1
<!--(end)-->

Basic **monitor** user configuration includes maintaining current state of peer
hosts not accessible from other hosts. The backup.peer.configs.sh script is
responsible for hosts hidden behind this host (such as CARP peers without
accessible IP addresses, or hosts behind a firewall.)

<!--(block | syntax("bash"))-->
$!showsrc("build/install/backup.peer.configs.sh")!$
<!--(end)-->