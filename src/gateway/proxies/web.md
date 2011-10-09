
#  Proxy/Cache Web Service

[ OpenBSD 4.9, squid-2.7.STABLE9p8-ldap-snmp.tgz ]

<div class="toc">

Table of Contents:
    
<ol>
  <li><a href="#cacheSquidOptimise">Squid - Optimizing Web Access</a></li>
  <li><a href="#cacheSquidConfig">Example Configuration</a></li>
  <li><a href="#squidEX2">Extending The Sample</a></li>
  <li>Managing the Log Files</li>
  <li><a href="#squidMisc">Miscellaneous</a>
</ol>
    
</div>
    
There are at least three values in using a caching proxy, the immediately 
obvious two are bandwidth optimisation (in the form of minimising unnecessary 
traffic also known as caching) and control of what resources can be requested from outside 
(also known as access control through a proxy.) 

The third, oft unexplored, value of a caching proxy server such 
as squid is the records, or logs that it maintains to allow the administrator 
to further 'fine-tune' the performance of the system and to isolate communications 
from within the environment to the external world.

## <a name="cacheSquidOptimise"></a>Optimising Web Access

[squid-2.7.STABLE9p8-ldap-snmp]

To install Squid, use the binary packages built by the OpenBSD team
as in the example below

<pre class="command-line">
# pkg_add /[path-to-package]/squid-2.7.STABLE9p8-ldap-snmp
</pre>
<pre class="screen-output">
squid-2.7.STABLE9p8-ldap-snmp: ok
The following new rcscripts were installed: /etc/rc.d/squid
See rc.d(8) for details.
Look in /usr/local/share/doc/pkg-readmes for extra documentation.
</pre>

Once the package is installed you will be prompted to two items:

- $!manpage("rc.d",8)!$ for details on the rcscript /etc/rc.d/squid
- Post-installation instructions at pkg-readmes

### rc.d startup scripts

Edit the file: /etc/rc.conf.local

For OpenBSD 4.9

<pre class="config-file">
rc_scripts="squid"
</pre>

For OpenBSD 5.0

<pre class="config-file">
pkg_scripts="squid"
</pre>

Add a new line for the macro **"rc_scripts"** (or update the line **pkg_scripts** in 5.0)
to add the rcscript specified by the install *squid*. Or, add it to the list of existing scripts for
the macro.

With this configuration, each restart of the host will automatically start
your squid server.

For further information, refer to the manpage: $!manpage("rc.d",8)!$

### Post Install instructions

<pre class="command-line">
# cat /usr/local/share/doc/pkg-readmes/squid-2.7.STABLE9p8-ldap-snmp
</pre>
<pre class="screen-output">
$OpenBSD: README,v 1.3 2011/04/14 08:11:50 sthen Exp $

Running Squid on OpenBSD
========================

... [stuff left out] ...

Please remember to initialize the cache by running "squid -z" before
trying to run Squid for the first time.
</pre>


Configure the cache swap directory by using squid -z. This process will 
take a bit of time.

<pre class="command-line">
# /usr/local/bin/squid -z
</pre>
<pre class="screen-output">
 [ ... program displays ... ]
 YYYY/MM/DD HH:MM:SS| Creating Swap Directories
</pre>

### <a name="cacheSquidStart"></a>Starting Squid

Start squid by using the installed *squid* $!manpage("rc.d",8)!$ script:

<pre class="command-line">
/etc/rc.d/squid start
</pre>

### <a name="cacheSquidOpenBSD"></a>Localised settings in OpenBSD package

It's useful to know where the standard configuration files, locations
are specified for the OpenBSD packages.

<pre class="command-line">
# cat /usr/local/share/doc/pkg-readmes/squid-2.7.STABLE9p8-ldap-snmp
</pre>
<pre class="screen-output">
$OpenBSD: README,v 1.3 2011/04/14 08:11:50 sthen Exp $

Running Squid on OpenBSD
========================

