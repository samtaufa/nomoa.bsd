
## SSL Self-signed Certificates

<div class="toc">

Table of Contents

<ul>
    <li><a href="#sscKey">Generate a Signing Key</a></li>
    <li><a href="#sscCSR">Certificate Signing Request</a></li>
    <li><a href="#sscCRT">Certificate Signing</a></li>
    <li><a href="#sscTest">Key Validation</a></li>
    <li><a href="#sscVirtualHosts">Apache Virtual Hosts</a></li>
    <li><a href="#formats">Certificate Formats</a></li>
</ul>

</div>

OpenBSD ships with built in support for OpenSSL and OpenSSH for secure encrypted 
end-to-end communication between a localhost and a remotehost. Following are 
notes on configuring and using SS# (pronounced S-S-Sharp, that's a pun)

[Last verified with OpenBSD 3.5 June 2004]

&#91;Ref: <a href="http://www.openbsd.org/faq/">OpenBSD 
FAQ</a> | mod_ssl/ssl_faq.html | /var/www/conf/httpd.conf]


SSL Communications assume the server has an authentication certificate which 
acts as a verification for whom the server publishes itself to be, and provides 
an envelope for the server's public key with which clients can encrypt communications 
bound for the server.

Creating a certificate was initially meant for a third-party authority to assist 
you in verifying that the server is who they say they are, so the creation of 
a self signing certificates requires 3 stages (a) creating a private signing 
key (b) creating a certificate request, and (c) self-authenticating your certificate 
request.

We are choosing our file names based on the standard OpenBSD/Apache configuration 
for SSLfiles

from /var/www/conf/httpd.conf

<pre class="config-file">
SSLCertificateFile    /etc/ssl/server.crt
SSLCertificateKeyFile /etc/ssl/private/server.key
</pre>

#### <a name="sscKey"></a>1. Generate a Signing key (1024 bit size) : 

<!--(block | syntax("bash") )-->
# /usr/sbin/openssl genrsa -out /etc/ssl/private/server.key 1024
<!--(end)-->

The generated key acts as our RSA private key for our 'internal' CA (Certificate 
Authority.) 

We can call the key anything we want, and the general mod_ssl example is ca.key, 
but in the above scenario we will use server.key. Check the mod_ssl documentation 
for why we are only using a key size of 1024.

#### <a name="sscCSR"></a>2. Generate a certificate signing request (csr)

We now generate a csr using the server key generated above (output will be 
PEM formatted.) 

<!--(block | syntax("bash") )--> 
# /usr/sbin/openssl req -new \
    -key /etc/ssl/private/server.key \
    -out /etc/ssl/private/server.csr 
<!--(end)-->

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


<!--(block | syntax("bash") )--> 
# /usr/sbin/openssl x509 -req -days 365 \
    /etc/ssl/private/server.csr \
    -signkey /etc/ssl/private/server.key \
    -out     /etc/ssl/server.crt
<!--(end)-->
    
<li>-x509 is the certificate structure we are using.
<li>-days 365 is the number of days for which we want the certificate to be valid

#### <a name="sscTest"></a>Testing your Keys

You can test from a terminal connection the status of your keys by using the 
following commands


<!--(block | syntax("bash") )--> 
# openssl rsa -noout -text -in /etc/ssl/private/server.key 
# openssl req -noout -text -in /etc/ssl/private/server.csr
# openssl x509 -noout -text -in /etc/ssl/server.crt
<!--(end)-->

#### <a name="sscVirtualHosts"></a>Virtual Hosts

Server CRTs for Virtual sites can be generated using the same above process, 
except you choose a different name for the CSR and CRT. One nice convention 
is to use the domain name of the site, for example: 
Certificate Request: */etc/ssl/private/virtualsite.com.csr* and 
Certificate: */etc/ssl/virtualsite.com.crt*

Within the Virtual Host configuration you will then need to specify the appropriate 
SSL Directive.

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
    SSLCertificateFile /etc/ssl/virtualsite.com.crt
    SSLCertificateKeyFile /etc/ssl/private/server.key
&lt;/VirtualHost&gt;
</pre>


<a name="formats"></a>

### Converting between formats.

&#91;Ref: IE9 Help - Certificate File Formats ]

Because we can't agree on the "one-size-fits-all" file format for the SSL
certificates, different applications/services use different formats for certificates.
Thus, we need a brief overview of these formats, and hints for converting
files between the different formats.

**Personal Information Exchange (PKCS #12)**

The Personal Information Exchange format (PFX, also called PKCS #12) 
supports secure storage of certificates, private keys, and all 
certificates in a certification path.

The PKCS #12 format is the only file format that can be used to
export a certificate and its private key.

**Cryptographic Message Syntax Standard (PKCS #7)**

The PKCS #7 format supports storage of certificates and all 
certificates in the certification path. 

**DER-encoded binary X.509**

The Distinguished Encoding Rules (DER) format supports storage 
of a single certificate. This format does not support storage 
of the private key or certification path.

**Base64-encoded X.509**

The Base64 format supports storage of a single certificate. 
This format does not support storage of the private key or 
certification path.

#### Converting Certificates

<table>
	<tr>
	<th>From / To </th>
	<th>Command</th>
	</tr><tr><td nowrap>
DER (.crt .cer .der) to PEM
	</td><td nowrap>
<!--(block | syntax("bash") )-->
openssl x509 -in input.crt -inform DER -out output.crt -outform PEM
<!--(end)-->
	</td></tr>
	<tr><td nowrap>
	PEM to PKCS#12 (.pfx .p12)
	</td><td nowrap>
<!--(block | syntax("bash") )-->
openssl pkcs12 -export -in input.pem -inkey key.pem -out output.p12
<!--(end)-->
	</td></tr>
	<tr><td nowrap>
	PEM to PKCS#12 (.pfx .p12) 
	</td><td nowrap>
May contain a private key.	
<!--(block | syntax("bash") )-->
openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key \
-in certificate.crt -certfile CACert.crt
<!--(end)-->
	</td></tr>
	<tr><td nowrap>
PKCS#12 to PEM
	</td><td nowrap>
<!--(block | syntax("bash") )-->
openssl pkcs12 -in input.p12 -out output.pem -nodes -clcerts
<!--(end)-->
	</td></tr>
	<tr><td nowrap>
PKCS#12 (.pfx .p12) to PEM  
	</td><td nowrap>
	May contain a private key and certificates
<!--(block | syntax("bash") )-->
openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes
<!--(end)-->
	</td></tr>
</table>

#### Converting KEYS

<table>
	<tr>
	<th>From / To </th>
	<th>Command</th>
	</tr><tr><td nowrap>
	DER to PEM
	</td><td nowrap>
<!--(block | syntax("bash") )-->
openssl rsa -in input.key -inform DER -out output.key -outform PEM
<!--(end)-->
	</td>
	</tr><tr>
	<td nowrap>
		NET to PEM
	</td><td nowrap>
<!--(block | syntax("bash") )-->
openssl rsa -in input.key -inform NET -out output.key -outform PEM
<!--(end)-->
	</td>
	</tr>
</table>
