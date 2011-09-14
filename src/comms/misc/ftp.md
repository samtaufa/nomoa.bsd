## Setting up the FTP Server

<div class="toc">

    Table of Contents
    
    <ul>
      <li><a href="#introduction">Introduction</a></li>
      <li><a href="#ftpLogin">Configure ftp Login</a>
      <ul>
        <li><a href="#configureShell">Configure the restricted Shell</a></li>
        <li><a href="#configureAccount">Configure the Account</a></li>
      </ul></li>
      <li><a href="#directory">Configure Directory ownership, permissions</a></li>
      <li><a href="#restrict">Restrict User Access</a>
      <ul>
        <li><a href="#restrictLoginConf">Restrict Using login.conf</a></li>
      </ul></li>
      <li><a href="#enable">Enable ftpd through /etc/rc.conf.local</a>
      <ul>
        <li><a href="#start">Starting at the command-prompt</a></li>
      </ul></li>
      <li><a href="#reference">Relative Reference</a>
      <ul>
          <li><a href="#otherLinks">Other Links</a></li>
      </ul></li>
      <li><a href="#author">Author and Copyright</a></li>
    </ul>
    
</div>

[ref. OpenBSD FAQ <a href="http://www.openbsd.org/faq/faq10.html">System Management</a> -&gt; <a href="http://www.openbsd.org/faq/faq10.html#AnonFTP">Setting up Anonymous FTP Services</a> |
[PF: Issues with FTP](http://www.openbsd.org/faq/pf/ftp.html)]
  
Security Warning: Default ftpd behaviour is to allow all users access to the 
root-directory, this can be a significant compromise. Use -A, anonymous access 
which is chroot to /home/ftp. Valid User accounts can be forced ftp access only 
to their home directories (eg. /home/janedoe)
  
Again: chroot is not the default behaviour of ftpd.

<b>Secure Alternative A</b> (also known as &quot;I've just discovered sftpserver&quot;)

Get your clients to use an ftp client that supports Secure FTP or sftp. OpenBSD 
delivers <a href="http://www.openssh.org">OpenSSH</a> (since 
2.6) which also has a component for secure ftp (sftp - unix client, sftpserver 
- unix server [since 2.9?].) If you require secure FTP then you will have the 
'features' of FTP together with the security of OpenSSH.
  
An Open Source Windows ftp client that supports sftp is [FileZilla](http://filezilla-project.org/) 
or commercial-ware GlobalScape's [CuteFTP](http://www.globalscape.com/products/ftp_clients.aspx)
  
<b>Secure Alternative B </b>(also known as, document what you've been using)

Although less interactive, and in my experience much slower than ftp, you can 
use a combination of <a href="http://www.openssh.org">OpenSSH</a>'s 
ssh client and scp (Secure Copy.) This is a reasonable alternative using character 
based Unix shells.
  
A number of MS Windows clients which I have used including 
<a href="http://winscp.vse.cz/">WinSCP</a>, <a href="http://www.chiark.greenend.org.uk/%7Esgtatham/putty/">Putty</a>, 
and <a href="http://i-tree.org/">iXplorer</a>. You could also 
go for commercialware from the originators, SSH Secure Shell at <a href="http://www.ssh.com">www.ssh.com.</a> 
For a more complete list of alternative clients please visit the <a href="http://www.openssh.org">OpenSSH</a> 
website.
  
### <a name="ftpLogin"></a>Configure ftp login

Before we can setup the ftp user account, we 1st need to configure the 'shell' 
we will allocate for anonymous users: /usr/bin/false.
  
#### <a name="configureShell"></a>Configure the Shell.

The /usr/bin/false is a short sh script that exits if any user attempts to 
connect to the system through the account. It is installed during the default 
installation but not included in /etc/shells, which provides the options for 
shells for user accounts.
  
File: /usr/bin/false

<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput">#! /bin/sh <br>
      # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CONTENTS 
      OF /usr/local/false<br>
      # $OpenBSD: false.sh,v 1.2 1996/06/26 05:32:50 deraadt Exp $ <br>
      <br>
      exit 1 </td>
  </tr>
</table>

Edit the file: /etc/shells and include a line to /usr/bin/false. Verify that 
false is in the /usr/bin directory. The /etc/shells file should end up looking 
similar to the below.

Edit: /etc/shells

<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput"># $OpenBSD: shells,v 1.5 1997/05/28 21:42:20 
      deraadt Exp $ <br>
      # List of acceptable shells for chpass(1). <br>
      # Ftpd will not allow users to connect who are not using <br>
      # one of these shells. <br>
      /bin/sh <br>
      /bin/csh <br>
      /bin/ksh <br>
      /usr/local/bin/bash </td>
  </tr>
  <tr> 
    <td nowrap class="Code"><b>/usr/bin/false</b> </td>
  </tr>
</table>

#### <a name="configureAccount"></a>Configure ftp account

Create the ftp account using &quot;<a href="installation.htm#adduser">adduser</a>&quot; 
with the below option, and a blank password.
  
<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput">User Name: <b>ftp<br>
      </b>Full Name:<b> <b>Anonymous FTP</b><br>
      </b>Shell:<b> <b>false</b> <br>
      </b>Login Group:<b> <b>ftp</b><br>
      </b>Invite to other Groups:<b> <b>No<br>
      </b></b>Enter Password []:<b><b> &lt;&lt;leave-blank&gt;&gt;<br>
      </b></b>Set the password so that user cannot logon? (y/n) [n]:<b><b> y</b></b></td>
  </tr>
</table>


### <a name="directory"></a>Configure ownership and permissions for directories

Change/ensure the ownership of the ftp root directory is owned by root, and 
files are read-only.
  
<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="Code"># <b>chown root.root /home/ftp</b><br>
      # <b>chmod 555 /home/ftp</b><br>
      # <b>mkdir /home/ftp/pub</b><br>
      # <b>chmod 555 /home/ftp/pub</b></td>
  </tr>
</table>

We change the mode to readonly execute, so people can traverse directories 
and read the files but cannot delete or move files.

From the man pages (and FAQ,) the below are suggested directories, but are 
<b>not required</b> for the server to operate.

<table width="95%" border="1">
  <tr> 
    <td nowrap valign="top">~/ftp/bin</td>
    <td>Make this directory owned by &quot;root&quot; and unwritable by anyone 
      (mode 511). This directory is optional unless you have commands you wish 
      the anonymous ftp user to be able to run (the ls(1) command exists as a 
      builtin). Any programs in this directory should be mode 111 (executable 
      only)</td>
  </tr>
  <tr> 
    <td nowrap valign="top">~/ftp/etc</td>
    <td>Make this directory owned by &quot;root&quot; and unwritable by anyone 
      (mode 511). The files pwd.db (see pwd_mkdb(8)) and group(5) must be present 
      for the ls command to be able to produce owner names rather than numbers. 
      The password field in pwd.db is not used, and should not contain real passwords. 
      The file motd, if present, will be printed after a successful login. These 
      files should be mode 444</td>
  </tr>
  <tr> 
    <td nowrap valign="top">~/ftp/pub</td>
    <td> Make this directory mode 555 and owned by &quot;root&quot;. This is traditionally 
      where publically accessible files are stored for download</td>
  </tr>
</table>

### <a name="restrict"></a>Restrict User Access

<table width="98%" border="1">
  <tr> 
    <td valign="top" align="left" nowrap>/etc/ftpusers</td>
    <td width="76%">List of unwelcome/restricted users</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/etc/ftpchroot</td>
    <td width="76%">List of normal users who should be chroot'd</td>
  </tr>
</table>

To maximise security we take a look at denying access to some users, and restricting 
access to everyone else.

Deny Access: Add users we want to have no access to the ftp services into the 
/etc/ftpusers file. The standard installation prevents access by special service 
accounts (eg. root, bin, daemon, operator, uucp, www, named.) To be safe, consider 
adding other accounts used by daemon services, such as: mysql, samba to /etc/ftpusers.

With the -A switch we effectively deny access to accounts not listed in the 
/etc/ftpchroot file.

Restrict Access: (chroot) If you provide ftp access for your user-accounts, 
add all users (not restricted above) to /etc/ftpchroot. ftpd will allow access 
by ftp accounts to the root directory, we can enforce some security by allowing 
chroot to force each login into their private directory.
  
#### <a name="restrictLoginConf"></a>Restrict Using login.conf

&#91;Ref: $!manpage("login.conf",5)!$, $!manpage("ftpd",8)!$ |  e-mail from Joakim Aronius | OpenBSD 3.0]
  
OpenBSD's login classes give us another method for structuring security privileges 
for our ftp clients. /etc/login.conf is the configuration file that determines 
your grouping/privilege settings.

In login.conf one can add default values for any user class:

<ol>
  <li>adding 'ftp-chroot' to the user class will chroot everyone in that class. 
    This can be used instead of adding users in /etc/ftpchroot. </li>
  <li>adding 'ftp-dir=/home/ftp' will make all class users chroot to /home/ftp 
    without changing each users home directory.</li>
</ol>

The simplest example, is to merely change the 'default' setting. In the example 
below, our login.conf settings will ensure all accounts are chrooted without 
the need to enter all users into the /etc/ftpchroot file.

e.g. Extract from the file /etc/login.conf

<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput">default:\<br>
      &nbsp;&nbsp;&nbsp;:path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin:\<br>
      &nbsp;&nbsp;&nbsp;:umask=022:\<br>
      &nbsp;&nbsp;&nbsp;:datasize-max=256M:\<br>
      &nbsp;&nbsp;&nbsp;:datasize-cur=64M:\<br>
      &nbsp;&nbsp;&nbsp;:maxproc-max=128:\<br>
      &nbsp;&nbsp;&nbsp;:maxproc-cur=64:\<br>
      &nbsp;&nbsp;&nbsp;:openfiles-cur=64:\<br>
      &nbsp;&nbsp;&nbsp;:stacksize-cur=4M:\<br>
      &nbsp;&nbsp;&nbsp;:localcipher=blowfish,6:\<br>
      &nbsp;&nbsp;&nbsp;:ypcipher=old:\<br>
      &nbsp;&nbsp;&nbsp;:tc=auth-defaults:\<br>
      &nbsp;&nbsp;&nbsp;:tc=auth-ftp-defaults:<b>\</b></td>
  </tr>
  <tr> 
    <td nowrap class="Code"><b>&nbsp;&nbsp;&nbsp;:ftp-chroot:\<br>
      &nbsp;&nbsp;&nbsp;:ftp-dir=~:</b></td>
  </tr>
</table>
<p>With the above settings we are ready to roll with our more secured, chrooted 
  ftp server. <br>
</p>
<p>From the man pages of ftpd(8)</p>
<table width="80%" border="0" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput" valign='top' colspan="2"> 
      <p><b>LOGIN.CONF Variables<br>
        <br>
        </b>The ftpd daemon uses the following ftp specific parameters:<br>
        <i>(auth-ftp and welcome not listed here.)</i> </p>
      </td>
  </tr>
  <tr> 
    <td nowrap class="pScreenOutput" valign='top'><b>ftp-chroot</b></td>
    <td class="pScreenOutput">A boolean value. If set, users in this class will 
      be automatically chrooted to the user's login directory.</td>
  </tr>
  <tr> 
    <td nowrap class="pScreenOutput" valign='top'><b>ftp-dir</b></td>
    <td class="pScreenOutput">A path to a directory. This value overrides the 
      login directory for users in this class. A leading tilde (`~') in ftp-dir 
      will be expanded to the user's home directory based on the contents of the 
      password database.</td>
  </tr>
</table>
<p>A users class is set in the fifth field of the user record in the passwd(5) 
  file. This field is not set on new users when you add them with adduser etc, 
  hence we all become default. (the other pre defined classes are daemon and staff)</p>
<p>If you do not wish for all users to be treated the same, then you could add 
  a new class (e.g.'ftpusers'.) This way you can set a whole bunch of parameters 
  specific to only these users.</p>
<p><i>Gratitudes to Joakim Aronius for pointing (and documenting) this out for 
  us.<br>
  </i> </p>
### Enable ftpd through /etc/rc.conf.local<a name="enable"></a>
<p>To auto-start ftpd with each system start-up we change the settings in the 
  <a href="rc.conf.htm">/etc/rc.conf.local</a> We can also manually 
  start the service with the same flags at the command prompt.</p>
Edit /etc/rc.conf.local:</p>
<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="pScreenOutput">ftpd_flags="-DllUSA" # for non-inetd use: 
      ftpd_flags="-D"</td>
  </tr>
</table>
#### <a name="start"></a>Starting ftpd at the command-prompt
<p>You can also enable ftpd through inetd (described in the FAQ) but making the 
  above settings in the /etc/rc.conf.local is what I like. Obviously, we can now 
  start the ftpd server manually from the command-line.</p>
<table border="0" width="800" class="pScreenOutput">
  <tr> 
    <td nowrap class="Code"># <b>/usr/libexec/ftpd -DllUSA</b></td>
  </tr>
</table>
<p>The command will run ftpd in the background and you are now ready to check 
  your ftp server whether it has been configured correctly.</p>
### <a name="reference"></a>Reference:
<p>From the man pages:</p>
<p>The switches listed above are described further [man pages.]</p>
		
<table class="pScreenOutput">
  <tr> 
    <td nowrap valign="top" width="17" class="pScreenOutput"><b>D</b></td>
    <td width="636" class="pScreenOutput">Detach and become a daemon, accepting 
      connections on the FTP port and forking child processes to handle them. 
      This has lower overhead than starting ftpd from inetd(8) and is thus useful 
      on busy servers to reduce load. </td>
  </tr>
  <tr> 
    <td nowrap valign="top" width="17" class="pScreenOutput"><b>l</b></td>
    <td width="636" class="pScreenOutput"> 
      <p>lower-case L, log successful and failed ftp(1) session using syslog. 
      </p>
      <p>When specified twice (eg. -ll,) the log will also include: retrieve (get), 
        store (put), append, delete, make directory, remove directory and rename 
        operations and their filename arguments. </p>
    </td>
  </tr>
  <tr> 
    <td nowrap valign="top" width="17" class="pScreenOutput"><b>U</b></td>
    <td width="636" class="pScreenOutput">Log each concurrent ftp(1) session to 
      the file /var/run/utmp, making them visible to commands such as who(1). 
    </td>
  </tr>
  <tr> 
    <td nowrap valign="top" width="17" class="pScreenOutput"><b>S</b></td>
    <td width="636" class="pScreenOutput">Log all anonymous downloads to the file 
      /var/log/ftpd when this file exists.</td>
  </tr>
  <tr> 
    <td nowrap valign="top" width="17" class="pScreenOutput"><b>A</b></td>
    <td width="636" class="pScreenOutput">Permit only anonymous ftp connections 
      or accounts listed in /etc/ftpchroot. Other connection attempts are refused.</td>
  </tr>
</table>
		
<p>Other configuration files of interest are:</p>


<table width="98%" border="1" class="pScreenOutput">
  <tr> 
    <td valign="top" align="left" nowrap><i>/etc/nologin</i></td>
    <td width="76%">The file can be used to disable ftp access. If the file exists, 
      ftpd displays it and exits.</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/etc/ftpwelcome</td>
    <td width="76%">Welcome notice. This holds the Welcome message for people 
      once they have connected to your ftp server.</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/etc/motd</td>
    <td width="76%">Welcome notice after login. This holds the message for people 
      once they have successfully logged into your ftp server</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>.message</td>
    <td width="76%">This file can be placed in any directory. It will be shown 
      once a user enters that directory.</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/var/run/utmp</td>
    <td width="76%">List of users on the system</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/var/run/ftpd.pid</td>
    <td width="76%">Process id if running in daemon mode</td>
  </tr>
  <tr> 
    <td valign="top" align="left" nowrap>/var/log/ftpd</td>
    <td width="76%">Log file for anonymous downloads</td>
  </tr>
</table>

#### <a name="otherLinks"></a>Other Links

FTP Server Behind a NAT Gateway Using OpenBSD 3.0 <a href="http://www.svartalfheim.net/natftp.html">http://www.svartalfheim.net/natftp.html</a>
