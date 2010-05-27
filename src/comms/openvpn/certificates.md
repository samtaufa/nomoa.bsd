## OpenSSL Certificates

[ OpenBSD 3.5 ]

Portions Reviewed in OpenBSD 4.6, and 4.7

<div style="float:right">

<p>Table of Contents</p>

<ul>
  <li><a href="#createcerts">Self-signed Certificates</a>
  <ul>
    <li><a href="#sscKey" class="anchBlue">Generate a Signing Key</a></li>
    <li><a href="#sscCSR">Server Certificate Signing Request</a></li>
    <li><a href="#sscCRT" class="anchBlue">Signing the Certificate</a></li>
    <li><a href="#sscTest" class="anchBlue">Testing the Keys</a></li>
    <li><a href="#sscVirtualHosts" class="anchBlue">Virtual Hosts</a></li>
  </ul></li>
</ul>

</div>

OpenBSD ships with built in support for OpenSSL and OpenSSH for secure encrypted 
end-to-end communication between a localhost and a remotehost. Following are 
notes on configuring and using SS# (pronounced S-S-Sharp, that's a pun)
  
<a name="createcerts"></a>

### Creating Self-Signed Certificates

[ref: <a href="http://www.openbsd.org/faq/">OpenBSD   FAQ</a> | 
mod_ssl/ssl_faq.html#ToC17 - html documentation of mod_ssl |
/var/www/conf/httpd.conf ]

SSL Communications assume the server has an authentication certificate which 
acts as a verification for whom the server publishes itself to be, and provides 
an envelope for the server's public key with which clients can encrypt communications 
bound for the server.

Creating a certificate was initially meant for a third-party authority to assist 
you in verifying that the server is who they say they are, so the creation of 
a self signing certificates requires 3 stages 
  
-   <a href="#sscKey">creating a private signing key</a>
-   <a href="#ccertificaterequest">creating a certificate request, </a>and
-   <a href="#selfsign">self-authenticating your certificate</a>   request.

We are choosing our file names based on the standard OpenBSD/Apache configuration 
for SSLfiles

File: /var/www/conf/httpd.conf

<pre class="config-file">
SSLCertificateFile    /etc/ssl/<b>server.crt</b>
SSLCertificateKeyFile /etc/ssl/<b>private/server.key</b>
</pre>

#### <a name="sscKey"></a>1. Generate a Signing key (1024 bit size) : 

<pre class="command-line">
 #  /usr/sbin/openssl genrsa -out /etc/ssl/private/server.key 1024
</pre>

The generated key acts as our RSA private key for our 'internal' CA (Certificate 
Authority.) 


We can call the key anything we want, and the general mod_ssl example is ca.key, 
but in the above scenario we will use server.key. Check the mod_ssl documentation 
for why we are only using a key size of 1024.

<b>Security Warning:</b> When you gravitate to a production system you should 
(at minimum) use -des3 Triple DES encryption and use an authentication pass-phrase 
for this key. Otherwise, someone can simply steal your key file and sign, authorise 
other servers masquerading as you.

<a name="sscCSR"></a>

#### 2. Generate a certificate signing request (csr)

We now generate a csr using the server key generated above (output will be 
PEM formatted.)

<pre class="command-line">
# /usr/sbin/openssl req -new \
    -key /etc/ssl/private/server.key       \
    -out /etc/ssl/private/server.csr 
</pre>

The above certificate request will prompt you to reply to a number of questions, 
most of which can be left as the default. You will be asked for the Fully Qualified 
Domain Name for this host. In my experience this requires the legitimate DNS 
name that the host will be responding to.

The last part of the above instructions is to ask for 'extra' attributes.

<pre class="screen-output">
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
</pre>

For my test configuration (ie. I don't want to enter the password everytime 
I want to start Apache) I do not enter a 'challange password.' On a security 
conscious system, you probably want to specify a challenge password here and 
have someone on 24-hour availability incase the server restarts and someone 
must enter the 'challenge password' before the server starts.

The concept is that you send the above CSR for a trusted third party to sign, 
and record in their system, so users who recieve your key can validate from 
the trusted third party that you are who you are. But we don't want no third 
party saying who we are (for now anyway.)
  
#### <a name="sscCRT"></a>3. Create a self-signed certificate (X509 structure.)

