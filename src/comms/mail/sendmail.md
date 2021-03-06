﻿
##  Serving with sendmail 
 
<div class="toc">
    <p> Table of Contents: </p>
    <ul>
      <li> <a href="#smtp">Process Queued Mail and Recieve incoming Mail</a>
        <ul>
          <li>Testing smtp</li>
        </ul>
      </li>
      <li> <a href="#pop">Reading Mail through  pop3 requests </a>
        <ul>
          <li>Testing the Pop3 Server</li>
          <li><a href="#imap">using the IMAP Toolkit (alternative)</a></li>
          <li>testing the IMAP Server</li>
        </ul>
      </li>
      <li><a href="#configure">Sendmail Configuration </a>
        <ul>
          <li><a href="#whoami">who am i?</a></li>
          <li><a href="#slow">slow startup - gethostbyname() blocks</a> </li>
          <li><a href="#relay">Relaying Access Denied</a></li>
        </ul>
      </li>
      <li><a href="#diag">Simple Diagnostics</a>
        <ul>
          <li><a href="#diagWhat">What's in the QUEUE</a></li>
          <li><a href="#diagDebug">Debug and Verbose Mode</a></li>
          <li><a href="#diagMX">Looking up MX Records</a></li>
        </ul>
      </li>
      <li><a href="#author">Author and Copyright</a></li>
    </ul>
</div>

[OpenBSD 3.6]

E-Mail services on the Internet exchange messages through a
clients/servers mechanism where the client sends and retrieves mail
from servers who store these messages for future forwarding (store and
forward.) Three components of e-mail (as noted above) is the service
for (a) clients to recieve their mail (b) servers to recieve mail from
clients 'store', and (c) servers to 'forward' stored mail. 

OpenBSD base install provides a functioning Mail Server from the
<a href="http://www.sendmail.org">http://www.sendmail.org</a> project.

In this brief we will configure sendmail to process smtp requests.
We will also install a daemon to process pop requests.

1.  Setup services to process the SMTP as well as forwarding Mail
    Queues 
2.  Setup services for Processing POP

### <a name="smtp"></a>Process Queued Mail and Recieve incoming Mail 

<table>
  <tbody>
    <tr>
      <td width="173" valign="top" class="pFileReference"> File: /etc/rc.conf </td>
      <td width="485" valign="top" class="pFileReference"> enable/disable sendmail
in this configuration file </td>
    </tr>
    <tr>
      <td> File: /etc/rc </td>
      <td> launches sendmail using the switches
specified in /etc/rc.conf </td>
    </tr>
  </tbody>
</table>

Sendmail is installed as standard part of the base installation of OpenBSD 3.6 and is configured for security, such that it will only process outgoing email and not accept incoming email. To enable processing of incoming email, you merely need to enable the features in the configuration file: <a href="rc.local" class="anchBlue2">/etc/rc.conf.local</a>.

File: /etc/rc.conf.local

Add the below lines mentioned in the /etc/rc.conf file to your rc.conf.local file.


<pre class="config-file">
# For normal use: &quot;-L sm-mta -bd -q30m&quot;, and note there is a cron job
sendmail_flags=&quot;-L sm-mta -C/etc/mail/localhost.cf -q30m"
</pre>

And make the change as shown below (i.e. add the &quot;-bd&quot;)

<pre class="config-file">
# For normal use: &quot;-L sm-mta -bd -q30m&quot;, and note there is a cron job
sendmail_flags=&quot;-L sm-mta -C/etc/mail/localhost.cf <strong>-bd </strong>-q30m&quot;
</pre>

The line specifies switches (command line options) that /etc/rc
will pass to sendmail during system startup. <b>&ndash;bd</b> tells
sendmail to run as a daemon, running in the background, listening for
and handling incoming SMTP connections. As a daemon, sendmail does a
listen(2) on TCP port 25 for incoming SMTP messages. When another site
connects to the listening daemon, the daemon performs a fork(2) and the
child handles receipt of the incoming mail message. This is the
preferred method for high use (smtp) servers.

The /etc/rc file is started at system boot and checks for the value of the above 'options' and if
options exist the /etc/rc will execute sendmail with the given options.

Further Documentation ? The Sendmail Operations Manual has a number
of suggested recommendations, scripts clearly described for starting
sendmail as an smtp service.

In a LAN only mail setup the queuing may not be necessary. The
Sendmail bat book suggests 1h is a good setting for most sites, and for
sites with few users &ndash;q15m may be appropriate to ensure immediate
delivery of mail.

