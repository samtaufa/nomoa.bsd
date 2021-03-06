## FlowViewer - Custom Graphs and Analysis

&#91;Ref: OpenBSD 4.8 amd64, 4.9 amd64 & i386]

<div class="toc">

Table of Contents

<ol>
	<li><a href="#prereq">Pre-requisites</a></li>
	<li><a href="#install">Install</a></li>
	<li><a href="#apache">Apache</a></li>
	<li><a href="#workflow">Workflow Sample</a>
		<ul>
			<li><a href="#flowviewer">FlowViewer</a></li>
			<li><a href="#flowgrapher">FlowGrapher</a></li>
			<li><a href="#flowtracker">FlowTracker</a></li>
		</ul></li>
</ol>

</div>

Now we have some analysis tools going, we have a basic workflow
for pro-active investigation of what's happening on our network:-

-	Smokeping shows a spike in traffic latency on your link.
-	CUFlow assists in isolating various parts of the traffc including:
    -   specific time period, 
    -   Networks and Servers (Network, Subnet)
    -   Protocol and Ports (Services)
-	Now what ?

Enter, FlowViewer (for those who don't want to investigate at
the command-line, flow-tools) and related tools FlowTracker,
FlowGrapher.

FlowViewer gives you a GUI front-end for interrogate the database
for quick analysis of the data. For our above scenario, you can 
quick drill through to see which hosts were generating the 
highest traffic at that time and to/from whom.

After the previous netflow analysis tools (flow-tools, flowscan, CUFlow)
installing FlowViewer is rather simplified.

- 	Install the Pre-requisites
-	Install Flowviewer
-	Configure Flowviewer

### <a name="prereq"></a> Pre-Requisites

