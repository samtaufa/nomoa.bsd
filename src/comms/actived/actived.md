## Active Directory Services and Unix Clients

<div style="float:right">

Table of Contents

<ol>
    <li>Base Configuration Requirements
    <li>Fundamental Tools Required - Windows
    <li>Fundamental Tools Required - Unix
</ol>

</div>

The following guides are for connecting OpenBSD clients
to authenticate and join Microsoft Active Directory Services (ADS.)

In this guide we'll be authenticating to the ADS using Kerberos and will
use the OpenLDAP tools to interrogate the service (aka debug our install 
configuration.)

### 1. Base Configuration Requirements

[ Ref: <a href="http://www.zytrax.com/books/dns/apd/rfc2782.txt">RFC 2782</a> | 
<a href="http://www.microsoft.com/technet/archive/interopmigration/linux/mvc/cfgbind.mspx?mfr=true">MS Doc</a> ]

* Synchronise time between the host and AD Server
* If you're using Active Directory but hosting DNS using Unix BIND, then make 
   sure you have appropriate SRV directives configured.

Check the above documents for more reading material.

### 2. Fundamental Tools Required - Windows

To assist with interrogating the Active Directory Forests to get expected object strings, 
install the CSVDE tool. Doing the interrogation on the Active Directory Server should
significantly cut down on the trial/error work on the Unix clients.