Note: To complete the installation process, we need to take heed 
of the warning: <span class="pScreenOutput"><strong>and note there 
is a cron job </strong> from the /etc/rc.conf file.</span>

Run the crontab utility as root to edit the cron jobs 
for the system and edit the following line referencing sendmail.

<pre class="config-file">
#minute hour mday month wday command
#
# sendmail clientmqueue runner
*/30 * * * * /usr/sbin/sendmail -L sm-msp-queue -Ac -q
</pre>

We need to comment the sendmail referenced line, as exampled below.

<pre class="command-line">
#       */30 * * * * /usr/sbin/sendmail -L sm-msp-queue -Ac -q
</pre>

We place a &quot;#&quot; hash at the beginning of the line 
to comment the line out, prevent its execution.

#### Testing smtp

&#91;Ref: <a href="http://www.tnpi.biz/internet/mail/forge.shtml">The Network People, Inc. Mail Server Testing</a> ] </p>

To simplify testing, we will perform the tests from on the 
SMTP server itself. You may need to test externally to 
verify behaviour with an active firewall or other systems 
between your SMTP (Sendmail) Server and the client.</p>

The test procedure will be to test a few basic commands, 
writing myself a message. </p>


<pre class="command-line">
$ <strong>telnet</strong> localhost smtp 
</pre>
<pre class="screen-output">
Trying ::1...
</pre>
<pre class="screen-output">
Connected to localhost.
Escape character is '^]'.
220 hostname.example.com ESMTP Sendmail 8.13.2/8.13.2; Sun, 20 Mar 2005 10:45:20 +1300 (TOT)
</pre>
<pre class="command-line">
<strong>helo</strong> localhost
</pre>
<pre class="screen-output">
250 obsdgcc3.ants.to Hello samt@localhost.example.com [IPv6:::1], pleased to meet you
</pre>
<pre class="command-line">
<strong>mail from:</strong> samt@localhost
</pre>
<pre class="screen-output">
250 2.1.0 samt@localhost... Sender ok
</pre>
<pre class="command-line">
<strong>rcpt to:</strong> samt@localhost
</pre>
<pre class="screen-output">
250 2.1.5 samt@localhost... Recipient ok
</pre>
<pre class="command-line">
<strong>data</strong>
</pre>
<pre class="screen-output">
354 Enter mail, end with &quot;.&quot; on a line by itself
</pre>
<pre class="command-line">
Subject: This is my subject line

I continue writing until I'm out of interesting things to say
which is not that far away

.
</pre>
<pre class="screen-output">
250 2.0.0 j2JLjKg3024237 Message accepted for delivery
</pre>
<pre class="command-line">
quit
</pre>
<pre class="screen-output">
221 2.0.0 hostname.example.com closing connection
Connection closed by foreign host.
You have new mail in /var/mail/samt
</pre>


### <a name="pop"></a><a href="#pop">Reading Mail through pop3 requests </a>