the output will be PEM formatted. (The documentation discusses a script sign.sh 
to do this task for you, but I can only find CA.pl and CA.sh with similar 'purpose.') 

<pre class="command-line">
# /usr/sbin/openssl x509 -req -days 365 \
    -in      /etc/ssl/private/server.csr \
    -signkey /etc/ssl/private/server.key \
     -out     /etc/ssl/server.crt
</pre>

-x509 is the certificate structure we are using.
-days 365 is the number of days for which we want the certificate to be valid
  
#### <a name="sscTest"></a>Testing your Keys

You can test from a terminal connection the status of your keys by using the 
following commands
  
<pre class="command-line">
# openssl rsa -noout -text -in /etc/ssl/private/<b>server.</b>key   
# openssl req -noout -text -in /etc/ssl/private/<b>server.</b>csr
# openssl x509 -noout -text -in /etc/ssl/<b>server.</b>crt
</pre>

#### <a name="sscVirtualHosts"></a>Virtual Hosts

<p>Server CRTs for Virtual sites can be generated using the same above process, 
except you choose a different name for the CSR and CRT. One nice convention 
is to use the domain name of the site, for example: 
Certificate Request: <i>/etc/ssl/private/virtualsite.com.csr </i>and 
Certificate:<i> /etc/ssl/virtualsite.com.crt </i></p>

<p>Within the Virtual Host configuration you will then need to specify the appropriate 
  SSL Directive.</p>
  

<pre class="screen-output">
NameVirtualHost 192.168.101.49:*
&lt;VirtualHost 192.168.101.49:*&gt;
ServerAdmin samt@qsc.com
DocumentRoot /var/www/twig
ServerName virtualsite.com
ErrorLog logs/virtualsite.com-error_log
CustomLog logs/virtualsite.com-access_log common
SSLEngine on
SSLCipherSuite ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP
SSLCertificateFile /etc/ssl/<b>virtualsite.com.crt</b>
SSLCertificateKeyFile /etc/ssl/private/server.key
&lt;/VirtualHost&gt;
</pre>

<p><b>Security Warning:</b> Remember I know less than you about this stuff, the 
above are just notations of something that worked. It doesn't mean it works 
well.
</p>

-   <a href="#certificate.authority">Certificate Authority</a>
-   <a href="#certificate.client">Client Certificates</a>
-   <a href="#certificate.revocation">Certificate Revocation</a>

<a name="certificate.authority"></a>

### Certificate Authority (CA)

We generate and sign all our own certificates, which means we need to set
ourselves up a CA certificate with will act as the master certificate with which
we sign all server and client certificates.

With the OpenSSL PKITOOLS, we document <a href="server.html#createcertificates">the process for Creating Certificates</a>:

<a href="server.html#createcertirficates.ca">Creating a CA Certificate</a> manually involves:

- Generating our Private CA Key
- Generate a CA Signing Request
- Go ahead and "Self Sign it"!!

OpenVPN CA are built using the <a href="server.html#createcertificates.ca">./build-ca</a> which invokes PKITOOL and the following command:

<pre class="command-line">
openssl req -days 3650 -new -newkey rsa:4096 -sha1 \
    -x509 -keyout path-to/private/ca.key \
    -out path-to/private/ca.crt \
    -config path-to/openssl.cnf &amp;&amp; \
    chmod 0600 path-to/private/ca.key
</pre>

Which ever manner you choose to generate the keys, you can validate the keys creation by
using OpenSSL.

<pre class="command-line">
openssl rsa -noout -text -in path-to/private/ca.key
openssl x509 -noout -text -in path-to/private/ca.crt
</pre>

<a name="certificate.client"></a>

#### Client Certificates

OpenVPN Client Certificates are generated using <a href="server.html#createcertificate.client">./build-key</a> client_details1.

which invokes PKITOOL and the following command:

<pre class="command-line">
openssl req -days 3650 -new -newkey rsa:4096 \
    -keyout path-to/keys/client_details1.key \
    -out path-to/keys/client_details1.csr \
    -config -path-to/openssl.cnf
</pre>

<a name="certificate.revocation"></a>

#### Certificate Revocation (CRL)

Certificate revocation is handled using a CRL pem file.  All certificates that
are generated and issued are tracked by the CA through a text based database
file "index.txt".  As new certificates are generated, they are keyed with a
sequentially increasing serial number that uniquely identifies each key that has
been generated and signed by our CA certificate.

