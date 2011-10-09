# Subversion and WebDAV

&#91; Ref: Subversion 1.7.0rc2, OpenBSD 5.0 beta]

<div class="toc">
Table of Content
<ul>
	<li>Install</li>
	<li>Configuration</li>
	<li>Repository</li>
</ul>
</div>

Placeholder notes for installing Subversion, because there were just a 
'few' little items not specifically in the documentation or in a quick
round-trip on Google/Bing.

## Install

All the required binary bits are available as packages. Install the
binary packages.

### Subversion

&#91; Ref: Subversion 1.7.0rc2]

package: subversion-1.7.0rc2

### Apache

&#91; Ref: Apache 2.2.20]

package: apache-httpd-2.2.20, ap2-subversion

Note the warning message from apache-httpd-2.2.20.

Note the Display message from ap2-subversion

## Configuration

After installing the above packages, we mostly need to configure
our Apache2 server, as for this installation we're using Apache
WebDAV as the transport layer for subversion.

Several apache modules are enabled to support subversion, and 
these "extra" modules are generally configured in the path
/etc/apache2/extras

- httpd-dav.conf - Web DAV
- httpd-ssl.conf - SSL Encryption
- httpd-subversion.conf - Subversion Provider
- /etc/apache2/httpd.conf - Apache Base Configuration

### Web DAV

&#91; [mod_dav](http://httpd.apache.org/docs/2.2/mod/mod_dav.html)]

What we need from the *./extra/httpd-dav.conf* file is to specify the
[DavLockDB Directive](http://httpd.apache.org/docs/2.2/mod/mod_dav_fs.html#davlockdb).

File: /etc/apache2/extra/httpd-dav.conf

<pre class="config-file">
DAVLockDB "/var/apache2/var/DavLock"
</pre>

Comment out other Alias and Directory settings in this file (unless
you actually want it.)

The *httpd-dav.conf* file also configures [BrowserMatch Directive](http://httpd.apache.org/docs/2.2/mod/mod_setenvif.html#browsermatch)
that may be important to you client base.

### SSL Encryption

&#91; [mod_dav](http://httpd.apache.org/docs/2.2/mod/mod_ssl.html)]

We have a generic layout for certificates on our servers, not
all servers host all the different types of services that use
certificates, so we'll just keep things standardised to simplify
knowledge or expectations of where certificates are placed.

We therefore modify the configuration to point to the path we
use for storing SSLCertificates.

File: /etc/apache2/extra/httpd-ssl.conf

<pre class="config-file">
SSLCertificateFile    /etc/ssl/server.pem
</pre>

The certificate file will contain both the server certificate,
and the server *key* in the PEM file format.

#### Generate the SSL Certificate/Key

From our [XMPP Chat](../comms/xmpp.html) notes, we take the Certificate Generation
Code and generate SSL Keys. Again, this part is well documented online, these 
instructions place the SSL certificates in what makes sense for my installs.

Use OpenSSL to generate keys.

<pre class="command-line">
# mkdir -p /etc/ssl/certs
# /usr/sbin/openssl req -new -x509 -newkey rsa:4096 -days 3650 \
       -keyout /etc/ssl/private/server.key \
	   -out /etc/ssl/certs/server.crt

# cp /etc/ssl/certs/server.crt /etc/ssl/server.pem
# /usr/sbin/openssl rsa -in /etc/ssl/private/server.key -out /etc/ssl/private/server.key.pem
# cat /etc/ssl/private/server.key.pem >> /etc/ssl/server.pem
</pre>

A few notes about the commands

- 	00 **/etc/ssl/certs**: We want to keep certificates in a directory, /etc/ssl/certs
- 	01 **req -new -x509 -newkey**: Generate the Private Key **server.key** and the self-signed certificate **server.crt**
- 	05 **/etc/ssl/server.pem**: Copy the CRT **server.crt** so we can add information about the key **server.key**
-	06 **/etc/ssl/private/server.key.pem**: Convert the Private Key to RSA output.
-	07 **/etc/ssl/server.pem**: Add the RSA Formatted Key information to the **server.pem** file

Effectively, we now have a single file which contains both the Certificate we serve to clients,
and the Private Key.

#### Subversion

Create the configuration file to enable the SVN *service-provider* for Web DAV,
and specify the path where we intend to configure our subversion folder(s)

New File: /etc/apache2/extra/httpd-subversion.conf

<pre class="config-file">
LoadModule dav_svn_module /usr/local/lib/apache2/mod_dav_svn.so
LoadModule authz_svn_module /usr/local/lib/apache2/mod_authz_svn.so

&lt;Location /svn>
    DAV svn
	
	# Automatically map any "/svn/foo" URL to repository /var/svn/foo
	SVNParentPath /var/svn
	
	# Authentication
	AuthName "Subversion Repository"
	AuthType Digest
	AuthUserFile /etc/svn-auth.htdigest
	
	# Authorisation: Authenticated users only
	Require valid-user
	
	SSLRequireSSL
&lt;/Location>
</pre>

The **DAV** directive enables the *provider-name* (svn). 

[AuthName](httpd.apache.org/docs/2.2/mod/core.html#authname) *auth-domain* displays the *auth-domain* 
to the user with the login prompt.

The *auth-domain* is also used in the Authentication Type *Digest* 
(implemented by mod_auth_digest)


#### Apache Base Configuration

Ensure the above "extra" configurations are enabled, and the
DAV modules have been read.


File: /etc/apache2/httpd.conf

<pre class="config-file">
auth_digest_module /usr/local/lib/apache2/mod_auth_digest.so

LoadModule dav_module /usr/local/lib/apache2/mod_dav.so
LoadModule dav_fs_module /usr/local/lib/apach2/mod_dav_fs.so

Include /etc/apache2/extra/httpd-dav.conf
Include /etc/apache2/extra/httpd-ssl.conf
Include /etc/apache2/extra/httpd-subversion.conf
</pre>

### User Accounts

Create the user accounts, related to the above Apache configuration.

Since we're using the Digest authentication-type, we use the command *htdigest*
and initially enable "**-c**" which:

<pre class="manpage">
-c    Create the <u>passwordfile</u>. If <u>passwordfile</u> already exists,
      it is deleted first.
</pre>

<!--(block|syntax("bash"))-->
sudo htdigest -c /etc/svn-auth.htdigest "Subversion Repository" samt
<!--(end)-->
<pre class="screen-output">
Adding password for samt in realm Subversion Repository
New password: *****
Re-type new password: *****
</pre>

Further invocations (running) of *htdigest* do not require the "-c" option:

<!--(block|syntax("bash"))-->
sudo htdigest /etc/svn-auth.htdigest "Subversion Repository" charlie
<!--(end)-->

## Repository

Create the paths that will contain our repositories

<!--(block|syntax("bash"))-->
$ sudo mkdir -p /var/svn
$ sudo svnadmin create /var/svn/repo
<!--(end)-->
Where 
Pre-build our subversion structure.

<!--(block|syntax("bash"))-->
$ cd ~
$ mkdir myrepo
$ cd myrepo
$ mkdir -p project1/branches
$ mkdir -p project1/tags
$ mkdir -p project1/trunk
$ mkdir -p utils
$ cd ~
$ svn commit myrepo https://svn-host/svn/repo/
<!--(end)-->


