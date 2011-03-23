## SSH Client Tips and Tricks

<div class="toc">

Table of Contents

<ul>
    <li><a href="#ssh">Remote Access with ssh</a> 
        <ul>
          <li><a href="#sshconfig">Configuring ssh</a></li>
        </ul>
    </li>
    <li><a href="#sshd">sshd - your ssh server daemon</a> 
        <ul>
          <li><a href="#sshd.disableRoot">Disable Root Login</a></li>
        </ul>
    </li>
    <li><a href="#scp">Copying a file through SSH</a></li>
    <li> <a href="#nopassword">SSH Login without a Password</a>
        <ul>
            <li> Generate SSH keys</li>
            <li> Copy to Destination Host</li>
            <li> Set up agent</li>
            <li> Connect</li>
        </ul>    
    </li>
    <li> <a href="#tunnel">SSH Tunnel</a>
        <ul>
            <li> <a href="#portforwarding">Port Forwarding</a></li>
            <li> <a href="#remoteportforwarding">Remote Port Fowarding</a></li>
        </ul>    
    </li>
    <li> <a href="#tunnel.smb">SSH Tunnel SMB</a></li>
    <li> <a href="#limitbandwidth"> Limit Bandwidth used</a></li>  
    <li><a href="#misc">Miscellaneous</a></li>
    <li><a href="#sshLinks" class="anchBlue">SSH Links</a></li>
</ul>

</div>

Veterans know their way back, forward, up, down, sideways, and the rest of us just need pointers here
and there to reading the documentation.

### <a name="ssh"></a>Remote Access with ssh

&#91;Ref: $!manpage("ssh",1)!$ | [OpenBSD FAQ4](http://www.openbsd.org/faq/faq4.html)]

