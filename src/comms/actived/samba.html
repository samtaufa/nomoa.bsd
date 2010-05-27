## Joining an Active Directory Forest

There's a plethora of documentation on the 'NET for configuring Samba 3 to join and MS Active Directory.
Almost all of them are probably out of date. Winbind and AD support is supposedly significantly improved
in the Samba 3.0 codebase, with 'obvious' improvements (bug tuning) within that branch and the introduction 
of a <a href="http://lists.samba.org/archive/samba-technical/2008-November/061933.html">new `libnet' 
library for the 'domain join process' in the v3.2 codebase</a>.

Canonical <a href="http://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/domain-member.html"> Reference</a>
| <a href="http://wiki.samba.org/index.php/Samba_%26_Active_Directory">HowTo</a>
| Community <a href="http://www.enterprisenetworkingplanet.com/netos/article.php/3487081">Join Samba 3 to Active Directory</a>
| <a href="https://help.ubuntu.com/community/ActiveDirectoryWinbindHowto">Ubuntu notes</a>
| <a href="http://www.linuxtopia.org/online_books/network_administration_guides/samba_reference_guide/20_NetCommand_19.html">Machine Trust Accounts</a> 


### Required Packages

Other than those files required for LDAP/Kerberos, you will most likely need the following

* Ubuntu (samba, samba-common, winbind)

The projected sequence for getting Samba connected to Active Directory seems to follow:

* Synchronise Time
* Do the <a href="ldap.html">LDAP / Kerberos</a> dance 1st.

* Initiate Kerberos Connection
* Basic Samba Configuration
* ADS Validation Tests
* Joining the Active Directory Forest



### Initiate Kerberos Connection

Assuming you have your <a href="ldap.html">Kerberos/LDAP configuration</a> set up correctly. 
You need to connect to Active Directory through Kerberos

<pre class="command-line">
# kinit Administrator@DOMAIN.CUBE
</pre>

### Basic Samba Configuration

#### Is Samba Built with support for AD ?

Do determine what options are built into your samba daemon, use the "-b" switch
<pre class="command-line">smbd -b
</pre>

Therefore, to determine whether we have ldap support built in.

<pre class="command-line">smbd -b | grep LDAP
</pre>

To determine whether we have Kerberos built in

<pre class="command-line"> smbd -b | grep KRB
</pre>

To determine whether we have Active Directory built in

<pre class="command-line"> smbd -b | grep ADS
</pre>

To determine whether we have winbindbuilt in

<pre class="command-line"> smbd -b | grep WINBIND
</pre>

Obviously, if any of the above gives you empty lines (i.e. they're not built
in) then you will have to rebuild your version of Samba (or forget the rest
of this guide.)

#### Barebones Config

Set up a basic configuration of samba that can connect to the Active Directory Server.

* File: /etc/samba/smb.conf

<pre class="config-file">
[global]
workgroup = CUBE
realm = DOMAIN.CUBE
netbios name = clientserver
enable privileges = yes
preferred master = no
server string = SAMBA-LDAP Server
security = ADS
encrypt passwords = yes
log level = 3
log file = /var/log/samba/%m
max log size = 50
idmap uid = 10000-20000
idmap gid = 10000-20000 
</pre>

Test that that configuration file syntax is correct using
<pre class="command-line">testparm</pre>

After all errors have been corrected, we will now:

* start the samba server
* join the ADS network

#### Start the Samba Server

In Ubuntu: /etc/init.d/samba start

#### ADS Validation Tests

After a kinit, presumably the Kerberos session is active and Samba's net ads should work partially
through that existing token?

Use lookup dc to get more information about how the DC may be interpreted by your samba
configuration.

<pre class="command-line"># net ads lookup dc</pre>
<pre class="command-line">
Information for Domain Controller: 10.9.10.111

Response Type: SAMLOGON
GUID: b057a08a-c1db-4a95-bd20-f77c3bc41804
Flags:
	Is a PDC:                                   yes
	Is a GC of the forest:                      yes
	Is an LDAP server:                          yes
	Supports DS:                                yes
	Is running a KDC:                           yes
	Is running time services:                   yes
	Is the closest DC:                          yes
	Is writable:                                yes
	Has a hardware clock:                       yes
	Is a non-domain NC serviced by LDAP server: no
Forest:			domain.cube
Domain:			domain.cube
Domain Controller:	ads.domain.cube
Pre-Win2k Domain:	cube
Pre-Win2k Hostname:	ADS
Server Site Name :		Default-First-Site-Name
Client Site Name :		Default-First-Site-Name
NT Version: 5
LMNT Token: ffff
LM20 Token: ffff
</pre>

Note 'Domain Controller: ads.domain.cube' is a 'domain entry' not otherwise mentioned in our
documentation

<pre class="command-line"># net ads info</pre>
<pre class="command-line">
LDAP server: 10.9.10.111
LDAP server name: ads.domain.cube
Realm: DOMAIN.CUBE
Bind Path: dc=DOMAIN,dc=CUBE
LDAP port: 389
Server time: Wed, 04 Feb 2009 17:33:50 EST
KDC server: 10.9.10.111
Server time offset: -21
</pre>

Again, 'LDAP server name: ads.domain.cube' refers to a domain-name not specified
previously in our Kerberos or Samba configuration.

It may be helpfull to address some of the 'address' issues above in your /etc/hosts file for 
expediency. (IF you are using BIND with a misconfigure SRV then this may be the
only solution for you.)

We can further validate the /etc/krb5.conf configuration and the /etc/samba/smb.conf configuration
by using the further samba tools.

<pre class="command-line"># net rpc testjoin</pre>

If you get errors at this time, it may simplify things to add your active directory server IP into
/etc/hosts and use -d3 (debug level 3) to get more information

<pre class="command-line"># net rpc testjoin -d3</pre>

Once you walk through net rpc testjoin, then you can try out net ads testjoin.

<pre class="command-line">net ads testjoin</pre>

### Joining the Active Directory Forest

In a sane world, all we'd need to do is

<pre class="command-line"># net ads join</pre>

And where the world is a little pricky, we might need to be more
explicit in a few matters, such as the power-user

<pre class="command-line"># net ads join -U Administrator</pre>

But things may not always go that way, 

#### Problems, Options

<pre class="command-line">Failed to join domain: failed to lookup DC info for domain 'DOMAIN.CUBE'</pre>

If you get the above error, even after net ads finds your ADS when using

<pre class="command-line"># net ads info</pre>

You can try specifying the ADS Server to the 'net join' command. Refer back to the
_LDAP server name_ output from the 'net ads info' file and explicitly specify the server name
specified there, and where necessary specify that domain name into the
/etc/hosts file.

<pre class="command-line">net ads join -S ads.domain.cube -U Administrator%Password</pre>

Further diagnostics commands to verify communications between your workstation
and the Active Directory Server include:

<pre class="command-line">net ads search cn=Administrator</pre>
<pre class="command-line">net ads search cn=Administrator -U Administrator</pre>
        
Looks like some form of ldap search supported by the samba net client.

"ads_connect preauthentication failed" means there is something wrong with
authenication or the machine account already exists. In some cases, this
may mean that the "join" worked successfully and the problem is other
related to <a href="http://www.nabble.com/kerberos_kinit_password-Preauthentication-failed-td21569275.html">heimdal and MIT are interacting with the ADS</a>.


Use wbinfo -t to verify sanity

<pre class="command-line"># wbinfo -t
checking the trust secret via RPC calls succeeded</pre>

<a href="http://lists.samba.org/archive/samba/2006-November/126811.html">Franz</a>

Other relevant / userful ADS commands [ join | leave | testjoin | user | group | info | status | lookup etc. ]

Great debugging aid.

net ads info

How badly is your time skewed.

net ads status

More than enough information about the machine configuration on the ADs.

net ads user

### Enable WinBIND

We want to avoid this, but in some situations it is needed.

After you have successfully joined your machine to the Active Directory, we can look at enabling winbind for
queries.

* Start winbind

Ubuntu: /etc/init.d/winbindd start

The standard wbinfo commands can now give you more information


<pre class="command-line">
# wbinfo -u
CUBE\administrator
CUBE\guest
CUBE\support_388945a0
CUBE\krbtgt
CUBE\samt
CUBE\aldo
CUBE\dave
</pre>

<pre class="command-line">
# wbinfo -g
CUBE\helpservicesgroup
CUBE\telnetclients
CUBE\domain computers
CUBE\domain controllers
CUBE\schema admins
CUBE\enterprise admins
CUBE\cert publishers
CUBE\domain admins
CUBE\domain users
CUBE\domain guests
CUBE\group policy creator owners
CUBE\ras and ias servers
</pre>

The following is optional, to perform full authentication 

Ubuntu: edit /etc/nsswitch.conf and modify the following 3 lines.

<pre class="command-line">
passwd: 	 compat winbind
group: 	compat winbind
hosts: 	files dns wins 
</pre>
