## Apache - Serving up the Web

<div class="toc">

Table of Contents:

<ol>
	<li>Setting Apache to <a href="#setup">Auto Start</a> 
	 </li>
	<li><a href="#apachectl">Manual Start</a> </li>
	<li><a href="#test">Test</a> </li>
	<li><a href="#mod_status">Status Configurations </a> </li>
	<li><a href="#mod_userdir">User Web Pages </a> 
	<ul>
		<li><a href="#restart"> Restart apache </a> </li>
		<li><a href="#public_html"> User chroot'd account</a> </li>
		<li><a href="#userid">http://server-name/~user-id/</a></li>
	</ul></li>
	<li><a href="#securessl">Securing with SSL</a>
		<ul>
			<li>Problems with Browsers</li>
			<li><a href="#secureVH">Virtual Hosts</a></li>
		</ul>
	</li>
</ol>

</div>

[OpenBSD 3.5 and Apache]

The Apache Web Server is installed as part of the OpenBSD base system. If you 
have a need for a different version of Apache than that supplied with the Base 
system then you can look at the ports collection.</p>

To see how configurable the Apache/OpenBSD combination is we will configure 
the Web server to start with each reboot, manually start and stop the server 
as well as setting up a basic test site. We will look at creating web space 
for the users on your system which may all make your system insecure, after 
the experimentation please reset these things or just reinstall the whole system.</p>

As a final piece we will look at setting up SSL Certificates for our web server.</p>

Apache is run in a chroot environment with OpenBSD, of course you can do the 
unspeakable and run it however you want including decreased security by not 
running the server in the chroot environment.</p>

<a name="setup"></a>

### Setting Apache to start every time the system is started/restarted

&#91;Ref: httpd(8), ssl(8)]</p>

The first thing we consider about the Apache web-server is turning it on, and 
setting it up so it turns on automatically if the system is restarted. To do 
this we make single change to the startup configuration file: 
<a href="rc.conf.htm">/etc/rc.conf.local</a></p>

Edit /etc/rc.conf.local to add the following line into 
<a href="rc.conf.htm#Section1">Section 1</a></p>


<pre class="command-line">
httpd_flags=""          # note the use of two double-quotes
</pre>

This will override the settings in /etc/rc.conf which 
reads:</p>

<pre class="screen-output">
# use -u to disable chroot, see httpd(8)
httpd_flags=NO           # for normal use: "" (or "-DSSL" after reading ssl(8))
</pre>
  
Save the changes and when the computer is restarted, the /etc/rc routines will 
automatically launch the Apache server httpd with every system restart.

<a name="apachectl"></a>

### Manually starting Apache

We can test the Apache server without the need to restart 
the computer. To manually start | restart the Apache server you can use the /usr/sbin/apachectl 
program

<pre class="command-line">
# <b>/usr/sbin/apachectl start</b>
</pre>

<pre class="screen-output">
/usr/sbin/apachectl start: httpd started
</pre>

Your server is up and running.

<a name="test"></a>

### Testing that it works

We can test the web server because OpenBSD installs Apache with a sample website 
that is full of documentation. This sample website is placed into the <strong>Document 
Root </strong> directory /var/www/htdocs.

To quickly view whether the web server is up and running, start your browser 
and test specify your server address. From a command prompt, check using <strong>lynx 
</strong> .

<pre class="command-line">
# <b>lynx localhost</b>
</pre>

<pre class="screen-output">
[ lynx displays the following ...]
   
     [OpenBSD]
      Apache
   
                                     It Worked!
   
     If you can see this page, then the people who own this host have just
     activated the Apache Web server software included with their OpenBSD
     System. They now have to add content to this directory and replace this
     placeholder page, or else point the server at their real content.
   [ ... more stuff cut out ... ]<
</pre>
   
### <a name="mod_status"></a>Setting some status configurations

Can we get more information on what the Server is doing?

