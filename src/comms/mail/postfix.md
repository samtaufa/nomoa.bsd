## Serving with Postfix

<div style="float:right">

Table of Contents

<ul>
    <li><a href="InstallingPostfix">Installing Postfix</a>
        <ul>
            <li><a href="#2.1InstallingThePort">Installing the Port</a>
            <li><a href="#2.2ReadTheDocument">Read the Documentation</a>
            <li><a href="#2.3EnablePostfix">Enable Postfix</a>
            <li><a href="#2.4MinimumMandatory">Minimal Configuration</a>
            <li><a href="#2.5EnableAutomaticStartup">Enable automatic startup on System Restart</a>
            <li><a href="#2.6CompleteDisablingSendmail">Complete Disabling Sendmail</a>
            <li><a href="#2.7VerifyAliasConfiguration">Verify Alias Configuration</a>
        </ul>
    <li><a href="#StartingPostfix">Starting Postfix</a>
        <ul>
                <li><a href="#3.1RestartSyslogd">Restart syslogd</a> 
                <li><a href="#3.2KillExistingSessionOfSendmail">Kill existing session of 
                Sendmail</a> 
                <li><a href="#3.3RebuildTheAliasFile">Rebuild alias file</a> 
                <li><a href="#3.4CheckFilesAndConfiguration">Check files and configuration</a> 
                <li><a href="#3.5StartPostfix">Start postfix</a> 
        </ul>
    <li><a href="#TestingTheMailServer">Testing SMTP</a>
        <ul>
                <li><a href="#4.1telnet">telnet localhost smtp</a>
                <li><a href="#4.2MailLog">Mail Log</a>
                <li><a href="#4.3mail">/usr/bin/mail</a>
                <li><a href="#4.4Summary">Summary</a>
        </ul>    
    <li><a href="#chroot">Postfix chroot files</a>
    <li><a href="#customise">Customise Postfix for local install</a>
    <li>Reference Resources
</ul>

</div>

[OpenBSD 4.7, Postfix 2.7]

