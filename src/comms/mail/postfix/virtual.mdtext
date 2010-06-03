## Virtual User Accounts

<div style="float:right">
    <p> Table of Contents: </p>
    <ul>
        <li><a href="#1.1Objectives">Objectives</a></li>
        <li><a href="#ConfiguringAVirtualEmailService_Basic">Configuring a Virtual Email Service - basic test install</li></a>
        <ul>
            <li> <a href="#5.1BaseConfiguration">Base Configuration for virtual hosting</a>
            <ul>
                <li><a href="#5.1.1MainConfiguration">Main Configuration</a> </li>
                <li><a href="#5.1.2DiskLayout">Disk Layout for Virtual Domains</a></li>
                <li><a href="#5.1.3VirtualDomains">Virtual Domains</a></li>
                <li><a href="#5.1.4VirtualMailbox">Virtual Mailbox </li>
                </a>
                <ul><li>Virtual Accounts - alpha.example.org</li>
                    <li>Virtual Accounts - beta.example.org</li>
                    <li>Virtual Accounts - gamma.example.org</li></ul>
                <li><a href="#5.1.5VirtualAliases">Virtual Aliases (currently broken) </li>
                </a>
                <ul><li>Virtual Alias - alpha.example.org</li>
                    <li>Virtual Alias - beta.example.org</li>
                    <li>Virtual Alias - gamma.example.org</li></ul>
            </ul>
            </li>
            <li><a href="#5.2CreateTheSystemUserAccount">Create system user account for managing virtual mail</a> </li>
            <li><a href="#5.3TestingConfiguration">Testing Configuration</li></a>
            <ul>
                <li><a href="#5.3.1postconf">postconf</a></li>
                <li><a href="#5.3.1telnet">telnet localhost smtp</a></li>
                <li><a href="#5.3.2MailLog">Mail Log</a></li>
                <li><a href="#5.3.3MailStore">Mail Store</a></li>
            </ul>
        </ul>
        <li><a href="#6ConfiguringVirtualEmail_MySQL">Configuring a Virtual Email Service - MySQL</li></a>
        <ul>
            <li><a href="#6.1ConfiguringMySQL">Configure MySQL</a>          
            <ul>
                <li><a href="#6.1.1CreatingTheDatabase">Creating the Database</a></li>
                <li><a href="#6.1.2CreatingTheAliasTable">Creating the Alias Table</a></li>
                <li><a href="#6.1.3CreatingTheDomainTable">Creating the Domain Table</a></li>
                <li><a href="#6.1.4CreatingTheMailboxTable">Creating the Mailbox Table</a></li>
                <li><a href="#6.1.5OtherTablesForPostfixadmin">Other Tables for postfixadmin</a></li>
            </ul></li>
        </ul>
        <ul>
            <li><a href="#6.2PopulatingTheTables">Populating the Tables</a>
            <ul>
                <li><a href="#6.2.1SuperAdministratorAccount">Super Administrator Account</a></li>
                <li><a href="#6.2.2VirtualDomains">Virtual Domains</a></li>
                <li><a href="#6.2.3VirtualMailbox">Virtual Mailboxes</a>
                    <ul>
                        <li>Virtual Users for alpha.example.org</li>
                        <li>Virtual Users for beta.example.org</li>
                        <li>Virtual Users for gamma.example.org</li>
                    </ul></li>
                <li><a href="#6.2.4VerifyOurSettings">Verify our settings</a></li>
            </ul></li>
            <li><a href="#6.3CreateTheSystemUserAccount">Create system user account for managing virtual mail</a></li>
            <li><a href="#6.4ConfiguringPostfix">Configuring Postfix</li></a>
                <li><a href="#6.5CreatingThePostfixToMySQLSettingsFile">Creating the Postfix to MySQL settings files</a>         
                <ul>
                    <li><a href="#6.5.1VirtualDomains">Virtual Domains</a></li>
                    <li><a href="#6.5.2VirtualMailbox">Virtual Mailbox</a></li>
                    <li><a href="#6.5.3VirtualAliases">Virtual Aliases</a></li>
                    <li><a href="#6.5.4RestartPostfix">Restart Postfix</a></li>
                </ul>
                </li>
            </ul>
        <ul>
            <li><a href="#6.6Testing">Testing</a>
            <ul>
                <li><a href="#6.6.1telnet">telnet localhost smtp</a></li>
                <li><a href="#6.6.2MailLog">Mail Log</a></li>
                <li><a href="#6.6.3MailStore">Mail Store</a></li>
                <li><a href="#6.2.5MySQLLogFile">MySQL Log File</a></li>
            </ul></li>
        </ul>
        <li>Configuring a Virtual Email Service - MySQL high load server</li>
        <li>Reference Resources</li>
    </ul>
</div>

[OpenBSD 4., postfix-2.3.2]


Customising the base Postfix installation to serve Virtual Accounts.

####  <a name="1.1Objectives"></a>Objectives

We've installed a few virtual user mail servers, through trial and error,
even with the better guides out there, and hopefully these notes adds useful tests,
log reviews during the install process to confidently reach a successful install every-time.

These guides will therefore install and test a 

-   Virtual Accounts using hash files, before progressing to
-   Virtual Accounts using MySQL

This installation exercise we are going to install three virtual domains 
on a single host, with three virtual accounts for each virtual domain:

<table align="center">
	<tr>
		<td > Host</td>
		<td>myhost.example.org</td>
	</tr>
	<tr>
		<td >
            Virtual Mail Base Directory</td>
		<td>/var/spool/postfix/vmail</td>
	</tr>
	<tr>
		<td >
                Virtual Domain</td>
		<td>
                alpha.example.org ~ users: alfred, bob, charlie</td>
	</tr>
	<tr>
		<td >
            Virtual Domain</td>
		<td>
                    beta.example.org ~ users: auntie, bill, chou</td>
	</tr>
	<tr>
		<td>
            Virtual Domain</td>
		<td>gamma.example.org ~ users: 
            alistair, ben, cinder</td>
	</tr>
</table>

Using OpenBSD's Postfix configuration, we will store the virtual mailboxes 
in: /var/spool/postfix/vmail

### <a name="ConfiguringAVirtualEmailService_Basic"></a>Configuring a Virtual Email Service - basic test install

[ref: Postfix Virtual Domain Hosting Howto - VIRTUAL_README.html]

I've always had difficulty in getting the full featured database driven 
virtual email working, so we will go through a slow installation process of 
installing the non-database driven version first to make sure all other 
configuration items are correct within Postfix.

<ol>
	<li>Base Configuration for virtual hosting<ul>
		<li>Main Configuration</li>
		<li>Virtual Mailbox</li>
		<li>Virtual Aliases (broken)</li>
	</ul>
	</li>
	<li>Create system user account for managing virtual mail</li>
	<li>Virtual Mail Accounts</li>
</ol>

