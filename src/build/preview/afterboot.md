## First Time - After Boot

&#91;Ref: $!manpage("afterboot",8)!$]

<div class="toc">

Table of Contents

<ol>
    <li><a href="#ab_date">Date &amp; Time</a></li>
    <li><a href="#ab_timezone">Time Zone</a></li>
    <li><a href="#ab_network">Network services.</a></li>
    <ul>
        <li><a href="#net_host">Host</a></li>
        <li><a href="#net_network">Network Interface</a> and</li>
        <li><a href="#net_routing">Routing.</a></li>
    </ul>
    <li><a href="#ab_daily">Daily, Weekly, Monthly Scripts</a></li>
</ol>

</div>


The $!manpage("afterboot")!$ man pages list a sequence of issues to review after
the OpenBSD system has been configured and is up and running. For the
'expert' practioner many of the items seem trivial, for us newbies it
is a good time to review basic skills that will be re-used often and
will probably minimise problems that would otherwise occur just from
not checking 'basic' items. 

$!manpage("afterboot")!$ is a serious document if you want to ensure the stability
of your system. I recommend you read the document anyway and use these
pages as supportive material where possible. These notes are supportive
of $!manpage("afterboot")!$ material.

#### <a name="ab_date"></a>Date - Setting the System Date

You can check and configure the system date using the date command.
Without parameters, date command will display the current system date.
You can set the date by using the following template

<pre class="screen-output">
date YYYYMMDDHHMM
</pre>

Where YYYY is the four digit year, followed by MM a two digit month
of the year, DD a two digit date of the month, HH a two digit (24 hour)
representation of the hour, and MM for the minute in the hour.

Using the above specification, we can set (as per man afterboot
example)

<pre class="command-line">
# <b>date 199901271504</b>
</pre>

 Set the current date to January 27th, 1999 3:04pm. 

For those new to the convention used above (YYYYMMDDHHMM) it is the
ANSI specified date format for SQL. I also prefer the above date
formatting as it is less confusing when sharing things with the
Americans 8-)

#### <a name="ab_timezone"></a>TimeZone - Specifying the Time Zone

The time zone information is recorded as data files under the
/usr/share/zoneinfo directory. So if I want to set the timezone to
Paris, France then I can look it up using "find / -name "Paris" -print"
and I can specify the zone file by typing in:

<pre class="command-line">
/root # <b>cd /usr/share/zoneinfo</b> 
zoneinfo # <b>find . -name "Paris" -print</b> 
</pre>

<pre class="screen-output">
./Europe/Paris zoneinfo 
# <b>ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime</b>
</pre>

Of course for us people in Tonga with UTC+13 we use ln -fs
/usr/share/zoneinfo/Pacific/Tongatapu /etc/localtime (I thought you
might just want to know that ?)

### <a name="ab_network"></a>Checking the Network Base Services

Basic services for connecting on the network are generally covered
by these three items.

<ul>
  <li><a href="#net_host">host configuration,</a></li>
  <li><a href="#net_network">network interface configuration,</a> and</li>
  <li><a href="#net_routing">network routing.</a></li>
</ul>

##### <a name="net_host"></a>Host configuration details

Files: /etc/hosts, /etc/myname

For many network services to function they need to determine the
name of the current host. Host Details are checked by using the <b>hostname</b>
command. hostname will display what your current host name is. If you
need to change the hostname more details are available in the
hostname(1) man page. If you change the hostname, then you need to also
make the change to /etc/myname and possibly /etc/hosts.

/etc/hosts is a text file listing IP addresses and their related
hostnames. Your hostname should be in this file associated with the IP
address which you assigned your host during installation.

/etc/myname is a text file with just one line containing the
hostname of your machine. 

##### <a name="net_network"></a>Network interface configuration

Network interfaces are necessary if you wish to communicate to other
computers (at least if you want to communicate using the standard
tools.) In most cases the network interface device will be an ethernet
card. To list the network devices recognised by your system we use the
ifconfig -a command.

<pre class="command-line"># <b>ifconfig -a</b></td>
</pre>

The <b>ifconfig -a</b> command will list the network interfaces
currently active on the system. This will let you review what the
system knows of itself during this instance. You can set the default
configurations by editing the /etc/hostname.* file that corresponds to
the network interface.

If the <b>ifconfig -a</b> command lists an interface <b>le0 </b>than
the corresponding hostname file will be <b>/etc/hostname.le0</b>

