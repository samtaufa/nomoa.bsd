## First Time - Package Management

<div class="toc">

Table of Contents


<ol>Examples
	<li><a href="#installPMpico">nice little editor</a></li>
	<li><a href="#bash2">Bash 2 - local</a></li>
	<li><a href="#bash2ftp">Bash 2 - ftp</a></li>
	<li><a href="#dontknow">Unknown Location</a></li>
</ol>


</div>

&#91;Ref: $!manpage("pkg_add",1)!$ | $!manpage("pkg_info",1)!$ | $!manpage("pkg_delete",1)!$ |
[FAQ 15 - The OpenBSD packages and port system](http://www.openbsd.org/faq/faq15.html)&#93;

[Config location: /usr/src ] 

&#91;Ref: [OpenBSD FAQ - Section 8](http://www.openbsd.com/faq/faq8.html#8.7 "General Questions")]
 
The OpenBSD Project provides application binary executables in 
what are termed 'packages.' These packages store the information 
required to safely install the binaries, documentation, and 
dependencies such as libraries. Packages are configured for 
the OpenBSD disk layout and database of installed software. 
The benefits of packages include someone else figuring out
how to install the software 'correctly,' including resolving 
dependencies (such as what else do you need to make sure that
this program will run.)

Three Package Administration tools you will most likely come-across are:

-	adding $!manpage('pkg_add')!$,
-	deleting $!manpage('pkg_delete')!$, and 
-	query $!manpage('pkg_info')!$

For those new to packages (and haven't read through the FAQ Entries) 
change your working directory to where the packages are stored before 
using pkg_add (this is not necessary and is explained later in setting 
environment variables.)

This guide will give you some simple useage scenarios of using 
Package Management to install a package. If you wish to gain greater
control of you application, then you will need to look at using
the 'ports' system.

The general format for using pkg_add is:

<pre class="command-line">
# pkg_add -v /[path-to-package]/filename
# pkg_add -v ftp.site.com/[path-to-package]/filename 
</pre>

The -v option is Verbose, which is real helpful in providing
visual feedback of files it is processing. After you figure out how
things work, you can leave the "-v" off.

#### <a name="installPMpico"></a>Example - Installing pico, a nice
little editor

[package: pico-4.33.tgz]

If you are uncomfortable with "vi" or the standard text editors
found on OpenBSD, then I suggest that you download the pico package and
follow the installation process below to simplify some of the editing
work that will be required in configuring your OpenBSD server.

<pre class="command-line">
# mkdir /usr/packages
# cd /usr/packages
# mv /[path-to-download]/pico-4.33.tgz .
# pkg_info pico-4.33.tgz
</pre>

Information for pico-4.33.tgz:

<pre class="manpage">
Comment: small text editor

Description:
Pico is a small text editor distributed as part of the pine mail
program. It is a separate program that may be installed and used
without using pine.

WWW: http://www.washington.edu/pine/
</pre>

In the above example we're just using a location /usr/packages to
keep packages. We go into this directory and copy into it the
pico-4.33.tgz file and then query the package to tell us what it
contains (by using pkg_info.) To install the package we can simply use
pkg_add.

<pre class="command-line">
#pkg_add -v pico-4.33.tgz 
</pre>
<pre class="screen-output">
Requested space: 359604 bytes, free
space: 4294905856 bytes in /var/tmp/instmp.ttTyg31193
Package `pico-4.33' conflicts with `pine+pico-*'
extract: Package name is pico-4.33
extract: CWD to /usr/local
extract: /usr/local/bin/pico
extract: /usr/local/man/man1/pico.1
extract: CWD to .
Attempting to record package into `/var/db/pkg/pico-4.33'
Package `pico-4.33' registered in `/var/db/pkg/pico-4.33'
</pre>

pkg_add will decompress the file into a temporary location
(/var/tmp/## above) 

By using the "-v" verbose display, we can tell the binary
/usr/local/bin/pico has been installed and the man page placed
/usr/local/man/man1/pico.1

If you've ever used "pine" as an e-mail manager then pico will be a
quick and easy editor to learn and use. Make sure you read the man page
for command-line options, especially the "-w" command line option to
turn off auto-wordwrap. 'pico -w file' is a quick and easy editor for
Unix.

#### <a name="bash2"></a>Example - Installing Bash 2

[package: bash-2.04-static.tgz | config file: /etc/shells]

This is an example of an installation that requires further work
after the binaries have been installed. This example assumes the
package file can be found on a mounted OpenBSD cd at /mnt/cdrom.

For your reference: There is a reason we choose the 'static' version
of bash, as opposed to other versions of bash.

<pre class="command-line">
# <b>cd /mnt/cdrom/2.7/packages/i386</b>
# <b>ls -l bash*</b>
</pre>

<pre class="screen-output">
bash-1.14.7-static.tgz
bash-2.04-static.tgz 
</pre>

<pre class="command-line">
# <b>pkg_add bash-2.04-static.tgz</b>
</pre>

<pre class="screen-output">
Requested space: 4606268 bytes, free
space: 7432482816 bytes in /var/tmp/instmp.eepTB28148
Running install with PRE-INSTALL for `bash-2.04-static'
extract: Package name is bash-2.04-static
extract: CWD to /usr/local
extract: /usr/local/bin/bash
extract: /usr/local/bin/bashbug
extract: /usr/local/man/man1/bash.1
extract: /usr/local/man/man1/bashbug.1
extract: /usr/local/info/bash.info
extract: execute 'install-info /usr/local/info/bash.info /usr/local/info/dir'
extract: /usr/local/share/doc/bash/article.ps
extract: /usr/local/share/doc/bash/article.txt
extract: /usr/local/share/doc/bash/bash.html
extract: /usr/local/share/doc/bash/bash.ps
extract: /usr/local/share/doc/bash/bashbug.ps
extract: /usr/local/share/doc/bash/bashref.html
extract: /usr/local/share/doc/bash/bashref.ps
extract: /usr/local/share/doc/bash/builtins.ps
extract: /usr/local/share/doc/bash/readline.ps extract: CWD to .
Running install with POST-INSTALL for `bash-2.04-static'
Attempting to record package into `/var/db/pkg/bash-2.04-static'
Package `bash-2.04-static' registered in `/var/db/pkg/bash-2.04-static'

+---------------
| For proper use of bash-2.04-static you should notify the system
| that /usr/local/bin/bash is a valid shell by adding it to the
| the file /etc/shells. If you are unfamiliar with this file
| consult the shells(5) manual page"
+---------------
</pre>

Notice how binary (./bin), man pages have been installed, together
with info files and more documentation at the shown location
/usr/local/share/doc/bash.

If a package (like bash) gives you further instructions for
completing the installation, make sure you follow the instructions. For
example, the bash pkg_add tells us to update the /etc/shells file to
include bash as a valid login shell.

<pre class="config-file">
# $OpenBSD: shells,v 1.5 1997/05/28 21:42:20 deraadt Exp $
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.
/bin/sh
/bin/csh
/bin/ksh
</pre>

<pre class="command-line">
<b>/usr/local/bin/bash</b>
</pre>


Include the above line (/usr/local/bin/bash) into the /etc/shells
file.

#### <a name="bash2ftp"></a>Example - Installing Bash 2 - ftp

For those without the release CDs, performing a pkg_add from an ftp
connection is no more difficult than the above, as shown in the below
example for installing the same package.

I have downloaded the bash package from the Internet and have it on
my intranet ftp site: 192.168.101.77

<pre class="command-line">
# <b>pkg_add ftp://192.168.101.77/OpenBSD/2.7/packages/i386/bash-2.04-static.tgz</b>
</pre>
<pre class="screen-output">
&gt;&gt;&gt; ftp -o - ftp://192.168.101.77/OpenBSD/2.7/packages/i386/bash-2.04-static.tgz 
# 
</pre>

pkg_add uses ftp to retrieve from my internal ftp site
(192.168.101.77) the requested package and then extracts the files as
per the same operation above. You can replace 192.168.101.77 with any
valid ftp site which holds the package you wish to install.

##### <a name="dontknow"></a>Example - Don't know the package or ftp directory ?

If you do not know what the package name is, or the specific
directory the file is located, you can still perform an ftp pkg_add.
Try using the get filename <b>"| command "</b> sequence as shown in
the below example. (note: I am connecting here to an internal site with
the OpenBSD files, connect to some other site)

<pre class="command-line">
# <b>ftp 192.168.101.77</b>
</pre>

<pre class="screen-output">
Connected to 192.168.10 1.77.
Name (192.168.101.77:root): <b>anonymous</b>
331 Anonymous access allowed, send identity (e-mail name) as password.
Password:
</pre>

<pre class="command-line">
ftp&gt; <b>cd pub/OpenBSD/2.7/packages/i386</b>
</pre>
<pre class="screen-output">
250 CWD command successful.
</pre>
<pre class="command-line">
ftp&gt; <b>ls bash*</b>
</pre>
<pre class="screen-output">227 Entering Passive Mode
(192,168,101,77,4,164).
125 Data connection already open; Transfer starting.
-r-xr-xr-x   1  owner    group          261366  May 10  0:24 bash-1.14.7.tgz
-r-xr-xr-x   1  owner    group          376068  May 10  0:26 bash-1.14.7-static.tgz
-r-xr-xr-x   1  owner    group          1000070 Jun 15  3:32 bash-2.04.tgz
-r-xr-xr-x   1  owner    group          1151567 Jun 15  3:32 bash-2.04-static.tgz
226 Transfer complete.
</pre>
<pre class="command-line">
ftp&gt; <b>bi</b>
</pre>

<pre class="screen-output">200 Type set to I.
</pre>

<pre class="command-line">
ftp&gt; <b>get bash-2.04-static.tgz "| pkg_add -v -"</b>
</pre>

<pre class="screen-output">
local: | pkg_add -v - remote:bash-2.04-static.tgz
227 Entering Passive Mode
(192,168,101,77,4,166).
125 Data connection already open; Transfer starting.
226 Transfer complete.
1151567 bytes received in 1.09 seconds (1.01 MB/s)
</pre>

<pre class="command-line">
ftp&gt; <b>quit</b>
</pre>