OpenBSD ships preconfigured with [Sendmail](http://www.sendmail.org) as 
the mail server (MTA.) For [Virtual User Accounts](postfix/virtual.htm),
[Mail Proxy](mail/proxy.html) postfix simplifies the buildprocess.

Customisations are referenced for:

-   [Proxy Configuration](postfix/proxy.html)
-   [Virtual Accounts](postfix/virtual.html)

###  <a name="InstallingPostfix"></a>Installing Postfix

The dovecot, mysql flavor of Postfix is a pre-built configuration of Postfix 
with support for dovecot as a POP3, IMAP, SSL provider, and mysql as a database backend.
The binary package may not be available as a download, the alternative is to install the ports tree and 
build the package.

####  <a name="2.1InstallingThePort"></a>Installing the Port

Install the postfix package, using the appropriate binary package, or if your
package flavor is not available, use the ports system (such as in the below example.)

<pre class="command-line">
 # cd /usr/ports/mail/postfix/stable
 # make show=FLAVORS
 </pre>
 <pre class="screen-output">
sasl2 ldap mysql pgsql dovecot</pre>
<pre class="command-line">
# env FLAVOR='mysql dovecot' make package
# env FLAVOR='mysql dovecot' make install
</pre>

The simplest solution is to install a binary package.

<pre class="command-line">
pkg_add postfix-2.7.0.tgz</pre>
<pre class="screen-output">
postfix-2.7.0: ok
--- +postfix-2.7.0 -------------------
-> Creating /etc/mailer.conf.postfix
-> Creating Postfix spool directory and chroot area under /var/spool/postfix
-> Creating Postfix data directory under /var/postfix
+---------------
| Configuration files have been installed in /etc/postfix.
| Please update these files to meet your needs.
+---------------
Postfix can be set up to replace sendmail entirely. Please read the
documentation at file:/usr/local/share/doc/postfix/html/index.html or
http://www.postfix.org/ carefully before you decide to do this!

To replace sendmail with postfix you have to install a new mailer.conf
using the following command:

    /usr/local/sbin/postfix-enable

If you want to restore sendmail, this is done using the following command:

    /usr/local/sbin/postfix-disable
</pre>

<p>The package build gives us a number of tasks to perform before we can assume 
that postfix is minimally installed.</p>

<ol>
	<li>Read the documentation
	<li>Enable Postfix using provided script
	<li>Minimal Configuration
	<li>Enable automatic startup on System Restart (i.e. edit startup 
	configuration file: /etc/rc.conf.local)
	<li>Complete Disabling Sendmail (i.e. edit root's crontab to disable 
	Sendmail)
	<li>Verify alias configuration
</ol>

#### <a name="2.2ReadTheDocument"></a>1. Read the documentation

<p>The documentation is made available in html format, below is an example local webspace for reading.</p>

<pre class="command-line">
# mkdir -p /var/www/htdocs/manual
# cp -R /usr/local/share/doc/postfix/html /var/www/htdocs/manual/postfix
</pre>

If you've previously enabled the standard OpenBSD <a href="apache.htm">apache</a> base installation then 
you should now be able to browse the Postfix documentation locally at 
<a href="http://www.example.org/manual/postfix/">http://www.example.org/manual/postfix/</a>. 
If you have enabled the Apache server and have no intentions of doing so, then 
you can read the official documentation at
<a href="http://www.postfix.org/docs.html">http://www.postfix.org/docs.html</a>.

#### <a name="2.3EnablePostfix"></a>2. Enable Postfix

Enable Postfix using the provided script, and follow the manual configuration changes
specified by the script.

<pre class="command-line">
/usr/local/sbin/postfix-enable</pre>

<pre class="screen-output">
If you want to restore sendmail, this is done using the following command:

    /usr/local/sbin/postfix-disable

root@:all# /usr/local/sbin/postfix-enable
old /etc/mailer.conf saved as /etc/mailer.conf.pre-postfix
postfix /etc/mailer.conf enabled

NOTE: do not forget to add sendmail_flags="-bd" to
      /etc/rc.conf.local to startup postfix correctly.

NOTE: do not forget to add "-a /var/spool/postfix/dev/log" to
      syslogd_flags in /etc/rc.conf.local and restart syslogd.

NOTE: do not forget to remove the "sendmail clientmqueue runner"
      from root's crontab.
</pre>

Ensure configuration is correct by completing the above instructions.

<ul>
    <li>Add flag entry to /etc/rc.conf.local:sendmail_flags="-bd" 
    <li>Add flag entry to /etc/rc.conf.local:syslogd_flags="-a /var/spool/postfix/dev/log"
    <li>Restart syslogd: kill -HUP `cat /var/run/syslog.pid`
    <li>Modify root's crontab, and remove  "sendmail clientmqueue runner"
</ul>

####  <a name="2.4MinimumMandatory"></a>3. Minimal Configuration

[ref: <a href="http://www.postfix.org/INSTALL.html#mandatory">
Mandatory</a> ]

File Fragment: /etc/postfix/main.cf

<pre class="command-line">
myhostname = myhost.example.org 
mydomain = example.org
myorigin = $mydomain
alias_database = hash:/etc/postfix/aliases
smtpd_banner = $myhostname ESMTP $mail_name
parent_domain_matches_subdomains =
</pre>

Notes:

Use _mynetworks_ to set your network. If you don't know 
how to make this setting, you can leave it and postfix will automatically set 
the known ip addresses on your servers configuration.

[Parent domain matches sub-domains](
http://www.postfix.org/postconf.5.html#parent\_domain\_matches\_subdomains)

<pre class="screen-output">
<strong>parent_domain_matches_subdomains</strong> 
(default: see 'postconf -d' output)
What Postfix features match subdomains of 'domain.tld' automatically, instead of 
requiring an explicit '.domain.tld' pattern. This is planned backwards 
compatibility: eventually, all Postfix features are expected to require explicit 
'.domain.tld' style patterns when you really want to match subdomains. </pre>

After making the above changes, we need to rebuild the 'hash' files with the 
following commands.

<pre class="command-line">
# /usr/local/sbin/postalias /etc/aliases
# /usr/local/sbin/newaliases</pre>


Likewise, we need to run the above commands after changes to related files 
(for example: /etc/aliases or /etc/postfix/aliases)

After postfix has been started, you can then use 

<pre class="command-line">
postconf | grep mynetworks
</pre>

as a basis for fine-tuning your configuration.

<a name="2.5EnableAutomaticStartup"></a>

####  4. Enable automatic startup on System Restart

To enable Postfix to start with each system start, we make the following edits 
to the startup configuration file: /etc/rc.conf.local

-   add '-a /var/spool/postfix/dev/log' to syslogd_flags
-   add '-bd' to Sendmail_flags.

You should have something like the following in your /etc/rc.conf.local

[ File: /etc/rc.conf.local ]

<pre class="command-line">
syslogd_flags='-a /var/spool/postfix/dev/log'
sendmail_flags='-bd'
</pre>

Explaining the '-a /var/spool/postfix/dev/log' (from the man pages)

$!manpage("syslogd",8)!$

<pre class="screen-output"> 
syslogd reads and logs messages to the system console, 
log files, other machines and/or users as specified by its configuration file.

-a path
    Specify a location where syslogd should place an additional log socket. Up to 
    about 20 additional logging sockets can be speci-
    fied. The primary use for this is to place additional log sockets in /dev/log of 
    various chroot filespaces.
</pre>

Explaining Sendmail -bd (from the man pages)

<pre class="screen-output">
Sendmail(8)
-bd     Run as a daemon. Sendmail will fork and run 
    in the background listening on socket 25 for incoming SMTP connections. By 
    default, Sendmail will also listen on socket 587 for RFC 2476 message 
    submission. This is normally run from /etc/rc.
</pre>

    
####  <a name="2.6CompleteDisablingSendmail"></a>5. Complete Disabling Sendmail

To complete the installation of Postfix, and disabling of Sendmail, we need 
to edit root's crontab and disable supplied Sendmail behaviour

-   comment out the Sendmail clientmqueue runner

To be safe, you should just comment out the relevant line, (just in case you 
need or want to go back to Sendmail.) We use 'crontab -e' and add '#' hashes to 
'comment' out the execution of the Sendmail line shown below.

<pre class="command-line">
# crontab -e
</pre>
<pre class="config-file">
#minute hour mday month wday command
#
# Sendmail clientmqueue runner
#*/30 * * * * /usr/sbin/sendmail -L sm-msp-queue -Ac -q
</pre>

#### <a name="2.7VerifyAliasConfiguration"></a>6. Verify alias configuration

Take a look at your /etc/postfix/aliases file which will contain some default 
aliases that you should manage.

<pre class="screen-output">alias_database = hash:/etc/postfix/aliases</pre>

For a basic, test install then there shouldn't be any real need to change 
this file. You should remember when you're ready for a full install then you 
should review this file for aliases such as root, postmaster, webmaster and 
ensure they are routed to the correct 'person.' 

From the file: The program 'newaliases' must be run after this file is 
updated for any changes to show through to Postfix.

<pre class="command-line"> &nbsp;<strong># /usr/local/sbin/newaliases</strong>
</pre>

### <a name="StartingPostfix"></a>Starting Postfix

[ref: $!manpage("postfix",1)!$]

Now, we are ready to make some fundamental tests, so let's start Postfix 
which at this stage is a nice 5 step process.

-   Restart syslogd (using pkill -HUP)
-   Kill existing session of Sendmail (using pkill)
-   Rebuild the alias file (using newaliases)
-   Check files and configuration (using postfix check)
-   Start postfix (using our 'new' Sendmail)


<pre class="command-line">
# pkill -HUP syslogd
# pkill Sendmail
# /usr/local/sbin/newaliases
# /usr/local/sbin/postfix check
# /usr/local/sbin/sendmail -bd -q30m
</pre>
<pre class="screen-output">
<strong>postfix/postfix-script: starting the Postfix mail system</strong>
</pre>


#### <a name="3.1RestartSyslogd"></a>1. Restart syslogd 

We are sending the SIGHUP (hangup) to syslogd,
from the man page.

[$!manpage('syslogd',8)!$]

<pre class="screen-output">
syslogd reads its configuration file when it starts up 
and whenever it receives a hangup signal.
</pre>

#### <a name="3.2KillExistingSessionOfSendmail"></a>2 Kill existing session of Sendmail 

We want to force the Sendmail program to die, from the man page

$!manpage("kill")!$

<pre class="screen-output">
The pkill command searches the process table on the 
running system and signals all processes that match the criteria given on the 
command line.
</pre>

The default signal TERM is sent when no other signal is specified, so we're 
just telling Sendmail to die.

#### <a name="3.3RebuildTheAliasFile"></a>3. Rebuild the alias file

Be careful to specify the full path with these commands. Remember that we 
have not deleted the old files from the original Sendmail installation, so it is 
very important that we use the full path of the programs /usr/local/sbin where 
postfix commands have been installed. If you do&nbsp; not use the full path, 
then we do not know, but you will most likely be running the OpenBSD Sendmail 
installation, which is not what we want here.

<pre class="screen-output">/usr/local/sbin/newaliases
</pre>

#### <a name="3.4CheckFilesAndConfiguration"></a>4. Check files and configuration

[Ref: $!manpage("postconf",1)!$, $!manpage("postfix",1)!$]

Postfix comes with rudimentary testing of file (_using postfix check_) 
and configuration settings(_using postconf_), so 
its a good habit to give it a test run before doing anything else.

The first quick test can be performed using the postfix command

$!manpage("postfix")$!

<pre class="screen-output">The following commands are implemented:
		
<strong>check </strong>Warn about bad directory/file ownership or 
permissions, and create missing directories.
</pre>

Essentially, just run the program and if it doesn't give you error messages, 
then we are one step closer with 'fewer' errors in our setup.

<pre class="command-line"># postfix check</pre>

The second test can be performed using the postconf 'Postfix configuration 
utility' , from the man pages

$!manpage("postconf")!$

<pre class="screen-output">
<strong>-n </strong>Print parameter settings that are not left at 
		their built-in default value, because they are explicitly specified in 
		main.cf.
</pre>
        
This essentially lets us quickly find out any blatant errors. For 
example, an output could look like this.

<pre class="command-line">
<strong># postconf </strong>| grep ^my</pre>

        
<pre class="screen-output">
mydestination = $myhostname, localhost.$mydomain, localhost
mydomain = example.org
myhostname = myhost.example.org
mynetworks = 127.0.0.0/8 public_ip/23 192.168.1.0/24 192.168.2.0/24 [::1]/128 
		...IPV6_Addresses
mynetworks_style = subnet
myorigin = $mydomain
</pre>

A quick perusal of the postconf output should give us an idea if we forgot or 
incorrectly put some information in.

Using 'postconf -n' is a good way to check for typing mistakes that can lead 
to many lost hours due the system being misconfigured and we're still trying to 
solve a problem with the wrong expections because the settings we placed in the 
configuration have not been set because of a typing mistake.

At this point in our install, there has been no serious changes to the configuration files.

#### <a name="3.5StartPostfix"></a>5. Start postfix 

After the above testing, validation, we should be able to start postfix with 
the postfix command, or in our example we will use the 'new' Sendmail command.

<pre class="command-line"># /usr/local/sbin/sendmail -bd -q30m
</pre>

### <a name="TestingTheMailServer"></a>Testing the mail server

[ref: The Network People, Inc. [Mail Server Testing](http://www.tnpi.biz/internet/mail/forge.shtml) ] 

We should now be able to test whether the server's 'face' to the world 
(smtp) is working. 

To simplify testing, we will perform the tests on server itself. Where 
possible/practical, you should also run the tests from an external 
client to verify expected behaviour with an active firewall or other 
systems between your Postfix/SMTP Server and your clients.

This test procedure will only test a few basic commands, writing myself a 
message, my system user account is samt (and you can use any valid user account 
on the system)

#### <a name="4.1telnet"></a>telnet localhost smtp

<p class="ScreenSession">Screen Session</p>


<pre class="command-line"><strong>$ telnet localhost smtp </strong> </pre>

<pre class="screen-output">
		Trying ::1...
Connected to localhost.
Escape character is '^]'.
220 myhost.example.org ESMTP Postfix
</pre>

<pre class="command-line"><strong>EHLO example.org</strong></pre>

<pre class="screen-output">250-myhost.example.org 
250-PIPELINING 
250-SIZE 10240000 
250-VRFY 
250-ETRN 
250-ENHANCEDSTATUSCODES 
250-8BITMIME 
250 DSN </pre>

<pre class="command-line"><strong>MAIL FROM: &lt;samt@example.org&gt;</strong></pre>
<pre class="screen-output">250 2.1.0 Ok </pre>
<pre class="command-line"><strong>RCPT TO: &lt;samt@example.org&gt;</strong></pre>
<pre class="screen-output">250 2.1.5 Ok </pre>
<pre class="command-line">DATA</strong></pre>
<pre class="screen-output">354 Enter mail, end with '.' on a line by itself</pre>
<pre class="command-line">Subject: This is my subject line

I continue writing until I'm out of interesting things to say
which is not that far away

.

</pre>
<pre class="screen-output">
250 2.0.0 Ok: queued as 
699ACBA2D7 </pre>
<pre class="command-line">QUIT</strong></pre>
<pre class="screen-output">
221 2.0.0 Bye 
Connection closed by foreign host. 
</pre>

I've just used capital letters for the SMTP commands, but obviously they work 
fine with lowercase.
If your server is not yet online with a valid DNS record, then you can test 
using RCPT TO: samt@localhost.

#### <a name="4.2MailLog"></a>Mail Log

The corresponding log messages will look something like the below.

<p class="ScreenSession">Screen Session</p>


<pre class="command-line"># tail -f /var/log/maillog</pre>
<pre class="screen-output">
starting the Postfix mail system
daemon started -- version 2.3.2, configuration 
/etc/postfix
connect from localhost[::1]
5E4A5BA2D4: client=localhost[::1]
5E4A5BA2D4: 
message-id=&lt;20061212080251.5E4A5BA2D4@hostname.example.org&gt;
5E4A5BA2D4: from=&lt;samt@example.org&gt;, size=457, nrcpt=1 (queue active)
5E4A5BA2D4: to=&lt;samt@example.org&gt;, relay=local, 
delay=77, delays=77/0.05/0/0.03, dsn=2.0.0, status=sent (delivered to 
mailbox)
5E4A5BA2D4: removed
disconnect from localhost[::1]
</pre>

'tail' is a unix program to look at the recent additions to a file, and in 
our case we're looking at the log file for 'mail' related programs. Using the 
'-f' parameter tells 'tail' to continue looking at the recent additions to the 
file (such that updates to the file are displayed on the screen for us.) Use 
Ctrl+C (i.e. hold the Ctrl key while pressing C) to break out of the log review 
session shown above

#### <a name="4.3mail"></a>mail

[Ref: $!manpage("mail",1)!$]

While we're testing with real system user accounts, we can use the unix 
'mail' program to check our mail message.

<p class="ScreenSession">Screen Session</p>

<pre class="command-line"># /usr/<span class="style1">bin/mail -u samt</pre>
<pre class="screen-output">
Mail version 8.1.2 01/15/2001. Type ? for help.
'/var/mail/samt': 1 message 1 new
&gt;N 1 samt@example.org Tue Dec 12 21:03 18/605 This is my subject line</pre>

<pre class="command-line">
&amp; <strong>more 1</strong></pre>
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
&amp; <strong>q</strong></pre>
<pre class="screen-output">
Saved 1 message in mbox
</pre>

In the above example, we enter mail for the user samt ('-u samt') and the 
'mail' client shows a list of current email for user 'samt' and then gives us 
the '&amp;' ampersand prompt.

We can read the email message by typing the message number, and 'mail' 
supports the use of a screen 'pager' such as 'more' so that we can scroll 
through longer messages.

Quit. We quit out of 'mail' using the 'q' command.

The above reference to the log files and mail client is to provide you with more tools for validating your installation.

#### <a name="4.4Summary"></a>Summary

We now have a fully functional email server that can receive email messages, 
and store those messages for users.

<a name="chroot"></a>

### Postfix chroot files

Postfix's OpenBSD port is built as a privilege separated service, launching minimal server requirements as root
and servicing transactions as a minimally authenticated user.  This requires a few files to be made available 
within the chroot, such as:

- /etc/$!manpage("resolv.conf")!$

$!manpage("resolv.conf")$! contains the DNS server list that postfix will interrogate
when it needs to perform name lookups.

<pre class="command-line">
# cp /etc/resolv.conf /var/spool/postfix/etc
</pre>

If you're mail MTA is slow to respond, and you know from the log files that the server
is up and running, then a 1st diagnostic investigation is to confirm that the 
DNS entries (as seen by postfix, above) are correct.

<a name="customise"></a>

### Customise Postfix for your local install 

Customisations for a Proxy is specified in [Proxy Configuration](postfix/proxy.html)

Customisations for Virtual Accounts is specified in [Virtual Accounts](postfix/virtual.html)

<a name="reference"></a>

### Reference Resources

[Troubleshooting Postfix](http://www.postfix-book.com/debugging.html) 
from the [Book of Postfix](http://www.postfix-book.com/)