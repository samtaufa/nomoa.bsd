## Standardised Install Notes

<div style="float:right">

<ul>
  <li><a href="#installation">Installation</a>
  <ol>
      <li> Partitioning
      <li> Packages
      <li> <a href="#submit.dmesg">Submit DMESG</a>
  </ol>
  <li><a href="#user.accounts">User Accounts</a>
  <ol>
      <li> User Shell
      <li> Groups
      <li> Passwords, SSH Public Keys
      <li> Sudoers
      <li> AuthPF
  </ol>
  <li><a href="#system.configuration">System Configuration</a>
  <ol>
      <li> Logs - newsyslog
      <li> inetd.conf
      <li> firewall / pf.conf
      <li> /etc/ssh/sshd
  </ol>
  <li><a href="#auditing">Auditing</a>
  <ol>
      <li> Patch Review
      <li> <a href="#nmapscan">nmap scan</a>
      <li> Package checklist
  </ol>
  <li><a href="#maintenance">Maintenance</a>
  <ol>
      <li> Syncback - Configuration Archiving
      <li> Log Archiving
      <li> System Status
      <li> Authentication Summaries
  </ol>
</ul>

</div>

<a name="installation"></a>

#### Partitioning

One concern with drive partitioning is stability of the system
when disk writes go out of control (e.g. log files grow) and 
recoverability. The increasing size of drives and time required 
to fsck large partitions makes the size of a partition an 
important issue.

The following is one guide to partitioning.

<table>
  <tr><th>Slice</th><th>Mount Point</th><th>Capacity</th><th>dump;fsck</th></tr>
  <tr>
      <td>a</td><td>/</td>
      <td>5G</td><td>(default)</td>
  </tr>
  <tr>
      <td>b</td><td>(swap)</td>
      <td>2G</td><td>~</td>
  </tr>
  <tr>
      <td>c</td><td>(disk-slice)</td>
      <td>(disk)</td><td>~</td>
  </tr>
  <tr>
      <td>d</td><td>/tmp</td>
      <td>4G</td><td>(default)</td>
  </tr>
  <tr>
      <td>e</td><td>/usr</td>
      <td>10G</td><td>(default)</td>
  </tr>
  <tr>
      <td>f</td><td>/home</td>
      <td>10G</td><td>(default)</td>
  </tr>
  <tr>
      <td>g</td><td>/var</td>
      <td>40G</td><td>(default)</td>
  </tr>
  <tr>
      <td>h</td><td>/storage</td>
      <td>(left-over)</td><td>0 0</td>
  </tr>
</table>

#### Packages

To improve speed of deployment, standard packages should be available 
on the install media, or from a networked internal resource. With
packages available on the install media, you can significantly decrease
your full restore process to 15 minutes or less.

##### Minimal | Common Configuration

This is the base set of applications for a system, we install on our
general service systems (i.e. hosts with only administrator local accounts.)
The goal is minimal functionality that can be audited (i.e. we can at least
keep tabs of published vulnerability reports.)

-   gnuwatch    - helps with monitoring 
-   nmap        - helps with diagnosing basic configuration, normally removed after
    installation testing is completed.
-   pstree      - helps visualise process states
-   rsync       - required for simplifying large/repetitive file transfers
-   vim no_x11  - Text Editor extrodinaire
-   trafshow    - helps with monitoring traffic flow

Obviously, the simplest thing is to have a directory with the listed packages and
any other dependencies. Make the files available on the install medium, a 'support'
medium, or on the LAN where the installation is built.

##### Alternate Server Configuration




#### <a name="submit.dmesg">Submit DMESG</a>

`dmesg` displays the contents of the system message buffer.  It is most
commonly used to review system startup messages.
     
<pre class="command-line">
(dmesg; sysctl hw.sensors) | mail -s "type of machine" dmesg@openbsd.org
</pre>

### <a name="user.accounts">User Accounts</a>

This process has expanded and is more completely detailed in the <a href="useradmin.html">User Administration documentation.</a>

### <a name="system.configuration">System Configuration</a>

Things to maximise security and maintainability post production rollout.

#### Log Files

A key priority is for all log files to be in a sane location, such as /var/log

##### newsyslog.conf