Example: ifconfig -a displays the following ethernet device on my
compaq with a HP network card.

<pre class="screen-output">
le1: flags=8863 &lt;UP,BROADCAST,NOTRAILERS,RUNNING,SIMPLEX,MULTICAST&gt; mtu 1500 
    inet 192.168.101.130 netmask 0xffffff00 broadcast 192.168.101.255
inet6 fe80::260:b0ff:fea4:18d3%le1 prefixlen 64 scopeid 0x1 </span>
</pre>


The related hostname file is /etc/hostname.le1 which contains the
lines

<pre class="config-file">
inet 192.168.101.130 255.255.255.0 NONE 
inet alias 207.124.66.156
</pre>

You can see that the inet line in hostname.le1 corresponds to the
inet line displayed by ifconfig -a. ifconfig allows you to manually
configure the network card, or at least check different configurations
before you insert the details into the hostname.interface file. Details
for configuring the network card are read from the
/etc/hostname.interface file during the boot sequence.

An example output for the loopback device will look like:

<pre class="screen-output">
lo0: flags=8009&lt;UP,LOOPBACK,MULTICAST&gt; mtu 32972
inet6 fe80::1%lo0 prefixlen 64 scopeid 0x3 inet6 ::1 prefixlen 128
inet 127.0.0.1 netmask 0xff000000
</pre>

If you have other network interfaces (example a ppp connection) then
these will also be listed. Check the afterboot and ifconfig pages for
more details.

The inet line specifies IPv4 information whereas the inet6 line
specifies IPv6 information. Since OpenBSD is an early adopter of IPv6
you will see this additional information for many network devices.

##### <a name="net_routing"></a>Routing Configuration

&#91;Ref: $!manpage("netstat")!$ | $!manpage("route")!$ ]
We can check the network routing using <b>netstat -r -n</b>

<pre class="command-line">
# <b>netstat -r -n</b>
</pre>
<pre class="screen-output">
Routing tables

Internet:   
Destination      Gateway          Flags  Refs  Use   Mtu   Interface

127/8            127.0.0.1        UGRS   0       0  32972    lo0
127.0.0.1        127.0.0.1        UH     4      42
192.168.101/24   link#1           UC     0       0   1500    le1
192.168.101.130  127.0.0.1        UGHS   0     122  32972    lo0
192.168.101.255  link#1           UHL    3      49   1500    le1
207.124.66/24    link#1           UC     0       0   1500    le1
207.124.66.156   127.0.0.1        UGHS   0       5  32972    lo0
224/4            127.0.0.1        URS    0       0  32972    lo0 
</pre>

If you are new to Unix, then just check to make sure the IP address
you specified specified for your host is listed and take a note that
the IP range (class) is gatewayed through the interface.

In the above example all 192.168.101/24 destinations (except for my
host ip address 192.168.101.130 nor the broadcast address
192.168.101.255) are sent through link#1 which is my network inteface
le1<i> [note: I need to verify more of this detail]</i> 

As I have an alias to the 207.124.66.156 the 207.124.66/24
destinations are also sent through link#1 (except for the host alias
207.124.66.156<i> [note: I need to verify more of this detail]</i>

The default gateway address is stored in the /etc/mygate file. If
you need to edit this file, a painless way to reconfigure the network
afterwards is route flush followed by a sh -x /etc/netstart command.
Or, you may prefer to manually configure using a series of route add
and route delete commands (see route(8))

<pre class="command-line">
# <b>route flush</b>
# <b>sh -x /etc/netstart</b>
</pre>

### <a name="ab_daily"></a>Daily, Weekly, Monthly Scripts

Actions that are scheduled to occur in a repetitive pattern such as
once each day, each week, each month can be placed into the
/etc/daily.local /etc/weekly.local /etc/monthly.local scripts.

The OpenBSD installation supplies a set of standard /etc/daily,
/etc/weekly, and /etc/monthly scripts. The scripts will check for
daily.local, weekly.local, and monthly.local so you should specify your
scripts as part of one of the above *.local files.

Finding and locating files. One of the more frequently asked
questions is how to find a file. The /etc/weekly script updates (on a
weekly basis) the locate.db file to index files on your system. To
manually execute the db update, see the notes below.

To manually execute any of the above scripts, they are sh shell
scripts, then use one of the examples below

<pre class="command-line">
# <b>sh /etc/daily</b>
# <b>sh /etc/weekly</b>
# <b>sh /etc/monthly</b>
</pre>
