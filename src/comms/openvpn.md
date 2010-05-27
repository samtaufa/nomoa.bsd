## Securing Remote Connections
    
Virtual Private Networks (VPN) are methodologies used to provide private
networks over a PUBLIC NETWORK infrastructure. In our context we want
the VPN to be extremely 'private' and that can be generally achieved
through encryption. OpenBSD continues to innovate the deployment capabilities
of IPSEC (i.e. they make it easier and easier to deploy) and these notes
cover the OpenVPN strategy for encrypting VPN traffic.

<a href="http://www.openvpn.net/index.php/open-source.html">OpenVPN </a> Open Source Project Home

<blockquote>
OpenVPN is a full-featured open source SSL VPN solution that 
accommodates a wide range of configurations, including remote 
access, site-to-site VPNs, Wi-Fi security, and enterprise-scale 
remote access solutions with load balancing, failover, and 
fine-grained access-controls. Starting with the fundamental premise 
that complexity is the enemy of security, OpenVPN offers a 
cost-effective, lightweight alternative to other VPN technologies 
that is well-targeted for the SME and enterprise markets.
</blockquote>    
    
<ul>
    <li>Our notes
        <ul>
            <li><a href="openvpn/server.html">Server Installation</a>
            <li><a href="openvpn/winclient.html">Windows Client</a>
            <li><a href="openvpn/wan.html">Wide Area Network (WAN)</a>
        </ul>
    <li>OpenManiak Notes
        <ul>
            <li><a href="http://openmaniak.com/openvpn.php">What is it?</a>
            <li><a href="http://openmaniak.com/openvpn_tutorial.php">Tutorial</a>
            <li><a href="http://openmaniak.com/openvpn_pki.php">SSL & PKI (certificates)</a>
            <li><a href="http://openmaniak.com/openvpn_routing.php">Routing</a>                
        </ul>
    <li>Other Notes
        <ul>
            <li><a href="http://blog.elasticserver.com/search?q=openvpn">OpenVPN - Multisourced Infrastructure</a><br>
            <li><a href="http://openvpn.net/index.php/open-source/documentation/miscellaneous/79-management-interface.html">Management Interface</a>
            <li><a href="http://mertech.com.au/mertech-products-openvpnusermanager.aspx">Client Administrator</a>
        </ul>
    </li>
</ul>

<div style="text-align: center">
<img src='@!urlTo("media/images/vpn.diagram.png")!@' />
</div>

<a href="http://openvpn.net/index.php/open-source/documentation/miscellaneous/79-management-interface.html">Management Interface</a>

<blockquote>
The OpenVPN Management interface allows OpenVPN to
be administratively controlled from an external program via
a TCP socket.

The interface has been specifically designed for GUI developers
and those who would like to programmatically or remotely control
an OpenVPN daemon.

The management interface is implemented using a client/server TCP
connection, where OpenVPN will listen on a provided IP address
and port for incoming management client connections.
</blockquote>


<a href="http://mertech.com.au/mertech-products-openvpnusermanager.aspx">Client Administrator</a>

<blockquote>
The OpenVPN User Manager is designed to make viewing and 
managing your OpenVPN server painless. This is the successor 
to the OpenVPN Status Viewer. This new version uses the management 
console of OpenVPN as opposed to reading the status file. 
</blockquote>

