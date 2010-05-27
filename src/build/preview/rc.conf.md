##  System Startup

<div style="float:right">

    Table of Contents
    
    <ul>
      <li><a href="#rc.conf.local">Localised Configuration</a> 
        <ul>
          <li><a href="#Section1" class="anchBlue">Section 1 Turn Features On</a></li>
          <li><a href="#Section2" class="anchBlue">Section 2 Switch Programs On</a></li>
          <li><a href="#Section3" class="anchBlue">Section 3 Configuration Options</a></li>
        </ul>
      </li>
      <li><a href="#author">Author and Copyright</a></li>
    </ul>

</div>

[ ref $!manpage("rc",8)!$, $!manpage("rc.conf",8)!$ ]

OpenBSD's startup instructions are built into the script /etc/rc
"command scripts for system startup" which are normally configured 
through the 'localised' files:

- /etc/rc.conf.local
- /etc/rc.local

We don't make updates to the 'standard' files __rc__ or __rc.conf__
because this will simplify upgrading to future versions of the
Operating System. We make our modifications to 'localised' versions. 
rc.conf.local is the localised version for rc.conf, and rc.local 
is the localised additions to to rc.

rc.conf - contains 'configuration' options for rc, so we can modify
rc's behaviour by making configuration changes to our 'localised'
version rc.conf.local. 

The configuration options may include variable/feature assignments such as:

<pre class="config-file">
httpd_flags=NO
</pre>

One suggested procedure is to copy rc.conf
as your new rc.conf.local and delete the last two lines. Make your
configuration changes to this rc.conf.local and it overrides the
default settings in the 'original' rc.conf.

For example: the apache web server is not started by default, but by
adding a configuration entry into rc.conf.local, we tell OpenBSD
to start the apache server, with specific options.

<pre class="config-file">
httpd_flags=""
</pre>

rc.local - is used to augment programs started in rc. For example
when we install new programs like a database server, the rc does not
know about these, and we can add the 'startup' process for that
database into rc.local.
  
Remember:

-   Changes you make in the /etc/rc.conf.local file will override 
    settings in /etc/rc.conf.
-   Do not make changes to /etc/rc or /etc/rc.conf

### <a name="rc.conf.local"></a>Localised Configurations
 
To simplify my use of rc.conf.local, I look at it as a division of
THREE separate sections.

1.  Section 1: Setting Programs that require Features turned on or off
2.  Section 2: Start/Stop Programs that do not need parameters
3.  Section 3: Configuring information for programs started above. Ignored if 
    servers are not started.

<p class="pFileReference">File: /etc/rc.conf.local

<pre class="config-file">
# SECTION 1 - Turn Features on/off



# SECTION 2 - Switch Programs On/Off



# SECTION 3 - Configuration Options

shlib_dirs = ""
</pre>


#### <a name="Section1"></a>Section 1 - Turn Features On

This section is where you set parameters for programs that need to be started 
with different types of options.
  
For example, sendmail is usually started with different options depending on 
whether you wish to process queues only, or also set up smtp processing.
  
<pre class="config-file">
# SECTION 1 - Turn Features on/off
# ##
xdm_flags=""                # use two double-quotes
sendmail="-bd -q30m"        # for normal use: "-bd -q30m" 
ftpd_flags="-DllUSA"        # for non-inetd use: ftpd_flags="-D"
</pre>

The above settings override the default /etc/rc.conf settings. 

xdm_flags now specifies to start xdm (previously it was xdm=NO.) The sendmail 
directive now specifies the use of '-q30m' whereas the default specification is 
without '-bd' 
  
The ftpd_flags are read by the start up scripts and specify parameters for 
the ftpd daemon.



#### <a name="Section2"></a>Section 2 - Switch Programs On

This section is for programs that merely need to be turned on or off. For example 
this is a good place for programs that get their configuration information from 
configuration files and not from command-line arguments.
  
 
<pre class="config-file">
# SECTION 2 - Start/Stop Programs that do not require parameters
# ##
mysql=YES
smbd=No
nmbd=No
</pre>

In the above modifications tells the variable assignments are relevant
to updates I make to rc.local for to:

- start: mysql services, but 
- do not start: Samba services (smbd, and nmbd.)

#### <a name="Section3"></a>Section 3 - Configuration Options

In this section we specify directives for programs started in either Section 
1 or Section 2. These directives will either be read when programs are activated 
or ignored when programs are not activated.
  
We can also place in here other directives that may be reviewed by the scripts 
in /etc/rc
  
<pre class="config-file">
# SECTION 3
# ##
shlib_dirs="$shlib_dirs /new/path1 /new/path2"
</pre>

The above changes to shlib_dirs expands the existing shlib_dirs read from /etc/rc.conf 
($shlib_dirs) and adds two new paths to shlib_dirs. Note that a space is used 
as the separator. You can also use multiple lines of shlib_dirs. Refer: rc.conf(8), 
ldconfig(8). 

Because the script reading /etc/rc.conf{.local,} is Bourne Shell 
you can also use settings like shlib_dirs="/usr/local/lib/{path1,path2,path3,}
  
<b>WARNING:</b> There are no spaces between shlib_dirs, the "=" sign, 
  and the first quote "
