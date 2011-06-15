## Graphs - Common Flow view with FlowScan/CUFlow 

&#91;Ref: OpenBSD 4.8 amd64, 4.9 amd64 & i386, [flow-tools](http://code.google.com/p/flow-tools/), [Network Flow Analysis](http://networkflowanalysis.com "Michael W. Lucas' book 'Network Flow Analysis'")]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#1">Cflow.pm</a>
		<ul>
			<li>Build the flow-tools Ports Tree Source</li>
			<li>Get the Source</li>
			<li>Extract the Source</li>
			<li>Compiling</li>
			<li>Verifying Build</li>
		</ul>
	</li>
	<li><a href="#2">Prerequisites</a>
		<ul>
            <li>Packages</li>
			<li>Perl CPAN Modules</li>
            <li>Other Perl Modules</li>
		</ul>
	</li>
	<li><a href="#3">FlowScan</a>
		<ul>
			<li>Get the Source</li>
			<li>Build and Install</li>
			<li>Create Account and Paths</li>
			<li>Configuration - FlowScan</li>
		</ul>
	</li><li><a href="#4">CUFlow</a>
		<ul>
			<li>Get the Source</li>
			<li>CUGrapher</li>
		</ul></li>
	<li><a href="#5">Execution</a>
		<ul>
			<li>Capturing netflow</li>
		</ul>
	</li>		
</ol>

</div>

Pretty pictures are always nice, and sometimes they assist the human
mind to make better decisions. Two tools discussed in these notes
are: FlowScan and CUFlow based on Perl present their output using 
a web server. Because of the dependency of various Perl modules,
we will implement a quick solution which requires running
Apache non-chroot.