The local (OpenBSD) differences are:
- configuration files are in            /etc/squid
- sample configuration files are in     /usr/local/share/examples/squid
- error message files are in            /usr/local/share/squid/errors
- sample error message files are in     /usr/local/share/examples/squid/errors
- icons are in                          /usr/local/share/squid/icons
- sample icons are in                   /usr/local/share/examples/squid/icons
- the cache is in                       /var/squid/cache
- logs are stored in                    /var/squid/logs
- the ugid squid runs as is             _squid:_squid

... [stuff left out] ...
</pre>

## <a name="cacheSquidConfig"></a>Example Configuration

<b>Scenario:</b></p>

At a private school I work with they have just recieved 
a DSL connection to the local ISP and before releasing the Internet connection 
the administrators have requirements (policies) within the school they wish 
to be implemented as part of the Internet Connection.</p>

The computer department have come to a realisation 
that a Block by Default approach is not conducive to optimal educational use 
of the Internet, but there is a need for policing and monitoring its policies.</p>

The chosen solution is two-fold. (1.) Physical supervision 
of Internet Access computers is mandatory and must be combined with user education 
and training. (2) Software blocking will be both informative and as comprehensive 
as possible.</p>

Software monitoring, restrictions is where squid plays 
a significant role. Squid's Access Control Lists (ACLs) provide a very flexible 
environment for supporting organisational policies.</p>

<b>Details:</b></p>

<b>School Policies: </b>The school has some standards 
of certain types of material it does not want students to access through the 
Internet (specifically pornography.) As a consequence of that requirement, the 
school also does not want students using 'chat' environments or public web hosted 
email services (eg. hotmail)</p>

<b>Network Policies: </b>The DSL connection is 64K 
but the ISP has a very poor connection to the backbone (remember we're calling 
from Tonga) so there is a significant concern about bandwidth utilisation. The 
less unnecessary stuff going up and down the 'pipe' the better for us.</p>

As a consequence of the bandwidth problem, and the 
need to keeping the students focussed on academically oriented pursuits, the 
network administrators want to ban a number of entertainment sites. Primarily 
to minimise bandwidth use and secondarily to keep students off time wasters.</p>

Advertisers are problematic bandwidth consumers, so 
these will also be blocked where possible.</p>

<b>Network Configuration:</b> </p>

The school operates 3 subnets with differing authorisation 
levels. Through some magic, we would like to provide special access privileges 
for system administrators:</p>
  
<table width="90%" border="0">
  <tr> 
    <td nowrap align="left" valign="top"> 
      <div align="center"><b>Segment</b></div>
    </td>
    <td> 
      <div align="center"><b>Purpose</b></div>
    </td>
  </tr>
  <tr> 
    <td nowrap align="left" valign="top">2 class-rooms</td>
    <td> 
      <p>controlled, timed access with potential limits to 'net access during 
        class times.
        subnet_lab1, subnet_lab2</p>
    </td>
  </tr>
  <tr> 
    <td nowrap align="left" valign="top">1 pub access</td>
    <td>Public Access for school community. This will include machines available 
      to school administrators and general staff for accessing the network and 
      'NET. subnet_pub</td>
  </tr>
  <tr> 
    <td nowrap align="left" valign="top">1 admin</td>
    <td>administrator with freer access to the 'NET, probably need to be password 
      authenticated.</td>
  </tr>
</table>

Authentication is the simplest solution for providing 
system administrators with greater access to the Internet. To simplify this 
example, I will discuss authentication in the more detailed revision of this 
example.</p>

The 7 stages we will cover to get our squid configuration working are:-</p>


-   <a href="#squidEXport">Specifying the port we want squid 
    to listen on</a>
-   <a href="#squidEXsubnet">Specifying which network IPs we 
    will support in squid</a>
-   <a href="#squidEXTIME">Specifying Time intervals we will 
    support</a>
-   <a href="#squidEXurl">Specifying Organisational Policies 
    (Restricted Sites)</a>
-   <a href="#squidEXcustomerrs">Specifying Informative Messages 
    relevant to Organisational Policies</a>
