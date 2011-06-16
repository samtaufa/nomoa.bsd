## MySQL Database Server

<div class="toc">

Table of Contents:
    
<ul>
    <li><a href="#defaultdb">Default Database</a></li>
    <li><a href="#systemsettings">System Settings</a>
    <ul>
        <li><a href="#library">Library Binaries</a></li>
        <li><a href="#class">Login Class</a></li>
        <li><a href="#password">Admin Password</a></li>
    </ul></li>    
    <li><a href="#test">Tests</a>
    <ul>
        <li>Is it Running?</li>
        <li>Access to the Server<li>
    </ul></li>
    <li><a href="#starting">Starting MySQL</a></li>
    <li><a href="#stopping">Stopping MySQL</a></li>
    <li><a href="#usability">Miscellaneous</a></li>
    <ul>
        <li><a href="#anonymous">Anonymous Users</a></li>
        <li><a href="#apache">Apache Chroot</a></li>
        <li><a href="#mysqlConf">User Configuration</a></li>
        <li><a href="#mysqlScreenEditor">Screen Editor</a></li>
    </ul>
</ul>
    
</div>

&#91;Ref: OpenBSD 4.9 | mysql-server-5.1.54p3.tgz  ]
  
Install the mysql package using pkg_add. The package installation will install 
the mysql binaries

<pre class="command-line">
sudo su
export PKG_PATH=ftp://ftp5.usa.openbsd.org/pub/OpenBSD/4.9/packages/i386
pkg_add mysql-server
</pre>
<pre class="screen-output">
mysql-server-5.1.54p3:p5-Net-Daemon-0.43p0: ok
mysql-server-5.1.54p3:p5-PlRPC-0.2018p1: ok
mysql-server-5.1.54p3:p5-DBI-1.609p1: ok
mysql-server-5.1.54p3:p5-DBD-mysql-4.014p1: ok
mysql-server-5.1.54p3: ok
The following new rcscripts were installed: /etc/rc.d/mysqld
See rc.d(8) for details.
Look in /usr/local/share/doc/pkg-readmes for extra documentation.
</pre>

The package automatically creates the user '\_mysql' (on my system with uid 
502) and group '\_mysql' (gid 502) which are used for running the sql server.

Open up the Package Readme file as directed in the install screen output.

### <a name="defaultdb"></a> Default Database

For the first time installation, create the default database using

<pre class="command-line">
/usr/local/bin/mysql_install_db
</pre>

<pre class="screen-output">
Installing MySQL system tables...
110509 21:26:16 [Warning] '--skip-locking' is deprecated and will be removed in a future release. Please use '--skip-external-locking' instead.
OK
Filling help tables...
110509 21:26:18 [Warning] '--skip-locking' is deprecated and will be removed in a future release. Please use '--skip-external-locking' instead.
OK

PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
To do so, start the server, then issue the following commands:

/usr/local/bin/mysqladmin -u root password 'new-password'
/usr/local/bin/mysqladmin -u root -h hostname.example.com password 'new-password'

Alternatively you can run:
/usr/local/bin/mysql_secure_installation

which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended for production servers.

See the manual for more instructions.

Please report any problems with the /usr/local/bin/mysqlbug script!
</pre>

### <a name="systemsettings"></a> System Settings

The server configuration defaults are built in to the compiled binaries, and
in the configuration file /etc/my.cnf, which can have a user version at 
~/.my.cnf

<pre class="manpage">
# MySQL programs look for option files in a set of
# locations which depend on the deployment platform.
# You can copy this option file to one of those
# locations. For information about these locations, see:
# <a href="http://dev.mysql.com/doc/mysql/en/option-files.html">http://dev.mysql.com/doc/mysql/en/option-files.html</a>
</pre>

Periodically review this file to ensure it fits your requirements.

#### <a name="library"></a>Library Binaries