<p>When the itch arrives and you just have to get a 'console' connection to that 
server, telnet is asking for someone to sniff your password and $!OpenBSD!$'s 
[OpenSSH](http://www.openbsd.org) is the preferred, secureable 'terminal' 
access system. Ssh is the preferred method of remote access with OpenBSD. There 
are many features of ssh including the ability to provide a tunnel for other 
services. The clear advantage of ssh is the full encryption of all communications 
between the localhost and the remote host.</p>

<p> For the MS Windows fans amongst us there are even ssh clients Windows can 
  run as a terminal window or from the command-prompt.</p>
  
<p>Communicating with a remote host is usually in the form shown below:</p>

<pre class="command-line">
$ <b>ssh user-id@remotehost.example.com</b>
</pre>

<p>If you don't specify the user-id you wish to login as, then ssh will send the 
current user-id in which you started ssh (ie. if you are currently logged into 
your host as johndoe, then ssh remotehost.example.com will attempt to make the 
connection using your user-id, johndoe)</p>
  
#### <a name="sshconfig"></a>Configuring ssh

&#91;Ref: $!manpage("ssh",1)!$]

ssh checks for its configuration from the command-line, then the user's configuration 
file ($HOME/.ssh/config), then the system-wide configuration file (/etc/ssh/ssh_config) 
The files are text files.

Below is an excerpt of what I choose to include in the system wide /etc/ssh_config 
file
  
File: /etc/ssh/ssh_config

<pre class="config-file">
UseRsh no
FallBackToRsh no
ForwardX11 no
KeepAlive no
Protocol 2,1
</pre>

<p>More documentation can be found in the man pages (ssh(1).) I choose not to 
  UseRsh or FallBackToRsh because I want secure communications or none. I don't 
  want to be forwarding X11 because I don't run X11 on the servers I'm connecting 
  to. I don't want keepalive 'cause if I'm not doing something with the connection 
  I would prefer it to dump me.</p>
  
### <a name="sshd"></a> sshd - your ssh server daemon

&#91;Ref: $!manpage("sshd",8)!$]

sshd is the daemon that listens for connections from clients. It is normally started at boot from /etc/rc. 
It forks a new daemon for each incoming connection. The forked daemons handle 
key exchange, encryption, authentication, command execution, and data exchange. 
This implementation of sshd supports both SSH protocol version 1 and 2 simultaneously.

System configuration is normally controlled by the /etc/ssh/sshd_config. Below 
is an excerpt of the config file

File: /etc/ssh/sshd_config

<pre class="config-file">
Port 22
ListenAddress 0.0.0.0 
ListenAddress ::
HostKey /etc/ssh_host_key
ServerKeyBits 1664
<b>PermitRootLogin yes</b>
</pre>

-   Port specifies to listen on the ssh port (22,) obviously this 
    line implies that you can specify a different port to listen to 
    (or add additional ports)
-   ListenAddress is specifying to listen on all active interfaces 
    (both IPv4 and IPv6).
-   HostKey specifies the location where the hosts key is to be located. 
    /etc/ssh_host_key is the default location.
-   ServerKeyBits specifies the size of the key to be generated, 
    the number above is larger than the 568 normally used 
    (is this more secure ?)
  
#### <a name="sshd.disableRoot"></a>Disable Root Login

The $!manpage("afterboot",8)!$ man page recommends that you disable direct login to root 
through the ssh daemon.

<pre class="manpage">
For security reasons, it is bad practice to log in as root during 
regular use and maintenance of the system. Instead, administrators 
are encouraged to add a &quot;regular&quot; user, add said user to 
the &quot;wheel&quot; group, then use the su and sudo commands when root 
privieges are required.
</pre>

Edit the /etc/sshd_config file:

<pre class="config-file">
<b>PermitRootLogin No</b>
</pre>

Check through the /etc/ssh/sshd_config for what looks interesting, and look 
through the man page for further information.
  
### <a name="scp"></a>Copying a file through SSH

&#91;Ref: $!manpage("scp",1)!$]

scp is a utility that allows you to copy files between hosts using the ssh 
transport. With ssh2 there is also support for gzip style compression of files 
for transmission.

<pre class="command-line">
$ scp files user-id@remote-host.example.com:path
</pre>
    
    
<a name="nopassword"></a>

### SSH Login without a Password

<ul>
    <li> Generate SSH keys
    <li> Copy to Destination Host
    <li> Set up agent
    <li> Connect
</ul>

#### Generate SSH keys

Use ssh-keygen to generate authentication keys.

From manpage $!manpage("ssh-keygen",1)!$:

<pre class="manpage">
ssh-keygen generates, manages and converts authentication keys for
ssh(1).  ssh-keygen can create RSA keys for use by SSH protocol version 1
and RSA or DSA keys for use by SSH protocol version 2.  The type of key
to be generated is specified with the -t option.  If invoked without any
arguments, ssh-keygen will generate an RSA key for use in SSH protocol 2
connections.
</pre>

To generate our authentication keys at:

- ~/.ssh/id_rsa : private key
- ~/.ssh/id_rsa.pub : public key

<pre class="command-line">
ssh-keygen -b 4096 -t rsa    
</pre>
<pre class="manpage">
-b bits
    Specifies the number of bits in the key to create.
-t type
    Specifies the type of key to create.  The possible values are
    ``rsa1'' for protocol version 1 and ``rsa'' or ``dsa'' for proto-
    col version 2.
</pre>

#### Copy to Destination Host

For ssh authentication keys to work, the SSH Daemon on the remote host needs to
have access to the public key generated above. This file is usually located in ~/.ssh
as authorized_keys.

<pre class="command-line">
ssh user@remotehost mkdir ~/.ssh
ssh user@remotehost chmod 0700 ~/.ssh
cat ~/.ssh/id_rsa.pub | ssh user@remotehost "cat - >> ~/.ssh/authorized_keys"
ssh user@remotehost chmod 0600 ~/.ssh/authorized_keys
</pre>

#### Set up Agent

To set up login, such that you only have to enter your ssh authentication password (not your
remotehost password) and for that authentication to persist whilst your desktop session is
active, we use an 'agent' to securely hold your credentials.

-   agent to store credentials
-   add credentials to store

<pre class="command-line">
eval `ssh-agent`
</pre>

From the manpage $!manpage("ssh-agent",1)!$:

<pre class="manpage">
ssh-agent is a program to hold private keys used for public key authentication 
(RSA, DSA).  The idea is that ssh-agent is started in the beginning of an 
X-session or a login session, and all other windows or programs are started 
as clients to the ssh-agent program.
</pre>

From the manpage $!manpage("ksh",8)!$:

<pre class="manpage">
eval command ...
    The arguments are concatenated (with spaces between them) to form
    a single string which the shell then parses and executes in the
    current environment.
</pre>

Add the credentials to the agent store using *ssh-add*

<pre class="command-line">
ssh-add
</pre>

From manpage $!manpage("sshd-add",1)!$:

<pre class="manpage">
ssh-add adds RSA or DSA identities to the authentication agent,
ssh-agent(1).  When run without arguments, it adds the files
~/.ssh/id_rsa, ~/.ssh/id_dsa and ~/.ssh/identity.  Alternative file names
can be given on the command line.
</pre>

#### Connect

You should now be able to connect to the remote host without need to enter your
HOST password

<pre class="command-line">
ssh user@remotehost
</pre>

<a name="tunnel"></a>

### SSH Tunnel

SSH Tunnels are simpler to execute using authentication keys.

<ul>
    <li> <a href="#portforwarding">Port Forwarding</a></li>
    <li> <a href="#remoteportforwarding">Remote Port Fowarding</a></li>
</ul>

From manpage $!manpage("ssh",1)!$:

<pre class="manpage">
 -4     Forces ssh to use IPv4 addresses only.
 
 -A     Enables forwarding of the authentication agent connection.  This
        can also be specified on a per-host basis in a configuration
        file.

 -f     Requests ssh to go to background just before command execution.
        This is useful if ssh is going to ask for passwords or passphras-
        es, but the user wants it in the background.  This implies -n.
        The recommended way to start X11 programs at a remote site is
        with something like ssh -f host xterm.

 -L [bind_address:]port:host:hostport

 -N     Do not execute a remote command.  This is useful for just for-
        warding ports (protocol version 2 only).
</pre>


#### <a name="portfowarding">Port Forwarding</a>

Something we use a lot is to lock down the POP3 (port 110) on our
servers. POP3 is normally only available from localhost.

In the below example, used in our fetchmailrc files, we access
POP3 by forwarding a localhost port address to the POP3 port
on the remote host (from inside the host.)

Local Host to Remote Host

<pre class="command-line">
ssh -4 -f -L1125:127.0.0.1:110 $REMOTEHOST -N
</pre>

or

<pre class="command-line">
ssh -4 -f user@REMOTEHOST -L1125:$REMOTEHOST -N
</pre>

We can now access the POP3 port on REMOTEHOST by talking to
port 1125 on our current machine.

#### <a name="remoteportforwarding">Remote Port Forwading</a>

We often have the case where access to various machines, is
through an intermediary host. We thus have to initiate a
tunnel to that intermediary host, then from that host to
our actual target host.

To simplify things, we use the same port address on our current
host for the port address to be used on the intermediary host.

Local Host to Intermediate Host to Remote Host

<pre class="command-line">
ssh -4 -f -A $INTERMEDIATE  -L 1109:127.0.0.1:1109 "ssh -4 -L 1109:127.0.0.1:110 $REMOTEHOST -N"
</pre>

Again, the above example is connecting to the POP3 port on
REMOTEHOST, by using a local port 1109 which connects to
the same port on an intermediary host.

### <a name="tunnel.smb">SSH Tunnel SMB</a>

-   [Windows XP](http://www.reviewingit.com/index.php/content/view/57/)
-   [Vista](http://social.technet.microsoft.com/Forums/en-US/itprovistanetworking/thread/d30d3c98-58c5-47f6-b5a5-f5620882020d/#page:2)

### <a name="limitbandwidth">Limit Bandwidth used</a>

Limit the bandwidth used for file transfers

<pre class="command-line">
scp -l SIZE SRC DST
</pre>

From manpage $!manpage("scp",1)!$

<pre class="manpage">
-l limit
    Limits the used bandwidth, specified in Kbit/s.
</pre>

### <a name="misc">Miscellaneous</a>

