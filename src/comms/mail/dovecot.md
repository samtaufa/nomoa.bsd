
##  Client connections using dovecot imap, pop, sasl 

<div class="toc">
    Table of Contents:
	
    <ul>
        <li><a href="#install">Installation and Configuration</a></li>
        <ul>
			<li>Specify the SSL Configuration</li>
			<li>Generate Certificates</li>
			<li><a href="#mod.pop.imap">Modify Base Configuration</a></li>
			<li><a href="#test">Test Installation</a>
				<ul>
					<li><a href="#start.dovecot">Starting Dovecot</a></li>
					<li><a href="#test.pop3">Test POP3</a></li>
					<li><a href="#test.imap">Test IMAP</a></li>
				</ul></li>
			<li><a href="#auto.start">Auto start during boot</a></li>
        </ul>
		<li><a href="#virtual.accounts">Virtual Accounts</a>
			<ul>
				<li><a href="#virtual.config">Config Changes</a></li>
				<li><a href="#auth.text">Authenticate to Text File</a> </li>
				<li><a href="#auth.mysql">Authenticate to SQL</a>
					<ul>
						<li><a href="#mysql.conf">SQL Configuration</a></li>
						<li><a href="#mysql.account">SQL Account</a></li>
					</ul></li>
				<li><a href="#mysql.pop3">Test POP3</a></li>
				<li><a href="#mysql.imap">Test IMAP</a></li>
			</ul>
		</li>
    </ul>
</div>

&#91;Ref: OpenBSD 4.7, Dovecot 1.2.13]

