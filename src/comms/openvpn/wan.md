## Wide Area Network - WAN

<div class="toc">

    Table of contents
        
<ol>
	<li>Virtual Private Network Subnet
	<li>Client Configurations
	<li>Unique route for client
	<li>Subnets at the OpenVPN Server
	<li>Subnets at the OpenVPN Client
</ol>

</div>

When using OpenVPN to secure traffic between two sites (where each
site is sharing subnets.) 

The following discusses the configurations on the Central Host server.

Our network scenario is:

-   Central Office has a server subnet we want to share
    with remote sites
-   Remote Site #1 has a subnet we want to share with 
    Central Office

$!Image("WAN.png", title="Wide Area Network Diagram", klass="imgcenter")!$

Configuration:

<table>
    <tr><td>OpenVPN Virtual Private Network Subnet:</td>
        <td>172.16.1.0/24</td>
    </tr>
    <tr><td>Paths:</td>
        <td>Remote Client Configs: /etc/openvpn/ccd</td>
    </tr>
    <tr><td>Client Canonical Name</td>
        <td>Remote1 - Site #1 <br/>
        Remote2 - Site #2</td>
    </tr>
    <tr><td>Private IP subnets to share</td>
        <td>
            - Central 10.0.1.0/24
            - Remote Site #1 - 192.168.45.0/24
        </td>
    </tr>
</table>

The standard OpenVPN Server configuration will be.

File: /etc/openvpn/server.conf

<pre class="config-file">
server 172.16.1.0 255.255.255.0
push "route 10.0.1.0 255.255.255.0"
route 192.168.45.0 255.255.255.0
client-config-dir /etc/openvpn/ccd
</pre>