The OpenBSD apache distribution is compiled with mod_status which allows us 
to configure the server so we can take a look at it's operational status. I 
put this in here as a another means for checking the server's functionality while setting it up. 
(AKA. what's an interesting task for changing the server configuration without 
having to do too much work.)

To activate the server-status reports in Apache we need to make the following 
changes to the configuration file:

File: /var/www/conf/httpd.conf, Change the lines that 
read:

<pre class="screen-output">
#ExtendedStatus On

#
# Allow server status reports, with the URL of http://servername/server-status
# Change the ".your_domain.com" to match your domain to enable.
#
#&lt;Location /server-status&gt;
#    SetHandler server-status
#    Order deny,allow
#    Deny from all
#    Allow from .your_domain.com
#&lt;/Location&gt;
</pre>

To Read:

<pre class="command-line">
ExtendedStatus On
   
  &lt;Location /server-status&gt;
      SetHandler server-status
      Order deny,allow
      Deny from all
      Allow from 127.0.0.1
  &lt;/Location&gt;
</pre>
  
(The above lines are not connected together in the configuration file as in 
this example.)

We can check the above configuration change let's you check the server status 
with at least two methods: opening a browser and pointing to the /server-status 
url or by using apachectl.

Restart the server and check if server-status is accessible.

<pre class="command-line">
# <b>apachectl restart</b>
# <b>apachectl status </b>
</pre>

<pre class="screen-output">
[ displays the following ...]
            Apache Server Status for example.com

Server Version: Apache/1.3.29 (Unix) PHP/4.3.5RC3 mod_ssl/2.8.16
OpenSSL/0.9.7c
Server Built: Mar 29 2004 10:31:17
 _________________________________________________________________

Current Time: Tuesday, 29-Jun-2004 13:37:09 EST
Restart Time: Tuesday, 29-Jun-2004 13:34:09 EST
Parent Server Generation: 0

  _________________________________________________________________
  
  [ ... more stuff cut out ... ]
</pre>
  
As mentioned earlier, a similar command to `apachectl status` is to directly 
access the website location specified above in our configuration

<pre class="command-line">
# <b>lynx http://localhost/server-status</b>
</pre>

Note: Here we are accessing the server-status from within the server (ie. 'localhost') 

