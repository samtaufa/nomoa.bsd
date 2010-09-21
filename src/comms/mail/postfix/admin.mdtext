
##  GUI Admin for Postfix, MySQL

<div class="toc">
    
    Table of Contents: 
    
    <ul>
        <li><a href="#install">C<span class="style1">onfiguring MySQL</span></a></li>
        <ul><li><a href="#2.1Creating the Database">Creating the Database</li></a>
        <ul><li><a href="#2.1.1ModifyingDatabase">Modifying the Database and MySQL users</a></li>
            <li><a href="#2.1.2ModifyingSuperadmin">Modifying the superadmin account</a></li></ul>
            <li><a href="#2.2CreateTheDatabase">Create the Database</a></li>
        <li><a href="#2.3DatabaseErrors">Database Errors</a></li>
        <li><a href="#2.4Summary">Summary</a></li></ul>
        <li><a href="#3ConfiguringFiles">Configuring Files</a>
        <ul>
            <li><a href="#3.1ChangingFilePermissions">Changing File Permissions</a></li>
            <li><a href="#3.2ChangingConfig.inc.php">Changing config.inc.php</a></li>
        </ul></li>
        <li><a href="#4ConfiguringPostfix">Configuring Postfix</a></li>
        <li><a href="#4StartOurEngines">Start our Engines</a></li>
        <li><a href="#5DATABASE_MYSQL.TXT">DATABASE_MYSQL.TXT</a></li>
        <li><a href="#7ReferenceResources">Reference Resources</a></li>
        <li><a href="#author">Author and Copyright</a></li>
    </ul>
</div>

[OpenBSD 4.0, postfixadmin 2.1.0]

