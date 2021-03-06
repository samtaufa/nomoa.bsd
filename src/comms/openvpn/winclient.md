## Windows Clients

Make life simple for yourself, install the RC with the GUI interface. It has a better interface 
for activating client VPN sessions and _watching the activity log_.

Create the TAP interface using the GUI install _c:\Program Files\OpenVPN\bin\tapinstall.exe_. 
Set the name of the created TAP Interface "TAP-ADAPTER-NAME" and note it for use in your OpenVPN client configuration.

### Sample Configuration

The names given to files in this example are placholders only, use the naming convention that best fits your requirements. 

In this context, we prefer the FQDN url of the server (e.g. __EXAMPLE.COM__) hosting the OpenVPN server service. 
For the "_remote_" command (i.e. client specifies the _remote_ server) to work, the name given to it must resolve to the 
correct IP address of your server. Obviously you can use an IP address as well.

Use of the FQDN in other areas of the configuration file is convention that should simplify configuration for clients 
needing access to multiple, separate OpenVPN servers.

File: c:\Program Files\OpenVPN\config\client.ovpn

<pre class="config-file">
client
dev tun
dev-node TAP-ADAPTER-NAME # from above configuration
remote EXAMPLE.COM 1194 # use valid URL or IP address
resolv-retry infinite
nobind
persist-key
persist-tun

ca     EXAMPLE.COM-ca.crt # modify certificate authority name
cert  client.EXAMPLE.COM.crt # modify certificate name
key   client.EXAMPLE.COM.key # modify key name
ns-cert-type server 
tls-auth EXAMPLE.COM-ta.key 1  # modify
cipher BF-CBC   #Blowfish (default) OpenVPN windows client seems to cycle through all anyway
comp-lzo
verb 3
route-method exe # may be relevant only for Windows Vista
</pre>



### Vista

With the wonderful elevated user privilege _features_ of Windows Vista, Windows 7
elevated privileges are required.

The privilege elevation is required because running route.exe (to add routes 
to your network configuration such that you can get through your new VPN gateway
to services within) now requires higher privileges.

We configure elevated privileges for:

- _openvpn.exe_

- _openvpn-gui.exe_
    
which allows us to use whichever of the client tools is optimal for our client.

The following instructions is specific to _openvpn.exe_ but also applies to _openvpn-gui.exe_. 
A standard way of elevating the privileges of a __trusted application__ is to set its properties
to always run as an administrator.

- Start Windows Explorer, (Win-Key+e) 
- Find and select the file _openvpn.exe_  or _openvpn-gui.exe_ ( most likely to be in: c:\Program Files\OpenVPN\bin\ )
- Right Click on the file, and Select Properties (or highlight the file then select the File Menu, then select Properties)
- In the "_openvpn.exe Properties_" dialogue box that appears, select the Compatibility tab
    $!Image("openvpn/openvpn_properties_compatibility.png", title="OpenVPN Client - Properties", klass="imgcenter")!$
- In the Compatibility Tab, select "_Privilege Level | Run this program as an Administrator_" 

You will know you have successfully performed this task if in Windows Explorer the application icon now displays a 
Four Colour Windows Shield  $!Image("openvpn/shield.elevated.privileges.png", title="OpenVPN - Elevated Privileges")!$
in the same location it normally has the curved arrow for "shortcut."

$!Image("openvpn/openvpn_elevated_privileges.png", title="OpenVPN - Elevated Privileges", klass="imgcenter")!$