-   <a href="#squidEXhttp_access">Configuring Access to the 
    Cache</a>
    -   <a href="#squidEXdeny">Restricting Access to External 
        Sites - relevant to organisational policies</a>
    -   <a href="#squidEXcache">Allowing Specified networks access 
        to the cache</a>
    -   <a href="#squidEXTIMEbased">Restricting Internal Access 
        relevant to organisational policies</a>
    -   <a href="#squidEXdirect">Ignoring the cache when requesting 
        from Local Area Network</a> 
-   <a href="#squidEXgo">Let's Go</a>

#### <a name="squidEXport"></a>Specifying the Port to Listen On 

Edit the file: /etc/squid/squid.conf</p>

Now the scenario is out of the way, lets get down 
to configuring our squid cache/proxy.</p>

The control of external access to the local lan should 
be managed by the Firewall.</p>

To be safer (or am I just pedantic) I set the below 
restriction on where the squid server is listening.

<!--(block | syntax("squid")  )-->
# http_port 3128
http_port internal_nic1:3128
http_port internal_nic2:3128
<!--(end)-->

Normally squid starts up and listens to 3128 on all 
network devices. The above just ensures that it is listening on port 3128 only 
for the internal network. Our firewall can further block port 3128 requests 
from coming through from the outside (but our ACLs should be handling any further 
problems.)

#### <a name="squidEXsubnet"></a>Specifying which network  IPs we will support in squid 

Next I set up my Access Control Lists (ACLs) defining 
the range of machines I have on the Internal Network.


<!--(block | syntax("squid")  )-->
# Networks allowed to use this Cache
acl subnet_lab1     src ip-address_lab1/netmask
acl subnet_lab2     src ip-address_lab2/netmask
acl subnet_pub      src ip-address_pub/netmask
acl all             src 0.0.0.0/0.0.0.0
acl dst_all         dst 0.0.0.0/0.0.0.0 
<!--(end)-->

I choose to list the subnets separately (all non-routeable 
IPs) as we have some policies for Internet access that can be managed using 
the subnet information. The acl "all" and "dst_all" refer 
to any communications with all available internet IP addresses. The "all" 
refers to "source" or 'client' ip address wanting to use the cache. 
The "dst_all" refers to "destination" or URL host being 
requested. 

#### <a name="squidEXTIME"></a>Specifying Time intervals we will support 

Related to the subnet information will be certain 
time periods for which we want to disable specific subnets. So I have to set 
up the ACL for that

<!--(block | syntax("squid")  )-->
# After Hours Settings
acl TIMEafterhoursMORN time MTWHF 00:00-08:00
acl TIMEafterhoursAFT  time MTWHF 16:30-24:00
acl TIMEsatMORN        time A 00:00-07:00
acl TIMEsatAFT         time A 17:00-24:00
acl TIMEsundALLDAY     time S 00:00-24:00
<!--(end)-->

Our sample Network Policy will provide different service levels dependent 
on the time of day (e.g. allow access after hours to different services blocked 
during business hours.)

Squid TIME acls cannot wrap from one day to the next, so to get from 4:30 
in the afternoon until 8:00 the next morning, we have to actually specify one 
acl for 4:30 to midnight and another acl for midnight to 8 in the morning.

#### <a name="squidEXurl"></a>Specifying Organisational Policies (Restricted Sites) 

A number of organisational policies require that we 
restrict use of the Internet and for that we have collected a list of urls and 
domains from the Internet. We are storing these urls in text files related to 
the categorisation we have chosen (eg. entertainment, porn, etc.)

<!--(block | syntax("squid")  )-->
# Regular Expression Review of URLs, and Destination Domains

# The first list are sites known to be wrongly blocked by the later list
acl unblock_porn        url_regex -i "/etc/squid/unblock_porn.txt"

# The following are the sites 
restricted by organisational policy
acl block_advertisers   url_regex -i "/etc/squid/block_advertisers.txt"
acl block_entertainment url_regex -i "/etc/squid/block_entertainment.txt"
acl block_webmail       url_regex -i "/etc/squid/block_webmail.txt"
acl block_porn          url_regex -i "/etc/squid/block_porn.txt"
<!--(end)-->        

