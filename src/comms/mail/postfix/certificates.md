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
well.



### <a name="ca"></a> Certificate Authority (CA)

We want to be our own Certificate Authority (CA) so that we can sign multiple certificates 
with the same CA for multiple servers.

The long-form command-line [req](http://www.openssl.org/docs/apps/req.html) creates
both a certificate and key:

<!--(block|syntax("bash"))-->
$ sudo openssl req -days 365 -new -newkey rsa:4096 -sha1 -x509 \
	-keyout /path-to/private/ca.key.pem \
    -out    /path-to/private/ca.crt.pem \
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
$ openssl x509 -noout -text -in /path-to/private/ca.crt.pem
<!--(end)-->

You can pre-fill the content for the CA by using the -subj option

<!--(block|syntax("bash"))-->
$ sudo openssl req -days 365 -new -newkey rsa:4096 -sha1 -x509 \
	-keyout /path-to/private/ca.key.pem \
    -out    /path-to/private/ca.crt.pem \
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
$ sudo openssl rsa -noout -text -in /path-to/private/server.key.rsa.pem
<!--(end)-->
  
### <a name="selfsigned"></a> Self Signed certificate (X509 structure.)

<!--(block|syntax("bash"))-->
$ sudo /usr/sbin/openssl x509 -req -days 365 \
    -in      /path-to/private/server.csr.pem \
    -CA      /path-to/private/ca.crt.pem \
    -CAkey   /path-to/private/ca.key.pem \
    -CAcreateserial \
    -signkey /path-to/private/server.key.pem \
    -out    /path-to/server.crt.pem
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
$ sudo openssl x509 -noout -text -in /path-to/server.crt.pem
<!--(end)-->

To verify that the key is paired with the certificate you just created, 
compare modulus (they should be the same)

<!--(block|syntax("bash"))-->
$ sudo openssl rsa -noout -text -in /path-to/private/server.key.pem -modulus \
    | grep ^Modulus | openssl md5
$ sudo openssl x509 -noout -text -in /path-to/server.crt.pem -modulus \
    | grep ^Modulus | openssl md5
<!--(end)-->

According to notes out there (?) The modulus and "public exponent" need to be the
same on the certificate and key file. If you've created the KEY and self-signed the
certificate correctly, then the above commands will return the same value.

### <a name="combined"></a> Combined Certificates

Ref: Postfix HOWTO TLS/SSL

<pre class="manpage">
To enable a remote SMTP client to verify the Postfix SMTP server certificate,
the issuing CA certificates must be made available to the client. You should
include the required certificates in the server certificate file.
</pre>

<!--(block|syntax("bash"))-->
# cat /path-to/server.crt.pem /path-to/private/ca.crt.pem > /path-to/server.pem
<!--(end)-->

### <a name="diffie"></a> Diffie Helman

<!--(block|syntax("bash"))-->
$ sudo openssl dhparam -out /path-to/dh_512.pem  -2 512
$ sudo openssl dhparam -out /path-to/dh_1024.pem -2 1024
<!--(end)-->