If we need to revoke a certificate we use the "revoke-full" script (part of the
provided OpenSSL toolkit that comes with OpenVPN), which then adds the unique
serial identified for the key to be revoked to the CRL pem file.  OpenVPN will
then refuse to authorise the revoked certificate.

If you want to view which serial identifiers are currently in the crl.pem file,
you can use the following command:

<pre class="command-line">
openssl crl -in /etc/openvpn/keys/crl.pem -outform DER |
openssl crl -inform DER -text -noout
</pre>

The output of these commands will look like the following:


<pre class="command-line">
Certificate Revocation List (CRL):
        Version 1 (0x0)
        Signature Algorithm: md5WithRSAEncryption
        Issuer: /C=AU/ST=NSW/L=SYDNEY/O=Nullcube/CN=Nullcube CA/emailAddress=...
        Last Update: Jun  3 23:12:48 2008 GMT
        Next Update: Jul  3 23:12:48 2008 GMT
    Revoked Certificates:
        Serial Number: 0A
            Revocation Date: May 18 05:38:19 2007 GMT
        Serial Number: 1A
            Revocation Date: Apr 30 02:41:24 2007 GMT
        Serial Number: 2B
            Revocation Date: Jun  3 23:12:48 2008 GMT
        ...
</pre>

You can then grep the serials (0A, 2B etc) out of the index.txt file as
follows:

<pre class="command-line">
# grep 0A /etc/openvpn/keys/index.txt
</pre>
<pre class="screen-output">
R 161209135638Z 070518053819Z 0A unknown /C=AU/ST=NSW/L=SYDNEY/O=MYCORP/CN=...
</pre>

Sample Script to automate the above

<pre class="command-line">
#!/bin/sh
# Grab List of Revoked Keys

COUNTRY="AU"
STATE="NSW"
LOCATION="SYDNEY"
ORG="MYCORP"
ADMIN1="admin1@example.com"
ADMIN2="admin2@example.com"
KEYSDIR=/etc/openvpn/keys
CRLPEM=$KEYSDIR/crl.pem 
INDEX=$KEYSDIR/index.txt

SERIALS=`openssl crl -in $CRLPEM -outform DER |\
        openssl crl -inform DER -text -noout | \
        grep "Serial Number:" | awk -F ":" '{ print $2 }'`
echo "State Serial Client-Details"
echo "-------------------------------------"
for i in $SERIALS; 
do grep $i $INDEX | grep "^R" | awk '{print $1, $4, $6}' | \
        sed "s/\/C=$COUNTRY//;s/\/ST=$STATE//;s/\/L=$LOCATION//" | \
        sed "s/\/O=$ORG//;s/\/CN=//" |\
        sed "s/\/emailAddress=$ADMIN1//;s/\/emailAddress=$ADMIN2//" 
done 
echo "-------------------------------------"
echo "State Serial Client-Details"
</pre>

Working in the opposite direction, you can now use the above generated list (confirming
the Serial Number, 2nd field in the list) (to verify
the Revocation date

For a list of active keys, use the following

<pre class="command-line">
#!/bin/sh

# Grab List of Active Keys

COUNTRY="AU"
STATE="NSW"
LOCATION="SYDNEY"
ORG="MYCORP"
ADMIN1="admin1@example.com"
ADMIN2="admin2@example.com"
KEYSDIR=/etc/openvpn/keys
CRLPEM=$KEYSDIR/crl.pem 
INDEX=$KEYSDIR/index.txt

SERIALS=`openssl crl -in $CRLPEM -outform DER |\
        openssl crl -inform DER -text -noout | \
        grep "Serial Number:" | awk -F ":" '{ print $2 }'`
echo "State Serial Client-Details"
echo "-------------------------------------"
for i in $SERIALS; 
do grep $i $INDEX | grep -v "^R" | awk '{print $1, $3, $5}' | \
        sed "s/\/C=$COUNTRY//;s/\/ST=$STATE//;s/\/L=$LOCATION//" | \
        sed "s/\/O=$ORG//;s/\/CN=//" |\
        sed "s/\/emailAddress=$ADMIN1//;s/\/emailAddress=$ADMIN2//" 
done 
echo "-------------------------------------"
echo "State Serial Client-Details"
</pre>