#### <a name="5.1BaseConfiguration"></a>1. Base Configuration for virtual hosting

##### <a name="5.1.1MainConfiguration"></a>Main Configuration

We'll put in some basic configuration information for virtual hosting into 
Postfix's main.cf


File Fragment: /etc/postfix/main.cf</td>

###### Virtual Mailbox Services - Local

<pre class="config-file">
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,
                       
mail.$mydomain, www.$mydomain, ftp.$mydomain, 

virtual_mailbox_base = /var/spool/postfix/vmail
virtual_mailbox_domains = hash:/etc/postfix/virtual/mailbox/domains
virtual_mailbox_maps = hash:/etc/postfix/virtual/mailbox/alpha.example.org,
                                  
hash:/etc/postfix/virtual/mailbox/beta.example.org, 
                                  
hash:/etc/postfix/virtual/mailbox/gamma.example.org
virtual_minimum_uid = 900
virtual_transport = virtual
virtual_uid_maps = static:901
virtual_gid_maps = static:901
</pre>

Notes:

-   The <a href="http://www.postfix.org/postconf.5.html#virtual_minimum_uid">virtual\_minimum\_uid</a>
    has to be less than or equal to 
	<a href="http://www.postfix.org/postconf.5.html#virtual_uid_maps">virtual\_uid\_maps</a> and 
	<a href="http://www.postfix.org/postconf.5.html#virtual_gid_maps">virtual\_gid\_maps</a>, 
    otherwise you will get an error during mail receipt processing.
-   The selected '901' value seems to be arbitrary, although it must be maintained 
	through a few other places in these instructions and in the
	<a href="dovecot.htm">dovecot</a> instructions. I don't know whether this 
	'901' clashes with any other OpenBSD port, but I specifically chose it to be 
	below the standard starting ID used for normal user accounts which tend to 
	start from 1,000.

##### <a name="5.1.2DiskLayout"></a>Disk Layout for Virtual Domains

We need to layout our files mentioned in the configuration file above and I 
have chosen the following which is hopefully scaleable if you want to use this 
as the basis (ignoring the simpler database solution reviewed later.)

<ul>
	<li>/etc/postfix/virtual - the base directory to store virtual related 
	configurations</li>
	<li>./alias - for virtual alias files
	<ul>
		<li>file: common</li>
	</ul>
    </li>

	<li>./mailbox - for virtual mailbox files
	<ul>
		<li>file: domains</li>
		<li>file: alpha.example.org</li>
		<li>file: beta.example.org</li>
		<li>file: gamma.example.org</li>
	</ul></li>
</ul>
    
Screen Session
</p>

<pre class="command-line">
mv /etc/postfix/virtual /etc/postfix/virtual_aliases
mkdir -p /etc/postfix/virtual/mailbox
mkdir -p /etc/postfix/virtual/aliases
mv /etc/postfix/virtual_aliases /etc/postfix/virtual/aliases/common
touch /etc/postfix/virtual/mailbox/domains
touch /etc/postfix/virtual/mailbox/alpha.example.org
touch /etc/postfix/virtual/mailbox/beta.example.org
touch /etc/postfix/virtual/mailbox/gamma.example.org
</pre>

We move the current virtual alias file from /etc/postfix/virtual to 
/etc/postfix/virtual/aliases.

##### <a name="5.1.3VirtualDomains"></a>Virtual Domains

We specify for postfix which virtual domains we want it to receive email with 
the following configuration option:

File Fragment: /etc/postfix/main.cf
</p>

<pre class="screen-output">
virtual_mailbox_domains = hash:/etc/postfix/virtual/domains
</pre>

File:/etc/postfix/virtual/mailbox/domains
</p>

<pre class="config-file">
alpha.example.org      IGNORED_PARAMETER
beta.example.org       IGNORED_PARAMETER
gamma.example.org      IGNORED_PARAMETER
</pre>

After creating or making any changes to the above domains 
file, recreate the hash database using postmap

<pre class="command-line">
# /usr/local/sbin/postmap /etc/postfix/virtual/mailbox/domains
</pre>

##### <a name="5.1.4VirtualMailbox"></a>Virtual Mailbox

For OpenBSD, the default chroot'd postfix installation stores its files in /var/spool/postfix 
so we'll specify the location for virtual email accounts within that structure.

File Fragment: /etc/postfix/main.cf
</p>

<pre class="screen-output">
virtual_mailbox_base = /var/spool/postfix/vmail
</pre>

When setting up virtual mailboxes (in this manner), it makes sense to 
structure the directories for scalability and to prevent clashing namespaces. 
Prior to setting up accounts we'll consider that our mailbox accounts will be 
structured by domain. 

For example:

-   /var/spool/postfix/vmail/alpha.example.org/accountX
-   /var/spool/postfix/vmail/alpha.example.org/accountY
-   /var/spool/postfix/vmail/alpha.example.org/accountZ
-   /var/spool/postfix/vmail/beta.example.org/accountX
-   /var/spool/postfix/vmail/beta.example.org/accountY
-   /var/spool/postfix/vmail/beta.example.org/accountZ
-   /var/spool/postfix/vmail/gamma.example.org/AccountX
-   /var/spool/postfix/vmail/gamma.example.org/AccountY
-   /var/spool/postfix/vmail/gamma.example.org/AccountZ


We can now create some sample user accounts into our virtual mailbox

File Fragment: /etc/postfix/main.cf
</p>

<pre class="config-file">
virtual_mailbox_maps = hash:/etc/postfix/virtual/mailbox/alpha.example.org, 
        hash:/etc/postfix/virtual/mailbox/beta.example.org, 
        hash:/etc/postfix/virtual/mailbox/gamma.example.org
</pre>

Obviously, each valid user needs a corresponding mailbox storage space. The 
mailbox file is specified relative to the virtual\_mailbox\_base shown above and 
since we already have our directory design structure above, we can go ahead and 
create some accounts.

###### Virtual Accounts - alpha.example.org

File: /etc/postfix/virtual/mailbox/alpha.example.org

<pre class="config-file">
#account                     --&gt; Storage location
alfred@alpha.example.org    alpha.example.org/alfred/
bob@alpha.example.org       alpha.example.org/bob/
charlie@alpha.example.org   alpha.example.org/charlie/
</pre>

After creating or making any changes to the above 
alpha.example.org file, recreate the hash database using postmap

<pre class="command-line">
# /usr/local/sbin/postmap /etc/postfix/virtual/mailbox/alpha.example.org
</pre>

###### Virtual Accounts - beta.example.org

<pre class="config-file">
#account                     --&gt; Storage location
auntie@beta.example.org     beta.example.org/auntie/
bill@beta.example.org       beta.example.org/bill/
chou@beta.example.org       beta.example.org/chou/
</pre>

After creating or making any changes to the above 
beta.example.org file, recreate the hash database using postmap</p>

    # /usr/local/sbin/postmap 
    /etc/postfix/virtual/mailbox/beta.example.org