These installation notes augment [Network Flow Analysis](
http://networkflowanalysis.com "Michael W. Lucas' book 'Network Flow Analysis'")
with more particulars about the OpenBSD installation/configuration process.

Dependency. The Graphical Analysis tools CUFlow, and FlowScan are built on top of another tool 
Cflow.pm. FlowScan analyses the data and generate some summary use data that
is presented using your web server, and viewable through an Internet Browser.
CUFlow presents its summarisation as charts providing two different views of
your data flow. 

**Important**, FlowScan will **delete the data after analysis**. We do not want to lose 
our historical data (because we know we can already analyse that historical data
using flow-tools.) We must analyse a copy of the data, and not the archives.

We continue with the installation guide for the following tools:

1.	Cflow.pm install
2.	FlowScan install
3.	CUFlow install

### <a name="1">1. </a> Cflow.pm

Cflow.pm is a pre-requisite for the data  flow analysis tools, but [Dave Plonka](http://net.doit.wisc.edu/~plonka/)'s Cflow perl module at: 
[http://net.doit.wisc.edu/~plonka/Cflow/](http://net.doit.wisc.edu/~plonka/Cflow/)
is a little convoluted to install. Hopefully, the below notes will give you
enough noise that if it doesn't work, at least you'll have material
to hopefully discover how to configure it on your system.

To **compile the Cflow.pm toolset**, we need to use compiled components
of the *flow-tools toolkit*. The sane technique we are going to use
is to compile the *flow-tools* source, in the OpenBSD ports system.

- Build the Ports tree source
- Get the Source
- Extract the Source
- Compile
- Verify Build

A quick run-down of what we'll need to get the software installed.

- Configure the [ports system](http://www.openbsd.org/faq/faq15.html) for source build
- [http://net.doit.wisc.edu/~plonka/Cflow/](http://net.doit.wisc.edu/~plonka/Cflow/)]

#### Build thePorts tree source

This sections assumes you have the ports system on your machine, or
on another same architecture machine. Using the ports build system,
is our shortcut to ensure the $!OpenBSD!$ standard layouts (encapsulated
in the port) are maintained in our source build.

<pre class="command-line">
# cd /usr/ports/net/flow-tools
# make
</pre>

This choice, is to ensure the flow-tools source has now been built with the
correct configurations for OpenBSD. In OpenBSD 4.8, 4.9 etc, compiled Ports 
are stored under the path: /usr/ports/pobj, so to find the compiled flow-tools, 
take a look at:

<pre class="command-line">
/usr/ports/pobj/flow-tools-0.68.5/flow-tools-0.68.5/
</pre>

In the above directory, will be the text file ./contrib/README 
which provides further information for compiling extensions
to the flow-tools toolkit (such as Cflow.pm)

#### Get the Source

&#91;Ref: [http://net.doit.wisc.edu/~plonka/Cflow/](http://net.doit.wisc.edu/~plonka/Cflow/)]

There is no package for Cflow.pm, so we need to download the source files and compile it.
The above page shows the current(?) release which you can then download.

<pre class="command-line">
# cd /path-to-local-src/
# curl -O http://net.doit.wisc.edu/~plonka/Cflow/Cflow-1.053.tar.gz
</pre>
<pre class="screen-output">
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 42007  100 42007    0     0  18839      0  0:00:02  0:00:02 --:--:-- 27874
</pre>

#### Extract the source

Extract the contents of the downloaded archive file.

<pre class="command-line">
# cd /usr/ports/pobj/flow-tools-0.68.5/flow-tools-0.68.5/contrib/
# tar -zxvf /path-to-local-src/Cflow-1.053.tar.gz
</pre>
<pre class="screen-output">
Cflow-1.053
Cflow-1.053/Cflow.xs
Cflow-1.053/cflow5.h
Cflow-1.053/Cflow.pm
Cflow-1.053/MANIFEST
Cflow-1.053/Makefile.PL
Cflow-1.053/Changes
Cflow-1.053/COPYING
Cflow-1.053/test.pl
Cflow-1.053/README
Cflow-1.053/flowdumper.PL
</pre>

#### Compiling

Notes for compiling the Cflow.pm toolkit is included in
the file Cflow-version/README. 

- 	The Cflow.pm package needs to be compiled from within 
	the 'contrib' directory of the flow-tools source.

Other instructions for the compilation did not work for me,
and the following few modifications were needed 
against the configuration file: Makefile.PL

<pre class="config-file">
--- Makefile.PL.org     Tue Feb 15 22:33:05 2011
+++ Makefile.PL Tue Feb 15 22:37:49 2011
@@ -42,10 +42,10 @@
 sub find_flow_tools {
    my($ver, $dir);
    my($libdir, $incdir);
-   if (-f '../../lib/libft.a') {
+   if (-f '/usr/local/lib/libft.a') {
       $dir = '../../lib';
       $incdir = "-I$dir -I$dir/..";
-      $libdir = "-L$dir";
+      $libdir = "-L/usr/local/lib";
    }
    if ("$libdir") {
       print "Found flow-tools... using \"-DOSU $incdir $libdir -lft -lz\".\n";
</pre>

Without the above changes, the flowdumper program cannot
find libft.a and displays no output or causes a Segmentation Fault.

After the above changes to Makefile.PL, we build the make configuration Makefile and 
run a 'make' and install.

<pre class="command-line">
$ perl Makefile.PL
</pre>
<pre class="screen-output">
Checking if your kit is complete...
Looks good
Found flow-tools... using "-DOSU -I../../lib -I../../lib/.. -L/usr/local/lib -lft -lz".
Note (probably harmless): No library found for -lnsl
Writing Makefile for Cflow
</pre>

<pre class="command-line">
$ make
</pre>
<pre class="screen-output">
cp Cflow.pm blib/lib/Cflow.pm
AutoSplitting blib/lib/Cflow.pm (blib/lib/auto/Cflow)
/usr/bin/perl /usr/libdata/perl5/ExtUtils/xsubpp  -typemap /usr/libdata/perl5/ExtUtils/typemap  Cflow.xs > Cflow.xsc && mv Cflow.xsc Cflow.c
cc -c  -I../../lib -I../../lib/..  -DOSU -O2     -DVERSION=\"1.053\"  -DXS_VERSION=\"1.053\" -DPIC -fPIC "-I/usr/libdata/perl5/amd64-openbsd/5.10.1/CORE"   Cflow.c
Running Mkbootstrap for Cflow ()
chmod 644 Cflow.bs
rm -f blib/arch/auto/Cflow/Cflow.so
LD_RUN_PATH="/usr/local/lib:/usr/lib" cc  -shared -fPIC  -fstack-protector Cflow.o  -o blib/arch/auto/Cflow/Cflow.so      -L/usr/local/lib -lft -lz 
chmod 755 blib/arch/auto/Cflow/Cflow.so
cp Cflow.bs blib/arch/auto/Cflow/Cflow.bs
chmod 644 blib/arch/auto/Cflow/Cflow.bs
/usr/bin/perl "-Iblib/arch" "-Iblib/lib" flowdumper.PL flowdumper
cp flowdumper blib/script/flowdumper
/usr/bin/perl -MExtUtils::MY -e 'MY->fixin(shift)' -- blib/script/flowdumper
Manifying blib/man1/flowdumper.1
Manifying blib/man3/Cflow.3p
</pre>

<pre class="command-line">
$ sudo make install
</pre>
<pre class="screen-output">
Manifying blib/man1/flowdumper.1
Files found in blib/arch: installing files in blib/lib into architecture dependent library tree
Appending installation info to /usr/libdata/perl5/amd64-openbsd/5.10.1/perllocal.pod
</pre>

The difficult part is done.

#### Verifying Build

Verify the Cflow.pm build/install, by running flowdumper on one
of you netflow data files.

<pre class="command-line">
$ flowdumper ft-v05.2011-02-13.075500+1100
</pre>

I've encountered 3 possible results when running flowdumper after the
above "make install"

-	Successful Execution
-	Failure No Output
-	Failure undefined symbol

##### a. Successful Execution

<pre class="command-line">
$ flowdumper ft-v05.2011-02-13.075500+1100 | head -20
</pre>
<pre class="screen-output">
FLOW
  index:          0xc7ffff
  router:         IP-Address
  src IP:         192.168.112.130
  dst IP:         192.168.18.57
  input ifIndex:  0
  output ifIndex: 0
  src port:       1478
  dst port:       80
  pkts:           3
  bytes:          128
  IP nexthop:     0.0.0.0
  start time:     Sun Feb 13 07:49:12 2011
  end time:       Sun Feb 13 07:49:12 2011
  protocol:       6
  tos:            0x0
  src AS:         0
  dst AS:         0
  src masklen:    0
  dst masklen:    0
</pre>

Get an explanation of what the above display means from 
<a href="http://networkflowanalysis.com" title="Michael W. Lucas' book 'Network Flow Analysis'">Network Flow Analysis.</a>

##### b. Failure No Output

No output.

Implication: libft.a did not link, you may need to hardcode
the location of libft.a, as in the first part of the above
patch.

##### c. Failure undefined symbol

<pre class="screen-output">
$ flowdumper /tmp/ft-v05.2011-02-13.075500+1100 | head -20
/usr/bin/perl:/usr/local/libdata/perl5/site_perl/amd64-openbsd/auto/Cflow/Cflow.so: undefined symbol 'fterr_setid'
lazy binding failed!
Segmentation fault (core dumped)
</pre>

Implication: The binary is not finding the runtime libraries it needs to
complete execution. You need the second change in the above
patch.

### <a name="2">2. </a>Prerequisites

There are a number of prerequisites highlighted in Michael W. Lucas' book ["Network Flow Analysis"](http://networkflowanalysis.com),
that need to be installed for FlowScan/CUFlow. Most can be installed with the
standard OpenBSD Package Binaries, others with Perl's own CPAN packaging
system, with only a few requiring more involved manual configuration,
installation.

The Packages

-   RRDtool (rrdtool from packages, includes dependencies such as: png and libart)
-   Perl Interface to RRD (p5-RRD from packages)
-   Perl Interpreter for Apache (mod_perl from packages, includes dependencies such as: HTML-Tagset, 
    HTML-Parser, libghttp, HTTP-GHTTP, Crypt-SSLeay, URI, libwww)

The Perl CPAN Modules

-   XML::Parser (required by Boulder::Stream)
-   Boulder::Stream
-   HTML::Table
-   Net::Patricia (installation may install dependencies, 
    Net::CIDR::Lite, Socket6)

Other Perl Modules
    
-   Cflow.pm (we already installed that above)
-   ConfigReader::DirectiveStyle 

#### The Packages

Install the OpenBSD binary packages listed above from your nearest OpenBSD packages mirror.

If you forget, you can take a look at some of the requirements after installing
packages. For example,

<!--(block|syntax("bash"))-->
$ cat /var/db/pkg/mod_perl-1.31p2/+DISPLAY
<!--(end)-->
<pre class="screen-output">
...

  /usr/local/sbin/mod_perl-enable
...
</pre>

#### The Perl CPAN Modules

On first attempt, I tried using the binary Packages, but enough of them and
their dependencies were revisions behind what was needed. I've listed here
the modules which worked after installing through Perl's CPAN.

<pre class="command-line">
$ sudo perl -MCPAN -e shell
</pre>
<pre class="screen-output">
Terminal does not support AddHistory.

cpan shell -- CPAN exploration and modules installation (v1.9402)
Enter 'h' for help.
</pre>
<pre class="command-line">
cpan[1]> install XML::Parser
cpan[2]> install Boulder::Stream
cpan[3]> install HTML::Table
cpan[4]> install Net::Patricia
cpan[5]> quit
</pre>

Some packages may install dependencies (such as Socket6 and Net::CIDR::Lite by Net::Patricia)
while others may require manual dependency installation (such as XML::Parser which is required by Boulder::Stream)

Remember that you have to watch the screen-output from the installation to ensure
that all the requested modules are downloaded successfully, built successfully, 
verified successfully, and installed successfully. If a module doesn't
install correctly, you'll have unknown other problems going forward until
this is resolved.

A *"sort-of list" of installed Perl Modules is sometimes available in the directory
path:

<!--(block | syntax("bash") )-->
$ export PMPATH=/usr/local/libdata/perl5/site_perl
$ (cd $PMPATH; find . -name "*.pm" -print)
<!--(end)-->

#### Other Perl Modules

The two dependencies that require manual processing are:

- Cflow.pm, and
- ConfigReader::DirectiveStyle

##### Cflow.pm

Cflow.pm we've already installed with the above instructions.

##### ConfigReader::DirectiveStyle 

<blockquote>
ConfigReader is a set of classes for reading configuration files.
</blockquote>

Get the source from the <a title="Andrew Wilcox">author's</a>  
[CPAN homepage](http://cpan.perl.org/authors/id/A/AM/AMW/)

<pre class="command-line">
$ cd /path-to-local-src
$ curl -O http://cpan.perl.org/authors/id/A/AM/AMW/ConfigReader-0.5.tar.gz
</pre>
<pre class="screen-output">
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 17592  100 17592    0     0  17350      0  0:00:01  0:00:01 --:--:-- 26335
</pre>
<pre class="command-line">
$ cd /tmp
$ tar -zxf /path-to-local-src/ConfigReader-0.5.tar.gz
$ sudo mv ConfigReader-0.5 /usr/local/libdata/perl5/site_perl/`uname -m`-openbsd/ConfigReader
</pre>

Where *uname -m* is the architecture you're on (such as i386, amd64)

### <a name="3">3. </a> FlowScan

&#91;Ref: [FlowScan Homepage](http://net.doit.wisc.edu/~plonka/FlowScan/), [flowscan.pm](http://net.doit.wisc.edu/~plonka/list/flowscan/archive/att-0848/01-FlowScan.pm)]

[Dave Plonka](http://net.doit.wisc.edu/~plonka/)'s FlowScan is a 
"freely-available Internet traffic measurement and analysis tool"

<div clas="toc">

<ul>
	<li>Get the Source</li>
	<li>Build and Install</li>
	<li>Create Account and Paths</li>
	<li>Configuration</li>
</ul>
   
</div>

#### a. Get the source from the author's site

There are two source packages we need to retrieve, 

-   the full FlowScan source release, and an
-   updated Perl pm for FlowScan.pm (version 1.6)

The latest release
[FlowScan-1.006.tar.gz](http://net.doit.wisc.edu/~plonka/FlowScan/FlowScan-1.006.tar.gz) 
is listed at the [FlowScan Home Page](http://net.doit.wisc.edu/~plonka/FlowScan/)

<pre class="command-line">
$ cd /path-to-local-src
$ curl -O http://net.doit.wisc.edu/~plonka/FlowScan/FlowScan-1.006.tar.gz
</pre>

Download using your preferred method.

The latest [FlowScan.pm](http://lmgtfy.com/?q=FlowScan.pm Dave Plonka 1.6)
may require searching on the Internet, with version 1.6 current
at the time of this install example.

[Google](http://lmgtfy.com/?q=FlowScan.pm+Dave+Plonka+1.6) or
[Bing](http://www.letmebingthatforyou.com/?q=FlowScan.pm Dave Plonka 1.6) for 
"FlowScan.pm 1.6 Dave Plonka"

On both services, the 1st result is the actual Perl file.

<!--(block  | syntax("bash") )-->
$ curl -o FlowScan.pm \
  http://net.doit.wisc.edu/~plonka/list/flowscan/archive/att-0848/01-FlowScan.pm
<!--(end)-->

#### b. Create Account and Paths

The path permissions will be important, so we'll create the user account and
some paths at the onset, and then populate them during the software installation,
configuration.

<!--(block  | syntax("bash") )-->
$ sudo /usr/sbin/groupadd _flowscan
$ sudo /usr/sbin/useradd -mvd /var/netflow/scan \
   -c "FlowScan Daemon" -L "default" -g _flowscan \
   -s /sbin/nologin _flowscan
<!--(end)-->

If you've already created the directory /var/netflow/scan, then you
may need to re-run useradd without the "-m" option.

To continue, we'll create some preliminary paths that will be used
during the installation.

<!--(block  | syntax("bash") )-->
$ sudo touch /var/log/flowscan.sensorXY.log
$ sudo chown _flowscan /var/log/flowscan.sensorXY.log
<!--(end)-->

Obviously, if you're only going to run/flowscan one sensor, then you don't 
need the .sensorXY in your log file.

#### c. Build and Install

Review [Network Flow Analysis](http://networkflowanalysis.com "Michael W. Lucas' book 'Network Flow Analysis'") for rationales

For our exercise, we're choose to install within our _flowscan home directory
/var/netflow/scan, with a sub-directory for the sensor. Again, if you're only
ever using a single sensor then you may choose to ignore that sub-directory.

<!--(block | syntax("bash") )-->
$ export DESTINATION=/var/netflow/scan/sensorXY
<!--(end)-->

For each netflow sensor *sensorXY* we can follow the below build, install instructions.
(or just copy the resulting bin folder to each sensor)

<!--(block  | syntax("bash") )-->
$ cd /tmp
$ tar -zxf /path-to-local-src/FlowScan-1.006.tgz
$ cd FlowScan-1.006
$ ./configure --prefix=${DESTINATION}
<!--(end)-->

During configuration you will get an error message of the form:

<pre class="screen-output">
checking that service name for 80/tcp is http... no
configure: error: Please change /etc/services so 
that the service name for 80/tcp is http with alias www
</pre>

Which must be resolved by updating the file: /etc/services with
something like the below diff:

<!--(block | syntax("bash"))-->
--- /etc/services.org   Wed Feb 16 03:15:53 2011
+++ /etc/services       Wed Feb 16 03:16:09 2011
@@ -50,7 +50,7 @@
 gopher         70/udp
 rje            77/tcp          netrjs
 finger         79/tcp
-www            80/tcp          http    # WorldWideWeb HTTP
+http           80/tcp          www     # WorldWideWeb HTTP
 www            80/udp                  # HyperText Transfer Protocol
 link           87/tcp          ttylink
 kerberos       88/udp          kerberos-sec    # Kerberos 5 UDP
<!--(end)-->

Complete the configuration, and install

<!--(block | syntax("bash"))-->
$ ./configure --prefix=${DESTINATION}
$ sudo make install
<!--(end)-->
<pre class="screen-output">
test -d ${DESTINATION}/bin || /bin/mkdir -p ${DESTINATION}/bin
install-sh -c flowscan ${DESTINATION}/bin
install-sh -c FlowScan.pm ${DESTINATION}/bin
install-sh -c CampusIO.pm ${DESTINATION}/bin
install-sh -c SubNetIO.pm ${DESTINATION}/bin
install-sh -c util/locker ${DESTINATION}/bin
install-sh -c util/add_ds.pl ${DESTINATION}/bin
install-sh -c util/add_txrx ${DESTINATION}/bin
install-sh -c util/event2vrule ${DESTINATION}/bin
install-sh -c util/ip2hostname ${DESTINATION}/bin
</pre>

The FlowScan software is now installed in ${DESTINATION}/bin. 
This path structure is to allow us to have multiple installs of flowscan for various
sensors (under the /var/netflow/scan path.)

The sample configuration files are not copied during installation,
so do this now

<!--(block  | syntax("bash") )-->
cp /tmp/FlowScan-1.006/cf/flowscan.cf ${DESTINATION}/bin
<!--(end)-->

Create sub-paths to be used in data recording, analysis.

<!--(block | syntax("bash"))-->
$ sudo mkdir -p ${DESTINATION}/data
$ sudo mkdir -p ${DESTINATION}/rrd

$ sudo chown -R _flowscan ${DESTINATION}
<!--(end)-->

##### Update FlowScan.pm to v. 1.6

There's a relevant reason (since we're using flow-tools/netflow) that we
need the 1.6 release of FlowScan.pm and not the 1.5 released in the release.

-   Copy the above download FlowScan.pm file (v. 1.6) to overwrite
    the installed FlowScan-1.0.0.6 v. 1.5 release.

<!--(block | syntax("bash"))-->
$ sudo cp /path-to-local-src/FlowScan.pm ${DESTINATION}/bin/
<!--(end)-->
    
If you can't get the v. 1.6 release, the following are my modifications to 
FlowScan.pm v 1.5 that worked with my installation (i.e. did not use FlowScan.pm v 1.6)

<pre class="command-line">
--- FlowScan.pm.org Mon Feb 12 07:41:47 2001
+++ FlowScan.pm      Wed Jan  5
16:49:09 2011
@@ -105,6 +105,20 @@
       }
       mutt_normalize_time(@tm);
       return mutt_mktime(@tm, -1, 0)
+   } elsif ($file =~
+            m/(\d\d\d\d)-(\d\d)-(\d\d).(\d\d)(\d\d)(\d\d)([+-])(\d\d)(\d\d)/) {
+      # The file name contains an "hours east of GMT" component
+      my(@tm) = ($6, $5, $4, $3, $2-1, $1-1900, 0, 0, -1);
+      my($tm_sec, $tm_min, $tm_hour, $tm_mday, $tm_mon, $tm_year,
+        $tm_wday, $tm_yday, $tm_isdst) = (0 .. 8); # from "man perlfunc"
+      if ('+' eq $7) { # subtract hours and minutes to get UTC
+        $tm[$tm_min] -= 60*$8+$9
+      } else { # add hours and minutes to get UTC
+        $tm[$tm_min] += 60*$8+$9
+      }
+      mutt_normalize_time(@tm);
+      return mutt_mktime(@tm, -1, 0)
+
    } elsif ($file =~ m/(\d\d\d\d)(\d\d)(\d\d)_(\d\d):(\d\d):(\d\d)$/) {
       # The file name contains just the plain old localtime
       return mutt_mktime($6, $5, $4, $3, $2-1, $1-1900, 0, 0, -1, 1)
</pre>

The above changes/patch was to factor for the different file format used on
my set up for storing flows on the hard drive.

#### d. Configuration - FlowScan

Update the file **flowscan.cf** to specify the paths we've
specified in our install.

-   FlowFileGlob
-   ReportClasses

##### FlowFileGlob

Be explicit with the directory path.

<pre class="config-file">
FlowFileGlob /var/netflow/scan/sensorXY/data/ft-v*[0-9]
</pre>

##### ReportClasses

We're not going to use the default sample configuration (CampusIO) 
and need to insert here that we are going to be using CUFlow.

<!--(block  | syntax("apache") )-->
#ReportClasses CampusIO
ReportClasses CUFlow
<!--(end)-->

Of course, we haven't installed CUFlow yet, so we can't really test
some of this until CUFlow is fully installed and configured.

##### Verbose

It's good to note that you can generate a lot more visible 'noise' during
initial install/testing by using the variable Verbose.

<!--(block  | syntax("apache") )-->
Verbose 1
<!--(end)-->

Use this as you see fit, but do use it.

#### Configuration - Apache

The FlowScan Reports, and other graphical views of the netflow data
are principally through a web browser. FlowScan reports are functional
in OpenBSD's default chroot'd Apache Web Server, the below is a sample 
configuration modification to a Apache's configuration
file.

File extract: /var/www/conf/httpd.conf

<!--(block  | syntax("apache") )-->
Alias /flowscan/ "/var/www/flowscan/"

<Directory "/var/www/flowscan">
	Options Indexes MultiViews
	AllowOverride None
	Order allow,deny
	Allow from all
</Directory>
<!--(end)-->

Some shell administration you may need to carry out.

<!--(block | syntax("bash") )-->
$ sudo mkdir -p /var/www/flowscan
$ sudo chown _flowscan /var/www/flowscan
<!--(end)-->
### <a name="4">4. </a>CUFlow

#### Get the Source

&#91;Ref: [CUFlow Home Page](http://www.columbia.edu/acis/networks/advanced/CUFlow/CUFlow.html)]

- Link to [Directory listing](http://www.columbia.edu/acis/networks/advanced/CUFlow/)

Extract and copy the files CUFlow.cf and CUFlow.pm to the above FlowScan *bin* 
directory: (/var/netflow/scan/bin/sensorXY)


<!--(block  | syntax("bash") )-->
$ cd /path-to-local-src/
$ curl -O http://www.columbia.edu/acis/networks/advanced/CUFlow/CUFlow-1.7.tgz
$ cd /tmp
$ tar -zxvf /path-to-local-src/CUFlow-1.7.tgz
$ cd CUFlow-1.7
$ sudo cp CUFlow.pm ${DESTINATION}/bin
$ sudo cp CUFlow.cf ${DESTINATION}/bin
$ sudo cp CUGrapher.pl /var/www/cgi-bin/CUGrapher_sensorXY.pl
<!--(end)-->

Create paths relevant to our below CUFLow configuration.

<!--(block  | syntax("bash") )-->
$ export CUFlow_D=/var/www/flowscan/sensorXY
$ sudo mkdir ${DESTINATION}/rrd
$ sudo mkdir ${CUFlow_D}/reports
$ sudo mkdir ${DESTINATION}/scoreboard

$ sudo chown -R _flowscan ${DESTINATION}
$ sudo chown -R _flowscan ${CUFlow_D}
<!--(end)-->

The following needs to be customised for your environment.

Modify File: ${DESTINATION}/bin/CUFlow.cf

<table>
	<tr>
		<th>Configuration</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>Subnet</td>
		<td>"Local" subnets for differentiation between "sides" of the edge device.
		</td>
	</tr>
	<tr>
		<td>Network</td>
		<td>Named network segments for tracking by label.	
		</td>
	</tr>
	<tr>
		<td>OutputDIR</td>
		<td>Storage location for RRD Data files (e.g. ./rrd)
		</td>
	</tr>
	<tr>
		<td>Scoreboard</td>
		<td>A top X usage style of report per data flow archive.
        
        <p>Note, the default configuration uses filsystem links to connect
        the linked "topXXX.html" file to the archival report. This will
        not work as expected from a browser</p>
        
        </td>
	</tr>
	<tr>
		<td>AggregateScore</td>
		<td>Aggregate Top X usage style of report
		</td>
	</tr>
	<tr>
		<td>Router</td>
		<td>Identify different sensors (edge-devices) collated
		in this flow data.
		</td>
	</tr>
	<tr>
		<td>Service</td>
		<td>Named Service ports (TCP/IP) to track by label.
		</td>
	</tr>
	
</table>

<pre class="config-file">
# -- note in this config, ${CUFlow_D}, ${DESTINATION} are not valid values
# --      you must manually substitute ${CUFlow_D}, ${DESTINATION} into your
# --      configuration file.

Subnet 10.1.0.0/24

Network 10.0.0.0/24 servers
Network 10.0.0.38 domain_server

OutputDir ${DESTINATION}/rrd

Scoreboard 10 ${CUFlow_D}/reports ${CUFlow_D}/topten.html

AggregateScore 50 ${DESTINATION}/scoreboard/agg.dat ${CUFlow_D}/overall.html

Router 10.0.0.1 sensorXY

Service 22/tcp,22/udp ssh
Service 80/tcp,8000/tcp,8080/tcp,8081/tcp http
Service 443/tcp https
Service 1433/tcp,1433/udp mssqlserver
</pre>	

#### CUGrapher.pl

FlowScan gives us some numerical tables in 
http://myserver/flowscan/sensorXY/topten.html and overall.html
and charts/graphs the default with CUGrapher.pl. We have copied it to 
our cgi-bin directory, differentiated between separate sensors by the
naming conventions (e.g. CUGrapher_sensorXY.pl) 

Modify the file to reflect your path environment.

File: /var/www/cgi-bin/CUGrapher_sensorXY.pl

<!--(block  | syntax("perl") )-->
my $rrddir = "/var/netflow/scan/sensorXY/rrd";
my $organization = "sensorXY @ my.com";
print $q->header, $q->start_html( -title => 'sensorXY - CUGrapher',
                                      -bgcolor => 'ffffff' );
<!--(end)-->

The graphs can be very difficult to read, so for those with large
monitors (or don't mind scrolling) an easier to interpret graph
is available by just bumping up the graph dimensions.

<!--(block  | syntax("perl") )-->
my $width = 1200;
my $height = 800;
<!--(end)-->

Likewise, we're sometimes called to review the "current" traffic
patterns, and it's nice to be able to automatically generate 
graphs for shorter timelines.

<!--(block  | syntax("perl") )-->
    my %hours = ( 1  => '1 hours',
                 2 => '2 hours',
                 3 => '3 hours',
                 6 => '6 hours',
                 24 => '24 hours',
                 36 => '36 hours',
                 48 => '48 hours',
                 168 => '1 week',
                 720 => '1 month',
                 1440 => '2 month',
                 8766 => '1 year' );
<!--(end)-->

### <a name="5"></a> 5. Execution

We've created the relevant paths, and configuration files
so it's time to start flowscan to analyse the tools so
we can start looking at some of the graphs.

<ul>
	<li>rotate script</li>
	<li>startup script</li>
	<li>autostart script</li>
	<li>FlowScan GUI</li>
	<li>CUFlow GUI</li>
</ul>

#### rotate script

Remember, how we talked about flowscan deleting files after
analysis? [^top](# "back to the top")

To compensate for this 'feature' we need to use flow-capture's 
[ -R rotate_program ] option to make a copy of the data. That
copied data will be what we work on.

<pre class="manpage">
-R rotate_program
   Execute rotate_program with the first argument as the flow file
   name after rotating it.
</pre>

Our simple copy shell-script will look something like this:

File: ${DESTINATION}/bin/rotate.sh

<!--(block | syntax("bash", linenos=True) )-->
#!/bin/sh
DESTINATION=/var/netflow/scan/sensorXY
cp $1 ${DESTINATION}/data 
<!--(end)-->

#### Startup Script

To simplify repeated executions of flowscan (and to capture the
requirements for effectively launching it) we use a startup script 
that sets up the execution user and generate logs. We
can monitor the log to review application execution:

File: ${DESTINATION}/bin/startup.sh

<!--(block  | syntax("bash", linenos=True) )-->
#!/bin/sh
SENSOR=sensorXY
USER=_flowscan
SCAN=/var/netflow/scan
BIN=${SCAN}/${SENSOR}/bin
LOG=/var/log/flowscan.${SENSOR}.log

nohup sudo -u ${USER} ${BIN}/flowscan > $LOG 2>&1 &
<!--(end)-->

The startup command gives us an early target for review
flowscan diagnostic/error messages, just look at the 
generated log file.

Run the script and review the log file to ensure the
configuration file settings are parsed correctly etc.

#### autostart script

We now have the components needed to launch flowscan with each
restart of our host (just incase someone decides to move the
box, turn it off.)

We will add to the /etc/rc.local the following:

-	Use our previous flow-capture startup routine
-	Modify it to use -R and our script rotate.sh
-	Start the flowscan binary using our startup script 

File Excerpt: /etc/rc.local

<!--(block  | syntax("bash", linenos=True) )-->
NETFLOW_D=/var/netflow
SCAN=${NETFLOW_D}/scan
SENSOR=sensorXY
CAPTURE=/usr/local/bin/flow-capture
FLOWPID=/var/run/flow-capture.${SENSOR}.pid
ROTATE=${SCAN}/${SENSOR}/bin/rotate.sh
ipa_collector=XXX.XXX.XXX.XXX
ipa_sensor=XXX.XXX.XXX.XXX
port=12345

if [ -x ${CAPTURE} ]; then
    printf ' flow-capture'; ${CAPTURE} -p ${FLOWPID} -n 287 -w ${NETFLOW_D}/${SENSOR} \
		-R ${ROTATE} -S 5 ${ipa_collector}/${ipa_sensor}/${port} && \
        echo "\t\t [OK]" || echo "\t\t [Failed]";
fi

startup=${SCAN}/${SENSOR}/bin/startup.sh
if [ -f ${startup} ]; then
	printf ' flowscan'; sh $startup && echo "\t\t [OK]" || echo "\t\t [FAILED]";
fi
<!--(end)-->

Remember to put in the appropriate collector and sensor IP Addresses.