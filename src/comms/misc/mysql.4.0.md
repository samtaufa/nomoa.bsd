## MySQL Database Server

<div class="toc">

    <p>Table of Contents: </p>
    
    <ul>
      <li><a href="#mysql">Installing</a></li>
      <ul>
        <li><a href="#library">Setting the Library Configuration</a></li>
        <li><a href="#password">Setting the Password</a></li>
      </ul>
      <li><a href="#testing">Testing the Installation</a></li>
      <li><a href="#starting">Starting MySQL</a></li>
      <li><a href="#stopping">Stopping MySQL</a></li>
      <li><a href="#usability">Usability Assistance Tip</a></li>
      <ul>
        <li><a href="#mysqlConf">User Configuration Files</a></li>
        <li><a href="#mysqlScreenEditor">Screen Editor in mysql</a></li>
      </ul>
      <li>Troubleshooting</li>
      <li><a href="#ref">Related Reference</a></li>
      <li><a href="#author">Author and Copyright</a></li>
    </ul>
    
</div>

&#91;Ref: OpenBSD 3.5Beta | mysql-server-4.0.18.tgz | Paul Dubois, MySQL, (Indiana, New Riders, 2000) ]
  
Install the mysql package using pkg\_add. The package installation will install 
the mysql binaries and create the default database by executing mysql\_install\_db. 
This includes initialising the data directory (--datadir=/var/mysql,) and Grant 
Tables for the 'root' user. The datadir is where the system-wide databases will 
be located. The Grant Tables is specify access privileges available. Together 
with creating the database directories/files the package will also chown/chmod 
the directories. Install the package with the standard method shown below:

<pre class="command-line">
sudo su
export PKG_PATH=ftp://ftp5.usa.openbsd.org/pub/OpenBSD/4.7/packages/i386
pkg_add mysql-server
</pre>

The package automatically creates the user '_mysql' (on my system with uid 
502) and group '_mysql' (gid 502) which are used for running the sql server.
  
#### <a name="library"></a>Setting the Library Configuration

Somewhere in the life of mysql development, the libraries were moved from /usr/local/lib 
to their own directory /usr/local/lib/mysql. Because of this, we need to specify 
its location for the machine startup routines. We make these changes in <a href="rc.conf.htm">rc.conf.local</a> 
by modifying the reference to shlib_dirs:

Edit rc.conf.local and add the following line

<pre class="config-file">
shlib_dirs=&quot;$shlib_dirs /usr/local/lib/mysql&quot; # extra directories for ldconfig
</pre>

This will include the library directory to the original 
settings in rc.conf which is usually:

<pre class="config-file">
shlib_dirs=                         # directories for ldconfig
</pre>

#### <a name="password"></a>Setting the Password

<b>Priority 1:</b> Set the root access password for the database, and before 
we can do that we need to temporarily start mysql.

<pre class="command-line">
/usr/local/bin/mysqld_safe &amp;
/usr/local/bin/mysqladmin -u root password mypassword
</pre>

If you already have accounts/users on the system then a more secure way of changing the password is to log into the mysql client program and create the password from in there.