[Openwall.com's popa3d]

The popa3d Post Office Protocol (POP3) server is included 
in OpenBSD 3.6 and according to the man pages, has been there 
since 3.0. So the basic software is included and all we need 
to do is enable it.

Now we need to configure the super server inetd to route pop
requests to be handled by our installed pop daemon. To do this we make
the following changes.

File: /etc/services - Make sure there exists
a line specifying port address 110 as a pop3 service

<pre class="screen-output">
pop3    110/tcp     # Post Office Protocol 3
pop3    110/udp
</pre>

File: /etc/inetd.conf - Make sure you have a
line specifying the pop services (pop3) and the responsibility for
handling it is popa3d as shown in this example.

Change the line that is 'commented out'

<pre class="screen-output">
#pop3           stream  tcp     nowait  root    /usr/sbin/popa3d        popa3d
#pop3           stream  tcp6    nowait  root    /usr/sbin/popa3d        popa3d
</pre>
      
To read:

<pre class="command-line">
pop3            stream  tcp     nowait  root    /usr/sbin/popa3d        popa3d
pop3            stream  tcp6    nowait  root    /usr/sbin/popa3d        popa3d
</pre>
 
After making the changes, force inetd to re-read its configuration
file by sending it the hang up signal.

<pre class="command-line">
# <b>kill &ndash;HUP `cat /var/run/inetd.pid` </b>
</pre>

From the man page:

<pre class="screen-output">
<strong>CAVEATS</strong>
POP3 authenticates using cleartext passwords.
</pre>

Note the 'caveat' above, and you may want to review a more 'secure' pop3 server once you get things up and running and know the system works.

#### Testing the Pop3 Server
  
&#91;Ref: The Network People, Inc. [Mail Server Testing](http://www.tnpi.biz/internet/mail/forge.shtml) ] 

To simplify testing, we will perform the tests on the POP server itself. You may need to test externally to verify behaviour with an active firewall or other systems between your POP Server and the client.

The test procedure will be to test a few basic commands to ensure POP is up and able to perform basic functions (like listing mail, deleting mail in your mailbox.) 

<pre class="command-line">
$ telnet localhost pop3 
</pre>
<pre class="screen-output">
Trying ::1...
</pre>
<pre class="screen-output">
Connected to localhost.
Escape character is '^]'.
+OK
</pre>
<pre class="command-line">
user samt
</pre>
<pre class="screen-output">
+OK
</pre>
<pre class="command-line">
pass mypassword
</pre>
<pre class="screen-output">
+OK
</pre>
<pre class="command-line">
list
</pre>
<pre class="screen-output">
+OK
</pre>
<pre class="screen-output">
1 553
</pre>
<pre class="command-line">
dele 1 
</pre>
<pre class="screen-output">
+OK
</pre>
<pre class="command-line">
list
</pre>
<pre class="screen-output">
+OK
.
</pre>
<pre class="command-line">
quit
</pre>
<pre class="screen-output">
+OK
Connection closed by foreign host.
</pre>

We now have a functioning smtp server (sendmail) and a functioning
pop server (popa3d) Mail should be received and delivered on your
mail-server.

#### <a name="imap"></a>pops and handling IMAP requests (alternative) 

[package: courier-imap-3.0.5p1 or imap-uw-2004.352-plaintext]

Install the package courier-imap and follow the installation instructions. 
If you missed the instructions, then you can view them again by going to 
the directory /var/db/[package-name], e.g. /var/db/pkg/courier-imap-3.0.5p1 
and looking at the file +DISPLAY 

You could alternatively use the imap-uw release, and in this context we/I 
am using the plaintext flavor because it will not be made available externally 
(i.e. will only be used by a web mail client running on the host.)

#### Testing the IMAP Server

&#91;Ref: [How I test an imap server](http://aplawrence.com/SCOFAQ/FAQ_scotec4testimap.html);
The Network People, Inc. [Mail Server Testing](http://www.tnpi.biz/internet/mail/forge.shtml)]

IF you are having problems, remember to review the log file /var/log/maillog for 
any error messages that might assist your diagnostics and if that isn't enough 
dig in with tcpdump.

Courier-Imap

<pre class="command-line">
$ telnet localhost imap
</pre>
<pre class="screen-output">
Trying ::1...
Connected to localhost.
Escape character is '^]'.
* OK [CAPABILITY IMAP4rev1 UIDPLUS CHILDREN NAMESPACE THREAD=ORDEREDSUBJECT 
THREAD=REFERENCES SORT QUOTA IDLE ACL ACL2=UNION] Courier-IMAP ready. 
Copyright 1998-2004 Double Precision, Inc. 
See COPYING for distribution information.
</pre>
<pre class="command-line">
abc1 login samt mypassword 
</pre>
<pre class="screen-output">
abc1 OK LOGIN Ok.
</pre>
<pre class="command-line">
abc2 select inbox
</pre>
<pre class="screen-output">
abc2 NO Unable to open this mailbox.
</pre>
<pre class="command-line">
abc3 fetch2 body[text]
</pre>
<pre class="screen-output">
abc3 NO Error in IMAP command received by server.
</pre>

uw-imap

<pre class="command-line">
$ telnet localhost imap
</pre>
<pre class="screen-output">
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
* OK [CAPABILITY IMAP4REV1 LITERAL+ SASL-IR LOGIN-REFERRALS STARTTLS AUTH=LOGIN] 
localhost.example.com IMAP4rev1 2004.352 at Mon, 21 Mar 2005 00:18:25 +1300 (TOT)
</pre>
<pre class="command-line">
abc1 login samt mypassword 
</pre>
<pre class="screen-output">
abc1 OK [CAPABILITY IMAP4REV1 LITERAL+ IDLE NAMESPACE MAILBOX-REFERRALS BINARY 
UNSELECT SCAN SORT THREAD=REFERENCES THREAD=ORDEREDSUBJECT MULTIAPPEND] User samt authenticated
</pre>
<pre class="command-line">
abc2 select inbox
</pre>
<pre class="screen-output">
* 1 EXISTS
* 2 EXISTS
* NO Mailbox vulnerable - directory /var/mail must have 1777 protection
* 0 RECENT
* OK [UIDVALIDITY 1111317531] UID validity status
* OK [UIDNEXT 3] Predicted next UID
* FLAGS (\Answered \Flagged \Deleted \Draft \Seen)
* OK [PERMANENTFLAGS (\* \Answered \Flagged \Deleted \Draft \Seen)] Permanent flags
* OK [UNSEEN 2] first unseen message in /home/samt/mbox
abc2 OK [READ-WRITE] SELECT completed
</pre>
<pre class="command-line">
abc3 fetch 2 body[text]
</pre>
<pre class="screen-output">
* 2 FETCH (BODY[TEXT] {93}
I continue writing until I'm out of interesting things to say
which is not that far away  )
* 2 FETCH (FLAGS (\Seen))
abc3 OK FETCH completed
</pre>
<pre class="command-line">
abc4 close
</pre>
<pre class="screen-output">
abc4 OK CLOSE completed
</pre>
<pre class="command-line">
abc5 logout
</pre>
<pre class="screen-output">
* BYE hostname.example.com IMAP4rev1 server terminating connection
abc5 OK LOGOUT completed
Connection closed by foreign host.
</pre>

If you get a 'connection refused' when attempting a connection, the configuration for inetd.conf is either wrong or the server not restarted.


### <a name="configure"></a>Sendmail Configuration 

The following are tweaks to the configuration files to get the
system working smoothly on my configuration and may be helpful.

<table>
  <tbody>
    <tr>
      <td>
        File:/etc/mail/sendmail.cf </td>
      <td> </td>
    </tr>
    <tr>
      <td>
        File: /etc/mail/relay-domains </td>
      <td> 
        List of domains for which you allow relaying through your server </td>
    </tr>
    <tr>
      <td>File: /etc/hosts </td>
      <td> known hostnames </td>
    </tr>
    <tr>
      <td>
        File: /usr/share/sendmail/cf/ </td>
      <td> 
        Sample Configuration Files for Sendmail </td>
    </tr>
  </tbody>
</table>

#### <a name="whoami"></a>Who Am I ?

Sometimes things may not be happening because you just can't tell
who you are (as the mail server.) To find out who sendmail things it is
serving as, use the following commands.


<pre class="command-line">
# sendmail -d0 &lt; /dev/null
</pre>
<pre class="screen-output">
[ . . . stuff cut-out. . . ]
============ SYSTEM IDENTITY (after readcf) ============ 
(short domain name) $w = myhostname 
(canonical domain name) $j = myhostname.example.com 
(subdomain name) $m = example.com 
(node name) $k = myhostname 
======================================================== 
[ . . . stuff cut-out . . . ] 
</pre>


The screen displays a number of useful information that may assist
you in reviewing your assumptions about what settings have been given
to sendmail.

#### <a name="slow"></a>slow start-up gethostbyname() blocks

When Sendmail starts it will try to determine the name of the server
by using the gethostname and getbyhostname system call. You may also
need to edit the /etc/hosts file for the reason specified below from
the IMAP Toolkit FAQ 

From the IMAP Toolkit FAQ

<pre class="screen-output"> Q: Why isn't it
showing the local host name as a fully-qualified domain name? 
Q: Why is the local host name in the From/Sender/Message-ID headers of
outgoing mail not coming out as a fully-qualified domain name? 
      
A: Your UNIX system is misconfigured. The entry for your system in
/etc/hosts must have the <b>fully-qualified domain name first</b>,
e.g. 
 105.69.1.234 <b>bombastic.blurdybloop.com</b>
bombastic
      
 A common mistake of novice system
administrators is to have the short name first, e.g. 
 105.69.1.234 bombastic
bombastic.blurdybloop.com 
      
or to omit the fully qualified domain name entirely, e.g. 
 105.69.1.234 bombastic 
</pre>

<p> If your system pauses for a length of time when sendmail is
started, the above situation may be the solution for your problem. </p>
<p>Make sure we have a fully qualified domain associated with each ip
address used by the server. With two network cards, OpenBSD install
will only specify the domain name for one of the network ip addresses.
[Discovered the same problem with Linux Mandrake 7.1 install] </p>
 File: /etc/hosts 
</p>

<pre class="command-line"> # The NIC for the external
connection is: aaa.bbb.ccc.ddd (a legitimate ip address from my ISP) 
# The NIC for the internal connection is: eee.fff.ggg.hhh (using
private ip address on local lan) 
aaa.bbb.ccc.ddd myhost.example.com myhost 
eee.fff.ggg.hhh myhost.example.com myhost 
</pre>

#### <a name="relay"></a> Relaying access denied

&#91;Ref: OpenBSD <a
 href="http://www.openbsd.org/faq/faq10.html">FAQ - 10.0 System
Management</a> -&gt; <a
 href="http://www.openbsd.org/faq/faq10.html#10.4">10.4 ... Relay
Access Denied ...</a>]</p>

