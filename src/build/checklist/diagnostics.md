## Post Build Application Services Testing

There are precious few tools for full automation tests for the functionality,
security, et. al. of most applications/services. As we come across a systematic
process for testing hosts, services we'll document them here.

Post build testing should be a sequence of well defined test sequences for
each application service, depending on the key parameters important
for that application (e.g. maintainability, security, performance.)

<ul>
    <li>Connectivity
    <li>Firewall rulesets (PF)
    <li>Postfix / Sendmail
    <li> OpenVPN
</ul>

### Connectivity

Base tools for diagnosis of system level failures include:

<pre class="command-line">
dmesg
</pre>   

dmesg displays the contents of the system message buffer.  It is most
commonly used to review system startup messages.
 
<pre class="command-line">
pcidump -v
</pre>    

The pcidump utility displays the device address, vendor, and product name
of PCI devices.  When no arguments are given, information on all PCI de-
vices in the system is shown; otherwise a single PCI domain or device may
be specified.

<pre class="command-line">
usbdevs -v
</pre>   

usbdevs prints a listing of all USB devices connected to the system with
some information about each device.  The indentation of each line indi-
cates its distance from the root.
     
<pre class="command-line">
netstat -m
</pre>  
The netstat command symbolically displays the contents of various net-
work-related data structures.  There are a number of output formats, de-
pending on the options for the information presented.

Show statistics recorded by the memory management routines (the
network manages a private pool of memory buffers).

### Postfix / Sendmail</a>

Known Test centers: vulnerability, performance 

Test Suites:

<ul>
    <li> performance: smtp-benchmark from ports/benchmarks
    <li> nmap from ports/net
    <li> relay: telnet
    <li> mail reciept: review logs (/var/log/maillog), telnet, mta client
    <li> mail delivery: review logs (/var/log/maillog), mta client
</ul>

### Firewall rulesets

<a href="../pf.html">Known Test centers</a>: vulnerability, performance, traffic route

Test Suites:

<ul>
    <li> tcpbench from base
    <li> tcpblast from ports/benchmarks
    <li> netcat from base
    <li> nmap from ports/net
    <li> review route tables, arp tables
    <li> review tcpdump -nettti pflog0
    <li> review tcpdump -nettti interface-in, CARP-in
    <li> review tcpdump -nettti interface-out, CARP-out
    <li> review tcpdump -nettti @ source host
    <li> review tcpdump -nettti @ destination host
</ul>

### OpenVPN

<a href="../vpn/openvpn.html">Known Test centers</a>: Traffic route, vulnerability, performance

Test Suites:

<ul>
    <li> tcpbench from base
    <li> tcpblast from ports/benchmarks
    <li> netcat from base
    <li> nmap from ports/net
    <li> review route tables, arp tables
    <li> review tcpdump -nettti pflog0
    <li> review tcpdump -nettti interface-in, CARP-in
    <li> review tcpdump -nettti interface-out, CARP-out
    <li> review tcpdump -nettti @ tunnel device source host
    <li> review tcpdump -nettti @ tunnel device destination host
    <li> review tcpdump -nettti @ source host
    <li> review tcpdump -nettti @ destination host
</ul>

Refer to <a href="../vpn/openvpn.html">OpenVPN notes</a> for further information.
