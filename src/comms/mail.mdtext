## Serving e-mail

<div class="toc">

Table of Contents

<ul>
    <li>The Mail Transport Agent (MTA)
    <li>Clients Access through POP3, IMAP Server
    <li>Domain Name Server (DNS)</li>
    <li>Authentication
    <li>GUI Management
</ul>

</div>
 
E-mail may just be the lifeblood of the Internet, unless you're younger than 25.

Various tools come together to provide what is generally termed an E-mail Server, 
and we bring together some of these key tools on OpenBSD.

$!Image("mail/mailserver.png", title="Serving Electronic Mail", klass="imgcenter")!$

Optional items, depending on your requirements may include:

-   Authentication Database
-   GUI Management Tool

###  The Mail Transport Agent (MTA)

The MTA manages the storage and forwarding of messages. Delivery can be local (to local users)
or external by forwarding the message to another MTA. More commonly referred as the mail 'server', two major MTA's documented here are:

-   [Sendmail](mail/sendmail.html) (included with the default OpenBSD install), and   
-   [Postfix](mail/postfix.html) (a well regarded mail server, included with the OpenBSD
    ports collection.)

OpenBSD 4.6 released an MTA development code based on the objectives and priorities of the 
project. SMTPD(8) (Simple Mail Transfer Protocol Daemon is developing with each OS release.

For a comparison of MTA's, consider reading [MTA Comparison](http://shearer.org/MTA_Comparison)
by [Dan Shearer](http://shearer.org/User:Dan) and 
Wikipedia's entry [Comparison of mail servers](http://en.wikipedia.org/wiki/Comparison_of_mail_servers)

Custom configurations for MTA's can include:

-   [Proxy Mail Service](mail/postfix/proxy.html)
-   [Virtual User Accounts](mail/postfix/virtual_accounts.html)

###  Clients Access through POP3, IMAP Server

Your Mail Clients normally access their e-mail either through desktop clients (Mail User Agents)
such as [Microsoft Outlook](http://www.microsoft.com) and [Mozilla 
Thunderbird](http://www.mozilla.org).

Clients 'push' their e-mail to the MTA's for delivery, but pull their e-mail from
other services on the 'server.'

Two major services for end-users to retrieving e-mail from a server is POP3 and IMAP. 
Various options are available with the default $!OpenBSD!$ install, with additional 
alternatives provided in the ports collection.

-   [popa3d](mail/sendmail.html#pop) in the $!OpenBSD!$ default install services POP3
-   [Courier Imap and UW Imap](mail/sendmail.html) in the ports services IMAP
-   [Dovecot](mail/dovecot.html) in the ports collection can service both POP3 and IMAP

###  Domain Name Server (DNS)

&#91;Ref: [OpenBSD as a domain name server](http://www.kernel-panic.it/openbsd/dns/) | 
[Is my DNS a mess](http://bind8nt.meiway.com/itsaDNSmess.cfm)]

A key infrastructure for email delivery, is Domain Name Services (DNS). For
mail destined outside, or coming from the outside we are dependent on
the Global DNS. 

Your MTA Mail Server will need connection to a DNS server, to find out where to send
e-mails, and it needs to be listed on the DNS system (so other Mail Servers can 
forward e-mail to your server.)

#### Common Fault:

When you can ping your mail host, but can't connect with SMTP,
check your DNS setting (either /etc/$!manpage("resolv.conf")!$ or 
/var/spool/postfix/etc/$!manpage("resolv.conf")!$)

###  Authentication Database

For a mail system servicing a small number of static users, it is sane to maintain
user account details using text/hash database files (or ths host system accounts.)
Large installations, with a high frequency of user changes may benefit from flexibility
through a database server.

###  GUI Management Tool

Various tools exist to simplify an administrators workload through GUI toolsets,
and allows delegation of various user creation, management responsibilities.

[Postfixadmin](mail/postfix/admin.html) is a wonderful Web GUI tool for 
managing your postfix/dovecot installation.