Refer: [Michael W. Lucas' book "Network Flow Analysis."](
http://networkflowanalysis.com) which already identifies
minimal prerequisites to get our FlowViewer up and running.

Binary tools I install from OpenBSD Packages, but perl modules
may require installing from CPAN. PAN.

If you got here, without installing and testing the [FlowScan/CUFlow](
flow.flowscan.html), things should work but interpretation of data
will really need more support from the above book.

The Package Binaries

- 	RRDtool (rrdtool from packages, includes dependencies libiconv, jpeg)
- 	gd 2.0.35 (gd from packages )
- 	gd::graph (p5-GD-Graph from packages, includes dependencies p5-GD-TextUtil)
-   GDBM_File (p5-GDBM_File from packages, includes dependencies gdbm)
	
#### The Package Binaries

The binaries should be installable from the Ports/Packages.
Check the website for what services require the binaries,
whether you need them, but they are relatively easy to install
so while we're learning, just install everything.

In summary, we need the gd related tools for graphing (e.g. FlowGrapher)
and the RRD tool for Tracking, charting with tracking data.

### <a name="install"></a> Install

Ref: [FlowViewer](http://ensight.eos.nasa.gov/FlowViewer/)

As per the installation instructions ('cause I know you were reading it.)

1. 'Un-tar' FlowViewer_3.X.tar in an appropriate directory such as your web server's cgi-bin directory 
2. Modify the contents of FlowViewer_Configuration.pm for your environment. 
3. If you are going to use FlowGrapher, you will need to install both the GD and the GD::Graph packages for Perl. 
4. If you are going to use FlowTracker, you will need to install the RRDtool package (at least version 1.2.12.) Create FlowTracker_Filters and FlowTracker_RRDtool subdirectories. 
5. Point your web browser at either of FlowViewer.cgi, FlowGrapher.cgi, or FlowTracker.cgi and go ...   

Installation Tips 

1. If you do not embed your device name in the name of the directory that stores the raw flow data (e.g., you have only one device) set the @devices array to empty (i.e., @devices = "";) With version 3.3, you can now collect all devices to one directory, and sort by Exporter. 
2. Make sure that the FlowViewer 'reports', 'graphs', 'tracker', 'work', 'names', and 'log' (if you're logging) directories that you specify have adequate permissions (e.g., 0777) for the web server to write into them. 
3. Double check that you have configured the proper HTTP protocol (i.e., either HTTP (usually port 80), or HTTPS (usually port 443)). 
4. For FlowTracker make sure you install an RRDtool version that is 1.2.12 or later.  

#### Get the Source

Get the current release from the FlowViewer homesite
[(http://ensight.eos.nasa.gov/FlowViewer/)](http://ensight.eos.nasa.gov/FlowViewer/)
and follow the basic install instructions that comes with the software.

<pre class="command-line">
curl -O http://ensight.eos.nasa.gov/FlowViewer/FlowViewer_3.4.tar
</pre>

#### 1. Copy to Install

Untar/copy the files to our destination path: 

Normally, /var/www/cgi-bin/FlowViewer

#### 2. Modify FlowViewer_Configuration.pm

Simplicity means keeping things as they are defined by the
install. But, I'm insane enough to do these documentation
and have decided on my own 'path'ing. The following
sample shows installation modifications that have worked
with FlowViewer 3.3.1 and 3.4. Your Mileage May Vary (YMMV)

File: FlowViewer_Configuration.pm

<!--(block  | syntax("perl") )-->
$FlowViewer_server       = "10.0.0.2";     # (IP address or hostname)

$trackings_title         = "My Company Title";
$user_logo               = "My.Company.Logo.jpg";  # For a nice look make your logo 86 pixels high
$user_hyperlink          = "http://www.example.com/";

@devices                  = ("sensorXY");
#@exporters               = ("sensorXY_ipaddress:sensorXY Title");
<!--(end)-->

Set the Basic configuration of Service Title and what sensors are being reviewed.

File: FlowViewer_Configuration.pm

<!--(block  | syntax("perl") )-->
$fviewdocs               = "/var/www/flowviewer";
$fviewdocs_url		 = "/FlowViewer";
$fviewwork                = "/var/www/var/flowviewer";
$reports_directory       = "$fviewdocs";
$reports_short           = $fviewdocs_url;
$graphs_directory        = "$fviewdocs/FlowGrapher";
$graphs_short            = "$fviewdocs_url/FlowGrapher";
$tracker_directory       = "$fviewdocs/FlowTracker";
$tracker_short           = "$fviewdocs_url/FlowTracker";
$cgi_bin_directory       = "/var/www/cgi-bin/FlowViewer";
$cgi_bin_short           = "/cgi-bin/FlowViewer";
$work_directory          = "$fviewdocs/FlowWorking";
$work_short              = "$fviewdocs_url/FlowWorking";
$save_directory          = "$fviewdocs";
$save_short              = "$fviewdocs_url";
$names_directory         = "$fviewwork/names";
$filter_directory        = "$fviewwork/filters";
$rrdtool_directory       = "$fviewwork/rrd";
<!--(end)-->

Set the directories where files are to be stored (X_directory), 
and the URL (X_short) matched to that directory.

File: FlowViewer_Configuration.pm

<!--(block  | syntax("perl") )-->
$flow_data_directory     = "/var/netflow";
$exporter_directory      = "/var/www/var/flowviewer/exporter";
$flow_bin_directory      = "/usr/local/bin";
$rrdtool_bin_directory   = "/usr/local/bin";

$log_directory           = "/var/www/var/flowviewer/log";
<!--(end)-->

Make sure that the data and binary folders are correct for
your configuration. The binaries on a regular install
(using ports/packages) for OpenBSD should be as in the
above.

During the initial startup of the CGI scripts, they will attempt to
create the relevant reporting paths. 

You will need to ensure that all paths from the above are valid
for your configuration. The below sample script creates paths for
the above configuration set permissions where appropriate:

<!--(block  | syntax("bash") )-->
fviewdocs=/var/www/flowviewer
fviewwork=/var/www/var/flowviewer
for d in FlowGrapher FlowTracker FlowWorking; \
    do mkdir -p $fviewdocs/$d/; chmod -R a=rwx $fviewdocs/$d/; done
for d in names filters rrd exporter log; \
    do mkdir -p $fviewwork/$d/; chmod -R a=rwx $fviewwork/$d/; done
<!--(end)-->

Of course, you need to realise what changing the above will do. Review, try and if it 
doesn't work for you, fix-it and try again (tm)

Copy your images to the new "working-directories"

<!--(block  | syntax("bash") )-->
cp My.Company.Logo.jpg $fviewdocs
cp /var/www/cgi-bin/FlowViewer/FlowViewerS.png $fviewdocs
<!--(end)-->

#### Startup

To make use of the FlowTracker and FlowGrapher, we need to start the
daemons to collate the data.

Updates to */etc/rc.local*

<!--(block  | syntax("bash") )-->
PERL5LIB=/var/www/cgi-bin/FlowViewer/ /var/www/cgi-bin/FlowViewer/FlowTracker_Collector \
	>> /var/log/FlowTracker_Collector.log 2>&1 &
PERL5LIB=/var/www/cgi-bin/FlowViewer/ /var/www/cgi-bin/FlowViewer/FlowTracker_Grapher \
	>> /var/log/FlowTracker_Grapher.log 2>&1  &
<!--(end)-->

### <a name="apache"></a> Apache

Customising your configuration, is basically choosing what paths
you want to show on your browser. The classic example is
a straight out alias using the Capitalisation of the application
name FlowViewer.

File extract: /var/www/conf/httpd.conf

<!--(block  | syntax("apache") )-->
Alias /FlowViewer/ /var/www/flowviewer/

<Directory /var/www/flowviewer/>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    Allow from [list.of.ips.you.trust]
</Directory>
<!--(end)-->

As noted in the above, working files are in the path
/var/www/flowviewer/

And now, we can point our browser to the above site to start looking
at reports:

<pre class="config-file">
http://collector-ip-address/cgi-bin/FlowViewer/FlowViewer.cgi
</pre>

Fortunately, that single online URL can connect you to other
parts of the toolkit.

#### Chroot

Remember that OpenBSD's default Apache instance runs in the $!manpage("chroot",2)!$ 
environment. To use FlowViewer, disable this environment using the "-u" option.

<pre class="manpage">
-u      By default httpd will $!manpage("chroot",2)!$ to the ``ServerRoot'' path.  The
		-u option disables this behaviour, and returns httpd to the
		expanded "unsecure" behaviour.
</pre>

If you're really paranoid, you could configure all the relevant tools to work within
a chroot'd environment.

#### /var/www/var

Some directories may not have been, or permissions not useable.

Review the /var/www/log/error_log file

### <a name="workflow"></a> Workflow Sample

A simple, active monitoring day's activities could revolve such as the scenario below:

- Isolate hosts/traffic in question using FlowViewer
- View historic chart of  host/traffic behaviour using FlowGrapher
- Track continued behaviour of that host/traffic pattern using FlowTracker

#### <a name="flowviewer"></a>FlowViewer

FlowViewer is good for getting snapshot views of traffic behaviour, whether the
snapshot is 5 minutes or 10 days. It is a good way of isolating the hosts, 
patterns of heavy use such that we can isolate further points of investigation.

#### <a name="flowgrapher"></a>FlowGrapher

To view historical data on the identified traffic pattern, we can use FlowGrapher
to generate a chart to give us a better view of previous behaviour.

#### <a name="flowtracker"></a>FlowTracker

Love using this feature to justify what modifications may or may not
be required on the infrastructure.

### <a name="rel.links"></a> Relative Links

Other links that may be relevant, or give better clues.

-	[Pierky's](http://pierky.wordpress.com/) [
	How to install and configure flwo-tools and FlowViewer on a fresh Debian setup](
	http://pierky.wordpress.com/2010/03/06/netflow-how-to-install-and-configure-flow-tools-and-flowviewer-on-a-fresh-debian-setup/)