Somewhere in the life of mysql development, the libraries were moved from /usr/local/lib 
to their own directory /usr/local/lib/mysql. Because of this, we need to specify 
its location for the machine startup routines. We make these changes in 
*rc.conf.local* by modifying the reference to shlib_dirs:

Edit rc.conf.local and add the following line

<pre class="config-file">
shlib_dirs=&quot;$shlib_dirs /usr/local/lib/mysql&quot; # extra directories for ldconfig
</pre>

This will include the library directory to the original 
settings in rc.conf which is usually:

<pre class="config-file">
shlib_dirs=                         # directories for ldconfig
</pre>

#### <a name="class"></a> Login Class

If you plan to have a busy MySQL Server, then you can change the login
class $!manpage("login.conf",5)!$ of the mysqld (MySQL Daemon) user (_mysql) 
from the default "daemon" class,  to one that you can adjust for the 
characteristics of your server.

Update the $!manpage("login.conf",5)!$ to something such as:

<pre class="config-file">
        mysqld:\
            :openfiles-cur=1024:\
            :openfiles-max=2048:\
            :tc=daemon:
</pre>

If you have to make any of the above changes, then make sure you 
rebuild the login.conf.db file with $!manpage("cap_mkdb")!$:

<pre class="command-line">
/usr/bin/cap_mkdb /etc/login.conf
</pre>

Obviously, if you've gone through these steps, you will want to use vipw
to update the user configuration to use the above mysqld login class:

Change:

<pre class="config-file">
_mysql:*************:502:502:daemon:0:0:MySQL Account:/nonexistent:/sbin/nologin
</pre>

To something like:
<pre class="config-file">
_mysql:*************:502:502:mysqld:0:0:MySQL Account:/nonexistent:/sbin/nologin
</pre>

#### <a name="password"></a>Admin Password

<b>Priority 1:</b> Set the root access password for the database, and before 
we can do that we need to temporarily start mysql.

<pre class="command-line">
/usr/local/bin/mysqld_safe &amp;
/usr/local/bin/mysqladmin -u root password mypassword
</pre>

If you already have accounts/users on the system, it is possible that
someone may get your admin password from the command-line. Another method for
changing the password is to log into the mysql client program and create 
the password from in there.