A 70GB should have significant storage capacity for between 6 to 12 months of log files. The higher the server disk space, the greater capacity for archiving log files.

Edit: /etc/newsyslog.conf

$!showsrc.plain("build/newsyslog.conf")!$

[refer: $!manpage("newsyslog",8)!$  for more information]


#### inetd.conf

Remove all unnecessary services listed on inetd.conf

* disable unnecessary ports | services started with _inetd_ , see /etc/inetd.conf
* secure running services

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
to be secured and used.

In general, services should be either secureable daemons with good security
practises, or set as local access only while another secure transport is used
for accessing the server (such as ssh or ssl tunnels.) For example, we
often use pop3 secured as below.

<pre class="command-line">
$ grep -v "^#" /etc/inetd.conf | grep -v "^;" | grep -v "^$"
</pre>
<pre class="screen-output">
127.0.0.1:pop3  stream  tcp     nowait  root    /usr/sbin/popa3d popa3d
</pre>

Restart the inetd daemon by passing a HUP signal.

<pre class="command-line">
sudo kill -HUP `cat /var/run/inetd.pid`
</pre>

Audit the above changes using the `grep' sequence of commands as well as
using `nmap' discussed further below.

#### pf.conf

By default, OpenBSD disables the firewall.

Remember to enable IP Forwarding if you intent to release this box as a  firewall.

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

#### sshd_config

Release installations should:

* PermitRootLogin=No
* Use Public Keys, no interactive passwords?

File: /etc/ssh/sshd_config

<pre class="command-line">
$ grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"
</pre>

<pre class="config-file">
Protocol 2
PermitRootLogin no
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

<pre class="screen-output">
    .-t      Test mode.  Only check the validity of the configuration file and
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

#### ssh_config

Determine whether you want Agent Forwarding.
<pre class="command-line">
grep -i agent /etc/ssh/ssh_config
</pre>

<pre class="screen-output">
ForwardAgent yes
</pre>

#### sysctl.conf

Disable unnecessary features.

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


#### aliases

Configure _root_ mail to go to the desginated monitoring team account alias _control_ :

-   OpenBSD sendmail: /etc/mail/aliases
-   OpenBSD postfix: /etc/postfix/aliases

For example, ensure email for the 'root' account is delivered to the _control_ account
by editing the alias file as in the below.

<pre class="screen-output">
root:           control
</pre>

Rebuild the alias hash file using newaliases

<ul>
  <li>OpenBSD sendmail: /usr/bin/newaliases
  <li>OpenBSD postfix: /usr/local/sbin/newaliases
</ul>

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
daemon: root
ftp-bugs: root
operator: root
uucp:   root
www:    root
root: control
abuse:          root
security:       root
</pre>

### <a name="auditing">Auditing</a>

#### <a name="nmapscan">nmap scan</a>

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

### Package Checklist

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

### Patch Review

Check appdata for the current stable releases of the installation and certify choices taken.

### <a name="maintenance">Maintenance</a>

-   Syncback - Configuration Archiving
-   Log Archiving
-   System Status
-   Authentication Summaries

General maintenance log archiving is pre-empted through various cron jobs.

#### ROOT's cron

<pre class="config-file">
50      18      *       *       *       /bin/ls -1 /var/db/pkg/ > /etc/packagelist.txt
00      19      *       *       *       /bin/sh /usr/local/sbin/backup.configs.sh > /dev/null 2>&amp;1
10      19      *       *       *       /bin/sh /usr/local/sbin/archlogs > /dev/null 2>&amp;1
</pre>

Basic root configuration includes maintaining current state of

- Installed Packages
- Syncback - Configuration Archiving
- Archiving Log Files
- System Status

#### Syncback - Configuration Archiving

Please review the syncback documentation for installing the Configuration Archiving Tools

- sbin/backup.configs.sh
- /etc/backup.configs

#### Archiving Log Files

Install and review the `archlog` script

#### System Status

Install and review the `sysstatus` script


#### Control's cron


<pre class="config-file">
20      19      *       *       *       /bin/sh /usr/local/sbin/backup.peer.configs.sh > /dev/null 2>&amp;1
</pre>

Basic CONTROL user configuration includes maintaining current state of
  
- Synchronised System States


Install and review the sysstatus script

#### Authentication Summaries

Install and review the authsummary script
