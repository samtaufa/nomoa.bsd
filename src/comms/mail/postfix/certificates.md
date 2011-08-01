## OpenSSL Certificates

&#91;Ref: OpenBSD 4.9, [Postfix TLS Support](http://www.postfix.org/TLS_README.html)  ]

<div class="toc">

<p>Table of Contents</p>

<ul>
	<li><a href="#ca">Certificate Authority</a></li>
	<li><a href="#csr">Certificate Request</a></li>
	<li><a href="#selfsigned">Self Signed</a></li>
	<li><a href="#verify">Verify Keys</a></li>
	<li><a href="#combined">Combined Certificate</a></li>
	<li><a href="#diffie">Diffie Helman</a></li>
</ul>

</div>

OpenBSD ships with built in support for OpenSSL and OpenSSH in the base
install for encrypted communication. Both systems use public key algorithms,
where key-pairs are used with one half is public, and the other half 
private.
  
**Warning:** Remember I know less than you about this stuff, these 
are notations of something that worked. It doesn't mean it works 
well. If you really want to know more about the tools, refer to the
OpenSSL website, and [madboa's Command-Line HOWTO](http://www.madboa.com/geek/openssl/)

The base install defaults to storing OpenSSL configuration files and
keys/certificates in the directory /etc/ssl. OpenSSL will look in the sub-directory
certs for trusted certificates. 

Verify the path for OpenSSL files using

<!--(block|syntax("bash"))-->
$ sudo openssl version -d
<!--(end)-->

<pre class="screen-output">
OPENSSLDIR: "/etc/ssl"
</pre>

If the path for trusted certs does not exist, create it:

<!--(block|syntax("bash"))-->
$ sudo mkdir -p /etc/ssl/certs
<!--(end)-->

### <a name="ca"></a> Certificate Authority (CA)

We want to be our own Certificate Authority (CA) so that we can sign multiple certificates 
with the same CA for multiple servers.

The long-form command-line [req](http://www.openssl.org/docs/apps/req.html) creates
both a certificate and key:

<!--(block|syntax("bash"))-->
$ sudo openssl req -days 365 -new -newkey rsa:4096 -sha1 -x509 \
	-keyout /path-to/private/ca.key.pem \
    -out    /path-to/certs/ca.crt.pem \
    -config /path-to/openssl.cnf
<!--(end)-->

<pre class="screen-output">
Generating a 4096 bit RSA private key
.........................................++
.........................++
writing new private key to 'ca.key.pem'
Enter PEM pass phrase: <b>1234</b>
Verifying - Enter PEM pass phrase: <b>1234</b>
-----
Country Name (2 letter code) []:
State or Province Name (full name) []:
Locality Name (eg, city) []:
Organization Name (eg, company) []:
Organizational Unit Name (eg, section) []:
Common Name (eg, fully qualified host name) []:
Email Address []:
</pre>
	
<!--(block|syntax("bash"))-->
$ sudo chmod 0600 /path-to/private/ca.key.pem
<!--(end)-->

Validate the key creation by using OpenSSL.

<!--(block|syntax("bash"))-->
$ openssl rsa -noout -text -in  /path-to/private/ca.key.pem
$ openssl x509 -noout -text -in /path-to/certs/ca.crt.pem
<!--(end)-->

You can pre-fill the content for the CA by using the -subj option

<!--(block|syntax("bash"))-->
$ sudo openssl req -days 365 -new -newkey rsa:4096 -sha1 -x509 \
    -keyout /path-to/private/ca.key.pem \
    -out    /path-to/certs/ca.crt.pem \
    -subj   '/CN=coco.nut.to/O=Coconut Games/C=TO/ST=Tongatapu/L=Nukualofa/emailAddress=samt@coco.nut.to' \
    -config /path-to/openssl.cnf
<!--(end)-->

We could also have generated the CA Key by using OpenSSL's 
[genrsa](http://www.openssl.org/docs/apps/genrsa.html)

<!--(block|syntax("bash"))-->
$ sudo /usr/sbin/openssl genrsa -des3 -out /path-to/private/ca.key.pem 4096
<!--(end)-->

The generated key acts as our SSL private key to be used as our 'internal' CA 
(Certificate Authority.) 

Refer/Monitor the documentation for the minimum recommended keysize.

<b>-des|-des3|-idea</b> You must specify the method to encrypt the private key or
no encryption is used.

<a name="ssc.csr"></a>

### <a name="csr"></a> Certificate Request (csr)

A certificate combines data identifying your host, and the authority that accepts
authentication of your identity. Create a certificate request (also
known as a certificate signing request) to be signed by the certificate authority.

<!--(block|syntax("bash"))-->
$ sudo /usr/sbin/openssl req -days 365 -nodes -new -newkey rsa:4096 \
    -keyout /path-to/private/server.key.pem \
    -out    /path-to/private/server.csr.pem
<!--(end)-->

<pre class="screen-output">
Enter pass phrase for server.key.pem:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:
State or Province Name (full name) []:
Locality Name (eg, city) []:
Organization Name (eg, company) []:
Organizational Unit Name (eg, section) []:
Common Name (eg, fully qualified host name) []:mx.example.com
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
</pre>

Note that the **-nodes** option above creates the key and certificate
request without requiring a password. The "password-less" nature of
the key is required for Postfix to operate correctly (i.e. it needs
to open the key at various stages)

The concept is that you send the above CSR for a trusted third party to sign, 
and record in their system, so users who recieve your key can validate from 
the trusted third party that you are who you are. But we don't want no third 
party saying who we are (for now anyway.)

Verify that the Certificate Signing Request has been created.

<!--(block|syntax("bash"))-->
$ sudo openssl req -noout -text -in /path-to/private/server.csr.pem
$ sudo openssl rsa -noout -text -in /path-to/private/server.key.pem
<!--(end)-->
  
### <a name="selfsigned"></a> Self Signed certificate (X509 structure.)

<!--(block|syntax("bash"))-->
$ sudo /usr/sbin/openssl x509 -req -days 365 \
    -in      /path-to/private/server.csr.pem \
    -CA      /path-to/certs/ca.crt.pem \
    -CAkey   /path-to/private/ca.key.pem \
    -CAcreateserial \
    -signkey /path-to/private/server.key.pem \
    -out    /path-to/certs/server.crt.pem
<!--(end)-->

<pre class="screen-output">
Signature ok
subject=/C=TO/ST=Nukualofa/L=Tongatapu/O=Coconut Farmers/OU=IT Department/CN=mx.coco.nut.to/emailAddress=spam@coco.nut.to
Getting Private key
Enter pass phrase for /path-to/private/ca.key.pem:
</pre>

### <a name="verify"></a> Verify your Keys

You can verify from you have created valid openssl keys through the 
following commands
  
<!--(block|syntax("bash"))-->
$ sudo openssl rsa -noout -text -in /path-to/private/ca.key.pem
$ sudo openssl req -noout -text -in /path-to/private/server.csr.pem
$ sudo openssl x509 -noout -text -in /path-to/certs/server.crt.pem
<!--(end)-->

To verify that the key is paired with the certificate you just created, 
compare modulus (they should be the same)

<!--(block|syntax("bash"))-->
$ sudo openssl rsa -noout -text -in /path-to/private/server.key.pem -modulus \
    | grep ^Modulus | openssl md5
$ sudo openssl x509 -noout -text -in /path-to/certs/server.crt.pem -modulus \
    | grep ^Modulus | openssl md5
<!--(end)-->

According to notes out there (?) The modulus and "public exponent" need to be the
same on the certificate and key file. If you've created the KEY and self-signed the
certificate correctly, then the above commands will return the same value.

### <a name="combined"></a> Combined Certificates

Ref: Postfix HOWTO TLS/SSL

<pre class="manpage">
To enable a remote SMTP client to verify the Postfix SMTP server certificate,
the issuing CA certificates must be made available to the client.
</pre>

 A simple way
of providing the CA certificates, is to bundle it together with your server
certificate (such as in the sample below: bundle = server cert + ca cert) where
the order of inclusion is significant.

<!--(block|syntax("bash"))-->
# cat /path-to/certs/server.crt.pem /path-to/certs/ca.crt.pem > /path-to/server.pem
<!--(end)-->

After which you should test the resulting PEM file to ensure that it will work
for us, using *'openssl verify'*

<!--(block|syntax("bash"))-->
# openssl verify -purpose sslserver /path-to/server.pem
<!--(end)-->

<pre class="screen-output">
server.pem: C=TO,ST=Tongatapu,L=Nukualofa,O=Coconut Games, CN=coco.nut.to, emailAddress=samt@coco.nut.to
error 18 at 0 depth lookup:self signed certificate
</pre>

The test failed!! Kind-of?

From the [manpage](http://www.openssl.org/docs/apps/verify.html)

<pre class="manpage">
The first line contains the name of the certificate being verified followed 
by the subject name of the certificate. The second line contains the error 
number and the depth. The depth is number of the certificate being verified 
when a problem was detected starting with zero for the certificate being verified 
itself then 1 for the CA that signed the certificate and so on. Finally a text 
version of the error number is presented. 

18 X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT: self signed certificate

    the passed certificate is self signed and the same certificate cannot be found in the list of trusted certificates.
</pre>

Review [madboa's Command-Line HOWTO](http://www.madboa.com/geek/openssl/) to
remove the error message, which is stripped from the sample code at the above
page as below root level command-lines.

<!--(block|syntax("bash"))-->
# cd /path-to/certs
# HASH=$(openssl x509 -noout -hash -in server.crt.pem)
# echo $HASH
# ln -s server.crt.pem ${HASH}.0
<!--(end)-->

If we've understood madboa's notes, and you've understood our mis-interpretation,
then you should get the following response:

<!--(block|syntax("bash"))-->
# openssl verify -purpose sslserver /path-to/server.pem
<!--(end)-->

<pre class="screen-output">
server.pem: OK
</pre>

Wooo hoo, It works.


### <a name="diffie"></a> Diffie Helman

<!--(block|syntax("bash"))-->
$ sudo openssl dhparam -out /path-to/dh_512.pem  -2 512
$ sudo openssl dhparam -out /path-to/dh_1024.pem -2 1024
<!--(end)-->

### <a name="other"></a> Other

-   [Testing for SSL-TLS (OWASP-CM-001)](https://www.owasp.org/index.php/Testing_for_SSL-TLS_%28OWASP-CM-001%29)