If you try to connect to the http://server-name/server-status from a separate 
workstation on the network, you should get a <i>403 Forbidden error message 
(You don't have permission to access � ) </i>If you do want to give other workstations 
access to this page, then you can add further <i>Allow from </i>lines such as:

File: /var/www/conf/httpd.conf

<pre class="command-line">
ExtendedStatus On   
&lt;Location /server-status&gt; 
    SetHandler server-status     
    Order   deny,allow     
    Deny from all
    Allow from 127.0.0.1 <strong>192.168.101. .example.com</strong> 
&lt;/Location&gt;
</pre>      

The above changed lines will allow access to the <i>/server-status </i>from 
any client with <i>192.168.101.xyz </i>ip address, and any client with the domain 
suffix  <i>example.com </i>

<a name="mod_userdir"></a>

### Creating User personal web pages

The chroot environment of OpenBSD's Apache creates a dilemma for those wishing 
to allow personal web pages for its users. Since Apache can no longer get to 
the root/home/user-name directory.

[incomplete]

The process discussed here selects the creation of user accounts within the 
Apache chroot environment (/var/www) of /users/user-account/

let's you create alias' (conceptually similar to symbolic links ?) to any point 
on your server (and possibly beyond.) But one advantage of Apache is how easy 
it is to let every user on your system have their own private web space. Again, 
the OpenBSD distribution httpd has this feature built into the binary and it 
is a simple matter of just modifying the configuration file and restarting Apache 
to see things work.

-   Modify configuration file /var/www/conf/httpd.conf 
-   Restart apache 
-   Create public_html in user accounts 
-   Access user accounts with the URL form http://server-name/~user-id/
    
1. Our modifications to the configuration is to enable the mod_userdir.c module 
which let's Apache talk with your user accounts and their home directories. 
We specify which directory within each users home directory we will send http 
requests for files.

File: /var/www/conf/httpd.conf, Change the lines that read:

<pre class="screen-output">
#
# UserDir: The directory which is prepended onto a users username, within
# which a users's web pages are looked for if a ~user request is received.
# Relative pathes are relative to the user's home directory.
#
# "disabled" turns this feature off.
#
# Since httpd will chroot(2) to the ServerRoot path by default,
# you should use
#       UserDir /var/www/users
# and create per user directories in /var/www/users/<username>
#

#UserDir disabled

#
# Control access to UserDir directories.  The following is an example
# for a site where these directories are restricted to read-only and
# are located under /users/<username>
# You will need to change this to match your site's home directories.
#
#&lt;Directory /users/*&gt;
#    AllowOverride FileInfo AuthConfig Limit
#    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
#    &lt;Limit GET POST OPTIONS PROPFIND>
#        Order allow,deny
#        Allow from all
#    &lt;/Limit>
#    &lt;Limit PUT DELETE PATCH PROPPATCH MKCOL COPY MOVE LOCK UNLOCK>
#        Order deny,allow
#        Deny from all
#    &lt;/Limit>
#&lt;/Directory>
</pre>

To read:

<pre class="command-line">
UserDir /var/www/users
&lt;Directory /users/*>
AllowOverride FileInfo AuthConfig Limit
Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
&lt;Limit GET POST OPTIONS PROPFIND>
    Order allow,deny
    Allow from all
&lt;/Limit>
&lt;Limit PUT DELETE PATCH PROPPATCH MKCOL COPY MOVE LOCK UNLOCK>
    Order deny,allow
    Deny from all
&lt;/Limit>
&lt;/Directory>
</pre>

In the above example, we specify that under the /var/www/users directory will 
be the directory space for each user-account's 'personal' webspace. </p>

Note: If you want to use a directory name other than those specified in the 
httpd.conf file, then you may need to modify the mod_userdir source.</p>

#### <a name="restart"></a> Restart apache

Before the configuration goes into effect, we need to force httpd to re-read 
it's configuration file.</p>

<pre class="command-line">
# <b>apachectl restart</b>
</pre>

Seems to simple, but if you forget to restart the server, you will be frustrated 
in trying to test the changes when the running server does not recognise them.</p>

#### <a name="public_html"></a>Link from user accounts to chroot'd account directory

The convention has been to use a directory called 'public_html' (or similar) 
within the users home directory to specify their web-space. Since Apache has 
now been chroot'd this will not work, as Apache cannot traverse below /var/www. 
</p>

One of the ways to allow for this chroot behaviour is to create a 'symlink' 
from the users normal file space to the Apache Server's user space.</p>
<p>Our process will be:</p>


-   Create the users Web Space under /var/www/users
-   'symlink' to it from the users standard home directory
-   Give the user full ownership to files in /var/www/users/username
-   Change to the user so we can create some test files
-   Change to the users standard home directory
-   Change into the 'public_html' directory
-   Create the test "index.html" file

<p>For our example user johndoe:</p>

<pre class="command-line">
# <b>mkdir /var/www/users/johndoe</b>
# <b>ln -s /var/www/users/johndoe/ /home/johndoe/public_html</b>
# <b>chown -R johndoe:johndoe /var/www/users/johndoe</b> 
# <b>su johndoe</b>
$ <b>cd ~</b>
$ <b>cd public_html</b>
$ <b>echo "&lt;html&gt;&lt;body&gt;&lt;h1&gt;Success&lt;/h1&gt;Now, get real content&lt;/body&gt;&lt;/html&gt;" &gt; index.html</b>
</pre>

Of course, you could move or place some more sophisticated files into this 
directory, but this is an adequate start for a test.</p>

#### <a name="userid"></a>Access user accounts with the URL form http://server-name/~user-id/

Now we try to access the web page.</p>

<pre class="command-line"># <b>lynx localhost/~johndoe/</b>
</pre>
<pre class="screen-output"> 
[ lynx displays the following ...]
                           
  Success
   
     Now, get real content
  </span>[ ... more stuff cut out ... ]
</pre>
  
Similarly from a GUI Browser you get &lt;h1&gt; settings for Success, and the 
rest of the page as plain text.</p>

You now not only have a working website (example.com) but your users can also 
have their own web space (http://example.com/~johndoe/)</p>

#### Securing public_html

There are security concerns with opening web space for users since we do not 
want to explicitly trust all users will not leave holes in their websites that 
can be exploited. To minimise security holes with allow User space these are 
some precautions you can take.</p>

1. disable root having web space.</p>

<pre class="command-line">UserDir disabled root
</pre>

<p><i>(I'll add more as I find out about it, hopefully not because someone has 
successful whacked my system.)</i></p>

### <a name="securessl"></a>Securing the Site with SSL

&#91;Ref: <a href="http://www.openbsd.org/faq/faq10.html#10.6">OpenBSD FAQ 10.6 
Setting up a Secure HTTP Server with SSL</a>]
[local: <a href="openssl.htm">openss# - Secured Communications</a>] ]</p>

For pumping out dynamic and static pages with public content, the webserver 
so far is just fine.

<p>When you want to secure content, such as credit-card transactions or webmail 
services, then we need to take a look at data encryption which is served through 
SSL. Fortunately, OpenBSD was one of the first (if not the first) operating 
system releases to come with SSL enabled by default for its basic configuration.</p>
<p>SSL is described in detail on a number of websites as well as the standard 
Apache documentation that is shipped with OpenBSD. </p>
<p>Since SSL is part of OpenBSD's install the 1st step is to <a href="openssl.htm">create 
an SSL server certificate</a>. Refer to the <a href="http://www.openbsd.org/faq/faq10.html#10.6">FAQ</a> 
or <a href="openssl.htm">Secured Communications</a> notes for creating an SSL 
and then continue below.</p>
<p>After you have successfully created or recieved an SSL server certificate, 
we can stop the web server and restart it using the new certificate.</p>
<pre class="command-line"># <b>apachectl stop</b>
</pre>
<pre class="screen-output"> /usr/sbin/apachectl stop: httpd stopped 
</pre>
<pre class="command-line"># <b>apachectl startssl</b>
</pre>
<pre class="screen-output">/usr/sbin/apachectl startssl: httpd started 
</pre>

<p> To ensure SSL is started when we restart the host we need to modify the /etc/rc.conf.local 
file and make the following changes.</p>

<p>In <a href="rc.conf.htm">/etc/rc.conf.local</a> Section 1, the lines that read 
:</p>

<pre class="screen-output">
httpd_flags=""            # or it could have httpd_flags=NO
</pre>
  
<p>Should be changed to:</p>

<pre class="command-line">
httpd_flags="-DSSL"            # note the use of two double-quotes
</pre>

#### Problems with Browsers

I began having weird problems with SSL connections where the browser seemed 
to lose the sessions, connections.</p>

Fortunately (not?) the environment I had was a controlled 
environment (MSIE 5.x) and we were eventually able to track the culprit down 
to an <a href="http://www.modssl.org/docs/2.8/ssl_faq.html#io-ie">MSIE deficiency</a>. 
Unfortunately there are problems with other browsers, so it will be best for 
you if you take a look at the 
<a href="http://www.modssl.org/docs/2.8/ssl_faq.html">FAQ.</a></p>

#### <a name="secureVH"></a>Securing Virtual Hosts

&#91;Ref: <a href="http://www.incyte-studios.com/ssl.htm">http://www.incyte-studios.com/ssl.htm</a>]</p>

Trey Stout [published an article](http://www.incyte-studios.com/ssl.htm)
for those who have a need to put several SSL 
hosts on a single machine.</p>

