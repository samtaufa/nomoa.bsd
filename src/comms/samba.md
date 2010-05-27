##  Sharing Files and Printers with MS Windows

[OpenBSD 3.6, Samba 3.0.11 ]
  
<div style="float:right">

    <p>Table of Contents</p>
    <ul>
      <li><a href="#packaged">Installing the Packaged Version</a></li>
      <li><a href="#service">Starting samba with each reboot</a></li>
      <ul>
        <li><a href="#inetd">Starting through inetd</a></li>
      </ul>
      <li><a href="#test">Testing the installation</a></li>
      <li><a href="#swat">SWAT - The Samba Web Administration Tool</a></li>
      <li><a href="#smbadduser">Adding Users</a></li>
      <li><a href="#winNT">Co-habiting with Windows NT PDC</a></li>
      <ul>
        <li><a href="#winNTadd">Adding the Samba Server to the Primary Domain Controller</a></li>
        <li><a href="#winNTjoin">Joining the Samba server to the Primary Domain Controller</a></li>
        <li><a href="#winNTupdate">Updating the /etc/samba/smb.conf</a></li>
      </ul>
      <li><a href="#sambaPDC">Authentication for NT, Win9X Workstations</a></li>
      <ul>
        <li><a href="#sambaPDCconf">Configuration File settings</a></li>
        <li><a href="#sambaPDCclient">Machine Account Creation</a></li>
      </ul>
      <li><a href="#stunnel">Using stunnel to secure SWAT password communications</a></li>
      <li><a href="#author">Author and Copyright</a></li>
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
    