We create ACLs for each category, and we store the 
text files in the /etc/squid directory. The text files list on separate lines 
the words or phrase we wish to block access to (such as domain adresses.)

#### <a name="squidEXcustomerrs"></a>Specifying Informative Messages relevant to Organisational Policies 

Location: /usr/local/share/squid/errors

<!--(block | syntax("squid")  )-->
# TAG: deny_info
# Usage: deny_info err_page_name acl
#
#Default:
# none
deny_info CUSTOM_ERRS_ADVERTISERS   block_advertisers
deny_info CUSTOM_ERRS_ENTERTAINMENT block_entertainment
deny_info CUSTOM_ERRS_PORN          block_porn
deny_info CUSTOM_ERRS_WEBMAIL       block_webmail
<!--(end)-->       

We have created customised error messages for the 
different areas our organisational policy restricts access. The error messages 
are text files using the naming convention used by the squid error messages. 
We store the files in /usr/local/share/squid/errors (standard configuration 
in the squid-2.3 OpenBSD port.)</p>

Note: the beautify our error messages (ie. add graphics 
&amp; style sheet) we have created an alias directory in our Apache website 
to store these extra files. Squid will throw the custom messages at the user 
browser, but all other access has to come from the local website.</p>

#### <a name="squidEXhttp_access"></a>Configuring Access to the Cache 

The final major thing, is to set up our rules for 
accessing the cache.


<!--(block | syntax("squid")  )-->
# TAG: http_access
# Allowing or Denying access based on defined access lists
#
# Access to the HTTP port:
# http_access allow|deny [!]aclname ...
<!--(end)-->

The standard format, as shown above, is <b>http_access 
</b>followed by either allow or denu and then a list of your aclnames (with 
an optional ! at the begin to negate the aclname.) Note that aclnames are "ANDed" 
together. </p>

There are a number of standard security configurations 
already in squid.conf, I've left them standing and added the things specific 
to our scenario.</p>

#### <a name="squidEXdeny"></a>Restricting Access to External 
  Sites - relevant to organisational policies

<!--(block | syntax("squid")  )-->
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#
# http ACCESS PRIVILEGES
# --&gt; URLs to Unblock
http_access allow unblock_porn

# --&gt; Domains &amp; URLS to block
http_access deny block_advertisers
http_access deny block_entertainment
http_access deny block_porn
http_access deny block_webmail
<!--(end)-->

Our first action is to block those sites which are 
  restricted by our organisational policies.
  
#### <a name="squidEXcache"></a>Allowing Specified networks access to the cache 

Specifying access to cache from LAN machines</p>

<!--(block | syntax("squid")  )-->
# --&gt; Subnet Access to the NET

http_access allow localhost
http_access allow subnet_lab1
http_access allow subnet_lab2
<!--(end)-->
        

In this example, we allow the local subnets to use 
the cache, so long as they are authenticated 
(again, if you are not using authentication 
then just remove the "authenticated" acl.)

####  <a name="squidEXTIMEbased"></a>Restricting Internal Access

Because we are not ready for prime-time, we denied 
Internet access to the public access machines. 1st they are two buildings away 
and we cannot supervise them at the moment, and 2nd we haven't gone through 
our education program for staff use.

<!--(block | syntax("squid")  )-->
# --&gt; Subnet Access to the NET

<b>http_access deny  subnet_pub </b>
# During initial phase, keep subnet_pub off the air
# 
# After testing, the below script should be used
# --&gt; Format, deny 1st and then allow later
http_access deny subnet_pub TIMEafterhoursMORN
http_access deny subnet_pub TIMEafterhoursAFT
http_access deny subnet_pub TIMEsatMORN
http_access deny subnet_pub TIMEsatAFT
http_access deny subnet_pub TIMEsundALLDAY
# http_access allow subnet_pub authenticated
<!--(end)-->

Because of the same above problems of supervising 
the public access terminals, we have included time based limiting. Once we are 
certain our system is better configured for public access then we can enable 
access from the public terminals within specified hours.</p>

