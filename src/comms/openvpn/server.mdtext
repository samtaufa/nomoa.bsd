[ OpenBSD 4.3,  OpenVPN 2.0.9 ]

Verified on OpenBSD 4.4 amd64 with OpenVPN 2.1 rc7; OpenBSD 4.6 i386 with OpenVPN 2.1rc22

<div class="toc">

Table of Contents

<ol>
	<li>Install
		<ul>
			<li>Base System Configuration</li>
			<li><a href="#preinstall">Pre-install Modifications</a>
				<ol>
					<li> <a href="#mod.vars">./vars</a> default environment variables</li>
					<li> <a href="#mod.pkitool">./pkitool</a> openssl front-end tool</li>
					<li> <a href="#mod.openssl.cnf">./openssl.cnf</a> OpenSSL sample configuration file</li>
				</ol></li>
		</ul></li>
	<li> <a href="#createcertificates">Build our Certificates</a>
		<ul>
			<li> <a href="#createcertificates.cleanup">Environment, Cleaning Up</a></li>
			<li> <a href="#createcertificates.ca">Certificate Authority</a></li>
			<li> <a href="#createcertificates.server">Server Keys, Self Sign</a></li>
			<li> <a href="#createcertificates.control">Control Channel Shared Key</a></li>
			<li> <a href="#createcertificates.client">Client Keys/Certificates</a></li>
			<li> <a href="#createcertificates.DH">DH key</a></li>
		</ul></li>
	<li><a href="#server.config">Sample Configuration File</a>
		<ul>
			<li><a href="#server.config.modification">Example Modification</a></li>
			<li><a href="#server.server.config">Server to Server</a></li>
		</ul></li>
	<li><a href="#server.interfaces">Interfaces</a></li>
	<li><a href="#server.start">Starting the Server</a></li>
	<li><a href="#server.firewall">Firewall (PF)</a></li>
</ol>

</div>

### Install

Install from Port Packages.

The base server / client software are in a single package that can simply be installed from
the OpenBSD ports system. The real challenge is configuring the program to execute as we expect.

Note:

If the server is to route traffic from the OpenVPN Private Network through other networks configured on the machine,
remember to enable IP Forwarding (routing) on the __physical server__.

In the /etc/sysctl.conf file:

<pre class="config-file">
net.inet.ip.forwarding=1
</pre>

On the command-line

<pre class="command-line">
/sbin/sysctl net.inet.ip.forwarding=1
</pre>

#### Base System Configuration


To retain consistency with how other OpenBSD applications are installed, and configured we pre-select a standard configuration for our installation as per the below structure.

The following discussion configures files in the following structure.

<table>
	<tr>
		<th> Directory Location </th>
		<th> Description </th>
	</tr>
    <tr>
		<td>/usr/local/sbin</td>
		<td>Location for openvpn executable. This is the standard install directory for the
          OpenBSD package.</td>
	</tr>
	<tr>
		<td>/etc/openvpn</td>
		<td>Configuration files, a clean install should contain few files: server.conf, openvpn.cnf, ipp.txt </td>
	</tr>
	<tr>
		<td>/etc/openvpn/keys</td>
		<td>generated certificates, keys, and index information</td>
	</tr>
	<tr>
		<td>/usr/local/bin/openvpn</td>
		<td>scripts used during the installation process. We are modifying the scripts and keeping 
        them in this location ensures we can rebuild the same configuration during software updates etc.</td>
	</tr>
</table>

We'll first create the appropriate directories and files.

<pre class="command-line">
$ sudo mkdir -p /usr/local/bin/openvpn
$ sudo mkdir -p /var/log/openvpn
$ sudo touch /var/log/openvpn/status.log 
$ sudo touch /var/log/openvpn/access.log
$ sudo touch /var/log/openvpn/ipp.txt
</pre>

Copy the sample distribution configuration files to a staging area where we can modify the files, 
but leave our configuration directory relatively clean.