<p>I want the server to service all smtp messages sent from users in my
private-ip network, regardless of where on the network they are sending
it from. To do this, we create the file /etc/mail/relay-domains and
include a list of the host domains we will service. For example, if the
server domain is example.com then including example.com in the
/etc/mail/relay-hosts file lets me smtp messages from a remote client,
so long as I specify my user information is @example.com </p>
 Create or Edit: /etc/mail/relay-domains</p>
 
<pre class="screen-output"> example.com 
</pre>

<p>This, of course, is a serious security hole. Another approach is to
allow by IP address (ie. local lan only) and use your firewall rules to
block access by people saying their using your IP addresses coming in
on your external network cards. <a href="firewalling.htm">But that's
another story.</a></p>

<p>What we are doing above assumes the standard /etc/mail/sendmail.cf
supplied with the OpenBSD 2.7 install. To verify the name of the file
where we can place relay-domains use:</p>

<pre class="command-line"># <b>cat /etc/mail/sendmail.cf | grep relay-domains</b>
</pre>

<p>and the output would be something like this (if the the sendmail.cf
supports relaying.)</p>

<pre class="screen-output"> FR-o /etc/mail/relay-domains 
</pre>

<p>If you do not get something similar to the above, then you will have
to create another sendmail.cf (cf. /usr/share/sendmail) Sendmail 8.9
changes the previous behaviour of Sendmail, where it now defaults to
not forwarding e-mail to combat bulk-mailers/spammers. So, the
sendmail.cf needs to include some support for relaying mail from other
domains. Look at using</p>