CSVDE is part of the ADAM Active Directory Application Mode toolkit from Microsoft.
(Use web search: [ADAM Microsoft Active Directory Mode Toolkit](
http://lmgtfy.com/?q=ADAM+Microsoft+Active+Directory+Mode+Toolkit)) to find the current
download.
        
Example execution lines are shown below for extracting data from ADS to a text
file.

<pre class="command-line">
CSVDE -f ads_users.csv -r "(&amp;(objectClass=User))"
CSVDE -f ads_groups.csv -r "(&amp;(objectClass=group))"
CSVDE -f ads_computer.csv -r "(&amp;(objectClass=Computer))"
CSVDE -f ads_contact.csv -r "(&amp;(objectClass=Contact))"
CSVDE -f ads_ou.csv -r "(&amp;(objectClass=Organizational Unit))"
CSVDE -f ads_printer.csv -r "(&amp;(objectClass=Printer))"
CSVDE -f ads_sfolder.csv -r "(&amp;(objectClass=Shared Folder))"

CSVDE -f ads_userlogin.csv -f export.csv -d "dc=example,dc=com" -r "(&amp;(ObjectClass=<span style="color:red">User</span>)(SAMAccountName=<span style="color:red">samt</span>))"
</pre>        
        
### 3. Fundamental Tools Required - Unix

[ Ref: <a href="http://developer.novell.com/wiki/index.php/HOWTO:_Configure_Ubuntu_for_Active_Directory_Authentication">Novell wiki</a> &nbsp;|&nbsp; <a href="http://www.wlug.org.nz/ActiveDirectoryKerberos">Linux to Windows 2000/3 Active Directory</a> ]

Packages:

* Ubuntu Client (krb5-user, ldap-utils, <a href="http://download.gna.org/smbldap-tools/docs/samba-ldap-howto/">smbldap-tools</a>)
<ul>
    <li>Kerberos for Authentication
    <li>LDAP for Queries
</ul>
        
### 3.1 Kerberos for Authentication

* Configure the Kerberos in /etc/krb5.conf

* Letter Casing is important (if I have it in capital letters,
   then it needs to be in CAPITAL LETTERS)
   
* our example Active Directory / LDAP Server has a DNS record of: __<span style="color:blue">ads.example.com</span>__

* our example Active Directory 'forest'(?) is dc=example, dc=com (i.e. __EXAMPLE.COM__)

File: /etc/krb5.conf

<pre class="config-file">
[logging]
default      = FILE:/var/log/krb5/libs.log
kdc          = FILE:/var/log/krb5/kdc.log
admin_server = FILE:/var/log/krb5/admin.log

[libdefaults]
    default_realm = EXAMPLE.COM
    kdc_timesync  = 1
    ccache_type   = 4
    forwardable = true
    proxiable = true

[realms]
    EXAMPLE.COM = {
        kdc            = <span style="color:blue">ads.example.com</span>
        admin_server   = <span style="color:blue">ads.example.com</span>
        default_domain = EXAMPLE.COM
    }

[domain_realm]
    .<span style="color:blue">ads.example.com</span> = EXAMPLE.COM
    <span style="color:blue">ads.example.com</span>  = EXAMPLE.COM
</pre>

Be careful to note these specific things about the configuration file

* Use of the specific domain, and all subdomains (eg. .domain and subdomain.domain)

### 3.2 Talking to Active Directory Tree

There seems a number of tools, and depending on which unix tools you install you either have kutil or klist included

- kinit initialises and logs you in.
        
<pre class="command-line">
kinit username@EXAMPLE.COM
</pre> 

If the login process has worked correctly, then you can use kutil | klist for a list of active
certificates (who's authenticated from your host, klist providing more immediately valuable
information.)
                
### 3.3 LDAP for Queries

* For LDAP accounts the software package libnss-ldap is required

* install ldap-utils

* install heimdal-clients libpam-heimdal (for testing connectivity/accounts)

* Find out the Transport mechanisms supported

<pre class="command-line">
ldapsearch -x -H ldap://<span style="color:blue">ads.example.com</span> -LLL -s "base" -b "" supportedSASLMechanisms
ldapsearch -x -h <span style="color:blue">ads.example.com</span> -LLL -s "base" -b "" supportedSASLMechanisms
</pre>

                will return something like:
<pre class="screen-output">
dn:
supportedSASLMechanisms: GSSAPI
supportedSASLMechanisms: GSS-SPNEGO
supportedSASLMechanisms: EXTERNAL
supportedSASLMechanisms: DIGEST-MD5
</pre>

unfortunately, it seems the lists doesn't necessarily mean that the mechanism
is active(?)

<pre class="command-line">
ldapwhoami -h <span style="color:blue">ads.example.com</span> -Y [mech-from-above-e.g.EXTERNAL] -I
</pre>
        
You may need to cycle through each of the SASL's to see what works for you.
Use -I (interactive mode) to make sure the appropriate user is used
otherwise the ldaptools will use the current unix user account
        
<pre class="command-line">
ldapsearch -h <span style="color:blue">ads.example.com</span> -Y DIGEST-MD5 -b "dc=example,dc=com" -I
</pre>

We can perform further revisions of the ADS Forest by increasing the complexity
of our query strings, such as:

<pre class="command-line">
ldapsearch -h <span style="color:blue">ads.example.com</span> -Y DIGEST-MD5 -b "dc=example,dc=com" "(&amp;(ObjectClass=<span style="color:red">User</span>)(SAMAccountName=<span style="color:red">samt</span>))"
</pre>

The ADS Interrogation is very 'precise.' The above query might dump the 
full tree on the console for you. When drilling further into your forest
it is important to ensure semantics and order are correct.

## SSL Connections

Going further with Active Directory and other services ... 

<a href="www.linuxmail.info">Linux Mail Server Setup and Howto Guide</a> have a number of LDAP SSL / 
<a href="http://www.linuxmail.info/category/active-directory/">Active Directory</a> related documentation that will be relevant here.

<a href="http://www.linuxmail.info/enable-ldap-ssl-active-directory/">Enable LDAP SSL with Active Directory in Windows 2003</a>

<ul>
    <li>Installing Microsoft Certification Services (i.e. ssl certificates for the server)
    <li>Configuring Automatic Certificate Request for Domain Controllers
    <li>How to Export an SSL Certificate in Windows Server 2003
</ul>

The nice, picture-by-picture, guide above gets you to the same point as if you

<ul>
    <li>Install the Certificate Service (and let it create a certificate for you)
            <ul><li>this creates a DER x509 certificate for you</li>
            </ul>
    <li>Install OpenSSL for windows
    <li>Convert the x509 DER certificate to PEM
            <ul>
                    <li><pre class="command-line">certutil -ca.cert <span style="color:blue">ads.example.com</span>.crt</pre>
                    <li><pre class="command-line">c:\openssl\bin\openssl.exe x509 -in <span style="color:blue">ads.example.com</span>.crt -inform DER -out <span style="color:blue">ads.example.com</span>.pem -outform PEM</pre>
            </ul>
</ul>

The conversation sample above is because our first instance to use this is
with RSA SecurID, shich in our instance did not work with the original
certificate and required the openssl conversion step.

http://blogs.technet.com/filecab/archive/2010/05/13/using-kerberos-security-with-server-for-nfs.aspx