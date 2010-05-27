## Validating connectivity, performance, configuration

<div style="float:right">

    Table of Content
    
<ol>
    <li> Remote Connectivity
        <ul>
            <li> <a href="#test.smtp">smtp</a> 
                <ul>
                    <li>telnet localhost smtp</li>
                    <li>log entries</li>
                    <li>mail</li>
                    <li>Relay
                        <ul>
                            <li>Deliver</li>
                            <li>Receipt</li>
                        </ul></li>
                    <li>summary</li>
                </ul></li>
            <li> <a href="#test.pop3">pop3</a>
                <ul>
                    <li>telnet localhost pop3</li>
                    <li>log entries</li>
                </ul></li>
            <li> <a href="#test.imap">imap</a>
                <ul>
                    <li>telnet localhost imap</li>
                    <li>log entries</li>
                </ul></li>
        </ul></li>
    <li> <a href="#test.Behaviour">Behaviour</a>
        <ul>
            <li> <a href="#test.performance">Performance</a></li>
            <li> <a href="#test.nmap">Publicly Accessible Services</a></li>
            <li> <a href="#test.relay">Open Relay</a></li>
        </ul></li>
    <li> <a href="#test.external">Related Notes</a>
        <ul>
            <li> <a href="#test.ssl">Diagnosing POP3, IMAP and SMTP via SSL</a></LI>
        </ul></li>
</ol>

</div>

As a conglomeration of various services, there are a 
number of separate tests that can be carried out to 
confirm, validate a systems activity, performance.

<div style="">
    <img src='@!urlTo("media/images/mail/mailserver.png")!@' title="Serving Electronic Mail">
</div>

General Remote/Local connections are through the standard protocols 
( smtp, pop3, and imap ) whereas service behaviour have some other
attributes that can also be monitored.

The following are a number of utilities, methodologies for validating
your server's behaviour, performance during development and 
after deployment.

### Remote Connectivity

<a name="test.smtp"></a>

#### SMTP - Simple Message Transfer Protocol


##### telnet

Telnet is a useful tool for connectivy testing with servers that
respond with Text responses and support protocols that can
be entered at the command-line. Services that generally support
this include smtp, imap, and pop3.

<pre class="command-line">
$ telnet localhost smtp
</pre>
<pre class="screen-output">
Trying ::1...
Connected to localhost.
Escape character is '^]'.
220 myhost.example.org ESMTP Postfix
</pre>
<pre class="command-line">
EHLO example.org
</pre>
<pre class="screen-output">
250-myhost.example.org 
250-PIPELINING 
250-SIZE 10240000 
250-VRFY 
250-ETRN 
250-ENHANCEDSTATUSCODES 
250-8BITMIME 
250 DSN 
</pre>
<pre class="command-line">
MAIL FROM: &lt;samt@example.org&gt;
</pre>
<pre class="screen-output">
250 2.1.0 Ok 
</pre>
<pre class="command-line">
RCPT TO: &lt;samt@example.org&gt;
</pre>
<pre class="screen-output">
250 2.1.5 Ok
</pre>
<pre class="command-line">
DATA
</pre>
<pre class="screen-output">
354 Enter mail, end with '.' on a line by itself
</pre>
<pre class="command-line">
Subject: This is my subject line
        
I continue writing until I'm out of interesting things to say
which is not that far away

.
</pre>
<pre class="screen-output">
250 2.0.0 Ok: queued as 699ACBA2D7
</pre>
<pre class="command-line">
QUIT
</pre>
<pre class="screen-output">
221 2.0.0 Bye 
Connection closed by foreign host.
</pre>
        
I've just used capital letters for the SMTP commands, but obviously they work 
fine with lowercase.

If your server is not yet online with a valid DNS record, then you can test 
using RCPT TO: samt@localhost.

##### Log Entries

[ $!manpage('tail')!$ ]

Confirm where your MTA logs it's messages, but in general mail entries are logged
in the /var/log/maillog file, and we can monitor general activities through this
file.

Screen Session

<pre class="command-line">
# tail -f /var/log/maillog
</pre>