<pre class="command-line"> define(confCR_FILE,`/etc/mail/relay-domains') 
</pre>

<p>General format for the /etc/mail/relay-domains file is:</p>

<table>
  <tbody>
    <tr>
      <td>.example.com</td>
      <td>#Allow relaying for/to any host in
example.com</td>
    </tr>
    <tr>
      <td>sub.example.com</td>
      <td>#Allow relaying for/to
sub.example.com and any host in that domain</td>
    </tr>
    <tr>
      <td>10.2</td>
      <td>#Allow relaying from all hosts in the
IP net 10.2.*.*</td>
    </tr>
  </tbody>
</table>

### <a name="diag"></a>Simple Diagnostics

<p>Although sendmail is hard to grasp, there is an abundance of
documentation on how to use, configure, and validate your sendmail
configuration. This abundant information is available online and in
print. The following tidbits are some of the commands I've used to
check my sendmail configurations, they are in no special order and in
many cases not cleverly written. For a list of reference resoureces
visit the Sendmail site <a href="http://www.sendmail.org">http//www.sendmail.org</a></p>

#### <a name="diagWhat"></a>What's in the Queue

<p>To get a listing of mail stuck in the queue (not yet delivered and
for what reason) then you can use the "-bp" option of sendmail. For
example:</p>

<pre class="command-line">
#<b> sendmail -bp</b>
</pre>
<pre class="screen-output">
/var/spool/mqueue
(1 request)
----Q-ID---- --Size-- -----Q-Time-----------------Sender/Recipient------------
e6UBU7B0        2385    24 Mon Jul 31 00:30    anat@myserver.com (host map: lookup (externalserver.com): deferred)
                                                samt@externalserver.com 
</pre>

#### <a name="diagDebug"></a>Debugging &amp; Verbose Mode

<p>-v (verbose) -d (debug) are two modes which print extra diagnostic
information on the screen while processing.</p>

<pre class="screen-output">sendmail -v user-id &lt; info-to-send 
</pre>

<p>The -v (verbose) option will display sendmail's activities in trying
to send mail to user-id. I find this especially useful when trying to
understand why sendmail fails trying to send to an external host. You
can use a user-id on another machine to watch what sendmail's doing in
trying to send your mail to that external host. For example:</p>

<pre class="screen-output">
sendmail -v user-id@remotehost.com &lt; info-to-send
</pre>

<p>The above will display the sendmail session trying to connect to the
SMTP port at remotehost.com. With the details of the connection you can
see any rejection messages from the external host.</p>

<pre class="screen-output">
sendmail -d## user-id &lt; info-to-send
</pre>

<p>The -d (debug) option (as it should) can generate a lot of
information and it is up to you to select the level of information that
is useful for isolating the cause of your problem. Further
documentation should be available at http://www.sendmail.org otherwise
I have seen the use of -d40 (limit output to information about the
queue) -d0 (produce general debugging information, as shown in earlier
example above.)</p>

<p>To get a comprehensive listing from sendmail of the current
settings, use the -d option without qualifiers.</p>

<pre class="command-line"><b># sendmail -d &lt; /dev/null</b>
</pre>

<p>The screen output will display the compiled in options and some of
the settings configured for sendmail. This is not a comprehensive list
of settings.</p>


#### <a name="diagMX"></a>Looking Up MX records

&#91;Ref: dig(1)]

<p>sendmail prioritises mail using the MX records given by your DNS
server. It may be useful sometimes to verify your assumptions of what
the MX records are saying by interrogating the MX records with <i>dig</i>,
and to follow a mail message using <i>sendmail -v</i>. </p>


<pre class="command-line"> #<b> dig example.com mx </b> 
</pre>
<pre class="screen-output">
; &lt;&lt;&gt;&gt; DiG
2.2 &lt;&lt;&gt;&gt; samnet.com mx
;; res options: init recurs defnam dnsrch
;; got answer:
;; -&gt;&gt;HEADER&lt;&lt;- opcode: QUERY, status: NOERROR, id: 40547
;; flags: qr aa rd ra; Ques: 1, Ans: 2, Auth: 2, Addit: 2
;; QUESTIONS:
;;example.com, type = MX, class =
IN
      
;; ANSWERS:
example.com. 86000
MX50 mail2.example.com.
example.com. 86000
MX20 mail.example.com.
      
;; AUTHORITY RECORDS:
example.com. 86000
NSdns.example.com.
example.com. 86000
NSdns2.example.com.
      
;; ADDITIONAL RECORDS:
mail2.example.com.
86000 A 192.168.101.130
mail.example.com.86000
A 192.168.101.1
      
;; Total query time: 3 msec
;; FROM: iwill to SERVER: default -- 192.168.101.1
;; WHEN: Tue Aug1 09:06:47 2000
;; MSG SIZEsent: 28rcvd: 140
</pre>


### Dial-Up Mail Serving?

<p>A few of the places we're working in do not have a live Internet
connection, or prefers to process the world mail queue on a scheduled
basis. On a dial-up class machine, we do not want the mail server
attempting to send mail on every message and the below is one
configuration that may be useful.</p>

<p>Essentially, we want the mail server to deliver local mail
immediately, but hold all external mail until we process the queue. The
concept is to define mail as expensive. For more details on
implementation, consult the HOWTO Sendmail and dial-up modem internet
by Wouter Hanegraaff</p>

<pre class="screen-output">
define(SMTP_MAILER_FLAGS, e)
define(`confTO_QUEUEWARN', `16h')
define(`SMART_HOST', `myISP')
MAILER(local)dnl
MAILER(smtp)dnl
</pre>

<p>I think from the above, smtp of local mail will get sent straight
away. The queue will only need to be processed when external mail needs to be
delivered (ie. when online)</p>

From the docs:

<pre class="screen-output">
<b>Mailer Flag</b>
<b>e</b> This mailer is expensive to connect to, so try to avoid
connecting normally; any necessary connection will occur during a queue
run.

<b>Options:</b>
There are a number of global options that can be set from a
configuration file. Options are represented by full words; some are
also representable as single characters for back compatibility.

The syntax of this line is:
<b>O option=value</b>

This sets option option to be value. Note that
there must be a space between 
the letter 'O' and the name of the option. An older version is:

<b>Oo value </b>

where the option o is a single character.
Depending on the option, value may be a string, an integer, a boolean
(with legal values "t", "T", "f", or "F"; the default is TRUE), or a
time interval.

The options supported (with the old, one
character names in brackets) are:

HoldExpensive [c]
If an outgoing mailer is marked as being expensive, don't connect
immediately. This requires that queueing be compiled in, since it will
depend on a queue run process to actual</span>ly send the mail.
</pre>

### Other Security Items

<p>ESMTP</p>

<p>Authenticated Mail Relay. </p>