#### <a name="squidEXdirect"></a>Ignoring the cache when requesting from Local Area Network 

Next, we tell squid to not cache requests for the 
internal Local Area Network sites.</p>

<!--(block | syntax("squid")  )-->
# always go direct to LAN sites
# always cache, and always cache (never_direct) all other sites.
always_direct allow localhost 
always_direct allow subnet_lab1 
always_direct allow subnet_lab2 
#never_direct allow all
<!--(end)-->

Our local website doesn't need to be cached. Some of my friends think they 
get better performance (even for internal clients) by caching the local web 
server. Parts of our sites are static pages (straight html, images, and pdfs) 
but our new section is based on PHP so we will just avoid any further complications 
with our cache by not caching it.

#### <a name="squidEXgo"></a>Let's Go.

The final part is to specifically state that we want to be able to access 
the rest of the world, and we want to specifically deny access to the cache 
from anyone we have not specifically allowed access.

<!--(block | syntax("squid")  )-->
# And finally deny all other access to this proxy
http_access allow dst_all
http_access deny  all
<!--(end)-->

### <a name="squidEX2"></a>Extending the Sample Configuration

This section further extends the previous example, 
but with more specifics. Partially as an aid to anyone wishing further examples, 
but primarily to document our network.

The portions of the example we will extend, and add 
upon are:

-   <a href="#squidEX2auth">Authenticating Users</a>
-   <a href="#squidEX2url">Specifying Organisational Policies 
    (Restricted Sites)</a>
-   <a href="#squidEX2customerrs">Specifying Informative Messages 
    relevant to Organisational Policies</a>
-   <a href="#squidEX2access">Configuring Access to the Cache</a>
    -   <a href="#squidEX2deny">Restricting Access to External 
        Sites - relevant to organisational policies</a>
    -   <a href="#squidEX2cache">Allowing Specified networks access 
        to the cache</a>
    -   <a href="#squidEX2TIMEbased">Restricting Internal Access 
        relevant to organisational policies</a>
-   <a href="#squidEX2go">Let's Go</a>

#### <a name="squidEX2auth"></a>Authenticating Users

To maximise the potential for user conformance, while 
providing a more flexible user environment we use User Authentication. 
Configuring authentication is not discussed here.

All the clients are authenticated on an MS Windows NT Domain before they can 
use the network, so our choice was simplified. 

Edit the file /etc/squid/squid.conf:

<!--(block | syntax("squid")  )-->
authenticate_program $authentication_program
authenticate_children   15 
authenticate_ttl       900 seconds
authenticate_ip_ttl     60 seconds
# authenticate_ip_ttl_is_strict on
<!--(end)-->

We specify the Authentication program and some important parameters.

In our environment we will let the authentication remain active 15 minutes 
after the last authentication (900 seconds). To annoy people who wish to share 
their passwords (should be more restrictive than this) we require authentication 
of a user to be tied to an ip address. If within 60 seconds two IP addresses 
request through the cache, both users will be denied access and be required 
to re-authenticate.

If we were really pedantic about password use (which may be relevant in our 
context) we could force authentication to remain with the originating authenticator 
until expiry. Specifically this prevents the user using two terminals.

Our organisation policy we setup authentication so (a) Only those designated 
for Internet Access can access the external web, (b) Our log files can determine 
by user their access patterns to the Internet. Note that this approach may be 
considered draconian by others and is dependent on the type of site you are 
running for which purpose you want to use authentication.

For authentication to be useful, we next have to specify 
an acl.

<!--(block | syntax("squid")  )-->
# Authentication
acl authenticated  proxy_auth REQUIRED
acl users_sysadmin proxy_auth  AdminID1 AdminID2
<!--(end)-->