###### Virtual Accounts - gamma.example.org

File: /etc/postfix/virtual/mailbox/gamma.example.org

<pre class="config-file">
#account                     --&gt; Storage location
alistair@gamma.example.org  gamma.example.org/alistair/
ben@gamma.example.org       gamma.example.org/ben/
cinder@gamma.example.org    gamma.example.org/cinder/
</pre>

After creating or making any changes to the above 
gamma.example.org file, recreate the hash database using postmap

<pre class="command-line">
# /usr/local/sbin/postmap /etc/postfix/virtual/mailbox/gamma.example.org
</pre>

We must now tell postfix to re-read its configuration files, by using postfix 
reload.

<pre class="command-line">
# /usr/local/sbin/postfix reload
</pre>

Mailbox files (above) can use either mbox or maildir format. To use maildir 
format, include a slash at the end of the filename. For a discussion of the 
relative differences you can follow the link to:
<a href="http://www.courier-mta.org/mbox-vs-maildir/">Benchmarking mbox versus 
maildir</a>, in short if your have a modern Unix OS (post 2004?) you should not 
have any problems using maildirs as an efficient scalable system. But read the 
benchmark and search the web for your own edification. 

I have chosen for this example to use separate files per domain, merely for 
illustration of the flexibility of the system (and if you are insane enough to 
manage it manually you can at least let the file structure assist you in some 
manner.)

NOT WORKING YET. 

##### <a name="5.1.5VirtualAliases"></a>Virtual Aliases (broken)

NOT WORKING YET. 

#### <a name="5.2CreateTheSystemUserAccount"></a>2. Create the system user account for managing virtual mail

[ref: <a href="http://www.postfix.org/postconf.5.html#virtual_uid_maps">virtual\_uid\_maps</a>,
<a href="http://www.postfix.org/postconf.5.html#virtual_gid_maps">virtual\_gid\_maps</a>]

Mail delivery happens with the recipient's UID/GID privileges specified with
<a href="http://www.postfix.org/postconf.5.html#virtual_uid_maps">
virtual_uid_maps</a> and
<a href="http://www.postfix.org/postconf.5.html#virtual_gid_maps">
virtual_gid_maps</a>, therefore the virtual mailbox files must be owned by a 
system user account and associated with a  group on your system. 
Fortunately Postfix is flexible to allow each mailbox to be owned by a unique 
system user account or by a single system user account for all domains, and even 
one system user account per domain. This is set by using the virtual_uid_maps 
and virtual_gid_maps setting.

<pre class="screen-output">
virtual_uid_maps = static:901
virtual_gid_maps = static:901
</pre>

The 'static' map type tells Postfix that you want the uid/gid to be for all 
accounts.

We can now create the system user account to manage virtual email mailboxes.

Screen Session
</p>

<pre class="command-line">
useradd -d /var/spool/postfix/vmail -g=uid -u 901 \
    -s /sbin/nologin -m -c 'Virtual Mailbox Owner' _vmail
chmod -R 770 /var/spool/postfix/vmail
</pre>

A by-product of the user/group creation is that the 'base' directory will 
also be created with the correct permissions.

If we wanted to use different users, groups for managing mailboxes, then we 
could have used a lookup file instead.

<pre class="screen-output">
virtual_uid_maps = hash:/etc/postfix/virtual_uids
virtual_gid_maps = hash:/etc/postfix/virtual_gids
</pre>

Ensure the standard (non-virtual) alias file is built by using Postfix's 
newaliases. 

<pre class="command-line">
/usr/local/sbin/newaliases
</pre>

Restart Postfix

<pre class="command-line">
/usr/local/sbin/postfix stop
/usr/local/sbin/postfix start
</pre>

#### <a name="5.3TestingConfiguration"></a>3. Testing Configuration

##### <a name="5.3.1postconf"></a>postconf

Use postconf -n to compare whether what we expect in virtual_* parameter 
settings is what is running on the system.

Screen Session
</p>

<pre class="command-line">
postconf | grep ^virtual
</pre>
<pre class="screen-output">
virtual_alias_domains = $virtual_alias_maps
virtual_alias_expansion_limit = 1000
virtual_alias_maps = $virtual_maps
virtual_alias_recursion_limit = 1000
virtual_destination_concurrency_limit = $default_destination_concurrency_limit
virtual_destination_recipient_limit = $default_destination_recipient_limit
virtual_gid_maps = static:901
virtual_mailbox_base = /var/spool/postfix/vmail
virtual_mailbox_domains = hash:/etc/postfix/virtual/domains
virtual_mailbox_limit = 51200000
virtual_mailbox_lock = fcntl
virtual_mailbox_maps = hash:/etc/postfix/virtual/mailbox/alpha.tbu.to,

                  
hash:/etc/postfix/virtual/mailbox/beta.tbu.to, 
                  
hash:/etc/postfix/virtual/mailbox/gamma.tbu.to
virtual_minimum_uid = 900
virtual_transport = virtual
virtual_uid_maps = static:901
</pre>

##### <a name="5.3.1telnet"></a>telnet localhost smtp

Remember to use the /var/log/maillog file to validate postfix has started 
without errors. You can also repeat the above 'telnet localhost smtp' to review 
nothing has drastically broken.

Screen Session
</p>

<pre class="command-line">
$ telnet localhost smtp
</pre>

<pre class="screen-output">
Trying ::1...
Connected to localhost.
Escape character is '^]'.
220 myhost.example.org ESMTP Postfix (2.3.2)
ehlo example.org
250-myhost.example.org
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
</pre>
<pre class="command-line">mail from: &lt;samt@example.org&gt;
</pre>
<pre class="screen-output">250 2.1.0 Ok
</pre>
<pre class="command-line">rcpt to: &lt;alfred@alpha.example.org&gt;
</pre>
<pre class="screen-output">250 2.1.5 Ok
</pre>
<pre class="command-line">rcpt to: &lt;auntie@beta.example.org&gt;
</pre>
<pre class="screen-output">250 2.1.5 Ok
</pre>
<pre class="command-line">rcpt to: &lt;alistair@gamma.example.org&gt;
</pre>
<pre class="screen-output">250 2.1.5 Ok
</pre>
<pre class="command-line">data
</pre>
<pre class="screen-output">354 End data with &lt;CR&gt;&lt;LF&gt;.&lt;CR&gt;&lt;LF&gt;
</pre>
<pre class="command-line">
Subject: Welcome Virtual Users

Hopefully you are all virtually OK.

Welcome to email

.
</pre>
<pre class="screen-output">
250 2.0.0 Ok: queued as BA1FC5A950
</pre>
<pre class="command-line">
quit
</pre>
<pre class="screen-output">
221 2.0.0 Bye
Connection closed by foreign host.
</pre>

##### <a name="5.3.2MailLog"></a>Mail Log

The corresponding /var/log/maillog entry should look something like the 
following

