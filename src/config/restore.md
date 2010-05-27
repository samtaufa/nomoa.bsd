## Restoring A host

<div style="float:right">

Table of Contents

<ul>
    <li><a href="#host.os.build">Host OS Install</a>
    <li><a href="#restore.system">Restore from Archives</a>
        <ul>
            <li><a href="#restore.packages">Installed Packages</a>
            <li><a href="#restore.custom">Custom Recovery Items</a>
            <li><a href="#restore.configs">Configuration Files</a>
        </ul>
</ul>


</div>    

    
The Recover CD layout is expected to be:

<table>
    <tr><td>Mount Point</td><td>Description</td>
    </tr><tr><td>/mnt</td><td>Root mount point. Contains scripts</td>
    </tr><tr><td>/mnt/configs</td><td>Configuration Archives (naming convention: `hostname -s`.tgz</td>
    </tr><tr><td>/mnt/packages</td><td>Binary packages (naming convention: $REV/$MACH</td>
    </tr><tr><td>/mnt/docs</td><td>Documentation</td>
    </tr>
</table>

 
<a name="host.os.build"></a>

### Host OS Install

As the presumption with restoration is that the "restored" host will be either
the existing host being rebuilt, or a new host built as a replacement, it is cognisant
on you to maximise compatibility between the two hosts. 

If the original host has two Intel NICs, make it so with the new host. Similarly with
all other aspects of the hardware configuration. 

Install the Operating System as per the original host build instructions, ensuring the same:

- OS build and release

- Hard Disk Type and Partitioning

- Network Cards

- Host Name

<a name="restore.system"></a>

### Restore System

After installing the Operating System, reboot the host and:

- Insert the appropriate __Restoration CD__

- Login as root

- Mount the CD with the following commands
    
<pre class="command-line">
mount -t cd9660 /dev/cd0c
</pre>

Completing installation is through the following scripts.

<ul>
    <li><a href="#restore.packages">Install Packages</a>
    <li><a href="#restore.custom">Custom Recovery Items</a>
    <li><a href="#restore.configs">Configuration Files</a>
</ul>

<a name="restore.packages"></a>

#### Install Packages

Install the packages for the host using the below script

<pre class="command-line">
/mnt/installpackages.sh
</pre>

<pre class="screen-output">
Usage:
      installpackages.sh
or
      installpackages.sh hostname
      installpackages.sh hostname machine-hardware openbsd-version

Install packages for host hostname

Generally this script requires no arguments as it will work out the
correct hostname and version itself. The alternative invocations are
mainly for testing purposes.
</pre>
    
Packages are OpenBSD prebuilt binaries based from the OpenBSD Ports Tree 
(where tools not developed by OpenBSD are maintained.)

As this script runs, you'll see information about the packages being
installed - something like this:

<pre class="screen-output">
Installing packages for samx01 - OpenBSD release 4.0
etc/packagelist.txt
bzip2-1.0.3: complete
expat-1.95.6p1: complete
gettext-0.4.2.2p3:|********* | 37%
</pre>

You may see some other information displayed, depending on the packages 
being installed, suggesting that you update certain confguration files. 
Since the config files are also stored on the _Restoration CD_
we can safely ignore most of these messages.

More Information:

The script essentially parses the /etc/packagelist.txt from the target hosts 
configuration archive file, iterates through the entries and executes a pkg_add

<pre class="command-line">
cd /tmp
tar -zxpf /mnt/configs/MYHOSTNAME.tgz
export PKG_PATH=/mnt/packages
for i in `cat etc/packagelist.txt`; do
    package="$PKG_PATH/${VERSION}/${MACHINE}/${i}.tgz"
    if [ ! -f "${package}" ] ; then
        echo "Can't see package: \"${package}\" ... skip"
    else
        /usr/sbin/pkg_add ${package}
    fi
done
</pre>

<a name="restore.custom"></a>

#### Custom Recovery Items

As per client install instructions, any further customisation to the system that is
not catered for by package installations, and the base install, should be documented
in a host /usr/local/sbin/dr-customisations.sh script.

<pre class="command-line">
/usr/local/sbin/dr-customisations.sh
</pre>

Unless otherwise necessary, the above script will be automatically executed by the
_unpackconfiguration.sh_ script

<a name="restore.configs"></a>

#### Configuration Files

Unpack the host configuration files using the script: unpackconfiguration.sh

<pre class="command-line">
/mnt/unpackconfiguration.sh
</pre>

<pre class="screen-output">
Usage:
      unpackconfiguration.sh
or
      unpackconfiguration.sh hostname

Unpack Configuration File for this host

Generally this script requires no arguments as it will work out the
correct hostname and version itself. The alternative invocations are
mainly for testing purposes.
</pre>

More Information:

The script essentially untar's the configuration files onto the current machine
as in the below sample.

<pre class="command-line">
cd /
tar -xzpf /mnt/configs/HOSTNAME.tgz
hostname `cat /etc/myname`
</pre>

Note that the above 'tar' uses the '-p' option.