<pre class="screen-output">
starting the Postfix mail system
daemon started -- version 2.3.2, configuration 
/etc/postfix
connect from localhost[::1]
5E4A5BA2D4: client=localhost[::1]
5E4A5BA2D4: message-id=&lt;20061212080251.5E4A5BA2D4@hostname.example.org&gt;
5E4A5BA2D4: from=&lt;samt@example.org&gt;, size=457, nrcpt=1 (queue active)
5E4A5BA2D4: to=&lt;samt@example.org&gt;, relay=local, delay=77, delays=77/0.05/0/0.03, dsn=2.0.0, status=sent (delivered to mailbox)
5E4A5BA2D4: removed
disconnect from localhost[::1]
</pre>

From the manpage: '$!manpage('tail',1)!$' 

<pre class="screen-output">
    The tail utility displays the contents of file or, by default, its
    standard input, to the standard output.

-f  Do not stop when end-of-file is reached; instead, wait for
    additional data to be appended to the input.  If the file is
    replaced (i.e., the inode number changes), tail will reopen the
    file and continue.  If the file is truncated, tail will reset its
    position to the beginning.  This makes tail more useful for
    watching log files that may get rotated.  The -f option is
    ignored if the standard input is a pipe, but not if it is a FIFO.
</pre>

Using the '-f' parameter tells 'tail' to continue looking at the recent additions to the 
file (such that updates to the file are displayed on the screen for us.) Use 
Ctrl+C (i.e. hold the Ctrl key while pressing C) to break out of the log review 
session shown above

##### mail

[Ref: $!manpage('mail',1)!$ ]

While we're testing with real system user accounts, we can use the unix 
'mail' program to check our mail message.

Screen Session

<pre class="command-line">
# /usr/bin/mail -u samt
</pre>
<pre class="screen-output">
Mail version 8.1.2 01/15/2001. Type ? for help.
'/var/mail/samt': 1 message 1 new
&gt;N 1 samt@example.org Tue Dec 12 21:03 18/605 This is my subject line
</pre>

<pre class="command-line">
&amp; <strong>more 1</strong>
</pre>

<pre class="screen-output">
Message 1:
From samt@example.org Tue Dec 12 21:03:54 2006
X-Original-To: samt@myhost.example.org
Delivered-To: samt@myhost.example.org
Subject: This is my subject line
From: samt@example.org
To: undisclosed-recipients:;

I continue writing until I'm out of interesting things to say
which is not that far away
</pre>
<pre class="command-line">
&amp; q
</pre>

<pre class="screen-output">
Saved 1 message in mbox
</pre>

In the above example, we enter mail for the user samt ('-u samt') and the 
'mail' client shows a list of current email for user 'samt' and then gives us 
the '&amp;' ampersand prompt.

We can read the email message by typing the message number, and 'mail' 
supports the use of a screen 'pager' such as 'more' so that we can scroll 
through longer messages.

From the manpage: $!manpage('mail',1)!$
<pre class="screen-output">
Reading mail
    In normal usage, mail is given no arguments and checks your mail out of
    the post office, then prints out a one line header of each message found.
    The current message is initially set to the first message (numbered 1)
    and can be printed using the print command (which can be abbreviated p).
    Moving among the messages is much like moving between lines in ed(1); you
    may use + and - to shift forwards and backwards, or simply enter a
    message number to move directly.
</pre>

Quit. We quit out of 'mail' using the 'q' command.

The above reference to the log files and mail client is to provide you with more tools for validating your installation.</p>

##### Mail Receipt

[ $!manpage('telnet')!$, $!manpage('mail')!$, /var/log/maillog ]

Verify that the mail server will accept tcp connections on smtp 
from the below by sending mail to a user account on the mail host:

- localhost
- relay network
- external network

With the verification, ensure that email is recieved by watching the maillog to note:

-   mail is accepted (queued) by the mail server
-   mail is delivered (sent) by the mail server (in this case, delivery is to a local 
    mail box
    
An internal client (destination email) should have successfully recieved mail from the above tests.

##### Mail Delivery

[ $!manpage('telnet')!$, $!manpage('mail')!$, /var/log/maillog ]

Verify the mail server will accept tcp connections on smtp and can send mail 'to the world' 
by sending messages from:

- localhost
- LAN 

Ensure that email can be sent through and to a destination by watching the maillog to note:

- mail is accepted from the mail server host (eg. telnet from host to remote smtp server)
- mail is queued by the mail server
- mail is delivered by the mail server
    
An external client (destination email) should have successfully recieved mail from the above tests.


##### Summary

We now have a fully functional SMTP server that can receive email messages, 
and store those messages for users.</p>

<a name="test.pop3"></a>
#### POP3 - Post Office Protocol

[ref: The Network People, Inc. 
[Mail Server Testing](http://www.tnpi.biz/internet/mail/forge.shtml) ]

If you've successfully installed dovecot with mysql above, and have gone 
through the Configuring a Virtual Email Service - MySQL in <a href="postfix.htm">our postfix 
installation guide</a>, (or you have installed your own MySQL virtual user accounts) 
then we can perform some testing, validating whether our configuration actually 
works.</p>

Screen Session</p>

<pre class="command-line">
$ telnet localhost pop3
</pre>
<pre class="screen-output">
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
+OK Dovecot ready.
</pre>
<pre class="command-line">
user <span class="style3">charlie</span>@alpha.example.org
</pre>
<pre class="screen-output">
+OK</pre>
<pre class="command-line">
pass <span class="style3">charlie</span>
</pre>
<pre class="screen-output">
+OK Logged in.
</pre>
<pre class="command-line">
list
</pre>
<pre class="screen-output">
+OK 3 messages:
1 503
2 445
3 503
.</pre>
<pre class="command-line">
retr 3
</pre>
<pre class="screen-output">
+OK 503 octets
Return-Path: &lt;samt@example.org&gt;
X-Original-To: charlie@alpha.example.org
Delivered-To: charlie@alpha.example.org
Received: from example.org (unknown [IPv6:::1])
by myhost.example.org (Postfix) with ESMTP id 9A6165A950;
Fri, 9 Feb 2007 13:50:26 +1300 (TOT)
Subject: Welcome MySQL based virtual users
Message-Id: &lt;20070209005037.9A6165A950@myhost.example.org&gt;
Date: Fri, 9 Feb 2007 13:50:26 +1300 (TOT)
From: samt@example.org
To: undisclosed-recipients:;

Hopefully you've received this email message without fault ?


.
</pre>
<pre class="command-line">
QUIT
</pre>
<pre class="screen-output">
+OK Logging out.
Connection closed by foreign host.
</pre>

The maillog file should show success similar to the below</p>

File Fragment: /var/log/maillog</p>

<pre class="screen-output">
pop3-login: Login: user=&lt;charlie@alpha.example.org&gt;, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured
POP3(charlie@alpha.example.org): Disconnected: Logged out top=0/0, retr=1/519, del=0/3, size=1451
</pre>

Again, a review of the mysql transaction log can be helpful in diagnosing 
errors.</p>

File Fragment: /var/mysql/myhost.log</p>

<pre class="screen-output">
Connect dovecot@localhost on mail
Query SELECT password FROM mailbox WHERE username = 'charlie@alpha.example.org' AND active = '1'
Query SELECT maildir, 901 AS uid, 901 AS gid FROM mailbox WHERE username = 'charlie@alpha.example.org' AND active = '1'
</pre>

##### Simple Errors -ERR Authentication failed.

You get an Authentication failed even though you know and swear that you have 
entered the correct password?

-   Check the /var/mysql/myhost.log file to ensure that the correct query is 
	sent by dovecot to the MySQL Server (i.e. <span class="style14">SELECT 
	password FROM mailbox WHERE username = 'VIRTUALACCOUNT@VIRTUALDOMAIN' AND 
	active = '1'</span>)
-   Check that your dovecot configuration is using the same encryption 
	method for creating/reading passwords, as postfixadmin. For example, in our 
	exercise we are using CRYPT: <span class="style14">default_pass_scheme = 
	CRYPT</span>.


<a name="test.imap"></a>
#### IMAP - Internet Message Access Protocol

We use telnet on the localhost to test imap's configuration</p>

Screen Session

<pre class="command-line">
$ telnet localhost imap
</pre>
<pre class="screen-output">
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
* OK Dovecot ready.
</pre>
<pre class="command-line">
a1 login charlie@alpha.example.org charlie
</pre>
<pre class="screen-output">
a1 OK Logged in.
</pre>
<pre class="command-line">
a2 select inbox
</pre>
<pre class="screen-output">
* FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
* OK [PERMANENTFLAGS (\Answered \Flagged \Deleted \Seen \Draft \*)] Flags permitted.
* 3 EXISTS
* 0 RECENT
* OK [UNSEEN 1] First unseen.
* OK [UIDVALIDITY 1170991431] UIDs valid
* OK [UIDNEXT 4] Predicted next UID
a2 OK [READ-WRITE] Select completed.
</pre>
<pre class="command-line">
a3 fetch 3 body[text]
</pre>
<pre class="screen-output">
* 3 FETCH (BODY[TEXT] {66}
Hopefully you've received this email message without fault ?


)
a3 OK Fetch completed.
</pre>
<pre class="command-line">
a4 close
</pre>
<pre class="screen-output">
a4 OK Close completed.
</pre>
<pre class="command-line">
a5 logout
</pre>
<pre class="screen-output">
* BYE Logging out
a5 OK Logout completed.
Connection closed by foreign host.
</pre>

Note:

a1, a2, .., a5 are randomly selected unique leaders (in 
this case we're just making things sequential)

_&quot;<strong>a3 fetch </strong><span class="style4">3</span><strong> body[text]</strong>&quot;_, the number '3' refers to 
the '3_ EXISTS_' in the list returned by '<strong>a2 select inbox'</strong>

Your maillog file is your friend and will give you clues to where you can 
check for other errors.

File Fragment: /var/log/maillog</p>

<pre class="screen-output">
auth-worker(default): mysql: Connected to localhost 
(mail)
imap-login: Login: user=&lt;charlie@alpha.example.org&gt;, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured
IMAP(charlie@alpha.example.org): Disconnected: Logged out
</pre>

Likewise the mysql transaction log should give further assistance should the 
installation be having problems.</p>

File Fragment: /var/mysql/myhost.log</p>

<pre class="screen-output">
Connect dovecot@localhost on mail
Query SELECT password FROM mailbox WHERE username = 'charlie@alpha.example.org' AND active = '1'
Query SELECT maildir, 901 AS uid, 901 AS gid FROM mailbox WHERE username = 'charlie@alpha.example.org' AND active = '1'
</pre>

<a name="test.behaviour"></a>
### Behaviour

<a name="test.performance"></a>
#### Performance

[ ports/benchmarks/smtp-benchmark ]

<a href="http://www.openbsd.org/cgi-bin/cvsweb/ports/benchmarks/smtp-benchmark/">smtp-benchmark</a>
 is a client/server program used to push as much data through 
 the pipe to visit the mail server and review it's capacity to
 handle load.

<a href="http://www.openbsd.org/cgi-bin/cvsweb/ports/benchmarks/smtp-benchmark/">smtp-benchmark</a>
consists of two programs, smtpsend and smtpsink.
smtpsend is used to send generated e-mail messages using SMTP
to a mail transfer agent, smtpsink is designed to dispose of received
messages as quick as possible.

-   Server
-   Client

<img src='@!urlTo("media/images/mail/smtp_benchmark.png")!@'>

##### smtp-benchmark: smtpsink

The _smtpsink_ Server runs on the destination side of the mail server, 
expecting to recieve mail FROM the mail server. It basically accepts the 
message delivery from the mail server and dumps it to /dev/null

<pre class="command-line">
smtpsink -v -p 25
</pre>

##### smtp-benchmark: smtpsend

The _smtpsend_ Client measures the time spent sending e-mails and the number
of e-mails actually sent and outputs statistics after the program
run.

smtp-send can fork one or more parallel senders each using one or more
sequential connections to a SMTP server to deliver one or more
messages per connection.

smtp-sink comes in handy when the relaying performance of a MTA is
to be measured.

<pre class="command-line">
smtpsend -s 1 -m 100 -b 512 -t 120 -p 25 -F samt@example.com \
   -T user@valid-domain.com -S "Test Message" -vv SMTP_SERVER
</pre>

<a name="test.nmap"></a>

#### Publicly Accessible Services

[ ports/net/nmap ]

Verify <a href="osinstall.html#nmapscan">with nmap</a> that 
only the expected services are running on this host.

<a name="test.relay"></a>

#### Open Relay

Since a configuration failing to allow "Open Relay" is just
not excusable.

Verify with telnet that open relay is not supported, other 
than those specifically included in the server configuration.

An attempt to relay should be rejected by the mail server.

#### tcpdump -nettti interface

Our standard configurations will require mail to traverse at least two firewalls, use tcpdump at
appropriate locations to verify that the smtp traffic is tranversing the route between the client and
our server.

-   NIC - verify traffic reaches the NIC and has a route back to the client.
-   Firewall External NIC - verify traffic reaches the NIC and is not blocked
-   Firewall Internal NIC - verify traffic goes in/out the Internal link and indicates return route from the client.

<a name="test.external"></a>

### External Links

<a name="test.ssl"></a>
## Diagnosing POP3, IMAP and SMTP via SSL

[ Formerly @ http://www.h-online.com/security/features/print/114281 ]
<date>22 September 2009, 10:51</date>
<author>by Jrgen Schmidt</author>

For diagnostic purposes, it can be very useful to talk 
directly to your SMTP or IMAP server. Things get a little 
more complicated when encryption rears its ugly head, but 
with the right tools, it doesn't have to be a black art.

Almost all mail servers offer the option of encrypting connections. 
Two different procedures are used  either the entire service protocol 
is sent via an SSL tunnel or a protocol extension called "StartTLS" is
used to activate encryption after establishing the connection.</p>

Taking SSL services first, these usually run on dedicated, 
specially defined TCP ports. Here is a short list of the more 
important ports:</p>
 
<table>
    <tr>
        <td>Service</td>
        <td>Abbreviation</td>
        <td>TCP port</td>
    </tr>
    <tr>
        <td>HTTP over SSL</td>
        <td>https</td>
        <td style="text-align:center;">443</td>
    </tr>
    <tr>
        <td>IMAP over SSL</td>
        <td>imaps</td>
        <td style="text-align:center;">993</td>
    </tr>
    <tr>
        <td>IRC over SSL</td>
        <td>ircs</td>
        <td style="text-align:center;">994</td>
    </tr>
    <tr>
        <td>POP3 over SSL</td>
        <td>pop3s</td>
        <td style="text-align:center;">995</td>
    </tr>
    <tr>
        <td>SMTP over SSL</td>
        <td>ssmtp</td>
        <td style="text-align:center;">465</td>
    </tr>
</table>

The service listening at the TCP port expects a direct SSL connection so, for example, email clients which don't support SSL can't communicate with IMAPS servers on port 993. Once encryption parameters have been negotiated and certificates exchanged you have a tunnel, through which the actual payload protocol passes. Due to the complications involved in establishing an SSL connection, when it comes to troubleshooting, standard tools such as telnet and netcat tend to come up short.</p>

Into the breach steps the universal <b>OpenSSL[1]</b>, which includes a simple SSL client that can easily be used to set up a connection to an SSL service such as <b>https://www.heise.de[2]</b>:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">openssl s_client -host www.heise.de -port 443</span><br />
CONNECTED(00000003)<br />
[...]<br />
---<br />
Certificate chain<br />
0 s:/C=DE/ST=Niedersachsen/L=Hannover/O=Heise Zeitschriften Verlag GmbH Co KG/OU=Netzwerkadministration/OU=Terms of use at www.verisign.com/rpa (c)05/CN=www.heise.de<br />
i:/O=VeriSign Trust Network/OU=VeriSign, Inc./OU=VeriSign International Server CA - Class 3/OU=www.verisign.com/CPS Incorp.by Ref. LIABILITY LTD.(c)97 VeriSign<br />
1 s:/O=VeriSign Trust Network/OU=VeriSign, Inc./OU=VeriSign International Server CA - Class 3/OU=www.verisign.com/CPS Incorp.by Ref. LIABILITY LTD.(c)97 VeriSign<br />
i:/C=US/O=VeriSign, Inc./OU=Class 3 Public Primary Certification Authority<br />
---<br />
[...]
</span></p>
 
<p>the information provided by openssl allows us to examine the certificates used. Indeed failure to do so lays us open to man-in-the-middle attacks. Technically accomplished users who known how to use ettercap have reputedly used this technique to obtain administrator passwords.</p>
 
<p>The SSL client encrypts and decrypts the input and output channels transparently, allowing the user to talk directly to the server:</p>
 
<p><span style="font-family:monospace;">
<span style="color:blue;">GET / HTTP/1.1<br />
Host: www.heise.de<br />
&lt;return&gt;</span><br />
HTTP/1.1 302 Found<br />
Date: Wed, 16 Sep 2009 10:24:44 GMT<br />
Server: Apache/1.3.34<br />
Location: http://www.heise.de/<br />
[...]
</span></p>
 
<p>Next: Logging in to IMAPS</p>
 
<p><hr></p>
 
<p> </p>
#### Logging in to IMAPS
<p>Logging into an IMAPS server is only a little more complicated:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">openssl s_client -host imap.irgendwo.de -port 993</span><br />
[...]<br />
* OK IMAP4 Ready 0.0.0.0 0001f994<br />
<span style="color:blue;">1 Login user-ju secret</span><br />
1 OK You are so in<br />
<span style="color:blue;">2 LIST "" "*"</span><br />
* LIST (\HasChildren) "." "INBOX"<br />
* LIST (\HasNoChildren) "." "INBOX.AV"<br />
[...]<br />
2 OK Completed (0.130 secs 5171 calls)<br />
<span style="color:blue;">3 logout</span><br />
* BYE LOGOUT received<br />
3 OK Completed<br />
</span></p>
 
<p>Don't forget the freely-selectable sequence number which must precede the actual IMAP command. A POP3 login works in a similar way, if we identify ourselves within the SSL tunnel using the USER and PASS POP3 commands:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">openssl s_client -host pop.irgendwo.de -port 995</span><br />
[...]<br />
+OK POP server ready H mimap3<br />
<span style="color:blue;">USER user-ju</span><br />
+OK password required for user "user-ju"<br />
<span style="color:blue;">PASS secret</span><br />
+OK mailbox "user-ju" has 0 messages (0 octets) H mimap3<br />
<span style="color:blue;">quit</span><br />
+OK POP server signing off<br />
</span></p>
 
<p>An alternative option is the telnet-ssl tool which offers similar functionality.</p>
 
<p>Next: StartTLS</p>
 
<p><hr></p>
 
<p> </p>
#### StartTLS
<p>Internet providers in particular prefer to use SSL's successor, Transport Layer Security via StartTLS. It has the advantage that it can be offered as an additional option, whilst still allowing clients which don't support it to communicate with the server without encryption. The flip side of this is that email clients need to be able to cope if the server refuses a TLS connection.</p>
 
<p>The default option in many email clients, "TLS, if available", carries with it a major risk  a man-in-the-middle attacker could silently change the <span style="font-family:monospace;">StartTLS</span> command, which should activate encryption, into an <span style="font-family:monospace;"><span style="color:red;">X</span>tartTLS</span>. The server would then respond that it doesn't do XtartTLS, causing some email clients to send user data in unencrypted form unbeknown to the user. It is therefore advisable to check whether a server can handle StartTLS and then to make it obligatory. If an error message appears, it's then clear that something's wrong.</p>
 
<p>The port on which TLS services run is provider-dependant. In principle, this type of encryption can be transparently embedded within normal operations. To find out whether a mail server supports this:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">nc smtp.irgendwo.de smtp</span><br />
220 Mailserver ESMTP Exim 4.69 Wed, 16 Sep 2009 13:05:15 +0200<br />
<span style="color:blue;">ehlo test</span><br />
250-Mailserver Hello loki [10.1.2.73]<br />
250-SIZE 78643200<br />
250-PIPELINING<br />
250-STARTTLS<br />
250 HELP<br />
<span style="color:blue;">quit</span><br />
221 Mailserver closing connection<br />
</span></p>
 
<p>This list should include the command <span style="font-family:monospace;">STARTTLS</span>, which activates Transport Layer Security encryption:</p>
 
<p><span style="font-family:monospace;">
<span style="color:blue;">STARTTLS</span><br />
220 TLS go ahead<br />
</span></p>
 
<p>Netcat runs into trouble at this point, but openssl again comes to the rescue. The developers have made the SSL client smart enough to ask for TLS encryption in SMTP, POP3, IMAP and FTP, although this doesn't work with all servers.</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">openssl s_client -host mail.irgendwo.de -port 25 -starttls smtp</span><br />
CONNECTED(00000003)<br />
[...]<br />
250 HELP<br />
<span style="color:blue;">ehlo test</span><br />
250-Mailserver Hello loki [10.1.2.73]<br />
250-SIZE 52428800<br />
250-PIPELINING<br />
250-AUTH PLAIN LOGIN<br />
250 HELP<br />
</span></p>
 
<p>Next: SMTP Authentication</p>
 
<p><hr></p>
 
<p> </p>
#### SMTP Authentication
<p>Authentication in SMTP is a little more complicated. Most servers, as in this example, support the <span style="font-family:monospace;">AUTH PLAIN</span> procedure, in which the access data must be Base64 coded. This is dealt with by the Perl command:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">perl -MMIME::Base64 -e 'print encode_base64("\000user-ju\000secret")'</span><br />
AHVzZXItanUAc2VjcmV0<br />
</span></p>
 
<p>the output from which should be fed to the SMTP server:</p>
 
<p><span style="font-family:monospace;">
<span style="color:blue;">AUTH PLAIN AHVzZXItanUAc2VjcmV0</span><br />
235 Authentication succeeded<br />
</span></p>
 
<p>which signals it is ready for further SMTP commands. For protocols and servers not supported by openssl you can use gnutls-cli from the gnutls-bin package. First it creates a cleartext connection to an arbitrary TLS-enabled service such as:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">gnutls-cli -s -p submission smtp.heise.de</span><br />
Resolving 'smtp.heise.de'...<br />
Connecting to '10.1.2.41:587'...<br />
<br />
- Simple Client Mode:<br />
<br />
220 taxis03.heise.de ESMTP Exim 4.69 Wed, 16 Sep 2009 18:03:01 +0200<br />
<span style="color:blue;">ehlo test</span><br />
250-taxis03.heise.de Hello loki.ct.heise.de [10.10.22.75]<br />
250-SIZE 78643200<br />
250-PIPELINING<br />
250-STARTTLS<br />
250 HELP<br />
<span style="color:blue;">starttls</span><br />
220 TLS go ahead<br />
</span></p>
 
<p>Then you switch to a second shell to get the process ID of the running tool and send the signal SIGALARM to it:</p>
 
<p><span style="font-family:monospace;">
$ <span style="color:blue;">ps aux | grep gnutls</span><br />
ju        6103  pts/3    S+   18:03   0:00 gnutls-cli [...]<br />
$ <span style="color:blue;">kill -s SIGALRM 6103</span><br />
</span></p>
 
<p>This causes gnutls-cli to negotiate the TLS connection and to reconnect stdin and stdout to the newly created tunnel. It also presents some interesting information about the new TLS connection it just created:</p>
 
<p><span style="font-family:monospace;">
*** Starting TLS handshake<br />
- Certificate type: X.509<br />
- Got a certificate list of 1 certificates.<br />
<br />
- Certificate[0] info:<br />
# The hostname in the certificate matches 'smtp.heise.de'.<br />
# valid since: Thu Dec 14 14:08:41 CET 2006<br />
# expires at: Sun Dec 11 14:08:41 CET 2016<br />
# fingerprint: 28:8C:E0:29:B9:31:9B:96:F6:3D:B4:49:10:CD:06:80<br />
# Subject's DN: C=DE,ST=Niedersachsen,L=Hannover,O=Heise Zeitschriften Verlag GmbH Co KG,OU=Netzwerkadministration,CN=smtp.heise.de,EMAIL=admin@heise.de<br />
# Issuer's DN: C=DE,ST=Niedersachsen,L=Hannover,O=Verlag Heinz Heise GmbH & Co KG,OU=Netzwerkadministration,CN=admin@heise.de,EMAIL=admin@heise.de<br />
<br />
- Peer's certificate issuer is unknown<br />
- Peer's certificate is NOT trusted<br />
- Version: TLS 1.0<br />
- Key Exchange: DHE RSA<br />
- Cipher: AES 256 CBC<br />
- MAC: SHA<br />
- Compression: NULL<br />
<span style="color:blue;">quit</span><br />
221 taxis03.heise.de closing connection<br />
- Peer has closed the GNUTLS connection<br />
</span></p>
 
<p>This allows you to interactively connect to arbitrary TLS enabled services.  Users wanting to experiment further may be interested to know that openssl also includes <span style="font-family:monospace;">s_server</span> which is able to emulate a very simple www server. <span style="font-family:monospace;">gnutls-serv</span> provides similar functionality for the gnutls-bin package.</p>
 
<p>(<b>ju[3]</b>)
</p>
 
<!-- /HEISETEXT -->
<hr />
<p>
    <strong>URL of this article:</strong><br />
    http://www.h-online.com/security/features/114281
</p>
 
<p>
    <strong>Links in this article:</strong><br />
    &nbsp;&nbsp;[1]&nbsp;http://www.openssl.org/<br />
&nbsp;&nbsp;[2]&nbsp;https://www.heise.de<br />
&nbsp;&nbsp;[3]&nbsp;mailto:ju@heisec.de<br />
</p>
<div >
    <span class="left">Copyright &copy; 2009 <a href="/contact/">Heise Media UK Ltd.</a></span>
    <span class="right"><a href="/security/privacy/">Privacy Policy</a> <a href="/security/contact/">Contact us</a></span>
</div>
 