We want authentication of all users before they access the Internet (for this 
we will use 'authenticated') and we want to provide special privileges to System 
Administrators (for this we will use 'users_sysadmin.

The AdminID1, AdminID2 are users on the server that will provide the authentication 
(in our case on our Windows NT Domain.)

##### <a name="squidEX2url"></a>Specifying Organisational Policies (Restricted Sites)

<!--(block | syntax("squid")  )-->
# Regular Expression Review of URLs, and Destination Domains
acl unblock_pornURL        url_regex    -i "/etc/squid/unblock_pornURL.txt"
acl unblock_domainDOM      dstdom_regex -i "/etc/squid/unblock_domainDOM.txt"
acl unblock_stuffURL       url_regex    -i "/etc/squid/unblock_stuffURL.txt"
acl block_pornURL          url_regex    -i "/etc/squid/block_pornURL.txt"
acl block_pornDOM          dstdom_regex -i "/etc/squid/block_pornDOM.txt"
acl block_advertisersURL   url_regex    -i "/etc/squid/block_advertisersURL.txt"
acl block_advertisersDOM   dstdom_regex -i "/etc/squid/block_advertisersDOM.txt"
acl block_entertainmentURL url_regex    -i "/etc/squid/block_entertainmentURL.txt"
acl block_entertainmentDOM dstdom_regex -i "/etc/squid/block_entertainmentDOM.txt"
acl block_anonymizersDOM   url_regex    -i "/etc/squid/block_anonymizersDOM.txt"
acl block_webhostURL       url_regex    -i "/etc/squid/block_webhostURL.txt"
acl block_webhostDOM       dstdom_regex -i "/etc/squid/block_webhostDOM.txt"
acl block_badlangURL       url_regex    -i "/etc/squid/block_badlangURL.txt"
acl block_piratesURL       url_regex    -i "/etc/squid/block_piratesURL.txt"
acl block_piratesDOM       dstdom_regex -i "/etc/squid/block_piratesDOM.txt"
<!--(end)-->

We drastically change our blocking scheme by using three separate methods of 
analysing a URL before we decide whether it should be allowed, or blocked. In 
our previous example we only used the full URL (url_regex) In this example, 
we use url_regex which analyses the full URL, and dstdom_regex which analyses 
only the host (domain) information of the URL.

This distinction is very important when we want to use a catch word like "quake" 
to block access to game sites that host quake tournaments. When we were blocking 
"quake" in the URL, students were unable to do research on Earthquakes 
as our URL based block prevented access.

By using dstdom_regex we can block only the reference to quake in the URLs 
(which still blocks Earthquake.com etc) By further refining our regular expression 
of quake, we can specify .quake. or ^quake. to block only sites with quake as 
a host (allow earthquake, deadquake, aquake) and block only domain names where 
quake. is at the very beginning, but allow quaken etc.


<!--(block | syntax("squid")  )-->
acl block_filesURLPATH     urlpath_regex -i "/etc/squid/block_filesURLPATH.txt"
<!--(end)-->

A further improvement in selectivity with the url is the urlapath_regex which 
only looks at the "path" portion of the URL. We will use the path 
only portion to review which are file transfers, audio video that we do not 
want.

Of course Squid 2.5 (and possibly 2.4) supports acls for mime-types, but I'm 
trying to get this stuff working 1st.

The next acl we configure is to specify the maximum number of connections we 
want users to be doing. This is mostly relevant to the power users, who inexplicably 
consume significant bandwidth by running multiple browsers.
 
<!--(block | syntax("squid")  )-->
acl MaxCONNECTIONS        maxconn 5
<!--(end)-->

Since this is the 1st time we're doing this, we will set a reasonable number 
initially and then change things along the way.

Note from the FAQ:

<pre class="manpage">
Note, the maxconn ACL type is kind of tricky because it uses 
less-than comparison. The ACL is a match when the number of 
established connections is greater than the value you specify.
</pre>

##### <a name="squidEX2customerrs"></a>Specifying Informative Messages relevant to Organisational Policies
 
<!--(block | syntax("squid")  )-->
deny_info CUSTOM_ERRS_ADVERTISERSurl   block_advertisersURL
deny_info CUSTOM_ERRS_ADVERTISERSdom   block_advertisersDOM
deny_info CUSTOM_ERRS_ANONYMIZERSdom   block_anonymizersDOM
deny_info CUSTOM_ERRS_BADLANGurl       block_badlangURL
deny_info CUSTOM_ERRS_ENTERTAINMENTurl block_entertainmentURL
deny_info CUSTOM_ERRS_ENTERTAINMENTdom block_entertainmentDOM
deny_info CUSTOM_ERRS_FILESurlpath     block_filesURLPATH
deny_info CUSTOM_ERRS_PIRATESurl       block_piratesURL
deny_info CUSTOM_ERRS_PIRATESdom       block_piratesDOM
deny_info CUSTOM_ERRS_PORNurl          block_pornURL
deny_info CUSTOM_ERRS_PORNdom          block_pornDOM
deny_info CUSTOM_ERRS_WEBHOSTurl       block_webhostURL
deny_info CUSTOM_ERRS_WEBHOSTdom       block_webhostDOM
deny_info CUSTOM_ERRS_MaxCONNECTIONS MaxCONNECTIONS
<!--(end)-->

Our Custom Error Messages have also evolved to inform users which parts of 
the URL they have hit upon has caused the 'connection failure.'

We deem that this is more helpful to clients and will maximise our ability 
to analyse whether the ruleset is accurate/effective.

##### <a name="squidEX2access"></a>Configuring Access to the Cache

##### <a name="squidEX2deny"></a>Restricting Access to External Sites - relevant to organisational policies

<!--(block | syntax("squid")  )-->
# --&gt; Domains &amp; URLS to block
http_access deny block_pornURL
http_access deny block_pornDOM
http_access deny block_advertisersURL
http_access deny block_advertisersDOM
http_access deny block_entertainmentURL
http_access deny block_entertainmentDOM
http_access deny block_anonymizersDOM
<!--(end)-->

Our access configuration remains largely the same, we're just using more acls.</p>
 
<!--(block | syntax("squid")  )-->
##
## SPECIAL PRIVILEGE SECTION FOR ADMINISTRATORS
## 
http_access allow users_sysadmin dst_all
<!--(end)-->

One change we implement is to allow administrators greater freedom to the Internet, 
restricting their access only to sites specifically limited by the network policy 
and organisational policy.

users_sysadmin is a proxy authentication 
acl, so this allow sequence will only be made available if the client user can 
authenticate to the users listed with users_sysadmin (in our example: AdminID1, 
and AdminID2)

<!--(block | syntax("squid")  )-->
http_access deny block_webhostURL
http_access deny block_webhostDOM
http_access deny block_badlangURL
http_access deny block_piratesURL
http_access deny block_piratesDOM 
http_access deny block_filesURLPATH
<!--(end)-->

We now restrict external access via the domain portion of the URL, giving us 
greater freedom to use words that would otherwise cause significant problem 
if used in the complete URL. We can also provide a set of limited users extra 
privileges, independent of the machines they are using.

<!--(block | syntax("squid")  )-->
http_access allow block_filesURLPATH authenticated TIMEafterhoursMORN !MaxCONNECTIONS
http_access allow block_filesURLPATH authenticated TIMEafterhoursAFT !MaxCONNECTIONS
http_access allow block_filesURLPATH authenticated TIMEsatMORN !MaxCONNECTIONS
http_access allow block_filesURLPATH authenticated TIMEsatAFT !MaxCONNECTIONS
http_access allow block_filesURLPATH authenticated TIMEsundALLDAY !MaxCONNECTIONS
http_access deny  block_filesURLPATH
<!--(end)-->

With file restrictions we choose to deny access to download files during peak 
use periods. Here we specifically allow file downloads to authenticated users 
after hours and when the user has not exceeded allowed maximum number of connections. 

Otherwise, we will block file downloads.

##### <a name="squidEX2cache"></a>Allowing Specified networks access to the cache

<!--(block | syntax("squid")  )-->
# --&gt; Subnet Access to the NET
http_access allow localhost
http_access allow subnet_lab1 authenticated !MaxCONNECTIONS
http_access allow subnet_lab2 authenticated !MaxCONNECTIONS</p>
<!--(end)-->

The subnets not only have to be correct to allow access to the cache, the clients 
also have to be connected and must not be greater than MaxConnections (5 in 
our initial estimation.)
To gain access to the cache, the client must 

-   be in a valid ip-address (subnet_lab1 or subnet_lab2) AND</li>
-   be an authenticated user (userid, password) AND</li>
-   Must not have more than the MaxCONNECTIONS</li>

##### <a name="squidEX2TIMEbased"></a>Restricting Internal Access - relevant to organisational policies

<!--(block | syntax("squid")  )-->
http_access deny subnet_pub TIMEafterhoursMORN
http_access deny subnet_pub TIMEafterhoursAFT
http_access deny subnet_pub TIMEsatMORN
http_access deny subnet_pub TIMEsatAFT
http_access deny subnet_pub TIMEsundALLDAY
# http_access allow subnet_pub authenticated !MaxCONNECTIONS
<!--(end)-->

There is minimal change in the time restriction. We have only included authentication 
and maxconn requirements to the commented access specifications.

##### <a name="squidEX2go"></a>Let's Go 

<!--(block | syntax("squid")  )-->
http_access allow dst_all authenticated !MaxCONNECTIONS
http_access deny all
<!--(end)-->

In our final line we have required authentication on going out from the cache 
to the rest of the world, just in case we've made some fundamentally stupid 
mistake somewhere else in our configuration.</p>

### Managing the Log Files

Edit the /etc/daily.local file and add the file lines:

<!--(block  | syntax("bash") )-->
if [ -x /usr/local/bin/squid -a -f /var/squid/logs/squid.pid ]; then
     /usr/local/bin/squid -k rotate
fi
<!--(end)-->

### <a name="squidMisc"></a>Other Miscellaneous Issues ?

#### <a name="squidMiscDNS"></a>Squids DNS Startup Test

We get very poor service from our ISP, and one serious 
problem when we were configuring our server was not being able to resolve the 
DNS names for squid. Failing to find the dns entries for netscape.com, internic.net, 
nlanr.net, microsoft.com the squid server will just hang-around and then eventually 
quit. </p>

<!--(block | syntax("squid")  )-->
# TAG: dns_testnames
# The DNS tests exit as soon as the first site is successfully looked up
#
# This test can be disabled with the -D command line option.
#
#Default:
# dns_testnames netscape.com internic.net nlanr.net microsoft.com
dns_testnames mydomain.com
<!--(end)-->
    
To solve the startup problem (because our ISP will 
regularly have problems with their DNS server) we set the dns test to look for 
our host details, which is configured in our internal DNS Server.</p>

#### <a name="squidMiscDebug"></a>Debugging your Configuration

<!--(block | syntax("squid")  )-->
# TAG: debug_options
# Logging options are set as section,level where each source file
# is assigned a unique section. Lower levels result in less
# output, Full debugging (level 9) can result in a very large
# log file, so be careful. The magic word "ALL" sets debugging
# levels for all sections. We recommend normally running with
# "ALL,1".
#
#Default:
# debug_options ALL,1
debug_options ALL,1 32,2
<!--(end)-->

I was having a number of problems with squid while 
playing around with the configuration file (especially when trying to get authentication 
working) and because of the problems we were having with our ISP connection 
failures. Squid can log more information in the /var/squid/logs/cache.log file. 
By increasing the amount of information that is placed in there I had a much 
better understanding of when squid was failing.</p>

#### <a name="squidMiscUser"></a>Squid User and Group

Another problem I was having in updating and downgrading 
squid (I was originally attempting to use LDAP authentication in squid to synchronise 
accounts between Samba, Squid, &amp; Windows 2000) is the fact that the source 
distribution will use nobody but the OpenBSD ports use _squid:_squid

<!--(block | syntax("squid")  )-->

#Default:
# cache_effective_user nobody
cache_effective_user  _squid
cache_effective_group _squid
<!--(end)-->

While shifting between port and source I was continually having problems with 
the source not being able to use the directories created by the OpenBSD port. 
It took a while (dumb admin I am) to figure out that uid:gid were different 
between the different compilations. Sometimes I would remember the ./configure 
directive, sometimes I'd forget.</p>