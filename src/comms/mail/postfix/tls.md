
&#91;Ref: $!OpenBSD!$ 4.9 amd64/i386,
[Postfix](http://www.postfix.org) 2.8.3, 
[TLS Support](http://www.postfix.org/TLS_README.html) ]

<div class="toc">

<p>Table of Contents</p>

<ul>
	<li><a href="#config">Configure TLS</a>
    <ol>
        <li><a href="#config.server">SMTPD Server</a></li>
        <li><a href="#config.client">SMTP Client</a></li>
        <li><a href="#config.policy">TLS Policy Table</a></li>
    </ol>
    </li>
	<li><a href="#smtps">SMTPS Daemon</a></li>
	<li><a href="#verify">Verification</a>
    <ol>
        <li><a href="#verify.starttls">SMTP Using STARTTLS</a></li>
        <li><a href="#verify.smtps">SMTPS</a></li>
    </ol>
    </li>
</ul>

</div>


There's abundant documentation with Postfix for configuring Postfix with
TLS. The following notes are directed at enabling TLS for Postfix as
the server, and as a client to other SMTP servers. The notes have been
shown to work/functional on a clean and working copy of Postfix, it is 
left to the reader to adapt to their own configuration for Postfix.

## <a name="config"></a> Configure TLS

TLS is dependent on Postfix (a) [compiled with support for encryption](
http://www.postfix.org/TLS_README.html#how), and (b) the appropriate
SSL certificates. Fortunately, the OpenBSD standard packages builds Postfix with
SSL support. Install from a prebuilt package.

OpenSSL is installed on the standard install, create certificates, as described in various Internet
resources, or our own interpretation at [SSL Certificate Generation using OpenSSL](
certificates.html)

### <a name="config.smtpd"></a> SMTPD Server

Servicing TLS connections from clients is configured independently of
the connecting from the Postfix server to another SMTP server.

File excerpt: /etc/postfix/main.cf

<!--(block|syntax("py"))-->
smtpd_tls_loglevel = 1

smtpd_tls_security_level = may
smtpd_tls_CAfile = /path-to/private/ca.crt.pem
smtpd_tls_cert_file = /path-to/server.crt.pem
smtpd_tls_key_file  = /path-to/private/server.key.pem
smtpd_tls_received_header = yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_tls_session_cache
smtpd_tls_mandatory_ciphers = high
smtpd_tls_mandatory_protocols = TLSv1, SSLv3
smtpd_tls_mandatory_protocols = !SSLv2

smtpd_tls_dh1024_param_file = /path-to/dh_1024.pem
smtpd_tls_dh512_param_file  = /path-to/dh_512.pem
smtpd_tls_eecdh_grade       = strong
<!--(end)-->

### <a name="config.client"></a> SMTP Client

To enable Postfix to send mail using TLS, the below configuration is
appropriate.

Note, the Postfix documentation specifies:

<blockquote>
Do not configure Postfix SMTP client certificates unless you <strong>must</strong>
present client TLS certificates to one or more servers. Client certificates are not
usually needed, and can cause problems in configurations that work well without
them. The recommended settings is to let the defaults stand
</blockquote>

Otherwise, ..., if you really must set something, try the following for
our 'known' configuration for certificates.

File excerpt: /etc/postfix/main.cf

<!--(block|syntax("py"))-->
smtp_tls_loglevel = 1

smtp_tls_cert_file = /path-to/server.pem
smtp_tls_key_file = /path-to/private/server.key.pem
smtp_tls_CAfile = /path-to/private/ca.crt.pem

smtp_tls_session_cache_database = btree:${data_directory}/smtp_tls_session_cache
smtp_tls_security_level = may
smtp_tls_policy_maps = hash:/etc/postfix/tls_policy
smtp_tls_note_starttls_offer = yes
smtp_tls_mandatory_ciphers = medium
smtp_tls_mandatory_exclude_ciphers = RC4, MD5
smtp_tls_exclude_ciphers = aNULL
smtp_tls_mandatory_protocols = SSLv3, TLSv1
smtp_tls_ciphers = export
smtp_tls_protocols = !SSLv2
<!--(end)-->

Client Side smtp configuration.

#### Opportunistic TLS

**smtp\_tls\_security_level = may**

Opportunistic TLS, the SMTP transaction is encrypted if the STARTTLS ESMTP is supported
by the server.

### <a name="config.policy"></a> TLS Policy Table
  
Ref: [postconf(5)](http://www.postfix.org/postconf.5.html#smtp_tls_policy_maps)

<pre class="manpage">
The TLS policy table is indexed by the full next-hop destination, 
which is either the recipient domain, or the verbatim next-hop. 
This includes any enclosing square brackets and any non-default 
destination server port suffix. 

:::

When the lookup key is a domain name without enclosing square brackets or 
any :port suffix (typically the recipient domain), and the full domain is 
not found in the table, just as with the transport(5) table, the parent domain 
starting with a leading "." is matched recursively. This allows one to specify a 
security policy for a recipient domain and all its sub-domains. 
</pre>
  
File excerpt: /etc/postfix/tls_policy

<!--(block|syntax("bash"))-->
example.com	    may
.example.com    may
<!--(end)-->

Policy options are **none | may | encrypt | fingerprint | verify | secure**. 
Once satisfied that configuration and connections are encrypting data, 
then the policy can be updated to *encrypt*.

File excerpt: /etc/postfix/tls_policy

<!--(block|syntax("bash"))-->
example.com     encrypt protocols=TLSv1
.example.com    encrypt
<!--(end)-->

You can also override the transport settings, and specify explicit routing 
with the following style

File excerpt: /etc/postfix/tls_policy

<!--(block|syntax("bash"))-->
[example.com]:25     encrypt protocols=TLSv1
[example.net]:465    encrypt protocols=TLSv1 ciphers=high
<!--(end)-->

Note: there is allusion in the documentation that you should use only one
of the above styles.

## <a name="smpts"></a> SMTPS Daemons

Although not necessary, we can enable explicit encrypted services on port smtps(465)
through the master.cf

<!--(block|syntax("bash"))-->
smtps   inet   n    -    -    -    -    smtpd
   -o smtpd_tls_wrappermode=yes
<!--(end)-->


## <a name="verify"></a> Verification

When the configuration is working, you should not get any warning or error messages 
in /var/log/maillog during startup, nor when explicitly initiating TLS communications.
The following connection methods are to allow you to simulate what a valid
client connection will be, and to monitor your logs for errors that may
occur (and to rectify them, obviously.)

### STARTTLS

To confirm that TLS is supported, you can connect to the Postfix daemon,
and list supported services with the EHLO command. If STARTTLS is supported,
configured, then in the list of features listed should be STARTTLS.

To negotiate an encrypted channel (TLS), use the command STARTTLS as in the example below.
Obviously, it's difficult to respond to encrypted communications
using the keyboard, so once you can intiate TLS without error messages
you are one step further to reviewing more complete tests.

<!--(block|syntax("bash"))-->
telnet localhost smtp
<!--(end)-->
<pre class="screen-output">
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 mx.coco.nut.to ESMTP Postfix
</pre>
<!--(block|syntax("bash"))-->
EHLO example.com
<!--(end)-->
<pre class="screen-output">
250-mx.coco.nut.to
250-PIPELINING
250-STARTTLS
</pre>
<!--(block|syntax("bash"))-->
STARTTLS
<!--(end)-->
<pre class="screen-output">
220 2.0.0 Ready to start TLS
</pre>

Incorrect configuration should be readily detected in console error messages,
or by watching /var/log/maillog.

Get out of the connection.

### <a name="verify.starttls"></a> SMTP using STARTTLS

[openssl s_client](http://www.openssl.org/docs/apps/s_client.html) provides a
command-line mechanism for initiating a connection, and starting STARTTLS
to encrypte connection link.

<!--(block|syntax("bash"))-->
openssl s_client -starttls smtp -crlf -connect localhost:25
<!--(end)-->
<pre class="screen-output">
A lot of certificate information is exchanged, and shown on the screen

...

250 DSN
</pre>
<!--(block|syntax("bash"))-->
MAIL FROM: <samt@example.com>
<!--(end)-->
<pre class="screen-output">
250 2.1.0 Ok
</pre>
<!--(block|syntax("bash"))-->
RCPT TO: mylocaluser
<!--(end)-->
<pre class="screen-output">
250 2.1.5 Ok
</pre>
<!--(block|syntax("bash"))-->
DATA
<!--(end)-->
<pre class="screen-output">
354 End data with <CR><LF>.<CR><LF>
</pre>
<!--(block|syntax("bash"))-->
Subject: STARTTLS Test Message

Postfix will decrypt

.
<!--(end)-->
<pre class="screen-output">
250 2.0.0 Ok: queued as XXXXXXXXXXX
</pre>
<!--(block|syntax("bash"))-->
quit
<!--(end)-->
<pre class="screen-output">
221 2.0.0 Bye
</pre>

**openssl's s_client -starttls smtp** tells it to make the encryption/decrypting
between our console and an SMTP server. Once connected, then we can go through our
normal smtp test message commands. (Shown in CAPITAL letters above.)

### <a name="verify.smtps"></a> SMTPS

Verify the wrapmode smtps service is working correctly using the
generic [openssl s_client](http://www.openssl.org/docs/apps/s_client.html)
connection.

<!--(block|syntax("bash"))-->
openssl s_client -connect localhost:465
<!--(end)-->
<pre class="screen-output">
CONNECTED(0000000X)
Plenty of Certificate negotiation/information

220 mx.coco.nut.to ESMTP Postfix
</pre>

At this point, you should be able to complete the SMTP test connection
using the same example as above for SMTP STARTTLS.

If all things work out, you now have a working TLS server for mail going into your
server. Use the above information for verifying your mail server can also send out
using TLS.