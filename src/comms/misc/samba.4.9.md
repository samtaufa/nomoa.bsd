##  Sharing Files and Printers with MS Windows

[OpenBSD 4.9 i386 | samba-3.5.8p2 | [Samba Book](http://www.samba.org)] 
  
<div class="toc">

Table of Contents
    
<ul>
  <li><a href="#packaged">Installing the Packaged Version</a></li>
  <li><a href="#service">Starting samba with each reboot</a></li>
  <li><a href="#test">Test</a></li>
  <li><a href="#smbadduser">Adding Users</a></li>
</ul>

</div>
    
The [Samba](http://www.samba.org) suite of programs allows you to 
share Unix resources with SMB Clients (in many cases [MS Windows](http://www.microsoft.com)
clients.) This significantly simplifies client access to OpenBSD 
printing and file resources. Users on SMB client machines access Samba resources 
as they would any other (file/print) resource available from SMB servers such 
as Microsoft Windows Workstations (e.g. XP, Vista, 7) and Microsoft Windows
Servers (e.g. 2003, 2008 R2).

We use OpenBSD/Samba to allow our network users to use the same tools for accessing 
their files on the OpenBSD/Samba box as they previously did when the same resources 
were on the Win NT boxes. Users can open their files from within their applications 
or use Windows Explorer to browse through the OpenBSD/Samba shares.

### <a name="packaged"></a>Installing the Packaged Version    
 
Install the package using pkg_add

<pre class="command-line">
sudo su
export PKG_PATH=ftp://ftp5.usa.openbsd.org/pub/OpenBSD/4.9/packages/i386
pkg_add samba
</pre>

00.  We need to be root, since we're making changes to the system as part of the 
    installation.
01.  Set the PKG_PATH to your nearest package repository, whether on an external 
    [ftp site](http://www.openbsd.org/ftp.html#ftp) or local path.
02.  Use 'pkg_add package-name' to install the samba package.

The package system will respond with a list of available packages it can
identify with the same start string that you specified (and if it finds just one then
it will install that for you.)

<pre class="screen-output">
Ambiguous: 
samba could be samba-3.5.8p2-ads samba-3.5.8p2-cups-ads samba-3.5.8p2-cups-ldap samba-3.5.8p2-cups 
samba-3.5.8p2-ldap samba-3.5.8p2 samba-docs-3.5.8
</pre>
<pre class="manpage">
SMB and CIFS client and server for UNIX
The Samba suite is a set of programs that implement a server for the
Windows file- and printer-sharing protocols (SMB/CIFS).

Samba allows Windows clients to use filesystem space and printers of
your OpenBSD system as if they were local drives or printers.

While configuration for larger sites can be quite complex, the default
installation of this package allows for immediate use of your OpenBSD
machine as a server for Windows clients.

Available flavors:

cups    Enable CUPS support
ldap    Enable LDAP support
ads     Enable Active Directory support

Available subpackage:

docs    Documentation in HTML and PDF (man pages are part of the base package)

Maintainer: Ian McWilliam <kaosagnt@tpg.com.au>

WWW: http://www.samba.org/
</pre>

We can pick the package that best meets our current needs.

<pre class="command-line">
pkg_add samba-3.5.8p2
</pre>

The package system will download and install the specified package,
and all packages needed for minimal functionality.

The default configuration file installed on /etc/samba/smb.conf, 
the quickest way to start Samba is:
    
<pre class="command-line">
sudo /etc/rc.d/smbd start
sudo /etc/rc.d/nmbd start
</pre>

1.  smbd is the Samba Server daemon
2.  nmbd is the Samba Naming Service daemon

### <a name="service"></a>Starting samba as a server service 
    
To ensure that Samba services are available between system restarts. 

Edit: /etc/rc.conf.local.

Include or extend the list of $!manpage("rc.d",8)!$ rc_scripts, such as the below

<pre class="config-file">
rc_scripts="samba"
</pre>

### <a name="test"></a>Testing the installation
    
[Config file: /etc/samba/smb.conf | Utility: smbclient]
    
A quick diagnostic test to verify whether the nmbd/smbd daemons are working 
is to use the <i>smbclient</i> program, one of the tools supplied with the samba 
suite of programs. smbclient attempts a client connection to an smb server, 
so one simple test is to attempt a connection to our localhost smb server.

<pre class="command-line">
smbclient -U% -L localhost 
</pre>

The -U% specifies attempt the connection with User % (% expands to be root, 
or current login) -L specifies the hostname to connect to (localhost.) The above 
command should show the Shares available on the localhost server (ipc$ et. al.) 
as well as other machines in the Work-group.

<pre class="screen-output">
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.5.8]

        Sharename       Type      Comment
        ---------       ----      -------
        IPC$            IPC       IPC Service (Samba Server)
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.5.8]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
</pre>

Basic configuration file settings that can be used to approximate the initial 
part of what your samba server should look like to to set the following settings 
in the configuration file /etc/samba/smb.conf
    
<pre class="config-file">
workgroup             = <b>myworkgroup</b>  
encrypt passwords  = <b>yes</b>  
smb passwd file     = <b>/etc/samba/smbpasswd</b>  
unix password sync = <b>yes</b>  
passwd program     = <b>/usr/bin/passwd %u </b> 
interfaces <b>       ip_for_eth0 ip_for_eth1 </b>
</pre>

<b>ip_for_eth0</b> and <b>ip_for_eth1</b> - These are the ip-addresses for 
the Ethernet cards on your server that you wish Samba to service through. For 
example, if you had one ethernet card for your LAN (eth0:192.168.101.5) and 
one ethernet card for your external connection (ISP eth1:202.123.44.1) then 
you can specify something like:

<pre class="command-line">interfaces 192.168.101.5
</pre>

This would allow machines on your local LAN access to the samba server, but 
not machines connected through any other devices.

Encrypt Passwords: All the clients i am using with my samba server will be 
Win98 or Win2000 and i want passwords encrypted when passed between the server 
and machines in preparation for when the sites go live on the internet. Likewise, 
i don't want to spend the time setting up the script to modify all the clients 
to send clear-text passwords. 

### <a name="smbadduser"></a>Adding Users 

[Utility: /usr/local/bin/smbpasswd ]

To make sure that you can access the smb shares from other clients, create (associate) samba
user accounts to system user accounts using smbpasswd
    
<pre class="screen-output">
smbpasswd -a login-id 
</pre>

For example:
    
<pre class="command-line">
smbpasswd -a samt
</pre>

More Information:

Run by root, the smbpasswd program can "-a" add a new user to the smbpasswd file. 
This is also a neat trick for finding out where the smbpasswd is 'supposed' to be located.

Other useful options:

<pre class="screen-output">
-x         delete the user information  
-d         disable the user account 
-e         enable a disabled account, no effect if account currently enabled  
-r         remote machine on which smb access is to be changed.
</pre>

But you can always lookup the manpages.