[OpenBSD 4.7 i386 | samba-3.0.37p1 | [Samba Book](http://www.samba.org)] 
 
Install the package using pkg_add

<pre class="command-line">
sudo su
export PKG_PATH=ftp://ftp5.usa.openbsd.org/pub/OpenBSD/4.7/packages/i386
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
Ambiguous: samba could be samba-3.0.37p1-cups-ldap samba-3.0.37p1 
samba-3.0.37p1-ldap samba-3.0.37p1-cups samba-3.0.37p1-cups-ads samba-3.0.37p1-ads
</pre>

We can pick the package that best meets our current needs.

<pre class="command-line">
pkg_add samba-3.0.37p1-cups
</pre>

The package system will download and install the specified package,
and all packages for that is needed for minimal functionality.

<pre class="screen-output">
samba-3.0.37p1-cups:xdg-utils-1.0.2p7: ok (8 to go)
samba-3.0.37p1-cups:jpeg-7: ok (8 to go)
samba-3.0.37p1-cups:tiff-3.8.2p5: ok (7 to go)
samba-3.0.37p1-cups:png-1.2.41: ok (6 to go)
samba-3.0.37p1-cups:pcre-7.9: ok (8 to go)
samba-3.0.37p1-cups:libgamin-0.1.10: ok (7 to go)
samba-3.0.37p1-cups:glib2-2.22.4: ok (6 to go)
samba-3.0.37p1-cups:desktop-file-utils-0.15p1: ok (5 to go)
samba-3.0.37p1-cups:dbus-1.2.16p0: ok (4 to go)
samba-3.0.37p1-cups:gdbm-1.8.3p0: ok (5 to go)
samba-3.0.37p1-cups:libdaemon-0.13: ok (4 to go)
samba-3.0.37p1-cups:avahi-0.6.25p5: ok (3 to go)
samba-3.0.37p1-cups:cups-1.3.11p6: ok (2 to go)
samba-3.0.37p1-cups:popt-1.7p0: ok (1 to go)
samba-3.0.37p1-cups: ok
</pre>

As seen above, this samba package has 14 dependencies that were installed
together with the samba. Note, that if you've already installed some of
the above packages with some other application, it will not need to be
re-installed (you will have fewer 'dependencies' in your install.

The Package system will display package installation related information
that you will need to review. You can also find the screen-output 
information in the path:

`
/var/db/pkg/package-name/+DISPLAY
`

For our samba installation, the following packages provide more information
after the installation.

-   avahi (/var/db/pkg/avahi-0.6.25p5/+DISPLAY)
-   cups (/var/db/pkg/cups-1.3.11p6/+DISPLAY)
-   dbus (/var/db/pkg/dbus-1.2.16p0/+DISPLAY)
-   samba (/var/db/pkg/samba-3.0.37p1-cups/+DISPLAY)

<pre class="screen-output">
--- +avahi-0.6.25p5 -------------------
For proper function, multicast(4) needs to be enabled. To do so, add the
following line to /etc/rc.conf.local:
    multicast_host=YES

To start avahi automatically, add the following to /etc/rc.local:
(after dbus-daemon but before Zeroconf-aware applications startup)

if [ -x /usr/local/sbin/avahi-daemon ]; then
        echo -n ' avahi-daemon'; /usr/local/sbin/avahi-daemon -D
fi
if [ -x /usr/local/sbin/avahi-dnsconfd ]; then
        echo -n ' avahi-dnsconfd'; /usr/local/sbin/avahi-dnsconfd -D
fi
</pre>

As above,

<pre class="screen-output">
--- +cups-1.3.11p6 -------------------
To enable CUPS, execute '/usr/local/sbin/cups-enable' as root.
To disable CUPS, execute '/usr/local/sbin/cups-disable' as root.

To start cups at boot time, add the following to
/etc/rc.local:

if [ -x /usr/local/sbin/cupsd ]; then
        #chown _cups /dev/ulpt[0-1] # uncomment if using USB printer
        #chown _cups /dev/lp[a,t][0-2] # uncomment if using parallel printer
        echo y | /usr/local/sbin/cups-enable > /dev/null
        echo -n ' cupsd'; /usr/local/sbin/cupsd
fi

Starting cupsd will overwrite /etc/printcap. A backup copy of this file
is saved as /etc/printcap.pre-cups by '/usr/local/sbin/cups-enable'
and will be restored when you run '/usr/local/sbin/cups-disable'.

If you want to print to non-Postscript printers or use CUPS bundled PPD
files (i.e. drivers), you'll need to install ghostscript.  You will also
most probably want to install the foomatic-filters package which
provides a universal filter script.
</pre>

As above,

<pre class="screen-output">
--- +dbus-1.2.16p0 -------------------
To start systemwide message dbus daemon whenever the machine boots,
add the following lines to /etc/rc.local:

if [ -x /usr/local/bin/dbus-daemon ]; then
        install -d -o _dbus -g _dbus /var/run/dbus
        echo -n ' dbus'; /usr/local/bin/dbus-daemon --system
fi
</pre>

As above, 

<pre class="screen-output">
--- +samba-3.0.37p1-cups -------------------
To start the Samba server and naming service enter the following commands:

$ sudo /usr/local/libexec/smbd # Start the Samba server component
$ sudo /usr/local/libexec/nmbd # Start the Samba naming service

The configuration file, found at /etc/samba/smb.conf can be used right
away for simple configurations.  Local users must be added to the Samba user
database using the smbpasswd utility in order to use the Samba server.

$ sudo smbpasswd -a <username>

To have Samba start whenever the machine boots, add the following lines to the
/etc/rc.local script:

if [ -x /usr/local/libexec/smbd ]; then
        echo -n ' smbd'
        /usr/local/libexec/smbd
fi
if [ -x /usr/local/libexec/nmbd ]; then
        echo -n ' nmbd'
        /usr/local/libexec/nmbd
fi

For more information and complete documentation, install the samba-docs package
and check the /usr/local/share/doc/samba directory.
</pre>

As per above, using the default configuration file installed on 
/etc/samba/smb.conf, the quickest way to start Samba is:
    
<pre class="command-line">
sudo /usr/local/libexec/smbd -D
sudo /usr/local/libexec/nmbd -D
</pre>

1.  smbd is the Samba Server daemon
2.  nmbd is the Samba Naming Service daemon

### <a name="service"></a>Starting samba as a server service 
    
To ensure that Samba services are available between system restarts, 
follow the above +DISPLAY instructions and 

Edit: /etc/rc.local.

After the 'starting local daemons' <b>and before</b> the following echo 
  '.', Insert the following instructions to the /etc/rc.local file: 
  
<pre class="config-file">
echo -n 'starting local daemons:'
# [ ... stuff left out ... ]
</pre>
<pre class="command-line">
    if [ -x /usr/local/libexec/smbd ]; then
            echo -n ' smbd'
            /usr/local/libexec/smbd
    fi
    if [ -x /usr/local/libexec/nmbd ]; then
            echo -n ' nmbd'
            /usr/local/libexec/nmbd
    fi
</pre>
<pre class="config-file">
# [ ... stuff left out ... ]
echo '.'
</pre>


#### <a name="inetd"></a>Starting samba as an inetd service

If you chose the inetd path then two files /etc/services and /etc/inetd.conf need to be updated. Note that to
only use the rc.local update or this configuration but do not use both as it may cause problems further down the
line for you.
    
/etc/services : change this file to include the following lines
    
<pre class="config-file">
netbios-ssn    139/tcp  
netbios-ns     137/udp
</pre>

/etc/inetd.conf : change this file to update the lines referring to the above 
ports
    
<pre class="command-line">
netbios-ssn    stream tcp nowait root /usr/local/<b>libexec</b>/smbd  
netbios-ns     dgram udp wait root /usr/local/<b>libexec</b>/nmbd
</pre>

Of course one advantage of inetd is you don't have to restart the computer to get things up and running. Just
send a -HUP signal to inetd and samba will be started.

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
Sharename      Type        Comment  
----------     -----       -------  
IPC$           IPC         IPC Service (Samba Server)  

Server               Comment  
---------            -------  
OPENBSDBOX           Samba Server  
</pre>

In the above example, the returned displays the Server OPENBSDBOX as being 
in the smb workgroup. OPENBSDBOX is the short-name for this sample localhost.

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

<a name="swat">

###  Setting up SWAT - the Samba Web Administration Tool 
</a>    
    
[Config file: /etc/services | /etc/inetd.conf ]

SWAT provides a GUI based tool for modifying samba's configuration file /etc/samba/smb.conf. Unfortunately it can
also cause disastrous things such as wipe the configuration file (actual experience.) Following are the steps
required to configure swat, which is installed but not enabled by the samba installation.

Edit /etc/services to include the following line

<pre class="screen-output">
swat     901/tcp       # Samba Web Administration Tool 
</pre>

Edit /etc/inetd.conf to include the following lines 

<pre class="screen-output">
swat      stream    tcp      nowait.400   root     /usr/local/sbin/swat     swat 
</pre>
    
Restart the inetd daemon so it can re-read the changes you have made to the 
/etc/inetd.conf file.
    
<pre class="command-line">kill -HUP `cat /var/run/inetd.pid` 
</pre>

You should now be able to point a browser (for example Windows/Internet Explorer) 
at your webserver:901 to configure samba using the SWAT GUI interface instead 
of having to manually edit through the smb.conf file.

Security Concern. I think swat sends passwords cleartext. You should be aware 
of this problem if concerned about potential security compromises by using swat.

### <a name="smbadduser"></a>Adding Users 

[Config file: /etc/samba/smbusers | /etc/samba/smbpasswd | Utility: /usr/local/bin/smbpasswd ]

To make sure that you can access the smb shares from other clients, make sure 
you add the smb access users to the /etc/samba/smbusers and the /etc/samba/smbpasswd 
file. I find this necessary because I specify the use of encrypted passwords 
for authentication.
    
<pre class="screen-output">smbpasswd -a login-id 
</pre>

For example:
    
<pre class="command-line">smbpasswd -a samt
</pre>

More Information:

Run by root, the smbpasswd program can "-a" add a new user to the smbpasswd file. This is also a neat trick for
finding out where the smbpasswd is 'supposed' to be located.

Other useful options:

<pre class="screen-output">
-x         delete the user information  
-d         disable the user account 
-e         enable a disabled account, no effect if account currently enabled  
-r         remote machine on which smb access is to be changed.
</pre>

###  <a name="winNT"></a>Co-habiting with NT Server - Primary Domain Controller 
    
    
As my environments is OpenBSD/Samba joining an existing Windows NT Primary 
Domain Controller (PDC) I need to maintain authentication on one server to minimise 
work-load. For this discussion we will use DEMO_DOMAIN as the domain and PDC_SERVER 
as the name of the Primary Domain Controller (Windows NT 4.0x server) server. 

The following are the basic steps for enabling NT Domain authentication for 
Samba connections.
    
-   On the PDC, Manually add the Samba Server netbios name as an NT Server/Workstation 
-   Join the Domain from the samba server using smbpasswd -j DEMO_DOMAIN -r 
    PDC_SERVER
-   Modify smb.conf to specify encrypted passwords and security=domain
-   Restart the Samba Server
     
#### <a name="winNTadd"></a> Adding the Samba Server to the Primary Domain Controller 
 
On the <b>Win NT (4.0 ) PDC Server</b>, start the Administrator -&gt; Server 
Manager program. Add the OpenBSD/Samba server you have installed as a "Windows 
NT Workstation or Server" 

On the <b>Win2000 Advanced Server PDC</b>, start the Administrator -&gt; Active 
Directory Users and Computers. Select the Domain you will be adding the OpenBSD/Samba 
server to. Add a new computer and make sure you select the check-box &quot;Allow 
pre-Windows 2000 computers to use this account&quot;

For the name of the OpenBSD/Samba server, use the NetBIOS name you have either 
specified in /etc/samba/smb.conf, or use the short-name of the server (OPENBSDBOX 
for this example).

<a name="winNTjoin"> 
####  Joining the Samba server to the Primary Domain Controller 
</a> 

This only works if the OpenBSD/Samba server has been 'installed' into the domain as mentioned above, so make sure
that you have followed the above step and verified the OpenBSD/Samba server is a valid 'NT Workstation or
Server.'

From the OpenBSD/Samba machine join the Primary Domain by using the smbpasswd 
"join" facility


<pre class="command-line">
smbpasswd -j DEMO_DOMAIN -r PDC_SERVER
</pre>

<a name="winNTupdate"> 
####  Updating /etc/samba/smb.conf 
</a> 

To complete joining the Domain, we need to make a few configuration changes. (a) we need to tell Samba to use the
Primary Domain Controller for authentication, and (b) We need to use encrypted passwords. Windows NT sp3 and
greater default to using encrypted password transmission.
    
File /etc/samba/smb.conf

<pre class="config-file">
domain controller = PDC_SERVER  
encrypt passwords = yes 
</pre>

Restart the samba server and user connections will now be verified through 
the Windows NT Domain Controller. Note that users still need a valid account 
on the server if user directories are expected.

###  <a name="sambaPDC"></a>Authentication for NT, Win9X Workstations

[ref: Samba-2.2.2/docs/Samba-HOWTO-Collection.pdf]

With later versions of Samba (2.2.2) we are able to use the OpenBSD/Samba combination 
to authenticate users for a LAN comprising Windows NT and Win9X clients. In 
this scenario, your OpenBSD/Samba server is the Primary Domain Controller (Windows 
Speak) and provides authentication for your Windows clients.

By configuring your clients to forcibly join the domain, you can ensure all 
workstation users must be validated from the OpenBSD/Samba server.

We may want to do this if we do not have a legitimate (Microsoft) Windows Server 
that can authenticate as the primary domain controller.

The Samba distribution actually comes with a HOWTO for this task (Chapter 8. 
How to Configure Samba 2.2 as a Primary Domain Controller)

In short, we set the configurations (in a working Samba system):

-   Configuration File settings
-   Machine Account Creation<

#### <a name="sambaPDCconf"></a>Configuration File settings

To configure your Samba server to provide user authentication you will need 
to include the following.


<pre class="config-file">
[global]
workgroup = myworkgroup
<b>security</b> = user
<b>domain master</b> = yes
<b>local master</b> = yes
<b>domain logons</b> = yes 
<b>add user script</b> = /etc/samba/my_add_user %u
</pre>

Security is set to user (not domain as you would initially expect.) The server 
is set to be the domain master and service domain logons which is where we will 
configure user authentication.

#### <a name="sambaPDCclient"></a>Machine Account Creation.

The <i>add user script</i> will be used by Samba to add a machine account for 
joining NT Workstations to the domain. This script will create an /etc/passwd 
entry using the client workstation's netbios name. At this writing (Samba 2.2.2) 
Samba requires the /etc/passwd entry before it can create a Samba account for 
the workstation.

Since OpenBSD typically does not allow workstations to have the dollar character 
&quot;$&quot; in a user-id we need to modify the useradd source to allow the 
dollar character &quot;$&quot;. Of course, you can manually create the accounts 
and not need to change the source code. Unix, including OpenBSD, readily allows 
the $ sign, but the user creation programs do not normally allow the use of 
dollar signs for a number of practical reasons.

### <a name="stunnel"> Using stunnel to secure SWAT password communication</a> 

[ stunnel-3.8.tgz  | [FAQ 10.6 Setting up a Secure HTTP 
Server with SSL](http://www.openbsd.org/faq/faq10.html) | 
Samba Book]

Samba can be set up to communicate exclusively through SSL, which is great but seems to be problematically
difficult (as in real difficult) to roll out on a WinX environment. By at least forcing SWAT communications to
use SSL then we add one level of security ? Using information available from the Samba site and the OpenBSD FAQ,
I have generated this step-by-step list for using SSL with SWAT under OpenBSD (installation with 2.7)

1. install the stunnel package

<pre class="command-line">
pkg_add /[location-of-packages]/stunnel-3.8.tgz 
</pre>

After stunnel is installed, you have to create a server certificate and put 
the result in /etc/ssl/private/stunnel.pem. For more information on how to create 
certificates, read ssl(8). For more information on stunnel, read stunnel(8).

2. Prepare certificate for stunnel. According to samba doc's stunnel documentation 
says that a blank line is needed between private key and certificate and another 
blank line at the end of the file (make sure you have created the server certificates 
per references above.) 

<pre class="command-line">
echo "" &gt; ~/blankline.txt
# cat /etc/ssl/private/server.key ~/blankline.txt /etc/ssl/server.crt \ 
    ~/blankline.txt &gt; /etc/ssl/stunnel.pem
</pre>

3. Move the stunnel.pem file to a standardised location

<pre class="command-line">mv /etc/ssl/stunnel.pem /etc/ssl/private
</pre>

4. Set the file permissions so no root have no access to the file

<pre class="command-line">chmod 700 /etc/ssl/private/stunnel.pem 
</pre>

5. Remove swat entry from inetd.conf (restart inetd)

<pre class="command-line">kill -HUP `cat /var/run/inetd.pid`
</pre>

6. Start stunnel

<pre class="command-line">
/usr/local/sbin/stunnel -p /etc/ssl/private/stunnel.pem \
      -d 901 -l  /usr/local/sbin/swat -- swat
</pre>
      
7. We now include stunnel into the configuration for SWAT</p>

Edit /etc/[rc.conf.local](../build/preview/rc.conf.html) to include the following line:

<pre class="config-file">
stunnel_swat=YES 
</pre>

Edit: /etc/rc.local.

<b>After</b> the 'starting local daemons' <b>and before</b> the following echo 
'.', Insert the following instructions to the /etc/rc.local file:

<pre class="screen-output">
echo -n 'starting local daemons:'

# [ ... stuff left out ... ] 
</pre>
<pre class="command-line">  
if [ -f /etc/samba/smb.conf ]; then 
   if [ X"${smbd}" = X"YES" -a X"${nmbd}" = X"YES" -a X"${stunnel_swat}" = X"YES" -a -x /usr/local/sbin/stunnel ]; 
   then 
       echo -n ' stunnel_swat';    
       /usr/local/sbin/stunnel -p /etc/ssl/private/stunnel.pem -d 901 -l  /usr/local/sbin/swat --swat 
   fi 
fi
</pre>

<pre class="screen-output">
# [ ... stuff left out ... ]
echo '.'
</pre>

Now each restart of the machine will automatically check to see whether we 
have enabled stunnel for swat in the configuration file (rc.conf) and then start 
the stunnel. If we wish to disable stunnel for swat we can simply change stunnel_swat=YES 
to stunnel_swat=NO.
  
Connect to the SSL enabled site using https://your_sambaserver:901 
and accept the certificate.

### Getting at Windows Shares

package: Sharity-light_1_2.tgz

Sometimes you want to access the Windows (eg. Win95, Win98, Win2000, WinNT) 
file share from within the Unix box. Sharity-Light is similar to the Linux only 
smbfs (smbmount, smbumount) which allows the user to mount a Windows file-share 
onto your unix file-system.

Check out the [developer's website](http://www.obdev.at/products/sharity/index.html "Objective Development") 
for more information on the &quot;light&quot; version and their commercial product.