File: /var/log/maillog
</p>

<pre class="screen-output">
connect from unknown[::1]
client=unknown[::1]
message-id=&lt;20070208214647.BA1FC5A950@myhost.example.org&gt;
from=&lt;samt@example.org&gt;, size=393, nrcpt=3 (queue active)
to=&lt;alfred@alpha.example.org&gt;, relay=virtual, delay=69, 
delays=67/0.05/0/1.8, dsn=2.0.0, status=sent (delivered to maildir)
to=&lt;auntie@beta.example.org&gt;, relay=virtual, delay=69, 
delays=67/0.05/0/1.9, dsn=2.0.0, status=sent (delivered to maildir)
to=&lt;alistair@gamma.example.org&gt;, relay=virtual, delay=69, 
delays=67/0.14/0/1.9, dsn=2.0.0, status=sent (delivered to maildir)
removed
disconnect from unknown[::1]
</pre>


##### <a name="5.3.3MailStore"></a>Mail Store

We should also be able to see evidence of the virtual account mails in the 
file system such as has occurred on this installation.

Screen Session

<pre class="command-line">
# ls -l /var/spool/postfix/vmail/alpha.example.org/alfred/new/
</pre>
<pre class="screen-output">
total 4
-rw------- 1 _vmail _vmail 481 Feb 9 10:47 
1170971257.V5I5a95aM294234.myhost.example.org
</pre>

<pre class="command-line">
cat /var/spool/postfix/vmail/alpha.example.org/alfred/new/1170971257.V5I5a95aM294234.myhost.example.org
</pre>

<pre class="screen-output">
Return-Path: &lt;samt@example.org&gt;
X-Original-To: alfred@alpha.example.org
Delivered-To: alfred@alpha.example.org
Received: from example.org (unknown [IPv6:::1])
by myhost.example.org (Postfix) with ESMTP id BA1FC5A950;
Fri, 9 Feb 2007 10:46:30 +1300 (TOT)
Subject: Welcome Virtual Users
Message-Id: &lt;20070208214647.BA1FC5A950@myhost.example.org&gt;
Date: Fri, 9 Feb 2007 10:46:30 +1300 (TOT)
From: samt@example.org
To: undisclosed-recipients:; 

Hopefully you are all virtually OK. 

Welcome to email 

</pre>

We can likewise confirm the same message was received for 
aunti@beta.example.org and alistair@gamma.example.org.

### <a name="6ConfiguringVirtualEmail_MySQL"></a>Configuring a Virtual Email Service - MySQL

Mischa Peters at <a href="http://high5.net">high5.net</a> has created a great tool for managing virtual user 
email accounts based on Postfix. We will look at installing and testing the 
foundation database configuration here.

To minimise tools being reviewed for debugging, we're going to attempt 
installing MySQL support, using the postfixadmin data tables, but without 
installing or using postfixadmin.

#### <a name="6.1ConfiguringMySQL"></a>Configuring MySQL

The following notes differs from a standard postfixadmin install in how it uses 
usernames, largely because it simplifies things for my understanding. The whole 
process has helped me to better understand the interactions between these 
different applications, finding methods for debugging installation problems. I 
hope it also simplifies for our understanding.

Please refer to <a href="mysql.htm">our MySQL notes </a>for how to install 
MySQL for OpenBSD.

Following Mischa's instructions at
<a href="http://postfix.wiki.xs4all.nl/index.php?title=Main_Page">Postfix Wiki</a>,
<a href="http://postfix.wiki.xs4all.nl/index.php?title=Virtual_Users_and_Domains_with_Courier-IMAP_and_MySQL">
Virtual Users and Domains</a> we'll take a look at:

-   Creating the database
-   Creating the Alias table
-   Creating the Domain table
-   Creating the Mailbox table
-   Populating the tables

Much of these database settings are straight out of the postfixadmin/DATABASE_MYSQL.TXT 
file with slight/inane modifications where it helps me find things more legible.

The key differentiators between these database instructions than the default 
install are as follows:

<ul>
	<li>database name is: mail instead of postfix</li>
	<li>postfix user account is: postfixserver instead of postfix</li>
	<li>populated sample data: username is different, password is different</li>
</ul>

Minor quibbles but makes the install instructions slightly more legible?

##### <a name="6.1.1CreatingTheDatabase"></a>Creating the database

We will first log into the mysql server with an account that has 
root/administrator privileges and insert (copy/paste) sql commands below.

Screen Session

<pre class="command-line">
$ mysql -u root -p
</pre>
<pre class="screen-output">
Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 41 to server version: 5.0.24a-log

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

mysql&gt;
</pre>

The rest of the 'greyed' instructions can be copy/pasted into your MySQL 
monitor above. Be sure to change your usernames and passwords as appropriate.

The first thing we want is to tell mysql that we want to modify the records 
relating to user accounts for the database server.

mysql client session

<pre class="command-line">USE mysql;</pre>

Next, we want to create some new settings for a new user 'postfixserver' that 
we want to designate for use by the postfix server.

mysql client session

<pre class="command-line">
INSERT INTO user (Host, User, Password) 
    VALUES ('localhost','postfixserver',
    password('postfixserver'));
INSERT INTO db (Host, Db, User, Select_priv)
    VALUES ('localhost','mail','postfixserver','Y');
</pre>

Next, we want to create a new user 'postfixadmin' that we want to designate 
for use by the postfixadmin application.

mysql client session

<pre class="command-line">
INSERT INTO user (Host, User, Password) 
    VALUES ('localhost','postfixadmin',
    password('postfixadmin'));
INSERT INTO db (Host, Db, User, Select_priv, 
    Insert_priv, Update_priv, Delete_priv) 
    VALUES ('localhost', 'mail', 'postfixadmin',
    'Y', 'Y', 'Y', 'Y');
</pre>

To ensure that these new user settings have been loaded into use, we flush 
the settings.

mysql client session

<pre class="command-line">FLUSH PRIVILEGES;
</pre>

Now, we want to set privileges for the database that we will be using.

mysql client session

<pre class="command-line">
GRANT USAGE ON mail.* TO postfixserver@localhost;
GRANT SELECT, INSERT, DELETE, UPDATE ON mail.* TO
    postfixserver@localhost;
GRANT USAGE ON mail.* TO postfixadmin@localhost;
GRANT SELECT, INSERT, DELETE, UPDATE ON mail.* TO
    postfixadmin@localhost;
</pre>

Next, we create the database itself.

mysql client session

<pre class="command-line">
CREATE DATABASE mail;
</pre>

The next stage is to create the relevant tables and some dummy/sample data.

##### <a name="6.1.2CreatingTheAliasTable"></a>Creating the Alias table

