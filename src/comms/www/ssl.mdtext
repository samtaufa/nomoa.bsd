
## SSL Self-signed Certificates

<div class="toc">

Table of Contents

<ul>
    <li><a href="#sscKey" class="anchBlue">Generate a Signing Key</a></li>
    <li><a href="#sscCSR">Server Certificate Signing Request</a></li>
    <li><a href="#sscCRT" class="anchBlue">Signing the Certificate</a></li>
    <li><a href="#sscTest" class="anchBlue">Testing the Keys</a></li>
    <li><a href="#sscVirtualHosts" class="anchBlue">Virtual Hosts</a></li>
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
SSLCertificateFile    /etc/ssl/<font color="#0000FF"><b>server.crt</b></font>
SSLCertificateKeyFile /etc/ssl/<font color="#0000ff"><b>private/server.key</b></font>
</pre>

#### <a name="sscKey"></a>1. Generate a Signing key (1024 bit size) : 

<pre class="command-line">
# <b>/usr/sbin/openssl genrsa -out /etc/ssl/private/<font color="#0000FF">server.</font>key 1024 </b> 
</pre>

The generated key acts as our RSA private key for our 'internal' CA (Certificate 
Authority.) 

We can call the key anything we want, and the general mod_ssl example is ca.key, 
but in the above scenario we will use server.key. Check the mod_ssl documentation 
for why we are only using a key size of 1024.

#### <a name="sscCSR"></a>2. Generate a certificate signing request (csr)

We now generate a csr using the server key generated above (output will be 
PEM formatted.) 

<pre class="command-line"> 
# /usr/sbin/openssl req -new \
    -key /etc/ssl/private/<font color="#0000FF">server.</font>key \
    -out /etc/ssl/private/<font color="#0000FF">server.</font>csr 
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
# <b>/usr/sbin/openssl x509 -req -days 365 \</b>
    /etc/ssl/private/<font color="#0000FF">server.</font>csr \
    -signkey /etc/ssl/private/<font color="#0000FF">server.</font>key \
    -out     /etc/ssl/<font color="#0000FF">server.</font>crt
</pre>
    
<li>-x509 is the certificate structure we are using.
<li>-days 365 is the number of days for which we want the certificate to be valid

#### <a name="sscTest"></a>Testing your Keys

You can test from a terminal connection the status of your keys by using the 
following commands


<pre class="command-line"> 
# openssl rsa -noout -text -in /etc/ssl/private/<b><font color="#0000FF">server.</font></b>key 
# openssl req -noout -text -in /etc/ssl/private/<b><font color="#0000FF">server.</font></b>csr
# openssl x509 -noout -text -in /etc/ssl/<b><font color="#0000FF">server.</font></b>crt
</pre>

#### <a name="sscVirtualHosts"></a>Virtual Hosts

Server CRTs for Virtual sites can be generated using the same above process, 
except you choose a different name for the CSR and CRT. One nice convention 
is to use the domain name of the site, for example: 
Certificate Request: <i>/etc/ssl/private/virtualsite.com.csr </i>and 
Certificate:<i> /etc/ssl/virtualsite.com.crt </i>

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
    SSLCertificateFile /etc/ssl/<b><font color="#0000FF">virtualsite.com.crt</font></b>
    SSLCertificateKeyFile /etc/ssl/private/server.key
&lt;/VirtualHost&gt;
</pre>


### Converting between formats.

<ul>
<li>Certificate from DER (.crt .cer .der) to PEM
<pre class="command-line">
openssl x509 -in input.crt -inform DER -out output.crt -outform PEM
</pre>
<li>Certificate from PEM to PKCS#12 (.pfx .p12)
<pre class="command-line">
openssl pkcs12 -export -in input.pem -inkey key.pem -out output.p12
</pre>
<li>Certificate from PEM to PKCS#12 (.pfx .p12) containing a private key
<pre class="command-line">
openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key \
-in certificate.crt -certfile CACert.crt
</pre>
<li>Certificate from PKCS#12 to PEM, certificates only
<pre class="command-line">
openssl pkcs12 -in input.p12 -out output.pem -nodes -clcerts
</pre>
<li>Certificate from PKCS#12 (.pfx .p12) to PEM containing a private key and certificates 
<pre class="command-line">
openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes
</pre>
<li>KEY from DER to PEM
<pre class="command-line">
openssl rsa -in input.key -inform DER -out output.key -outform PEM
</pre>
<li>KEY from NET to PEM
<pre class="command-line">
openssl rsa -in input.key -inform NET -out output.key -outform PEM
</pre>
</ul>