For example, after 'mysqld_safe &amp;' do something like the below. 
(courtesy of <a href="http://www.revunix.tk/">http://www.revunix.tk/</a>)

<pre class="command-line">
/usr/local/bin/mysqld_safe &amp;
</pre>
<pre class="screen-output">
time-stamp mysqld_safe Logging to '/var/mysql/hostname.example.com.err'.
time-stamp mysqld_safe Starting mysqld daemon with databases from /var/mysql
</pre>
/usr/local/bin/mysql -u root
</pre>

<pre class="screen-output">
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.1.54-log OpenBSD port: mysql-server-5.1.54p3

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
</pre>

<pre class="command-line">
mysql&gt; <strong>SET PASSWORD FOR root@localhost=PASSWORD('new_password');</strong>
</pre>

<pre class="screen-output">
Query OK, 0 rows affected (0.05 sec)
</pre>

<pre class="command-line">
mysql&gt; <strong>SET PASSWORD FOR root@hostname.example.com=PASSWORD('new_password');</strong>
</pre>

<pre class="screen-output">
Query OK, 0 rows affected (0.03 sec)
</pre>

<pre class="command-line">
mysql&gt; <strong>SET PASSWORD FOR root@127.0.0.1=PASSWORD('new_password');</strong>
</pre>

<pre class="screen-output">
Query OK, 0 rows affected (0.01 sec)
</pre>

### <a name="test"></a>Tests

Always good to get an idea of whether our process is working, so it's time to
review secondary procedures to validate/confirm that the above instructions
are working correctly and our installation is progressing.

#### Is it Running?

&#91;Ref: $!manpage("fstat",1)!$ ]

We can always use $!manpage("ps")!$ to verify that the **mysqld** daemon
is running, but we want to go a little further than that and ensure that
the service/daemon has launched and is actively waiting for connections.


Verify the server is running by using the 'fstat' in the following example:

<pre class="command-line">
fstat | grep &quot;*:&quot; | grep mysql
</pre>
<pre class="screen-output">
_mysql   mysqld     19623   13* internet stream tcp 0xd6bf57fc *:3306
</pre>

Now we know through fstat that the mysql daemon (mysqld) is running with user 
privileges of _mysql and listening on port 3306. The [ | grep &quot;*:&quot; ] 
filters for processes that have an &quot;internet stream&quot; open. The [ | 
grep mysql ] further filters down to processes with the word mysql on the line.
  
One neat feature of the 'fstat' program is that the &quot;*.nnnnn&quot; 
indicates the port on which the process is listening. 

The displayed line is $!manpage("fstat",1)!$:

<pre class="screen-output">
USER   Command  PID   FD  DOMAIN          Socket_Type  Socket_Flag  Protocol_Numb:Protocol_Address
_mysql mysqld   19623 13* internet stream tcp          0xd6bf57fc   *:3306
</pre>

If the server is not listening for connections, then the diagnostics step
is to use $!manpage("ps")!$ to verify that the binary has been loaded. The
next step from there is to review the mysqld error logs for any messages that
can help you diagnose the problem.

On my hosts, the error log is stored in the file: 

/var/mysql/hostname.domain.tld.err

#### Can we access the server?

After we've confirmed with the above that the server is running and listening
for connections, we access the MySQL database server and look at the 
default database configuration, server maintenance database 'mysql.' 

Log in to the system through mysql interactive interface to the server.

<pre class="command-line">
/usr/local/bin/mysql -u root -p
</pre>

<pre class="screen-output"> 
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.1.54-log OpenBSD port: mysql-server-5.1.54p3

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

</pre>

The mysql&gt; prompt allows sql statements and MySQL commands 
to be entered. Most commands are completed by using the &quot;;&quot; semi-colon 
delimiter.

We check whether the initial database creation was successful 
(mysql, and test.) Use the show databases; command. The MySQL package should 
have successful created the system database 'mysql' and a sample database 'test'.


<pre class="command-line">
mysql> show databases;
</pre>

<pre class="screen-output">
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| test               |
+--------------------+
3 rows in set (0.11 sec)
</pre>

We can check whether the mysql database has been installed by looking at the 
installed tables which should look like the below.

<pre class="command-line">
mysql&gt; <b>use mysql;</b>
</pre>
<pre class="screen-output">
Database changed
</pre>
<pre class="command-line">
mysql> <b>show tables; </b>
</pre>

<pre class="screen-output">
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| host                      |
| ndb_binlog_index          |
| plugin                    |
| proc                      |
| procs_priv                |
| servers                   |
| slow_log                  |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| user                      |
+---------------------------+
23 rows in set (0.03 sec)
</pre>

The user table is the system wide table to record what users are allowed onto 
the system and with what privileges. By using the 'describe' command we can 
see a list of the table fields and data-types. In this table it shows us the 
different levels of privileges available on the MySQL server.

<pre class="command-line">
mysql>  <b>describe  user;</b>
</pre>

<pre class="screen-output">
+-----------------------+-----------------------------------+------+-----+---------+-------+
| Field                 | Type                              | Null | Key | Default | Extra |
+-----------------------+-----------------------------------+------+-----+---------+-------+
| Host                  | char(60)                          | NO   | PRI |         |       |
| User                  | char(16)                          | NO   | PRI |         |       |
| Password              | char(41)                          | NO   |     |         |       |
| Select_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Insert_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Update_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Delete_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Create_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Drop_priv             | enum('N','Y')                     | NO   |     | N       |       |
| Reload_priv           | enum('N','Y')                     | NO   |     | N       |       |
| Shutdown_priv         | enum('N','Y')                     | NO   |     | N       |       |
| Process_priv          | enum('N','Y')                     | NO   |     | N       |       |
| File_priv             | enum('N','Y')                     | NO   |     | N       |       |
| Grant_priv            | enum('N','Y')                     | NO   |     | N       |       |
| References_priv       | enum('N','Y')                     | NO   |     | N       |       |
| Index_priv            | enum('N','Y')                     | NO   |     | N       |       |
| Alter_priv            | enum('N','Y')                     | NO   |     | N       |       |
| Show_db_priv          | enum('N','Y')                     | NO   |     | N       |       |
| Super_priv            | enum('N','Y')                     | NO   |     | N       |       |
| Create_tmp_table_priv | enum('N','Y')                     | NO   |     | N       |       |
| Lock_tables_priv      | enum('N','Y')                     | NO   |     | N       |       |
| Execute_priv          | enum('N','Y')                     | NO   |     | N       |       |
| Repl_slave_priv       | enum('N','Y')                     | NO   |     | N       |       |
| Repl_client_priv      | enum('N','Y')                     | NO   |     | N       |       |
| Create_view_priv      | enum('N','Y')                     | NO   |     | N       |       |
| Show_view_priv        | enum('N','Y')                     | NO   |     | N       |       |
| Create_routine_priv   | enum('N','Y')                     | NO   |     | N       |       |
| Alter_routine_priv    | enum('N','Y')                     | NO   |     | N       |       |
| Create_user_priv      | enum('N','Y')                     | NO   |     | N       |       |
| Event_priv            | enum('N','Y')                     | NO   |     | N       |       |
| Trigger_priv          | enum('N','Y')                     | NO   |     | N       |       |
| ssl_type              | enum('','ANY','X509','SPECIFIED') | NO   |     |         |       |
| ssl_cipher            | blob                              | NO   |     | NULL    |       |
| x509_issuer           | blob                              | NO   |     | NULL    |       |
| x509_subject          | blob                              | NO   |     | NULL    |       |
| max_questions         | int(11) unsigned                  | NO   |     | 0       |       |
| max_updates           | int(11) unsigned                  | NO   |     | 0       |       |
| max_connections       | int(11) unsigned                  | NO   |     | 0       |       |
| max_user_connections  | int(11) unsigned                  | NO   |     | 0       |       |
+-----------------------+-----------------------------------+------+-----+---------+-------+
39 rows in set (0.61 sec)
</pre>

Grabbing a set of information from the user table lets us see who has been 
given access to the system.

<pre class="command-line">
mysql>  <b>select  host,  user,  select_priv,  grant_priv,  password  from  user;</b>
</pre>

<pre class="screen-output">
+----------------------+------+-------------+------------+-------------------------------------------+
| host                 | user | select_priv | grant_priv | password                                  |
+----------------------+------+-------------+------------+-------------------------------------------+
| localhost            | root | Y           | Y          | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| hostname.example.com | root | Y           | Y          | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| 127.0.0.1            | root | Y           | Y          | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| localhost            |      | N           | N          |                                           |
| hostname.example.com |      | N           | N          |                                           |
+----------------------+------+-------------+------------+-------------------------------------------+
</pre>

Anonymous (blank user) and root have accounts on the system.

<pre class="command-line">mysql&gt; <b>quit</b>
</pre>

### <a name="starting"></a>Starting MySQL

The documentation recommends using the supplied launcher mysqld\_safe for starting
the MySQL Daemon/Service. A simplified manner, in OpenBSD, is to use the package
supplied $!manpage("rc.d")!$ script /etc/rc.d/mysqld

<pre class="command-line">
/etc/rc.d/mysqld start
</pre>

To configure OpenBSD to automatically start mysql with every system start-up 
then you can edit the rc.conf.local file.

Edit: /etc/rc.conf.local and edit the macro rc_scripts to have something like the below:

<pre class="screen-output">
mysqld_flags=
rc_scripts="mysqld"
</pre>

Now each restart of the machine will start MySQL using the supplied rc.d
script
  
Once you have the startup script working you can set command-line options
by changing the mysqld_flags to be something like the following:

<pre class="screen-output">
mysqld_flags="--log --open-files-limit=256"
</pre>

Note: The $!manpage("rc.d",8)!$ script /etc/rc.d/mysqld uses mysqld\_safe as 
the launching tool. Parameters relevant to mysqld\_safe can be aplied to
mysqld\_flags.

### <a name="stopping"></a> Stopping MySQL

To stop the MySQL server, a standard approach is to use the mysqladmin program 
as shown below:
  
<pre class="command-line">
# /usr/local/bin/mysqladmin shutdown -p
</pre>

Of course you need mysql administrator privileges for shutting the service
down.

As root, you can use /etc/rc.d/mysqld to pkill the daemons.

<pre class="command-line">
/etc/rc.d/mysqld stop
</pre>

### <a name="usability"></a>Miscellaneous
 
#### Anonymous Users

The MySQL default install configures anonymous login from localhost with 
its default installation, you can remove anonymous access by 
using commands similar to that shown below:
  
<pre class="command-line">
/usr/local/bin/mysql -u root -p </b>
</pre>

<pre class="screen-output">
Enter password: <b>mypassword </b>&lt;-- 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.1.54-log OpenBSD port: mysql-server-5.1.54p3
</pre>

<pre class="command-line">
>mysql &gt; <b>use mysql</b>
</pre>

<pre class="command-line">
mysql> select user, password from user;
</pre>
<pre class="screen-output">
+------+-------------------------------------------+
| user | password                                  |
+------+-------------------------------------------+
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
|      |                                           |
|      |                                           |
+------+-------------------------------------------+
</pre>

<pre class="command-line">
mysql &gt; <b>delete from user where user = "";</b> 
</pre>

<pre class="screen-output">
Query OK, 2 rows affected (0.08 sec) 
</pre>

<pre class="command-line">
mysql> select user, password from user;
</pre>
<pre class="screen-output">
+------+-------------------------------------------+
| user | password                                  |
+------+-------------------------------------------+
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
| root | *AAA8DC73940D53C0532945C34AFAC74A1349A8B8 |
+------+-------------------------------------------+
</pre>

#### <a name="apache"></a>Apache Chroot

A consistent installation configuration for my MySQL, is as
a database backend for a web service, preferably hosted in
the default/standard chroot environment for apache.

Key aspects of this chroot environment are:

- Socket files need to be in chroot environment
- Path permissions need to be accessible

<pre class="command-line">
mkdir -p /var/www/var/run/mysql
chown _mysql:_mysql /var/www/var/run/mysql
</pre>

Adust /etc/my.cnf to put the mysql socket in the chroot.

<pre class="config-file">
[client]
socket = /var/www/var/run/mysql/mysql.sock

[mysqld]
socket = /var/www/var/run/mysql/mysql.sock
</pre>

#### <a name="mysqlConf"></a>User Configuration

mysql will search for user configurations in a file called ~/.my.cnf which 
has a simple format to let you specify settings we have been forced to manually 
type with each invocation (start) of msyql.

~/.my.cnf have the below settings which are user configurable.

<pre class="config-file">
[client]
      host=
      user=
      password=
      socket=
      
[mysqld]
      socket=
</pre>

#### <a name="mysqlScreenEditor"></a>Screen Editor

In Unix, the mysql command line supports using a screen editor for modifying 
and creating queries. The 'edit' command in the MySQL command line calss the 
text editor of your choice (typically set with the EDITOR environment variable, 
probably vi on your OpenBSD.)

<pre class="command-line">
mysql&gt; <font color="#0000FF"><b>edit</b></font>
</pre>

If you make a mistake in keying in a command, then you can use the up-arrow 
to review your command, or you can type in edit to re-enter. edit remembers 
the previous command string you typed, so it is especially useful getting those 
large queries working.