<pre class="command-line">
$ cd /usr/local/bin/openvpn
$ sudo cp /usr/local/share/examples/openvpn/easy-rsa/2.0/* .
$ sudo mv openssl.cnf /etc/openvpn
</pre>

#### <a name="preinstall">Pre-install Modifications</a>


The default configurations from the openvpn distribution is not 'sane' for OpenBSD, 
and the following instructions are to put the deployment into a 'sane' configuration

##### <a name="mod.vars">./vars default environment variables</a>

Fix-up errors with the install files and default data into our working files.

<pre class="command-line">
# diff -u /usr/local/share/examples/openvpn/easy-rsa/2.0/vars \
     /usr/local/bin/openvpn/vars
</pre>
<pre class="screen-output">
--- /usr/local/share/examples/openvpn/easy-rsa/2.0/vars Sun Mar 16 09:22:52 2008
+++ /usr/local/bin/openvpn/vars       Thu Aug 21 12:55:48 2008
@@ -26,7 +26,7 @@
 # This variable should point to
 # the openssl.cnf file included
 # with easy-rsa.
-export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
+export KEY_CONFIG=/etc/openvpn/openssl.cnf

 # Edit this variable to point to
 # your soon-to-be-created key
@@ -36,7 +36,7 @@
 # a rm -rf on this directory
 # so make sure you define
 # it correctly!
-export KEY_DIR="$EASY_RSA/keys"
+export KEY_DIR="/etc/openvpn/keys"

 # Issue rm -rf warning
 echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR
@@ -46,7 +46,7 @@
 # down TLS negotiation performance
 # as well as the one-time DH parms
 # generation process.
-export KEY_SIZE=1024
+export KEY_SIZE=4096

 # In how many days should the root CA key expire?
 export CA_EXPIRE=3650
@@ -57,8 +57,9 @@
 # These are the default values for fields
 # which will be placed in the certificate.
 # Don't leave any of these fields blank.
-export KEY_COUNTRY="US"
-export KEY_PROVINCE="CA"
-export KEY_CITY="SanFrancisco"
-export KEY_ORG="Fort-Funston"
-export KEY_EMAIL="me@myhost.mydomain"
+export KEY_COUNTRY="AU"
+export KEY_PROVINCE="NSW"
+export KEY_CITY="Sydney"
+export KEY_ORG="My Company Pty Ltd"
+export KEY_EMAIL="vpn_admin@example.com"
</pre>


We're paranoid, so let's just set the basis for all encryption to be 4096, even if it does take a long time to generate keys.

##### <a name="mod.pkitool">pkitool</a>

##### <a name="mod.openssl.cnf">openssl.cnf</a>

### <a name="createcertificates">Create Certificates</a>

The following process builds the basic set of keys for operating the VPN. Keys are built (and cleared,) 
for this configuration, in the /etc/openvpn/keys directory. For those who can't wait and don't mind 
destroying their configuration, the annotated steps are:

<ol style="list-style-type: lower-alpha">
        <li> <a href="#createcertificates.cleanup">Prep the environment, Clean Up</a></li>
        <li> <a href="#createcertificates.ca">Build the Certificate Authority</a></li>
        <li> <a href="#createcertificates.server">Build the Server Keys, Self Sign</a></li>
        <li> <a href="#createcertificates.control">Build a Control Channel Shared Key</a></li>
        <li> <a href="#createcertificates.client">Build Client Keys/Certificates</a></li>
</ol>

<pre class="command-line">
_ $ sudo su
a # cd /usr/local/bin/openvpn
- # . ./vars
- # ./clean-all
b # ./build-ca
c # ./build-key-server EXAMPLE.COM
d # /usr/local/sbin/openvpn --genkey --secret $KEY_DIR/ta.key
e # ./build-key client_username
</pre>

Depending on the shell of choice, the above 'vars' configuration may not work correctly.
'/usr/local/bin/openvpn/vars' exports variables used in the build scripts. EXAMPLE.COM 
is the variable we added to the ./vars script above.

#### a. <a name="createcertificates.cleanup">Preparing the environment, Cleaning Up</a>

"Install" the 'environment' used as the default for the whole process by sourcing the ./vars script. 
As the subsequent scripts need to use these environment variables, and the process needs to write 
files in the root only access /etc/openvpn/keys directory, we can either run the scripts from root 
or from sudo -E (but with this you would need to ensure that your sudoers configuration is compatible) 
so for simplicity we choose to install as _root_. When correctness prevails we'll update this document.

<pre class="command-line">
$ cd /usr/local/bin/openvpn
$ sudo su
# . ./vars
</pre>
<pre class="screen-output">
NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/keys
</pre>

Following instructions, the next thing is to clear out the destination directory for our keys and certificates

<pre class="command-line">
# ./clean-all
</pre>

####  b. <a name="createcertificates.ca">Build the Certificate Authority</a>

Build our local Certificate Authority signing key for our domain.

<pre class="command-line">
# ./build-ca
</pre>
<pre class="screen-output">
Generating a 4096 bit RSA private key
............................................++
..............................................................................
.............................................................++
writing new private key to 'ca.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [NSW]:
Locality Name (eg, city) [City]:
Organization Name (eg, company) [Organisation Name]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) [Organisation Name CA]:
Email Address [vpnmeister@example.com]:
</pre>
<pre class="command-line">
# ls $KEY_DIR
</pre>
<pre class="screen-output">
ca.crt ca.key index.txt          serial
</pre>

####  c. <a name="createcertificates.server">Build and Authenticate our Server Certificate</a>


Build and sign a certificate for our server EXAMPLE.COM. We will sign the new 
certificate (EXAMPLE.COM.key) using the certificate authority created in the above step ca.

<pre class="command-line">
#  ./build-key-server EXAMPLE.COM
</pre>
<pre class="screen-output">
Generating a 4096 bit RSA private key
........................................................................................................................
.........................................................................................................................++
....++
writing new private key to 'example.com.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [NSW]:
Locality Name (eg, city) [City]:
Organization Name (eg, company) [Organisation Name]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) [example.com]:
Email Address [vpnmeister@example.com]:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Using configuration from /etc/openvpn/openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'AU'
stateOrProvinceName   :PRINTABLE:'NSW'
localityName          :PRINTABLE:'City'
organizationName      :PRINTABLE:'Organisation Name'
commonName            :PRINTABLE:'example.com'
emailAddress          :IA5STRING:'vpnmeister@example.com'
Certificate is to be certified until Jun 11 01:55:01 2018 GMT (3650 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
</pre>
<pre class="command-line">
# ls $KEY_DIR
</pre>
<pre class="screen-output">01.pem             ca.key example.com.csr    index.txt          index.txt.old      serial.old
ca.crt example.com.crt    example.com.key    index.txt.attr     serial
</pre>

####  d. <a name="createcertificates.control">Build a control channel shared key</a> 

If we've set up clients with their own (reverse) DNS entry, then it may be 
appropriate to specify clients with these domain names. Another example 
of where the above naming convention will be useful is when you have 
clients accessing from multiple locations to multiple (separate) OpenVPN servers.

To help with security he final server key to be built is the tls-auth key.
<pre class="command-line">
$ sudo /usr/local/sbin/openvpn --genkey --secret $KEY_DIR/ta.key
$ sudo cat $KEY_DIR/ta.key
</pre>
<pre class="screen-output">
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
8ca2fef6b3453a8b08b295b4b636736d
27409ddb496ea42f2491a9b0a877679f
94c94394513deb6af5d0e39c418fcc47
fd78a401ffbcbb5c40d367dcc165bd52
8b5c0dc97fca762921afbdf6b6bd459b
0c0c0dd272d52de00f8905dd9f36b5ad
c75f310ad55ab034f7bebc9f097f10a6
abd05323dcaf6204e52024f327c3cd59
9dc83889d8596cfbf1d7790fb27189ab
25f965d5ba0f9fc367b9f12ed418dbaa
b9e44bc97d06a7712d6402f9868e48ac
3122e26d0700d1b71d4b51ee7e739e7b
9bd79fecc83e53a4e4faacda27fe7884
cbcf93a4327ea20c5833719d288658da
cd3e4ff253484a6825c2ed4de8b5e21e
1027887af54343f9919321648f9e072b
-----END OpenVPN Static key V1-----
</pre>


That covers most of our server certificate requirements and we can continue 
with creating keys/certificates for our long list of clients.

####  e. <a name="createcertificate.client">Build Client Keys/Certificates</a>

<pre class="command-line">
# ./build-key client_username1
</pre>
<pre class="screen-output">
Generating a 4096 bit RSA private key
..........................................................................................................................
..........................................................................................................................
.............................................................................++
................++
writing new private key to 'client_username1.key'
-----
You are about to be asked to enter information that will be i:qncorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [NSW]:
Locality Name (eg, city) [City]:
Organization Name (eg, company) [Organisation Name]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) [client_username1]:
Email Address [vpnmeister@example.com]:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Using configuration from /etc/openvpn/openssl.cnf
DEBUG[load_index]: unique_subject = "yes"
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'AU'
stateOrProvinceName   :PRINTABLE:'NSW'
localityName          :PRINTABLE:'City'
organizationName      :PRINTABLE:'Organisation Name'
commonName            :PRINTABLE:'client_username1'
emailAddress          :IA5STRING:'vpnmeister@example.com'
Certificate is to be certified until Jun 11 02:08:28 2018 GMT (3650 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
</pre>
<pre class="command-line">
# ls $KEY_DIR
</pre>
<pre class="screen-output">
01.pem                     client_username1.key    example.com.csr            index.txt.attr.old
02.pem                     ca.crt         example.com.key            index.txt.old
client_username1.crt    ca.key         index.txt                  serial
client_username1.csr    example.com.crt            index.txt.attr             serial.old
</pre>

To create more client keys, run the ./build-key script again

<pre class="command-line">
# ./build-key client_username2
</pre>

#### <a name="createcertificates.DH">Building the DH key</a>

There's a reason why this  is the last key construction for the setup. 
Warning: The above keys, at KEY_SIZE = 4096, takes sometime to 
build. Building the DH key at 4096 takes a really long time to build.

<pre class="command-line">
# ./build-dh
</pre>

The above should output a file $KEY_DIR/dh4096.pem

###  <a name="server.config">Sample Configuration File</a>

For our sample configuration, we are taking private IPs from a 
known working configuration, and it is a matter of adapting to 
the situation that fits your new installation.

<ul>
  <li>InternalLAN_IP=10.0.2.0
  <li>InternalLAN_IP_MASK=255.255.255.0
  <li>InternalLAN_DNS_SERVER= 10.0.2.1
  <li>VirtualLAN_IP=10.8.0.0
  <li>VirtualLAN_IP_MASK=255.255.255.0
</ul>

Remember that _EXAMPLE.COM_ is a placeholder for 
whatever your preferred domain name is going to be.

<pre class="config-file">
# File: /etc/openvpn/server.conf
port 1194
proto udp
dev tun0
ca   /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/EXAMPLE.COM.crt
key  /etc/openvpn/keys/EXAMPLE.COM.key
dh   /etc/openvpn/keys/dh4096.pem
tls-auth /etc/openvpn/keys/ta.key 0

server 10.8.0.0 255.255.255.0
push "route 10.0.2.0 255.255.255.0"
push "dhcp-option DNS 10.0.2.1"

client-to-client

keepalive 10 120
comp-lzo
user _openvpn
group _openvpn
persist-key
persist-tun
ifconfig-pool-persist /var/log/openvpn/ipp.txt
status  /var/log/openvpn/status.log
log-append /var/log/openvpn/access.log
verb 3
</pre>

Further explanations of our option selection with _server.conf_

<pre class="config-file">
#server $VPN_IP $VPN_IP_MASK
server 10.8.0.0 255.255.255.0
</pre>

_server 10.8.0.0 255.255.255.0 becomes_ the IP range for the 
virtual network. Clients connecting to our OpenVPN will be 
given an IP address from within this range, and the server 
itself will get an address from this range.

<pre class="config-file">
push "route 10.0.2.0 255.255.255.0"
push "dhcp-option DNS 10.0.2.1"
</pre>

_push "route 10.0.2.0 255.255.255.0" instructs_ the client to
route traffic bound for the stated IP Range (10.0.2.0/24), 
through OpenVPN.

To redirect *ALL* traffic through the VPN, use: _push "redirect-gateway def1_".  Refer <a href="http://www.openvpn.net/index.php/documentation/howto.html">OpenVPN HOWTO</a> for scenarios and issues relevant to redirect such as all machines being on the same segment, but some being on less secure transports (such as wireless), or all clients are connected wirelessly.

#### <a name="server.config.modification">Example modifications</a> 

Thinking through the route table facilities above, we have the 
Virtual LAN working on the 10.8.0.0/24 ip range, giving access 
to remote clients to a local 10.0.2.0/24 range. We are adding 
specific routes to the client to the Virtual LAN and to specific 
services accessible to the OpenVPN Server. We can restrict/open 
client access to server-side services, by controlling the routing 
(finegrained controls require firewall rules.)


Key aspects of our example server configuration file includes:

* Be explicit about file locations

#### <a name="server.server.config">Server to Server Configuration File</a>

If the client is a server, acting as a gateway for subnets gatewayed
through it, then the configuration changes to require the use of:

<pre class="config-file">
client-config-dir /etc/openvpn/ccd
</pre>

Where __/etc/openvpn/ccd__ is the _client configuration directory_. 
When a server/gateway client connects to the OpenVPN server, 
the daemon will check this directory for a file which matches the 
_common name_ of the connecting client. If a matching file is found, 
it will be read and processed for additional configuration file directives
to be applied to the named client.

Create a file _hostname.example.org_ in the /etc/openvpn/ccd directory
to contain the routing information for the external gateway, for example:

<pre class="config-file">
iroute 10.9.10.0 255.255.255.0
</pre>

This will tell the OpenVPN server that the 10.9.10.0/24 subnet 
should be routed to client hostname.example.org.

Next, add the following line to the main server config file _server.conf_
<pre class="config-file">
route 10.9.10.0 255.255.255.0
</pre>

###  <a name="server.interfaces">Configure Interfaces</a> 

_dev tun0_ tells OpenVPN to use the _tun0_ interface, __and__ 
sets the session to be _routing_ as opposed to _bridging_. 
We need to create the _tun0_ tunnel interface.

OpenVPN re-creates the tun(4) interface at startup; compatibility
with PF is improved by starting it from hostname.if(5). For example:

<pre class="command-line">
# cat &lt;&lt; EOF &gt; /etc/hostname.tun0
up
!/usr/local/sbin/openvpn --daemon --config /etc/openvpn/server.conf
EOF
</pre>

The above updated documentation improves compatibility with PF.

###  <a name="server.start">Starting the Server</a> 

To start the server, restart network services with

<pre class="command-line">
# sh /etc/netstart
</pre>

####  Debugging the /etc/openvpn/server.conf Configuration 


Visit the files: /var/log/openvpn/[status|access].log

### <a name="server.firewall">Configuring PF</a>

The following is a sample configuration for OpenVPN.

<pre class="config-file">
ext_if  =  "em0"
lan_if  =  "em1"
vpn_if  =  "tun0"
vpn_port = "1194"

table &lt;vpn_network&gt; { 10.8.0.0/24 }

icmp_types   = "{ echoreq, echorep }"

set skip on lo
scrub in

nat on $ext_if from $lan_if:network to any -> ($ext_if)

# Default rules
block log

# Traffic allowed from any direction
pass in inet proto icmp icmp-type $icmp_types keep state
pass in inet proto tcp from any to any port ssh

# External Interface
pass in on $ext_if inet proto udp from any to $ext_if port $vpn_port keep state
pass out on $ext_if keep state

# Internal Interface
pass out on $lan_if from &lt;vpn_network&gt; to $lan_if:network keep state

# VPN IF
pass in on $vpn_if inet proto { tcp, udp } \
        from &lt;vpn_network&gt; to $lan_if:network keep state
pass out on $vpn_if from $lan_if:network keep state
</pre>

For a bridging example, see <a href="http://blog.innerewut.de/2005/7/4/openvpn-2-0-on-openbsd">BlogFish post</a>