Client access, getting your e-mail from the mail server, is generally
through programs that support the standard protocol for receiving
mail (such as POP3, POP3S, IMAP, IMAPS.) In this guide we look at
a basic configuration of [dovecot](http://ww.dovecot.org)
as an imap, pop3, sasl server.

OpenBSD comes with some tools in the default install, and depending on
your needs you may prefer those, or other tools in the ports tree.
I hope this guide will help you in using it with [our postfix guide](postfix.html)

### Installing and Configuring

Install dovecot from the packages, and if you prefer some special configuration
not in the standard package then you can use the ports system. For SQL support
we're installing the "mysql" flavor, although this is not necessary for the majority
of the instructions below.

<pre class="command-line">
# cd /usr/ports/mail/dovecot
# env FLAVOR="mysql" make package
</pre>
<pre class="screen-output"> 
===&gt; Building package for dovecot-1.X.Y-mysql

</pre>

<pre class="command-line">
pkg_add dovecot-1.X.Y-mysql
</pre>
<pre class="screen-output">
dovecot-1.X.Y-mysql: complete
--- dovecot-1.X.Y-mysql -------------------
Files to facilitate the generation of a self-signed
certificate and key for Dovecot have been installed:
/etc/ssl/dovecot-openssl.cnf (Edit this accordingly!)
/usr/local/sbin/dovecot-mkcert.sh

If this has been or will be accomplished by other means,
use the following paths for the files:
/etc/ssl/dovecotcert.pem
/etc/ssl/private/dovecot.pem

If you wish to have Dovecot started automatically at boot time,
simply add the follow lines to /etc/rc.local:

if [ -x /usr/local/sbin/dovecot ]; then
    echo -n ' dovecot'; /usr/local/sbin/dovecot
fi
</pre>

Following through on the installation instructions from the dovecot package

-   Specify SSL Configuration
-   Generate Certificates
-   Configure automatic start during boot

#### Specify the SSL Configuration

The dovecot ports/package provides a simplified approach for generating the 
SSL certificates. The configuration file is at /etc/ssl/dovecot-openssl.cnf, 
while the configuration tool is /usr/local/sbin/dovecot-mkcert.sh.

<pre class="screen-output">
Files to facilitate the generation of a self-signed
certificate and key for Dovecot have been installed:
/etc/ssl/dovecot-openssl.cnf (Edit this accordingly!)
</pre>

File Fragment: /etc/ssl/dovecot-openssl.cnf

<pre class="config-file">
[ req_dn ]
# country (2 letter code)
#C=FI
# State or Province Name (full name)
#ST=# Locality Name (eg. city)
#L=Helsinki# Organization (eg. company)
#O=Dovecot
# Organizational Unit Name (eg. section)
#OU=Imap Server
 
# Common Name (*.example.com is also possible)
#CN=imap.example.com
# E-mail contact
#emailAddress=postmaster@example.com
</pre>

There are some unspecified options from above that may be interesting to you 
at a later stage.

If you've never used certificates before, or are just using these 
instructions on a test server, then just work with the sample configuration 
above. If you are ready to deploy your system, then please read the man pages 
and make some further reviews of your certificate files. The full openssl 
configuration file example in OpenBSD is stored as /etc/ssl/openssl.cnf

#### Generate Certificates

The dovecot install supplies the shell script

<pre class="screen-output">
/usr/local/sbin/dovecot-mkcert.sh
</pre>

 to generate your SSL certificates using the source information provided in the 
above configuration file. Just run the script to generate your certificates


<pre class="command-line">
# /usr/local/sbin/dovecot-mkcert.sh
</pre>

The first part of the script generates the private 
key using /etc/ssl/dovecot-openssl.cnf

<pre class="screen-output">
Generating a 1024 bit RSA private key
...++++++
.................++++++
writing new private key to '/etc/ssl/private/dovecot.pem'
-----
</pre>

The second part of the script just outputs the signature from the 
generated key to assure us that it executed corrected (i.e. if you didn't get 
the second part, then things failed badly.)

<pre class="screen-output">
subject= (information text from above configuration file)
MD5 Fingerprint=(long fingerprint)
</pre>

As shown in the ports documentation, /var/db/pkg/dovecot-1.X.Y-mysql/+DISPLAY
you can manually generate your own configuration/certificate files so long 
as you place the resulting files into a 'known' location:

File Fragment: /var/db/pkg/dovecot-1.X.Y-mysql/+DISPLAY

<pre class="config-file">
if this has been or will be accomplised by other means,
use the following paths for the files:
/etc/ssl/dovecotcert.pem
/etc/ssl/private/dovecot.pem   
</pre>

The location, and naming of the *.pem files are **specified in your /etc/dovecot.conf**
file for the key/value pairs of ssl_cert_file and ssl_key_file.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
ssl_cert_file = /etc/ssl/dovecotcert.pem
ssl_key_file  = /etc/ssl/private/dovecot.pem
</pre>

#### <a name="mod.pop.imap"></a> Modify Base Configuration /etc/dovecot.conf

We will test pop3 and imap so let us ensure this is configured for dovecot in 
the /etc/dovecot.conf file. Edit the dovecot.conf file to ensure protocols is 
enabled and we are allowing at least imap and pop3.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
# Protocols we want to be serving: imap imaps pop3 pop3s
# If you only want to use dovecot-auth, you can set this to "none".
protocols = imap imaps pop3 pop3s
</pre>


By default, the OpenBSD dovecot package configures support of using the
OS BSD Authentication for authenticating user accounts.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
auth default {
  ..
  
  passdb bsdauth {
  }
  ..
  userdb passwd {
  }
  ..
}
</pre>

This means, the dovecot install let's you collect mail for users on your server.

#### <a name="test"></a> Test Installation

Before continuing, let's just check to make sure we've got at least these 
parts working and not causing a conflict.

The default installation of OpenBSD dovecot packages supports 
[authentication through the password file](
http://wiki.dovecot.org/AuthDatabase/Passwd) 
so we will need at least one valid system user 
account for testing the dovecot install. 

##### <a name="start.dovecot"></a>Starting Dovecot

Before we start dovecot, we need to take care of some resource requirements,
such as increasing the number of file descriptors the program can use.
We can configure this by creating a login class 'dovecot' in $!manpage('login.conf')!$

File Fragment: /etc/login.conf

<pre class="config-file">
	dovecot:\
			:ignorenologin:\
			:openfiles-cur=1024:\
			:openfiles-max=2048:\
			:tc=default:
</pre>

To ensure the file is compiled, use $!manpage('cap_mkdb')!$

<pre class="command-line">
cap_mkdb /etc/login.conf
</pre>

To make sure that we execute 'dovecot' with the increased file descriptors, 

<pre class="command-line">
# su -c dovecot root -c '/usr/local/bin/dovecot'
</pre>
<pre class="screen-output">
dovecot: Dovecot v1.X.Y starting up
</pre>

Check for error messages by looking at /var/log/maillog (using tail -f /var/log/maillog) 
and you should get a message such as the following

Check running processes to ensure that dovecot is running with the appropriate login
configuration.

<pre class="command-line">
# ps auxw | grep dovecot
</pre>
<pre class="screen-output">

run it and put the output here.

</pre>

##### <a name="test.pop3"></a> Test POP3

To test POP3 we connect with **my system-user account (samt)**.

<pre class="command-line">$ telnet localhost pop3
</pre>
<pre class="screen-output">
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
+OK Dovecot ready.
</pre>
<pre class="command-line">USER<strong> samt</strong>
</pre>
<pre class="screen-output">+OK
</pre>
<pre class="command-line">PASS <strong> mypassword</strong>
</pre>
<pre class="screen-output">+OK Logged in.
</pre>
<pre class="command-line">LIST
</pre>
<pre class="screen-output">
+OK 0 messages:
.
</pre>
<pre class="command-line">QUIT
</pre>
<pre class="screen-output">
+OK Logging out.
Connection closed by foreign host.
</pre>

File: /var/log/maillog: 

Reviewing the log file should reveal something 
like the below just after the user/pass have been passed to dovecot

<pre class="screen-output">
dovecot: pop3-login: Login: user=&lt;samt&gt;, method=PLAIN, 
rip=127.0.0.1, lip=127.0.0.1, secured
</pre>

File: /var/log/maillog: 

On disconnection you should receive a disconnect log 
entry.

<pre class="screen-output">
dovecot: POP3(samt): Disconnected: Logged out top=0/0, retr=0/0, del=0/0, size=0
</pre>

A list of [common POP3 commands](http://sol4.net/telnetpop3.shtml)
courtesy of SOL4.net

<table style="width: 70%" class="style6" align="center">
	<tr>
		<th>Command</td>
		<th>Functional Description</th>
	</tr>
	<tr>
		<td style="width: 182px" class="style9">
        <strong>LIST </strong></td>
		<td style="width: 668px" class="style8">
        Lists the messages in the mailbox together with their sizes. also 
		can be used with the message number to return specific message sizes.</td>
	</tr>
	<tr>
		<td style="width: 182px" class="style10">
        <strong>RETR messageID</strong></td>
		<td style="width: 668px" class="style11">
        Retrieve the message specified by messageID, displays it to the 
		screen.</td>
	</tr>
	<tr>
		<td style="width: 182px" class="style10">
        <strong>DELE messageID</strong></td>
		<td style="width: 668px" class="style11">
        Delete the message specified by messageID.</td>
	</tr>
	<tr>
		<td style="width: 182px" class="style10">
        <strong>RSET </strong></td>
		<td style="width: 668px" class="style11">
        Undo any changes made.</td>
	</tr>
	<tr>
		<td style="width: 182px" class="style10">
        <strong>STAT </strong></td>
		<td style="width: 668px" class="style11">
        List the number of messages and the total mailbox size.</td>
	</tr>
	<tr>
		<td style="width: 182px" class="style12">
        <strong>QUIT </strong></td>
		<td style="width: 668px" class="style13">
        Close the connection.</td>
	</tr>
</table>

##### <a name="test.imap"></a> Test IMAP

The same basic look test with IMAP

Screen Session

<pre class="command-line">
# telnet localhost imap
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
a1 login samt mypassword
</pre>
<pre class="screen-output">
a1 OK Logged in
</pre>
<pre class="command-line">
a2 select inbox
</pre>
<pre class="screen-output">
* FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
* OK [PERMANENTFLAGS (\Answered \Flagged \Deleted \Seen \Draft \*)] Flags permitted.
* 0 EXISTS
* 0 RECENT
* OK [UIDVALIDITY 1165837992] UIDs valid
* OK [UIDNEXT 2] Predicted next UID
</pre>
<pre class="screen-output">a2 OK [READ-WRITE] Select completed.
</pre>
<pre class="command-line">a3 logout
</pre>
<pre class="screen-output">
* BYE Logging out
a3 OK Logout completed.
Connection closed by foreign host.
</pre>

Again, we review /var/log/maillog for dovecot's messages and after 
successfully entering the correct user/password combination we should get a log 
entry similar to the below.

File Fragment: /var/log/maillog

<pre class="screen-output">
dovecot: imap-login: Login: user=&lt;samt&gt;, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured
</pre>

Likewise, on QUITting, we should get the disconnect log entry.

File Fragment: /var/log/maillog

<pre class="screen-output">
dovecot: IMAP(samt): Disconnected: 
Logged out
</pre>

It seems our server is working correctly.

#### <a name="auto.start"></a>Auto start during boot

Configuring for auto-start of dovecot during reboot is a little more 
complicated with this option than it may need to be. Essentially, this 
configuration will depart by setting and looking for an enabling option in the 
/etc/rc.conf.local file.

Add the following option in the rc.conf.local file.

File Fragment: /etc/rc.local

<pre class="config-file">
if [ -x /usr/local/sbin/dovecot ]; then
   echo -n ' dovecot'; su -c dovecot root -c '/usr/local/bin/dovecot'
fi
</pre>

At this point, you should be able to service IMAP and POP3 for 
system users. Before using this configuration you 
should at least check the [dovecot documentation](
http://wiki.dovecot.org) and in particular the [Client issues](
http://wiki.dovecot.org/Clients) and configuration.

Additional configuration tweaks from the documentation may include:

File Fragment: /etc/dovecot.conf

<pre class="config-file">
first_valid_uid = 901
last_valid_uid = 32766
</pre>

-	**first_valid_uid**. OpenBSD's regular users are generally created
	above 1000, and in our virtual mail configuration we use 901.
	If you will be using dovecot to exclusively handle virtual user 
	accounts, then first and last uid should be set to the UID 
	you specify for postfix. 
-	The two settings let you configure the system to avoid
	attempts to read mail for non-user accounts.

## <a name="virtual.accounts"></a>Virtual Accounts

Dovecot has good support for retrieving mail messages through
authenticating from various sources, and finding mail located
places other than the system default.

### <a name="virtual.config"></a>Config Changes /etc/dovecot.conf

Four items need to be modified in the /etc/dovecot.conf configuration
file for virtual accounts.

-	Group, User ID
-	Specify the location where virtual e-mail account files will
	be stored.
-	Specify the authentication mechanism to be used
-	Debugging

<pre class="config-file">
mail_uid = 901
mail_gid = 901
auth_verbose = yes
auth_debug = yes
auth_debug_passwords = yes
mail_location = maildir:/var/spool/postfix/vmail/%d/%n
auth default {
    ..
	passdb AUTH-TYPE {
			args = ???
	  }
	..
	userdb AUTH-TYPE {
			args = ???
	  }
	..
}
</pre>

#### Group, User ID

File Fragment: /etc/dovecot.conf

<pre class="config-file">
mail_uid = 901
mail_gid = 901
</pre>

In our Virtual Mail configuration our _vmail account for managing mail
is uid/gid 901

#### mail_location

The location for Virtual e-mails is determined by the configuration
in our MTA [Postfix](postfix.html) configuration. We set the
option as in:

File Fragment: /etc/dovecot.conf

<pre class="config-file">
mail_location = maildir:/var/spool/postfix/vmail/%d/%n
</pre>

#### authentication type

Authentication is managed in the *auth default* segement in the 
configuration file, with two complementary items:

-	**passdb AUTH-TYPE** is used for authenticating the user
	password.
-	**userdb AUTH-TYPE** is used for determining user specific
	information, such as file storage location
	
File Fragment: /etc/dovecot.conf

<pre class="config-file">
auth default {
    ..
	passdb AUTH-TYPE {
			args = ???
	  }
	..
	userdb AUTH-TYPE {
			args = ???
	  }
	..
}
</pre>

#### Debugging

The more information we can get from dovecot while installing the system,
the easier it will be for us to track down errors, and stabilise a functional
system.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
auth_verbose = yes
auth_debug = yes
auth_debug_passwords = yes
</pre>

### <a name="auth.text"></a>Authenticate to Text File

Minimalist installations, a simplest with straight text files.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
  passdb passwd-file {
	args = scheme=plain-md5 username_format=%u /etc/dovecot.passwd
  }
  userdb passwd-file {
	args = /etc/dovecot.passwd
  }
</pre>

We can now use a plain text file for adding/removing user accounts.

File Fragment:  /etc/dovecot.passwd

<pre class="config-file">
user@domain:{PLAIN}password:id:gid::/path/to/mail/folder
</pre>

### <a name="auth.mysql"></a>Authenticate to SQL

Ref
[Virtual Users and Domains with Courier-IMAP and MySQL](
http://postfix.wiki.xs4all.nl/index.php?title=Virtual_Users_and_Domains_with_Courier-IMAP_and_MySQL#dovecot-mysql.conf) 

Authenticating to a Database has the disadvantage of increasing the 
number of bits running on your system, with the advantage that other
tools can be used to managing your mail accounts.

File Fragment: /etc/dovecot.conf

<pre class="config-file">
	passdb sql {
			args = /etc/dovecot-mysql.conf
	  }
	userdb sql {
			args = /etc/dovecot-mysql.conf
	  }
</pre>

##### <a name="mysql.config"></a>SQL Configuration File: /etc/dovecot-mysql.conf

Our SQL configuration file will contain key/value pairs for how dovecot will 
access the sql provider.

File : /etc/dovecot-mysql.conf

<pre class="config-file">
# NOTE: '\' line splitting works only with v1.1+
# Database driver: mysql, pgsql
driver = mysql

# Currently supported schemes include PLAIN, PLAIN-MD5, DIGEST-MD5, and CRYPT.
default_pass_scheme = PLAIN

# Database options
connect = host=/var/run/mysql/mysql.sock dbname=mail user=dovecot \
	password=dovecotpassword

password_query = SELECT username as user, password FROM mailbox where \
	username = '%u' AND active = '1'
user_query = SELECT 901 AS uid, 901 AS gid, concat ('/var/spool/postfix/vmail/',maildir) \
	AS home from mailbox WHERE username = '%u' AND active = '1'
</pre>

The above SELECT queries are using the database tables used by
PostfixAdmin, with our own modification of using dbname=mail
instead of the default install configuration of dbname=postfix

Notes:

-   The uid, gid of 901 shown above is referring to [our postfix 
	configuration](postfix.html).
-	Verify the configuration is correct, but connecting to your database
	and manually executing the **password_query**, and the **user_query**.
	
##### <a name="mysql.account"></a>SQL Account

We need create a user account for our dovecot daemon to access our 
MySQL server, and because we are using a post 4.1 release, we will also ensure a 
shorter/older passphrase by using the old_password command.

Enter the mysql client and enter the following commands

Screen Session
<pre class="command-line">
# mysql -u root -p
</pre>

<pre class="screen-output">
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 12 to server version: 5.0.24a-log

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

mysql&gt;
</pre>
<pre class="command-line">
mysql&gt; grant select on mail.* to 'dovecot'@'localhost' identified by 'dovecotpassword';
</pre>
<pre class="screen-output">
Query OK, 0 rows affected (0.00 sec)
</pre>
<pre class="command-line">
mysql&gt; flush privileges;
</pre>
<pre class="screen-output">Query OK, 0 rows affected (0.02 sec)
</pre>

The database 'mail' references the same database 
used by [our postfix installation](postfix.html), 
and also the same database for [our postfixadmin installation](postfix/admin.html).

#### <a name="mysql.test"></a> Test our configuration

It's time to test and see whether we've configured our system correctly. We 
will kill the current dovecot and start a new connection.

<pre class="command-line">
# pkill -HUP dovecot
</pre>

Our maillog file should give us an idea if our mysql configuration is mostly 
good.

File Fragment: /var/log/maillog

<pre class="screen-output">
dovecot: SIGHUP received - reloading configuration
dovecot: auth-worker(default): mysql: Connected to localhost (mail)
</pre>

Note: 'mail' above refers to our MySQL database, so 
if you have an error with this 'auth-worker' you might check whether the 
password is correct, or whether the database is correctly entered above.

### <a name="mysql.pop3"></a>Test the Pop3 Server

&#91;Ref: The Network People, Inc. [Mail Server Testing](
http://www.tnpi.biz/internet/mail/forge.shtml)]

If you've successfully installed dovecot with mysql above, and have gone 
through the Configuring a Virtual Email Service - MySQL in [our postfix 
installation guide](postfix.html), (or you have installed your own MySQL virtual user accounts) 
then we can perform some testing, validating whether our configuration actually 
works.

Screen Session

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
user charlie@alpha.example.org
</pre>
<pre class="screen-output">
+OK
</pre>
<pre class="command-line">pass charlie
</pre>
<pre class="screen-output">
+OK Logged in.
</pre>
<pre class="command-line">list
</pre>
<pre class="screen-output">
+OK 3 messages:
1 503
2 445
3 503
.
</pre>
<pre class="command-line">retr 3
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
<pre class="command-line">QUIT
</pre>
<pre class="screen-output">
+OK Logging out.
Connection closed by foreign host.
</pre>

The maillog file should show success similar to the below

File Fragment: /var/log/maillog

<pre class="screen-output">
pop3-login: Login: user=&lt;charlie@alpha.example.org&gt;, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured
POP3(charlie@alpha.example.org): Disconnected: Logged out top=0/0, retr=1/519, del=0/3, size=1451
</pre>

Again, a review of the mysql transaction log can be helpful in diagnosing 
errors.

File Fragment: /var/mysql/myhost.log

<pre class="screen-output">
Connect dovecot@localhost on mail
Query SELECT password FROM mailbox WHERE username = 'charlie@alpha.example.org' AND active = '1'
Query SELECT maildir, 901 AS uid, 901 AS gid FROM mailbox WHERE username = 
'charlie@alpha.example.org' AND active = '1'
</pre>

#### Simple Errors -ERR Authentication failed.

You get an Authentication failed even though you know and swear that you have 
entered the correct password?

-   Check the /var/mysql/myhost.log file to ensure that the correct query is 
	sent by dovecot to the MySQL Server (i.e. SELECT 
	password FROM mailbox WHERE username = 'VIRTUALACCOUNT@VIRTUALDOMAIN' AND 
	active = '1')
-   Check that your dovecot configuration is using the same encryption 
	method for creating/reading passwords, as postfixadmin. For example, in our 
	exercise we are using CRYPT: default_pass_scheme = 
	CRYPT.
  

### <a name="mysql.imap"></a>Test the IMAP server

We use telnet on the localhost to test imap's configuration

Screen Session

<pre class="command-line">$ telnet localhost imap
</pre>
<pre class="screen-output">
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
* OK Dovecot ready.
</pre>
<pre class="command-line">a1 login charlie@alpha.example.org charlie
</pre>
<pre class="screen-output">a1 OK Logged in.
</pre>
<pre class="command-line">a2 select inbox
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
<pre class="command-line">a3 fetch 3 body[text]
</pre>
<pre class="screen-output">
* 3 FETCH (BODY[TEXT] {66}
Hopefully you've received this email message without fault ?


)
a3 OK Fetch completed.
</pre>
<pre class="command-line">a4 close
</pre>
<pre class="screen-output">a4 OK Close completed.
</pre>
<pre class="command-line">a5 logout
</pre>
<pre class="screen-output">
* BYE Logging out
a5 OK Logout completed.
Connection closed by foreign host.
</pre>

Note:

a1, a2, .., a5 are randomly selected unique leaders (in 
this case we're just making things sequential)

-   "<strong>a3 fetch </strong>3<strong> body[text]</strong>", 

the number '3' refers to the '3_ EXISTS_' in 
the list returned by '<strong>a2 select inbox'</strong>

Your maillog file is your friend and will give you clues to where you can 
check for other errors.

File Fragment: /var/log/maillog

<pre class="screen-output">
auth-worker(default): mysql: Connected to localhost (mail)
imap-login: Login: user=&lt;charlie@alpha.example.org&gt;, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured
IMAP(charlie@alpha.example.org): Disconnected: Logged out
</pre>

Likewise the mysql transaction log should give further assistance should the 
installation be having problems.

File Fragment: /var/mysql/myhost.log

<pre class="screen-output">
Connect dovecot@localhost on mail
Query SELECT password FROM mailbox WHERE username = 'charlie@alpha.example.org' 
AND active = '1'
Query SELECT maildir, 901 AS uid, 901 AS gid FROM mailbox WHERE username = 
'charlie@alpha.example.org' AND active = '1'
</pre>

### Reference Resources

sol4.net's [POP3 Access using Telnet](http://sol4.net/telnetpop3.shtml) 

The Network People, Inc. [Mail Server Testing](http://www.tnpi.biz/internet/mail/forge.shtml)