The alias table will store/retrieve our virtual aliases (which I have not yet 

mysql client session

<pre class="command-line">
USE mail;
CREATE TABLE `alias` (
        `address` varchar(255) NOT NULL default '',
        `goto` text NOT NULL,
        `domain` varchar(255) NOT NULL default '',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `modified` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        PRIMARY KEY (address),
        KEY address (`address`) 
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Virtual Aliases';
</pre>


##### <a name="6.1.3CreatingTheDomainTable"></a>Creating the Domain table


The domain table will store/retrieve our virtual domains

mysql client session

<pre class="command-line">
CREATE TABLE `domain` (
        `domain` varchar(255) NOT NULL default '',
        `description` varchar(255) NOT NULL default '',
        `aliases` int(10) NOT NULL default '0',
        `mailboxes` int(10) NOT NULL default '0',
        `maxquota` int(10) NOT NULL default '0',
        `quota` int(10) NOT NULL default '0',
        `transport` varchar(255) default NULL,
        `backupmx` tinyint(1) NOT NULL default '0',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `modified` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        PRIMARY KEY (`domain`),
        KEY domain (`domain`)
    ) TYPE=MyISAM COMMENT='Postfix Admin - Virtual Domains';
</pre>

##### <a name="6.1.4CreatingTheMailboxTable"></a>Creating the Mailbox table


The mailbox table will store/retrieve the usernames, passwords, and file 
directories

mysql client session

<pre class="command-line">USE mail;
</pre>
<pre class="command-line">
CREATE TABLE `mailbox` (
        `username` varchar(255) NOT NULL default '',
        `password` varchar(255) NOT NULL default '',
        `name` varchar(255) NOT NULL default '',
        `maildir` varchar(255) NOT NULL default '',
        `quota` int(10) NOT NULL default '0',
        `domain` varchar(255) NOT NULL default '',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `modified` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        PRIMARY KEY (`username`),
        KEY username (`username`)
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Virtual Mailboxes';
</pre>


##### <a name="6.1.5OtherTablesForPostfixadmin"></a>Other Tables for postfixadmin

The database is now created, and we might as well configure the other tables 
used by postfixadmin

mysql client session

<pre class="command-line">
USE mail;</pre>
<pre class="command-line">
CREATE TABLE `admin` (
        `username` varchar(255) NOT NULL default '',
        `password` varchar(255) NOT NULL default '',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `modified` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        PRIMARY KEY (`username`),
        KEY username (`username`)
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Virtual Admins';
</pre>

mysql client session

<pre class="command-line">
USE mail;</pre>
<pre class="command-line">
CREATE TABLE `domain_admins` (
        `username` varchar(255) NOT NULL default '',
        `domain` varchar(255) NOT NULL default '',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        KEY username (`username`)
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Domain Admins';
</pre>

<pre class="command-line">
USE mail;
</pre>
<pre class="command-line">
CREATE TABLE `log` (
        `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
        `username` varchar(255) NOT NULL default '',
        `domain` varchar(255) NOT NULL default '',
        `action` varchar(255) NOT NULL default '',
        `data` varchar(255) NOT NULL default '',
        KEY timestamp (`timestamp`)
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Log';
</pre>


mysql client session

<pre class="command-line">
USE mail;</pre>
<pre class="command-line">
#
# Table structure for table vacation
#
CREATE TABLE `vacation` (
        `email` varchar(255) NOT NULL default '',
        `subject` varchar(255) NOT NULL default '',
        `body` text NOT NULL default '',
        `cache` text NOT NULL default '',
        `domain` varchar(255) NOT NULL default '',
        `created` datetime NOT NULL default '0000-00-00 00:00:00',
        `active` tinyint(1) NOT NULL default '1',
        PRIMARY KEY (`email`),
        KEY email (`email`)
    ) TYPE=MyISAM 
    COMMENT='Postfix Admin - Virtual Vacation';
</pre>

#### <a name="6.2PopulatingTheTables"></a>Populating the tables

We will populate our database with some test data that you can easily remove 
later using <a href="admin.htm">GUI Admin</a>. By using our sample 
data below we avoid having to configure <a href="admin.htm">postfixadmin</a> 
to have a working test server.

-   Populate an administrator account for postfixadmin, so you can follow 
	through and make your own changes to the data as the testing continues.
-   Populate Virtual Domains data
-   Populate Virtual Mailbox data (virtual users)
-   Verify our Settings

We will replicate our virtual user system used with the above hash files into 
our MySQL database.

##### <a name="6.2.1SuperAdministratorAccount"></a>Super Administrator Account.

This is largely relevant only if you will be installing
<a href="admin.htm">postfixadmin</a>, and can be skipped.

Now, here's one part where the standard documentation always got me lost. The 
standard instructions provides the below image which will work for logging into 
the system, but will cause other problems. Instead of the following instructions

superadmin user &amp; password (login: admin@domain.tld, password: admin)
<pre class="screen-output">
INSERT INTO domain_admins 
    (username, domain, active) 
    VALUES ('admin@domain.tld','ALL','1');
INSERT INTO admin 
    (username, password, active) VALUES 
    ('admin@domain.tld','$1$0fec9189$bgI6ncWrldPOsXnkUBIjl1','1');
</pre>

We will be using the following instructions which uses CRYPT instead of 
postfixadmin's md5crypt for encrypting the password to:

-   Create the administrator account 'admin' and using 'admin' as the password.
-   make the administrator account a 'Super Administrator' with powers over 
	all virtual domains.

    
mysql client session

<pre class="command-line">USE mail;</pre>
<pre class="command-line">
INSERT INTO admin (username, password, active) 
    VALUES 
    ('admin','6dwLx9NTxhTjU','1');
INSERT INTO domain_admins (username, domain, active) 
    VALUES ('admin','ALL','1');
</pre>

When installing postfixadmin, from the above settings, we set:

File: /var/www/htdocs/postfixadmin/config.inc.php

<pre class="command-line">$CONF['encrypt'] = 'system';
</pre>

##### <a name="6.2.2VirtualDomains"></a>Virtual Domains

We will be creating virtual domains for our three sample domains:

-   alpha.example.org
-   beta.example.org
-   gamma.example.org

Creating our virtual domains<

mysql client session

<pre class="command-line">
USE mail;
</pre>
<pre class="command-line">
INSERT INTO domain 
    (domain,description,aliases,mailboxes,maxquota,
        quota,transport,backupmx,active) 
    VALUES ('alpha.example.org', 'Alpha 
        Tester','10','10', '0','0','virtual', '0','1');
INSERT INTO domain 
    (domain,description,aliases,mailboxes,maxquota,
        quota,transport,backupmx,active) 
    VALUES ('beta.example.org', 'Beta 
        Site','10','10', '0','0','virtual', '0','1');
INSERT INTO domain 
    (domain,description,aliases,mailboxes,maxquota,
        quota,transport,backupmx,active) 
    VALUES ('gamma.example.org', 'Gamma 
        Born','10','10', '0','0','virtual', '0','1');
</pre>

We can verify that the data has been entered correctly with the following 
simple test. From the command prompt, start mysql.

Screen Session

<pre class="command-line"># mysql -u root -p
</pre>
<pre class="screen-output">
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 94 to server version: 5.0.24a-log 
Type 'help;' or '\h' for help. Type '\c' to clear the buffer. 
</pre>
<pre class="command-line">mysql&gt; use mail;</pre>
<pre class="screen-output">Database changed</pre>
<pre class="command-line">
mysql&gt; select domain, transport from domain;
</pre>
<pre class="screen-output">
+--------------+-----------+
| domain | transport |
+--------------+-----------+
| alpha.example.org | virtual |
| beta.example.org | virtual |
| gamma.example.org | virtual |
+--------------+-----------+
3 rows in set (0.00 sec)
</pre>
##### <a name="6.2.3VirtualMailbox"></a>Virtual Mailbox

As from our example above, we will be creating virtual mailboxes (virtual 
user accounts) for our above three sample domains:

-   Virtual Users for alpha.example.org
-   Virtual Users for beta.example.org
-   Virtual Users for gamma.example.org

###### Virtual Users for alpha.example.org

Creating our virtual users for alpha.example.org : password is username

mysql client session

<pre class="command-line">
USE mail;

INSERT INTO mailbox 
    (username,password,name,maildir,quota,domain,active) 
    VALUES ('alfred@alpha.example.org',
        '82fU0EHEzA6wo', 'Alfred',
        'alpha.example.org/alfred@alpha.example.org/', 
        '0','alpha.example.org','1'
     );
INSERT INTO mailbox 
    (username,password,name,maildir,quota,domain,active) 
    VALUES ('bob@alpha.example.org','1bdyGcAE/JC0I', 
        'Bob','alpha.example.org/bob@alpha.example.org/', 
        '0','alpha.example.org','1'
    );
INSERT INTO mailbox 
    (username,password,name,maildir,quota,domain,active) 
    VALUES ('charlie@alpha.example.org','048qvFjqS3zBc', 
        'Charlie','alpha.example.org/charlie@alpha.example.org/', 
        '0','alpha.example.org','1'
    );
</pre>

###### Virtual Users for beta.example.org

Creating our virtual users for beta.example.org : password is username

mysql client session

<pre class="command-line">
USE mail;

INSERT INTO mailbox (username,password,name,maildir,
    quota,domain,active) 
    VALUES ('auntie@beta.example.org', '3336RmmvRQ0NU', 
        'Auntie','beta.example.org/auntie@beta.example.org/', 
        '0','beta.example.org','1'
    );
INSERT INTO mailbox (username,password,name,maildir,
    quota,domain,active) 
    VALUES ('bill@beta.example.org', 'fbVsBHcPJVVjU', 
        'Bill','beta.example.org/bill@beta.example.org/', 
        '0','beta.example.org','1'
    );
INSERT INTO mailbox (username,password,name,maildir,
    quota,domain,active) 
    VALUES ('chou@beta.example.org', '359nFQg1J.8nc', 
        'Chou','beta.example.org/chou@beta.example.org/', 
        '0','beta.example.org','1'
    );
</pre>

###### Virtual Users for gamma.example.org

Creating our virtual users for gamma.example.org : password is username

mysql client session

<pre class="command-line">
USE mail;
INSERT INTO mailbox (username,password,name,
        maildir,quota,domain,active) 
    VALUES ('alistair@gamma.example.org', 
        '12XeQqcTNk3YU', 'Alistair','gamma.example.org/alistair@gamma.example.org/', 
        '0','gamma.example.org','1'
    );
INSERT INTO mailbox (username,password,name,
        maildir,quota,domain,active) 
    VALUES ('ben@gamma.example.org', '1bKpSqtESjdck', 
        'Ben','gamma.example.org/ben@gamma.example.org/', 
        '0','gamma.example.org','1'
    );
INSERT INTO mailbox (username,password,name,
        maildir,quota,domain,active) 
    VALUES ('cinder@gamma.example.org', '19rP1zls.evZQ', '
        Cinder','gamma.example.org/cinder@gamma.example.org/', 
        '0','gamma.example.org','1'
    );
</pre>

##### <a name="6.2.4VerifyOurSettings"></a>Verify our settings

Remember to change the user domains in the above to your specific virtual 
domain(s). You can use an sql query such as the below to help verify that you 
are not using the *.example. domains from this document.

mysql client session

<pre class="command-line">
use mail;
select username from mailbox;
select domain from domain;
</pre>

#### <a name="6.3CreateTheSystemUserAccount"></a>Create the system user account for managing virtual mail

[ref: <a href="http://www.postfix.org/postconf.5.html#virtual_uid_maps">
http://www.postfix.org/postconf.5.html#virtual_uid_maps</a>,
<a href="http://www.postfix.org/postconf.5.html#virtual_gid_maps">
http://www.postfix.org/postconf.5.html#virtual_gid_maps</a>] 

If you've skipped the hash virtual user instructions, then you will need to 
create the System user Account for Postfix to use for delivering 'virtual' mail.

Mail delivery happens with the recipient's UID/GID privileges specified with
<a href="http://www.postfix.org/postconf.5.html#virtual_uid_maps">
virtual_uid_maps</a> and
<a href="http://www.postfix.org/postconf.5.html#virtual_gid_maps">
virtual_gid_maps</a>, therefore the virtual mailbox files must be owned by a 
system user account and associated with a  group on your system. 
Fortunately Postfix is flexible to allow each mailbox to be owned by a unique 
system user account or by a single system user account for all domains, and even 
one system user account per domain. This is set by using the virtual_uid_maps 
and virtual_gid_maps setting.

<pre class="screen-output">
virtual_uid_maps = static:901
virtual_gid_maps = static:901
</pre>

The 'static' map type tells Postfix that you want the uid/gid to be for all 
accounts.

We can now create the system user account to manage virtual email mailboxes.

<pre class="command-line">
useradd -d /var/spool/postfix/vmail -g=uid -u 901 \
    -s /sbin/nologin -m -c 'Virtual Mailbox Owner' _vmail
chmod -R 770 /var/spool/postfix/vmail
</pre>

A by-product of the user/group creation is that the 'base' directory will 
also be created with the correct permissions.

If we wanted to use different users, groups for managing mailboxes, then we 
could have used a lookup file instead.

<pre class="screen-output">
virtual_uid_maps = hash:/etc/postfix/virtual_uids
virtual_gid_maps = hash:/etc/postfix/virtual_gids
</pre>

Ensure the standard (non-virtual) alias file is built by using Postfix's 
newaliases. 

<pre class="command-line">
/usr/local/sbin/newaliases
</pre>

Restart Postfix

<pre class="command-line">
/usr/local/sbin/postfix stop
/usr/local/sbin/postfix start
</pre>


#### <a name="6.4ConfiguringPostfix"></a>Configuring Postfix

Postfix can read it's configuration data from hash files, text files, and 
from databases. To tell Postfix that data will be obtained from a MySQL 
database, we use the 'mysql:' prefix to a text file that contains the relevant 
information for postfix to extract that data.

For our example, modify the above /etc/postfix/main.cf. We can work by just 
removing the additions made above and replacing them with the following.

File Fragment: /etc/postfix/main.cf

<pre class="command-line">
virtual_alias_maps = mysql:/etc/postfix/mysql/alias_maps.cf
virtual_gid_maps = static:901
virtual_mailbox_base = /var/spool/postfix/vmail
virtual_mailbox_domains = mysql:/etc/postfix/mysql/domains_maps.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql/mailbox_maps.cf
virtual_minimum_uid = 900
virtual_transport = virtual
virtual_uid_maps = static:901
parent_domain_matches_subdomains =
</pre>

The /etc/postfix/mysql/*.cf files contain the login information for postfix to access 
and retrieve the MySQL database/table.

Verify that what we've set above is actually what postfix will recognise.

Screen Session

<pre class="command-line">
/usr/local/sbin/postfix reload
/usr/local/sbin/postconf -n | grep ^virtual
</pre>
<pre class="screen-output">
virtual_alias_maps = mysql:/etc/postfix/mysql/alias_maps.cf
virtual_gid_maps = static:901
virtual_mailbox_base = /var/spool/postfix/vmail
virtual_mailbox_domains = mysql:/etc/postfix/mysql/domains_maps.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql/mailbox_maps.cf
virtual_minimum_uid = 900
virtual_transport = virtual
virtual_uid_maps = static:901
</pre>

Key things to watch out for is that we are using the file type: 'mysql' and 
that the file locations specified above will be correct to what we are creating 
below.

#### <a name="6.5CreatingThePostfixToMySQLSettingsFile"></a>Creating the postfix to mysql settings file

Before we create our text *.cf files, we'll need to make the directory.

<pre class="command-line">
mkdir -p /etc/postfix/mysql
</pre>

Create the current mysql instruction/configuration files for postfix.

##### <a name="6.5.1VirtualDomains"></a>Virtual Domains

<pre class="screen-output">
virtual_mailbox_domains = mysql:/etc/postfix/mysql/domains_maps.cf
</pre>

domains\_maps.cf will be used for virtual\_mailbox\_domains

File:/etc/postfix/mysql/domains_maps.cf

<pre class="command-line">
user = postfixserver
password = postfixserver
hosts = 127.0.0.1
dbname = mail
table = domain
select_field = domain
where_field = domain
additional_conditions = and backupmx = '0' and active = '1'
</pre>

##### <a name="6.5.2VirtualMailbox"></a>Virtual Mailbox

<pre class="screen-output">
virtual_mailbox_maps = mysql:/etc/postfix/mysql/mailbox_maps.cf
</pre>

mailbox\_maps.cf will be used for virtual\_mailbox\_maps

File:/etc/postfix/mysql/mailbox_maps.cf

<pre class="command-line">
user = postfixserver
password = postfixserver
hosts = 127.0.0.1
dbname = mail
table = mailbox
select_field = maildir
where_field = username
additional_conditions = and active = '1'
</pre>

##### <a name="6.5.3VirtualAliases"></a>Virtual Aliases

<pre class="screen-output">
virtual_alias_maps = mysql:/etc/postfix/mysql/alias_maps.cf
</pre>

alias\_maps.cf will be used for virtual\_alias\_maps

File: /etc/postfix/mysql/alias_maps.cf

<pre class="command-line">
user = postfixserver
password = postfixserver
hosts = 127.0.0.1
dbname = mail
table = alias
select_field = goto
where_field = address
</pre>

##### <a name="6.5.4RestartPostfix"></a>Restart Postfix

Once you've created all these mysql files, we can stop and restart 
postfix and should be working together with postfixadmin for managing virtual 
user accounts.

<pre class="command-line">
/usr/local/sbin/postfix stop
/usr/local/sbin/postfix start
</pre>

#### <a name="6.6Testing"></a>Testing

We can now provide some sample testing of mail routing through to our virtual 
accounts, using MySQL as the database.

##### <a name="6.6.1telnet"></a>telnet localhost smtp

Screen Session

<pre class="command-line">
$ telnet localhost smtp
</pre>
<pre class="screen-output">Trying ::1...
Connected to localhost.
Escape character is '^]'.
220 myhost.example.org ESMTP Postfix (2.3.2)
</pre>
<pre class="command-line">ehlo example.org
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
<pre class="command-line">mail from: &lt;samt@example.org&gt;</pre>
<pre class="screen-output">250 2.1.0 Ok</pre>
<pre class="command-line">rcpt to: &lt;charlie@alpha.example.org&gt;</pre>
<pre class="screen-output">250 2.1.5 Ok</pre>
<pre class="command-line">rcpt to: &lt;chou@beta.example.org&gt;</pre>
<pre class="screen-output">250 2.1.5 Ok</pre>
<pre class="command-line">rcpt to: &lt;cinder@gamma.example.org&gt;</pre>
<pre class="screen-output">250 2.1.5 Ok</pre>
<pre class="command-line">data</pre>
<pre class="screen-output">354 End data with &lt;CR&gt;&lt;LF&gt;.&lt;CR&gt;&lt;LF&gt;</pre>
<pre class="command-line">
Subject: Welcome MySQL based virtual users

Hopefully you've received this email message without fault ?


.
250 2.0.0 Ok: queued as 357E65A950
quit
221 2.0.0 Bye
Connection closed by foreign host.
</pre>

##### <a name="6.6.2MailLog"></a>Mail Log

With the following results showing in our log file: /var/log/maillog</p>
File: /var/log/maillog

<pre class="screen-output">
connect from unknown[::1]
# client=unknown[::1]
# message-id=&lt;20070209010215.45BCC5A956@myhost.example.org&gt;
# from=&lt;samt@example.org&gt;, size=402, nrcpt=3 (queue active)
# disconnect from unknown[::1]
# to=&lt;charlie@alpha.example.org&gt;, relay=virtual, delay=54, delays=52/0.01/0/1.6, dsn=2.0.0, status=sent (delivered to maildir)
# to=&lt;chou@beta.example.org&gt;, relay=virtual, delay=54, delays=52/0.03/0/1.7, dsn=2.0.0, status=sent (delivered to maildir)
# to=&lt;cinder@gamma.example.org&gt;, relay=virtual, delay=54, delays=52/0.04/0/1.8, dsn=2.0.0, status=sent (delivered to maildir)
# removed
</pre>

##### <a name="6.6.3MailStore"></a>Mail Store

We should now have email in the user directories 

-   ./alpha.example.org/charlie@alpha.example.org/new as well as 
-   ./beta.example.org/chou@beta.example.org/new and 
-   ./gamma.example.org/cinder@gamma.example.org/new 

with the same content as below:

File: /var/spool/postfix/vmail/alpha.example.org/charlie@alpha.example.org

<pre class="screen-output">
59984.myhost.example.org &lt;
Return-Path: &lt;samt@example.org&gt;
X-Original-To: charlie@alpha.example.org
Delivered-To: charlie@alpha.example.org
Received: from example.org (unknown [IPv6:::1])
by myhost.example.org (Postfix) with ESMTP id 45BCC5A956;
Fri, 9 Feb 2007 14:02:08 +1300 (TOT)
Subject: Welcome MySQL based virtual users
Message-Id: &lt;20070209010215.45BCC5A956@myhost.example.org&gt;
Date: Fri, 9 Feb 2007 14:02:08 +1300 (TOT)
From: samt@example.org
To: undisclosed-recipients:; 
</pre>
<pre class="screen-output"> </pre>
<pre class="screen-output">
Hopefully you've received this email message without 
fault ?

</pre>

##### <a name="6.2.5MySQLLogFile"></a>MySQL Log file

If you're having problems then you can also take a look at the sql log files 
at /var/mysql/myhost.log

File: /var/mysql/myhost.log

<pre class="screen-output">
20 Connect postfixserver@localhost on mail
20 Query SELECT goto FROM alias WHERE address='example.org'
21 Connect postfixserver@localhost on mail
21 Query SELECT domain FROM domain WHERE domain='example.org' 070209 13:50:37 20 Query SELECT goto FROM alias WHERE address='alpha.example.org'
21 Query SELECT domain FROM domain WHERE domain='alpha.example.org'
22 Connect postfixserver@localhost on mail
22 Query SELECT goto FROM alias WHERE address='charlie@alpha.example.org'
22 Query SELECT goto FROM alias WHERE address='@alpha.example.org'
23 Connect postfixserver@localhost on mail
23 Query SELECT maildir FROM mailbox WHERE username='charlie@alpha.example.org' and active = '1'
24 Connect postfixserver@localhost on mail
24 Query SELECT goto FROM alias WHERE address='charlie@alpha.example.org'
24 Query SELECT goto FROM alias WHERE address='@alpha.example.org'070209 13:50:44 20 Query SELECT goto FROM alias WHERE address='beta.example.org'
21 Query SELECT domain FROM domain WHERE domain='beta.example.org'
22 Query SELECT goto FROM alias WHERE address='chou@beta.example.org'
22 Query SELECT goto FROM alias WHERE address='@beta.example.org'
23 Query SELECT maildir FROM mailbox WHERE username='chou@beta.example.org' and 
active = '1'
24 Query SELECT goto FROM alias WHERE address='chou@beta.example.org'
24 Query SELECT goto FROM alias WHERE address='@beta.example.org'
070209 13:50:55 20 Query SELECT goto FROM alias WHERE address='gamma.example.org'
21 Query SELECT domain FROM domain WHERE domain='gamma.example.org'
22 Query SELECT goto FROM alias WHERE address='cinder@gamma.example.org'
22 Query SELECT goto FROM alias WHERE address='@gamma.example.org'
23 Query SELECT maildir FROM mailbox WHERE username='cinder@gamma.example.org' and active = '1'
24 Query SELECT goto FROM alias WHERE address='cinder@gamma.example.org'
24 Query SELECT goto FROM alias WHERE address='@gamma.example.org'
070209 13:51:24 20 Query SELECT goto FROM alias WHERE address='alpha.example.org'
21 Query SELECT domain FROM domain WHERE domain='alpha.example.org'
20 Query SELECT goto FROM alias WHERE address='beta.example.org'
21 Query SELECT domain FROM domain WHERE domain='beta.example.org'
20 Query SELECT goto FROM alias WHERE address='gamma.example.org'
21 Query SELECT domain FROM domain WHERE domain='gamma.example.org'
25 Connect postfixserver@localhost on mail
25 Query SELECT maildir FROM mailbox WHERE username='charlie@alpha.example.org' and active = '1'
26 Connect postfixserver@localhost on mail
26 Query SELECT maildir FROM mailbox WHERE username='chou@beta.example.org' and active = '1'
27 Connect postfixserver@localhost on mail
27 Query SELECT maildir FROM mailbox WHERE username='cinder@gamma.example.org' and active = '1'
</pre>

So, if some of the above are not working properly then you at least can get 
some clues from the above two log files of where you can begin debugging your 
installation.

Remember that postconf returns what Postfix actually understands from your 
changes to the ./postfix/main.cf file so it is always a good point to start here 
to ensure that what you thought you typed in, is actually what postfix is 
reading.

The next logical step in configuring your email server with Postfix, is to 
set up an imap/pop3 server. For this exercise, we've reviewed instructions
<a href="dovecot.htm">to use dovecot</a>.

### Configuring a Virtual Email Service - MySQL high load server

Below are just collections from other people's notes, since I haven't got a 
'high load' server for testing as yet (otherwise known as machines and ram are 
dealing well currently.)

You can improve performance in high load environments by sharing 
database/mysql connections among Postfix smtpd connections.

<pre class="config-file">
virtual_alias_maps = proxy:mysql:/etc/postfix/mysql/alias_maps.cf
virtual_mailbox_domains = proxy:mysql:/etc/postfix/mysql/domains_maps.cf
virtual_mailbox_maps = proxy:mysql:/etc/postfix/mysql/mailbox_maps.cf
</pre>

### <a name="author"></a>Reference Resources

There is a plethora of documentation out there using
Postfix with Virtual Accounts, likewise 
there is also quite a few with OpenBSD as 
the server operating system.

Postfix [Documentation](http://www.postfix.org/documentation.html)

-   Postfix - [Hosting Multiple Domains with Virtual Accounts](http://www.akadia.com/services/postfix_separate_mailboxes.html) 
-   [OpenBSD Postfix Admin Guide](http://postfix.wiki.xs4all.nl/index.php?title=OpenBSD_PostfixAdmin_Guide)
-   [Virtual Users and Domains with Courier IMAP and MySQL](http://postfix.wiki.xs4all.nl/index.php?title=Virtual_Users_and_Domains_with_Courier-IMAP_and_MySQL)
-   [SASL README](http://www.postfix.org/SASL_README.html)
-   Server with virtual multi-domain support How-To setup a server to use Apache2, 
    Postfix, Pure-FTPd, Dovecot, Roundcube and [all of them controlled easy over web 
    by CCC](http://postfix.pentachron.net/) 
-   The Book of Postfix - [Chapter 25 Troubleshooting Tips](http://www.postfix-book.com/debugging.html)
-   [ISP-style Email Service with Debian-Sarge and Postfix 2.1](http://workaround.org/articles/ispmail-sarge/)
-   [Virtual Users and Domains with Postfix, Courier and MySQL (+SMTP_AUTH, Quota, 
    SpamAssassin, ClamAV)](http://www.howtoforge.com/virtual_postfix_mysql_quota_courier)