For example, after 'mysqld_safe &amp;' do something like the below. (courtesy of <a href="http://www.revunix.tk/">http://www.revunix.tk/</a>)

<pre class="command-line">
/usr/local/bin/mysqld_safe &amp;
/usr/local/bin/mysql -u root
</pre>

<pre class="screen-output">
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 1 to server version: 4.0.20-log
Type 'help;' or '\h' for help. Type '\c' to clear the buffer.    
</pre>

<pre class="command-line">
mysql&gt; <strong>SET PASSWORD FOR root@localhost=PASSWORD('new_password');</strong>
</pre>

<pre class="screen-output">
Query OK, 0 rows affected (0.07 sec)
</pre>

### <a name="testing"></a>Testing the installation.

#### Is it Running?

&#91;Ref: fstat(1) ]
<p>Verify the server is running by using the 'fstat' in the following example:</p>

<pre class="command-line">
fstat | grep &quot;*:&quot; | grep mysql
</pre>
<pre class="screen-output"> 
_mysql mysqld 22190 5* internet stream tcp 0xd0bc25a4 *:3306
</pre>

Now we know through fstat that the mysql daemon (mysqld) is running with user 
privileges of _mysql and listening on port 3306. The [ | grep &quot;*:&quot; ] 
filters for processes that have an &quot;internet stream&quot; open. The [ | 
grep mysql ] further filters down to processes with the word mysql on the line.
  
One neat feature of the 'fstat' program is that the &quot;*.nnnnn&quot; 
indicates the port on which the processes is listening. 

The displayed line is fstat(1):

<pre class="screen-output">
USER     Command PID       FD DOMAIN      Socket_Type  Socket_Flag   Protocol_Numb:Protocol_Address
_mysql mysqld   22190   5* internet stream tcp   0xd0bc25a4     *:3306
</pre>

#### Can we access the server?

Our first test for validating the installation is to access the MySQL database 
server and look at the server maintenance database 'mysql.' We log in to the 
system through mysql interactive interface to the server.

<pre class="command-line">
/usr/local/bin/mysql -u root -p
</pre>

<pre class="screen-output"> 
Enter password: <b>mypassword </b>&lt;-- 
this will show as **********
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 5 to server version: 4.0.18 

Type 'help;' or '\h' for help. Type '\c' to clear the buffer. 

mysql> 
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
+----------+
|  Database|
+----------+
|  mysql   |
|  test    |
+----------+ 
</pre>

We can check whether the mysql database has been installed by looking at the 
installed tables which should look like the below.

<pre class="command-line">
mysql&gt; <b>use mysql;</b>
mysql> <b>show tables; </b>
</pre>

<pre class="screen-output">
+-----------------+
|  Tables  in  mysql  |
+-----------------+
|  columns_priv       |
|  db                 |
|  func               |
|  host               |
|  tables_priv        |
|  user               |
+-----------------+ 
</pre>

The user table is the system wide table to record what users are allowed onto 
the system and with what privileges. By using the 'describe' command we can 
see a list of the table fields and data-types. In this table it shows us the 
different levels of privileges available on the MySQL server.

<pre class="command-line">
mysql>  <b>describe  user;</b>
</pre>

<pre class="screen-output">
+-----------------+---------------+------+-----+---------+-------+
|  Field                      |  Type                    |  Null  |  Key  |  Default  |  Extra  |
+-----------------+---------------+------+-----+---------+-------+
|  Host                        |  char(60)            |            |  PRI  |                  |              |
|  User                        |  char(16)            |            |  PRI  |                  |              |
|  Password                |  char(16)            |            |          |                  |              |
|  Select_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Insert_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Update_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Delete_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Create_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Drop_priv              |  enum('N','Y')  |            |          |  N              |              |
|  Reload_priv          |  enum('N','Y')  |            |          |  N              |              |
|  Shutdown_priv      |  enum('N','Y')  |            |          |  N              |              |
|  Process_priv        |  enum('N','Y')  |            |          |  N              |              |
|  File_priv              |  enum('N','Y')  |            |          |  N              |              |
|  Grant_priv            |  enum('N','Y')  |            |          |  N              |              |
|  References_priv  |  enum('N','Y')  |            |          |  N              |              |
|  Index_priv            |  enum('N','Y')  |            |          |  N              |              |
|  Alter_priv            |  enum('N','Y')  |            |          |  N              |              |
+-----------------+---------------+------+-----+---------+-------+
</pre>

Grabbing a set of information from the user table lets us see who has been 
given access to the system. The machine I have mysql installed on is called 
<b> iwill</b>, and you should see a similar result to the select query on your 
machine. Note the &quot;blank&quot; users is used by mysql for 'anonymous' and 
at the beginning only --user=root has privileges to do anything on the system. 
Note that the password field is encrypted with a one-way encryption system similar 
to but not the unix crypt() function

<pre class="command-line">
mysql>  <b>select  host,  user,  select_priv,  grant_priv,  password  from  user;</b>
</pre>

<pre class="screen-output">
+-----------+------+-------------+------------+------------------+
|  host            |  user  |  select_priv  |  grant_priv  |  password                  |
+-----------+------+-------------+------------+------------------+
|  localhost       |  root  |  Y            |  Y           |  162eebfb6477e5d3  |
|  iwill           |  root  |  Y            |  Y           |                    |
|  localhost       |        |  N            |  N           |                    |
|  iwill           |        |  N            |  N           |                    |
+-----------+------+-------------+------------+------------------+ 
</pre>

<pre class="command-line">mysql&gt; <b>quit</b>
</pre>

### <a name="starting"></a>Starting MySQL with each start-up.

To configure OpenBSD to automatically start mysql with every system start-up 
then you can edit the rc.conf.local file to modfiy the configuration and rc.local 
to take action when the configurations are set.

Edit: /etc/[rc.conf.local](../build/preview/rc.conf.html)
file to include:

<pre class="screen-output">mysql=YES 
</pre>

 Edit: /etc/rc.local

<b>After</b> the 'starting local daemons' <b>and</b> <b>before</b> the following 
echo '.', Insert the following instructions to the /etc/rc.local file:
  
<pre class="screen-output">
<b>echo -n 'starting local daemons:'</b> 

# [ ... stuff left out ... ]   
</pre>

      
<pre class="command-line">
if [ X&quot;${mysql}&quot; == X&quot;YES&quot; -a 
    -x /usr/local/bin/mysqld_safe ]; then 
    echo -n &quot; mysqld&quot;; /usr/local/bin/mysqld_safe \
        --user=_mysql --log --open-files-limit=256 &amp; 

    for i in 1 2 3 4 5 6; do
        if [ -S /var/run/mysql/mysql.sock ]; then
                break
        else
                sleep 1
                echo -n &quot;.&quot;
        fi
    done          #
    # Apache chroot Settings

    mkdir -p /var/www/var/run/mysql
    ln -f /var/run/mysql/mysql.sock /var/www/var/run/mysql/mysql.sock

    #
    # Postfix chroot Settings
    if [ &quot;X${postfix_flags}&quot; != X&quot;NO&quot; ]; then 
        mkdir -p /var/spool/postfix/var/run/mysql
        ln -f /var/run/mysql/mysql.sock /var/spool/postfix/var/run/mysql/mysql.sock
    fi
fi
</pre>

<pre class="screen-output"> # [ ... stuff left out ... ] 
<b>echo '.' </b>
</pre>


<p> Now each restart of the machine will automatically check to see whether we 
  have enabled mysql in the configuration file (rc.conf) and then start the mysql 
  daemon. If we wish to disable mysql we can simply change mysql=YES to mysql=NO</p>
  
<p>Once you have the startup script working you can get rid of all the extraneous 
messages that mysql startup daemons makes by changing the 
mysqld_safe line to be something like the following:</p>


<pre class="command-line">
/usr/local/bin/mysqld_safe --user=_mysql --log --open-files-limit=256 &gt; /dev/null 3&gt;&amp;1 2&gt;&amp;1 &amp;
</pre>

Note: /usr/local/share/mysql/mysql.server is a script for 
starting/stopping mysql daemon. The files are there with mysql-server-4.0.18 
on OpenBSD 3.5 so your mileage may vary.

### <a name="stopping"></a> Stopping MySQL

To stop the MySQL server, a standard approach is to use the mysqladmin program 
as shown below:
  
<pre class="command-line"># <b>/usr/local/bin/mysqladmin shutdown</b>
</pre>

Of course you have to be logged in as a user with privileges to shutdown the 
server (as noted above in the the user table, field Shutdown_priv. Otherwise 
if you had root access you could shutdown the server through a 'kill'.

Security Notice: MySQL installs anonymous login access from the localhost with 
its default installation, you may or may not consider this a security issue. 
If you do consider it a problem then you can remove the anonymous access by 
using commands similar to that shown below:
  
<pre class="command-line">
/usr/local/bin/mysql -u root -p </b>
</pre>

<pre class="screen-output">
Enter password: <b>mypassword </b>&lt;-- 
this will show as **********
Welcome to the MySQL monitor. Commands end with ; or \g. 
Your MySQL connection id is 6 to server version: 3.22.32

Type 'help' for help.
</pre>

<pre class="command-line">
>mysql &gt; <b>use mysql</b>
</pre>

<pre class="screen-output">
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
</pre>

<pre class="command-line">
mysql &gt; <b>delete from user where user = "";</b> 
</pre>

<pre class="screen-output">
Query OK, 2 rows affected (0.08 sec) 
</pre>

### <a name="usability"></a>Usability Assistance
 
#### <a name="mysqlConf"></a>User Configuration Files

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

#### <a name="mysqlScreenEditor"></a>Screen Editor in mysql

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

### Troubleshooting

&#91;Ref: misc@openbsd.org October 2001 archives | /usr/ports/databases/mysql/patches/]
  
One problem that seems to be reported a lot on the mailing lists (and subsequently 
responded to) is that mysql at a large level of use begins to consume all available 
resources and locks up the system.

The answer for this problem OpenBSD 2.x and OpenBSD 3.0 have been well documented 
by Derek Sivers