[Postfixadmin](http://postfixadmin.sourceforge.net) is a web front end for 
managing a MySQL database, that is normally configured for use by your postfix 
installation.

This guide was tested on OpenBSD 4.0 release with postfixadmin 2.1.0
[postfix](../postfix.html) 2.3.2 and [dovecot](dovecot.htm) 
1.0rc15</a> and [mysql]() 5.024a. Check with the release you are using whether you have the minimal 
software requirements before continuing.

If you have not already done so, please install and verify your
<a href="mysql.htm">mysql</a> configuration with php support.

You can download [postfixadmin](http://postfixadmin.sourceforge.net) from 
[Sourceforge](http://postfixadmin.sourceforge.net) or grab the current source 
using svn, instructions at [http://postfixadmin.sourceforge.net](http://postfixadmin.sourceforge.net). 
If you can follow through the INSTALL.TXT file, go ahead and install from there. Otherwise, read that file 
first before continuing further.

For our purposes, we will assume that you have already unarchived the 
postfixadmin files available in the 
/var/www/htdocs/postfixadmin directory.

### <a name="2ConfiguringMySQL"></a>Configuring MySQL

Postfixadmin's installation instruction are in the INSTALL file.

The simplest way to configure your mysql server is to use the 
following DB configuration file.

The DB configuration is based on SVN release 2010.08.25 and may
differ from your version of Postfixadmin.

#### <a name="2.1Creating the Database"></a>Creating the Database

Obviously, the current release of postfixadmin is most likely to have the 
latest configuration of the database. For MySQL, the current schema is in the 
file DATABASE_MYSQL.TXT.

There are two basic changes I want to make for how I have installed 
postfixadmin:

-   Modify the database and mysql user names
-   Modify the superadmin user

You may not want to make the changes as I have made them, but may use this as 
the foundation for ensuring your set up is customised for your needs.

In our installation, I have decided to use different user account name for 
the postfix server, and a different database name. The standard release uses the 
database 'postfix' and a user account 'postfix' which I found confusing, so I've 
renamed the postfix user account to be 'postfixserver' and the database name 
will be 'mail.'

What we want to do is use the same installation files as postfixadmin with 
the following modifications.

-   Replace 'postfix' user to be 'postfixserver'
-   Replace 'postfix' database to be 'mail'

The major changes we will want to make is shown in the following file 
fragment that begins at around line 25.

File Fragment: ./DATABASE_MYSQL.TXT

<table style="width: 86%" class="Screen">
	<tr>
		<td style="height: 23px; width: 32px">25</td>
		<td style="height: 23px">#</td>
	</tr>
	<tr>
		<td style="width: 32px">26</td>
		<td># Postfix / MySQL</td>
	</tr>
	<tr>
		<td style="width: 32px">27</td>
		<td>#</td>
	</tr>
	<tr>
		<td style="width: 32px">28</td>
		<td>USE mysql;</td>
	</tr>
	<tr>
		<td style="width: 32px">29</td>
		<td># Postfix user &amp; password</td>
	</tr>
	<tr>
		<td style="width: 32px">30</td>
		<td>INSERT INTO user (Host, User, Password) VALUES ('localhost','postfix',password('postfix'));</td>
	</tr>
	<tr>
		<td style="width: 32px">31</td>
		<td>INSERT INTO db (Host, Db, User, Select_priv) VALUES ('localhost','postfix','postfix','Y');</td>
	</tr>
	<tr>
		<td style="width: 32px">32</td>
		<td># Postfix Admin user &amp; password</td>
	</tr>
	<tr>
		<td style="width: 32px">33</td>
		<td>INSERT INTO user (Host, User, Password) VALUES ('localhost','postfixadmin',password('postfixadmin'));</td>
	</tr>
	<tr>
		<td style="width: 32px">34</td>
		<td>INSERT INTO db (Host, Db, User, Select_priv, Insert_priv, 
		Update_priv, Delete_priv) VALUES ('localhost','postfix', 'postfixadmin', 
		'Y', 'Y', 'Y', 'Y');</td>
	</tr>
	<tr>
		<td style="width: 32px">35</td>
		<td>FLUSH PRIVILEGES;</td>
	</tr>
	<tr>
		<td style="width: 32px">36</td>
		<td>GRANT USAGE ON postfix.* TO postfix@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">37</td>
		<td>GRANT SELECT, INSERT, DELETE, UPDATE ON postfix.* TO 
		postfix@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">38</td>
		<td>GRANT USAGE ON postfix.* TO postfixadmin@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">39</td>
		<td>GRANT SELECT, INSERT, DELETE, UPDATE ON postfix.* TO 
		postfixadmin@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">40</td>
		<td>CREATE DATABASE postfix;</td>
	</tr>
	<tr>
		<td style="width: 32px">41</td>
		<td>USE postfix;</td>
	</tr>
</table>

After we make changes to the above file, we should have something like the 
below, with the changes highlighted in blue

Updated File Fragment: ./DATABASE_MYSQL.TXT

<table style="width: 86%" class="Screen">
	<tr>
		<td style="height: 23px; width: 32px">25</td>
		<td style="height: 23px">#</td>
	</tr>
	<tr>
		<td style="width: 32px">26</td>
		<td># Postfix / MySQL</td>
	</tr>
	<tr>
		<td style="width: 32px">27</td>
		<td>#</td>
	</tr>
	<tr>
		<td style="width: 32px">28</td>
		<td>USE mysql;</td>
	</tr>
	<tr>
		<td style="width: 32px">29</td>
		<td># Postfix user &amp; password</td>
	</tr>
	<tr>
		<td style="width: 32px">30</td>
		<td>INSERT INTO user (Host, User, Password) VALUES ('localhost','<span class="emphasis"><strong>postfixserver</strong></span>',password('<span class="emphasis"><strong>postfixserver</strong></span>'));</td>
	</tr>
	<tr>
		<td style="width: 32px">31</td>
		<td>INSERT INTO db (Host, Db, User, Select_priv) VALUES ('localhost','<span class="emphasis"><strong>mail</strong></span>','<span class="emphasis"><strong>postfixserver</strong></span>','Y');</td>
	</tr>
	<tr>
		<td style="width: 32px">32</td>
		<td># Postfix Admin user &amp; password</td>
	</tr>
	<tr>
		<td style="width: 32px">33</td>
		<td>INSERT INTO user (Host, User, Password) VALUES ('localhost','postfixadmin',password('<span class="emphasis">postfixadmin</span>'));</td>
	</tr>
	<tr>
		<td style="width: 32px">34</td>
		<td>INSERT INTO db (Host, Db, User, Select_priv, Insert_priv, 
		Update_priv, Delete_priv) VALUES ('localhost','<span class="emphasis"><strong>mail</strong></span>', 
		'postfixadmin', 'Y', 'Y', 'Y', 'Y');</td>
	</tr>
	<tr>
		<td style="width: 32px">35</td>
		<td>FLUSH PRIVILEGES;</td>
	</tr>
	<tr>
		<td style="width: 32px">36</td>
		<td>GRANT USAGE ON <span class="emphasis">mail</span>.* TO
		<span class="emphasis">postfixserver</span>@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">37</td>
		<td>GRANT SELECT, INSERT, DELETE, UPDATE ON <span class="emphasis">mail</span>.* TO postfixserver@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">38</td>
		<td>GRANT USAGE ON <span class="emphasis">mail</span>.* TO postfixadmin@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">39</td>
		<td>GRANT SELECT, INSERT, DELETE, UPDATE ON <span class="emphasis">mail</span>.* TO postfixadmin@localhost;</td>
	</tr>
	<tr>
		<td style="width: 32px">40</td>
		<td>CREATE DATABASE <span class="emphasis">mail</span>;</td>
	</tr>
	<tr>
		<td style="width: 32px">41</td>
		<td>USE <span class="emphasis">mail</span>;</td>
	</tr>
</table>

Details of the changes we want to make are as follows:

<ul>
	<li>Line 30: Replace the user 'postfix' with 'postfixserver', and remember 
	that the password 'postfixserver' should be something unique to your 
	installation.</li>
	<li>Line 31: Replace the Db 'postfix' with 'mail' and the User 'postfix' to 
	be 'postfixserver'</li>
	<li>Line 33: Replace the password for 'postfixadmin' with something unique 
	for your installation.</li>
	<li>Line 34: Replace the Db 'postfix' with 'mail'</li>
	<li>Line 36: Replace&nbsp; postfix.* with mail.* and replace 
	postfix@localhost with <a href="mailto:postfixserver@localhost">
	postfixserver@localhost</a> </li>
	<li>Line 37: Replace postfix.* with mail.*</li>
	<li>Line 38: Replace postfix.* with mail.*</li>
	<li>Line 39: Replace postfix.* with mail.*</li>
	<li>Line 40: Replace postfix; with mail;</li>
	<li>Line 41: Replace postfix; with mail;</li>
</ul>


##### <a name="2.1.2ModifyingSuperadmin"></a>Modifying superadmin account

The default superadmin user account can be somewhat confusing as you are 
literally requested to enter 'admin@domain.tld' as the user account. This 
aesthetic change is to use 'admin' and allow setting the default password.

File Fragment: ./DATABASE_MYSQL.TXT

<table style="width: 86%" class="Screen">
	<tr>
		<td style="height: 23px; width: 32px">145</td>
		<td style="height: 23px"># superadmin user &amp; password (login: 
		admin@domain.tld, password: admin)</td>
	</tr>
	<tr>
		<td style="width: 32px">146</td>
		<td>INSERT INTO domain_admins (username, domain, active) VALUES ('admin@domain.tld','ALL','1');</td>
	</tr>
	<tr>
		<td style="width: 32px">147</td>
		<td>INSERT INTO admin (username, password, active) VALUES 
		('admin@domain.tld','$1$0fec9189$bgI6ncWrldPOsXnkUBIjl1','1');</td>
	</tr>
	</table>

We will change the default to something like the below

Updated File Fragment: ./DATABASE_MYSQL.TXT

<table style="width: 86%" class="Screen">
	<tr>
		<td style="height: 23px; width: 32px">145</td>
		<td style="height: 23px"># superadmin user &amp; password (login: 
		admin@domain.tld, password: admin)</td>
	</tr>
	<tr>
		<td style="width: 32px">146</td>
		<td>INSERT INTO domain_admins (username, domain, active) VALUES ('<span class="emphasis">admin</span>','ALL','1');</td>
	</tr>
	<tr>
		<td style="width: 32px">147</td>
		<td>INSERT INTO admin (username, password, active) VALUES ('<span class="emphasis">admin</span>','<span class="emphasis">6dwLx9NTxhTjU</span>','1');</td>
	</tr>
	</table>
<p>Details of the changes we want to make are as follows:
<ul>
	<li>Line 146: Replace 'admin@domain.tld' with 'admin'</li>
	<li>Line 147: Replace 'admin@domain.tld' with 'admin'. Replace password with 
	new password.</li>
</ul>

#### <a name="2.2CreateTheDatabase"></a>Create the Database

Now that we've completed the modifications to our database instructions, we 
can create our database with the following instructions.
<pre class="command-line"># mysql -u root -p &lt; ./DATABASE_MYSQL.TXT
</pre>

#### <a name="2.3DatabaseErrors"></a>Database Errors

You should not get any error messages, and if you do you may need to check 
the file changes above for any syntax errors.

Otherwise, copy the DATABASE_MYSQL.TXT shown later in this documentation, and 
recreate the database after executing the below mysql commands to clear out your 
previous installation. 

Note: You may inadvertently destroy something on your server, so only perform 
these on a test server unless you know what you are doing.

To remove the previous, or any part of the previous database instructions 
that may have been added to the database server:

<ul>
	<li>drop/delete the database mail and or postfix</li>
	<li>delete user postfix</li>
	<li>delete user postfixadmin</li>
	<li>delete user postfixserver</li>
	<li>delete database privileges (db) for postfix</li>
	<li>delete database privileges (db) for postfixadmin</li>
	<li>delete database privileges (db) for postfixserver</li>
	<li>flush the privileges</li>
</ul>
<p class="ScreenSession">Screen Session
<pre class="command-line">$ mysql -u root -p
</pre>
<pre class="screen-output">Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 25 to server version: 5.0.24a-log

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

</pre>
<pre class="command-line">mysql&gt; drop database mail;
</pre>
<pre class="screen-output">Query OK, 7 rows affected (0.05 sec)
</pre>
<pre class="command-line">mysql&gt; drop database postfix;
</pre>
<pre class="screen-output">ERROR 1008 (HY000): Can't drop database 'postfix'; 
database doesn't exist
</pre>
<pre class="command-line">mysql&gt; use mysql;
</pre>
<pre class="screen-output">Database changed
</pre>
<pre class="command-line">mysql&gt; delete from user where user='postfix';
</pre>
<pre class="screen-output">Query OK, 0 rows affected (0.00 sec)
</pre>
<pre class="command-line">mysql&gt; delete from user where user='postfixadmin';
</pre>
<pre class="screen-output">Query OK, 1 row affected (0.00 sec)
</pre>
<pre class="command-line">mysql&gt; delete from user where user='postfixserver';
</pre>
<pre class="screen-output">Query OK, 1 row affected (0.00 sec)
</pre>
<pre class="command-line">mysql&gt; delete from db where user='postfix';
</pre>
<pre class="screen-output">Query OK, 0 rows affected (0.01 sec)
</pre>
<pre class="command-line">mysql&gt; delete from db where user='postfixserver';
</pre>
<pre class="screen-output">Query OK, 1 row affected (0.00 sec)
</pre>
<pre class="command-line">mysql&gt; delete from db where user='postfixadmin';
</pre>
<pre class="screen-output">Query OK, 1 row affected (0.00 sec)
</pre>
<pre class="command-line">mysql&gt; flush privileges;
</pre>

Remember that if you've changed the user names, then you need to remember to 
use those changes in the above instructions.

#### <a name="2.4Summary"></a>Summary

Your database should now be appropriately created for use with
<a href="postfix.htm">postfix</a> and postfixadmin.

### <a name="3ConfiguringFiles"></a>Configuring Files

There are two main changes you need to make with the files that are 
distributed with postfixadmin.

<ul>
	<li>Set the correct permissions</li>
	<li>Change config.inc.php</li>
</ul>

#### <a name="3.1ChangingFilePermissions"></a>Changing File permissions

For security reasons, we will set the permissions for files in the 
postfixadmin directory. We can use a combination of the 'find' and 'chmod' 
programs to quickly achieve this
<pre class="command-line"># cd /var/www/htdocs/postfixadmin
</pre>
<pre class="command-line"># find . -type f -exec chmod 640 &quot;{}&quot; &quot;;&quot;
</pre>

If you observe some file permission problems after the above settings, then 
you may need to take a look at whether you also need to change the ownership of 
the files, as in the example below.

<pre class="command-line"># find . -exec chown www:www &quot;{}&quot; &quot;;&quot;
</pre>

#### <a name="3.2ChangingConfig.inc.php"></a>Changing config.inc.php

postfixadmin's runtime behaviour is effected by initialisation settings in 
the config.inc.php file. Mostly, the changes are relevant to the users and 
passwords you've set in the above Database creation exercise, as well as issues 
relevant to your installation.
Things that I changed include:
<p class="pFileReference">File Fragment: 
/var/www/htdocs/postfixadmin/config.inc.php

<pre class="command-line">
$CONF['postfix_admin_url'] = 'http://PRIVATE_IP/postfixadmin/';
$CONF['postfix_admin_path'] = '/admin/';
$CONF['database_host'] = '127.0.0.1';
$CONF['database_name'] = 'mail';
$CONF['admin_email'] = 'postmaster@example.org';
$CONF['smtp_server'] = '127.0.0.1';
$CONF['encrypt'] = 'system';
&nbsp;$CONF['default_aliases'] = array (
&nbsp;'abuse' =&gt; 'abuse@example.org',
&nbsp;'hostmaster' =&gt; 'hostmaster@example.org',
&nbsp;'postmaster' =&gt; 'postmaster@example.org',
&nbsp;'webmaster' =&gt; 'webmaster@example.org'
);
$CONF['domain_path'] = 'YES';
$CONF['vacation_domain'] = 'autoreply.example.org';
$CONF['footer_text'] = 'Return to MYHOST';
$CONF['footer_link'] = 'http://PRIVATE_IP';
</pre>

### <a name="4ConfiguringPostfix"></a>Configuring Postfix

Documentation for <a href="postfix.htm#6.4ConfiguringPostfix">configuring 
Postfix</a> for use with this MySQL database, is described at
<a href="postfix.htm#6.4ConfiguringPostfix">this link</a>.

### <a name="4StartOurEngines"></a>Start our Engines

Your postfixadmin installation should be installed and ready.

To start, open your browser to the url you specified in your configuration 
file, like:
<pre class="command-line">$ lynx http://PRIVATE_IP/postfixadmin/
</pre>

You can now use user 'admin' with password 'admin' for managing your virtual 
domains, or if you have changed the password in the above instructions, use that 
password.

### <a name="5DATABASE_MYSQL.TXT"></a>DATABASE_MYSQL.TXT

Following is the modified DATABASE_MYSQL.TXT discussed above.

<p class="pFileReference">File: ./DATABASE_MYSQL.TXT
<pre class="screen-output">#
# Postfix Admin
# by Mischa Peters &lt;mischa at high5 dot net&gt;
# Copyright (c) 2002 - 2005 High5!
# Licensed under GPL for more info check GPL-LICENSE.TXT
# 
# This is the complete MySQL database structure for Postfix Admin.
# If you are installing from scratch you can use this file otherwise you
# need to use the TABLE_CHANGES.TXT or TABLE_BACKUP_MX.TXT that comes with 
Postfix Admin.
# You can find these in DOCUMENTS/ 
#
# There are 2 entries for a database user in the file.
# One you can use for Postfix and one for Postfix Admin.
#
# If you run this file twice (2x) you will get an error on the user creation in 
MySQL.
# To go around this you can either comment the lines below &quot;USE MySQL&quot; until 
&quot;USE postfix&quot;.
# Or you can remove the users from the database and run it again.
#
# You can create the database from the shell with:
#
# mysql -u root [-p] &lt; DATABASE_MYSQL.TXT 
#
# Postfix / MySQL
#
USE mysql;
# Postfix user &amp; password
INSERT INTO user (Host, User, Password) VALUES ('localhost','postfixserver',password('postfixserver'));
INSERT INTO db (Host, Db, User, Select_priv) VALUES ('localhost','mail','postfixserver','Y');
# Postfix Admin user &amp; password
INSERT INTO user (Host, User, Password) VALUES ('localhost','postfixadmin',password('postfixadmin'));
INSERT INTO db (Host, Db, User, Select_priv, Insert_priv, Update_priv, 
Delete_priv) VALUES ('localhost', 'mail', 'postfixadmin', 'Y', 'Y', 'Y', 'Y');
FLUSH PRIVILEGES;
GRANT USAGE ON mail.* TO postfixserver@localhost;
GRANT SELECT, INSERT, DELETE, UPDATE ON mail.* TO postfixserver@localhost;
GRANT USAGE ON mail.* TO postfixadmin@localhost;
GRANT SELECT, INSERT, DELETE, UPDATE ON mail.* TO postfixadmin@localhost;
CREATE DATABASE mail;
USE mail;
#
# Table structure for table admin
#
CREATE TABLE `admin` (
`username` varchar(255) NOT NULL default '',
`password` varchar(255) NOT NULL default '',
`created` datetime NOT NULL default '0000-00-00 00:00:00',
`modified` datetime NOT NULL default '0000-00-00 00:00:00',
`active` tinyint(1) NOT NULL default '1',
PRIMARY KEY (`username`),
KEY username (`username`)
) TYPE=MyISAM COMMENT='Postfix Admin - Virtual Admins'; 
#
# Table structure for table alias
#
CREATE TABLE `alias` (
`address` varchar(255) NOT NULL default '',
`goto` text NOT NULL,
`domain` varchar(255) NOT NULL default '',
`created` datetime NOT NULL default '0000-00-00 00:00:00',
`modified` datetime NOT NULL default '0000-00-00 00:00:00',
`active` tinyint(1) NOT NULL default '1',
PRIMARY KEY (`address`),
KEY address (`address`)
) TYPE=MyISAM COMMENT='Postfix Admin - Virtual Aliases'; 
#
# Table structure for table domain
#
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
#
# Table structure for table domain_admins
#
CREATE TABLE `domain_admins` (
`username` varchar(255) NOT NULL default '',
`domain` varchar(255) NOT NULL default '',
`created` datetime NOT NULL default '0000-00-00 00:00:00',
`active` tinyint(1) NOT NULL default '1',
KEY username (`username`)
) TYPE=MyISAM COMMENT='Postfix Admin - Domain Admins'; 
#
# Table structure for table log
#
CREATE TABLE `log` (
`timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
`username` varchar(255) NOT NULL default '',
`domain` varchar(255) NOT NULL default '',
`action` varchar(255) NOT NULL default '',
`data` varchar(255) NOT NULL default '',
KEY timestamp (`timestamp`)
) TYPE=MyISAM COMMENT='Postfix Admin - Log'; 
#
# Table structure for table mailbox
#
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
) TYPE=MyISAM COMMENT='Postfix Admin - Virtual Mailboxes'; 
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
) TYPE=MyISAM COMMENT='Postfix Admin - Virtual Vacation'; 
# superadmin user &amp; password (login: admin@domain.tld, password: admin)
INSERT INTO domain_admins (username, domain, active) VALUES ('admin','ALL','1');
INSERT INTO admin (username, password, active) VALUES 
('admin','6dwLx9NTxhTjU','1');
</pre>