<table>
    <tr>
        <th>Line #</th>
        <th>Configuration</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>00</td>
        <td>server 172.16.1.0 255.255.255.0</td>
        <td>Virtual Private Network Subnet.
        
            The Server takes the first host (i.e. 172.16.1.1
            and distributes the rest to client connections.
        </td>
    </tr>
    <tr>
        <td>01</td>
        <td>push "route 10.0.1.0 255.255.255.0"</td>
        <td>Subnets at the OpenVPN Server</td>
    </tr>
    <tr>
        <td>02</td>
        <td>route 192.168.45.0 255.255.255.0</td>
        <td>Subnets at the OpenVPN Client</td>
    </tr>
    <tr>
        <td>03</td>
        <td>client-config-dir /etc/openvpn/ccd</td>
        <td>Client Configurations.

            Path to a directory containing client specific
            configurations.</td>
    </tr>
</table>

### 00. Virtual Private Network Subnet.

$!Image("WAN_virtual.png", title="Wide Area Network - Virtual Network", klass="imgcenter")!$

<pre class="config-file">
server 172.16.1.0 255.255.255.0
</pre>

OpenVPN, in server mode, will create a 'virtual' subnet from where hosts are allocated
IP Addresses.

The Server takes the 1st network-host IP (172.16.1.1) for itself, the rest are available
for clients. Each client will be able to reach the server on 172.16.1.1.

### 01. Subnets at the OpenVPN Server

We need to tell connecting clients, the subnets we wish for them
to send to the OpenVPN Server host.

Use the __push "route ip subnet" __ config to tell connecting clients 
the subnets that need to be routed to the OpenVPN server. 

<pre class="config-file">
push "route 10.0.1.0 255.255.255.0"
</pre>

In our above example, we are telling connecting clients that the subnet 10.0.1.0/24 is
to be routed through to the OpenVPN Server host.

### 02. Subnets at the OpenVPN Client

We need to __tell__ the OpenVPN __Server host__, to route traffic
for _subnets_ at the OpenVPN _Client._

Use the 'route' configuration to tell our OpenVPN to tell 
the host kernel the subnets on the otherside of the OpenVPN tunnel.

<pre class="config-file">
route 192.168.45.0 255.255.255.0
</pre>

192.168.45.0/24 is at Remote Site #1, on the otherside of the OpenVPN
tunnel, so route 192.168.45.0 through the tunnel.

### 03. Client Configurations

To specify the directory path for Client Custom Configurations, use the
__client-config-dir__ directive as in the below

<pre class="config-file">
client-config-dir /etc/openvpn/ccd
</pre>

Inside the specified path, configurations are simple TEXT files with
client connections matched to the filename using the SSL Certificate 
"Common Name" CCN.

<pre class="screen-output">
When a server/gateway client connects to the OpenVPN server, 
the daemon will check this directory for a file which matches the 
_common name_ of the connecting client. If a matching file is found, 
it will be read and processed for additional configuration file directives
to be applied to the named client.
</pre>

#### Remote #1 Configuration

We've told the OpenVPN Server host to route traffic for client-side
subnets into the OpenVPN tunnel, but if we have not specified for
the VPN, which of the connecting clients should the traffic be 
routed.

Two things are required to complete the routing requirements of our
traffic.

-   Specify a pre-determined IP address for the client
-   Route the client-side subnet to the above IP address

$!Image("WAN_virtual_ccd.png", title="Wide Area Network - Virtual Network with CCD", klass="imgcenter")!$

File: /etc/openvpn/ccd/Remote1

<pre class="config-file">
ifconfig-push  172.16.1.5 172.16.1.6
iroute 192.168.45.0 255.255.255.0
</pre>

<table>
    <tr>
        <th>Line #</th>
        <th>Configuration</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>00</td>
        <td>ifconfig-push  172.16.1.5 172.16.1.6</td>
        <td>Specify a pre-determined IP address for the client</td>
    </tr>
    <tr>
        <td>01</td>
        <td>iroute 192.168.45.0 255.255.255.0</td>
        <td>Route the client-side subnet to the Client IP address</td>
    </tr>
</table>


##### Specify a pre-determined IP address for the client

We want to specify the IP Address for the connecting client,
because I find that routing is simpler this way.

<pre class="config-file">
ifconfig-push  172.16.1.5 172.16.1.6
</pre>

Through the tunnel interface, __ifconfig-push__ configures at the client an 
IP address  172.16.1.5. for the tunnel interface that is routed to 172.16.1.6
in the Private Network.

<pre class="screen-output">
ifconfig-push local remote-netmask

Push virtual IP endpoints for client tunnel, overriding the ifconfig-pool
dynamic allocation. 

The parameters local and remote-netmask are set according to the
_ifconfig_ directive which you want to execute on the client machine
to configure the remote end of the tunnel. Note that the parameters
local and remote-netmask are from the perspective of the client, not 
the server. They may be DNS names rather than IP addresses, in which
case they will be resolved on the server at the time of client connection.

This option must be associated with a specific client instance, which means
that it must be specified either in a client instance config file using 
client-config-dir or dynamically generated using a client-connect script.

Remember also to include a _route_ directive in the main OpenVPN config
file which encloses local, so that the kernel will know to route it to the server's
TUN/TAP interface.

OpenVPN's internal client IP address selection algorithm works as follows:

1 -- Use _client-connect_ script generated file for static IP (first choice). 
2 -- Use _client-config-dir_ file for static IP (next choice). 
3 -- Use _ifconfig-pool_ allocation for dynamic IP (last choice).
</pre>

More importantly, the HOWTO adds the following:

[ <a href="http://openvpn.net/index.php/open-source/documentation/howto.html#policy">
Configuring client-specific rules and access policies</a> ]

<pre class="screen-output">
Each pair of ifconfig-push addresses represent the 
virtual client and server IP endpoints. They must be taken 
from successive /30 subnets in order to be compatible with 
Windows clients and the TAP-Win32 driver. Specifically, 
the last octet in the IP address of each endpoint pair must 
be taken from this set
 
<blockquote>[  1,  2] [  5,  6] [  9, 10] [ 13, 14] [ 17, 18]<br />
[ 21, 22] [ 25, 26] [ 29, 30] [ 33, 34] [ 37, 38]
<br />[ 41, 42] [ 45, 46] [ 49, 50] [ 53, 54] [ 57, 58]<br />
[ 61, 62] [ 65, 66] [ 69, 70] [ 73, 74] [ 77, 78]<br />
[ 81, 82] [ 85, 86] [ 89, 90] [ 93, 94] [ 97, 98]<br />
[101,102] [105,106] [109,110] [113,114] [117,118]<br />
[121,122] [125,126] [129,130] [133,134] [137,138]<br />
[141,142] [145,146] [149,150] [153,154] [157,158]<br />
[161,162] [165,166] [169,170] [173,174] [177,178]<br />
[181,182] [185,186] [189,190] [193,194] [197,198]<br />
[201,202] [205,206] [209,210] [213,214] [217,218]<br />
[221,222] [225,226] [229,230] [233,234] [237,238]<br />
[241,242] [245,246] [249,250] [253,254]</blockquote>

</pre>


##### Route the client-side subnet to the Client IP address

With the IP Address specified for the client, it simplifies setting
the routing for subnets at the client.

<pre class="config-file">
iroute 192.168.45.0 255.255.255.0
</pre>

__iroute__ tells OpenVPN that traffic INSIDE the Virtual Network
should route (the _iroute_ range) 192.168.45.0/24 to this client.
(@ 172.16.1.5)

<pre class="screen-output">
iroute network [netmask]

Generate an internal route to a specific client. The netmask parameter,
if omitted, defaults to 255.255.255.255. 

This directive can be used to route a fixed subnet from the server to a
particular client, regardless of where the client is connecting from. 
Remember that you must also add the route to the system routing table 
as well (such as by using the route directive). The reason why two
routes are needed is that the route directive routes the packet from the
kernel to OpenVPN. Once in OpenVPN, the iroute directive routes to 
the specific client.

This option must be specified either in a client instance config file using 
client-config-dir or dynamically generated using a client-connect script.

The iroute directive also has an important interaction with push "route ...".
iroute essentially defines a subnet which is owned by a particular client 
(we will call this client A). If you would like other clients to be able to reach
A's subnet, you can use push "route ..." together with client-to-client to
effect this. In order for all clients to see A's subnet, OpenVPN must push
this route to all clients EXCEPT for A, since the subnet is already owned 
by A. OpenVPN accomplishes this by not not pushing a route to a client
if it matches one of the client's iroutes.
</pre>
