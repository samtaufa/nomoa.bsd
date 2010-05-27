## First Time - General Configuration Aids

<div style="float:right">

Table of Contents
<ul>
  <li><a href="#removable">Configuring Removable Storage Devices</a></li>
  <ul>
    <li><a href="#instFSTable">The File System Table (/etc/fstab)</a></li>
    <li><a href="#instMountPoints">Mount Points for Removable Media (nodes)</a></li>
    <li><a href="#instEX">Example CDs, and SCSI</a></li>
    <ul>
      <li><a href="#instEXMountPoints">The Mount Points / nodes</a></li>
      <li><a href="#instEXManualTest">Manually Testing for a Connection</a></li>
      <li><a href="#instEXupdateFSTable">Updating the File System Table</a></li>
    </ul>
    <li>Fast Forward - doing it correctly?
        <ul>
            <li>$!manpage("dmesg",1)!$ - discovering attached devices</li>
            <li>disklabel - discovering device filesystems</li>
            <li>mount - connecting device filesystems</li>
        </ul>
    </li>
  </ul>
  <li><a href="#instPackageManagement">Package
Management - adding programs</a></li>
  <ul>
    <li><a href="#installPMpico">Example: Installing a
nice little editor</a></li>
    <li><a href="#instPMbash2">Example: Installing
Bash 2 - local</a></li>
    <li><a href="#instPMbash2ftp">Example: Installing
Bash 2 - ftp</a></li>
    <ul>
      <li><a href="#instPMdontknow">Example: Don't
know the package or ftp directory ?</a></li>
    </ul>
  </ul>
  <li><a href="#instUserAdmin">User Administration</a></li>
  <ul>
    <li><a href="#instAddUser">Adding a New User</a></li>
    <li><a href="#instRootAccess">Specifying root access privileges</a></li>
    <li><a href="#instchpass">Changing details of a User</a></li>
  </ul>
  <li><a href="#instSHELL">Shell Profile (bash example)</a></li>
  <li><a href="#afterboot">Afterboot Install </a>
    <ul>
      <li><a href="#ab_date">Date. Setting the Date &amp; Time</a></li>
      <li><a href="#ab_timezone">TimeZone. Setting the Time Zone</a></li>
      <li><a href="#ab_network">Network. Setting the basic network
services.</a></li>
      <ul>
        <li><a href="#net_host">host configuration,</a></li>
        <li><a href="#net_network">network interface configuration,</a>
and</li>
        <li><a href="#net_routing">network routing.</a></li>
      </ul>
    </ul>
    <ul>
      <li><a href="#ab_daily">Daily, Weekly, Monthly Scripts</a></li>
      <li>Root Backup</li>
      <li>Cron - scheduled commands</li>
    </ul>
  </li>
  <li><a href="#misc">Miscellaneous</a></li>
  <ul>
    <li><a href="#findfile">Making it easier to find files</a></li>
    <li><a href="#singleuser">Booting in Single User Mode</a></li>
    <li><a href="#movdir">Moving Directories Safely</a></li>
    <li><a href="#gentools">General Tools I install</a></li>
  </ul>
</ul>
</div>

ref: 
[For People New to Both FreeBSD and Unix](http://andrsn.stanford.edu/FreeBSD/newuser.html) |
[The Goodness of Men and Machinery](http://bsdly.blogspot.com/2010/01/goodness-of-men-and-machinery.html) |
[Remote Simple Installation of OBSD 4.6](http://www.openbsd101.com/installation.html)
 
The installation instructions that comes with OpenBSD is 
straight forward. Buy the CD the instructions is a colourful 
CD sleeve. If you've downloaded the files from the
Internet then read the <i>INSTALL</i>.<i><font color="#0000ff">$ARCH</font></i>
file (for example if you are installing it on an Intel class machine,
then the file to read is INSTALL.386)

When you're too lazy to load the above files and read it, then click
onto Google and do a search for sample installations (with screenshots)
such as 
[The Goodness of Men and Machinery](
http://bsdly.blogspot.com/2010/01/goodness-of-men-and-machinery.html)
or [Remote Simple Installation of OBSD 4.6](
http://www.openbsd101.com/installation.html)

Outlined here are installation items likely to be
helpful for someone new to OS installations or has come from another
Unix. For those really new to Unix I suggest you read the complete
section you are interested in before attempting to follow the
instructions.

<b>Warning</b>: If you are not familiar with using the vi text
editor, or similar variants on unix (ex, view) I would suggest that it
will make life much easier for you if you find a tutorial on "vi"
somewhere on the 'net and get familiar. Most things in Unix requires
editing text files, and it takes a while to get a graphical system up
and running so editing usually requires a character based editor (like
vi).

There is a real nice introductory, short, tutorial [For People New to Both FreeBSD and Unix](http://andrsn.stanford.edu/FreeBSD/newuser.html)
You should at least read through the tutorial for a guide to what you
will do here (and reference.)

For the 1st time installer, I suggest either installing from a CD or
by downloading the main installation files onto a local network machine
or local hard-disk. Of course you can burn your own CD after
downloading. Current OpenBSD mirrors will also have an install_$version_.iso
that can be burned to a CD for installation.

### <a name="removable"></a>Configuring Removable Storage Devices 

(e.g. CD Drives, Zip Drives, etc.) 
 
ref: /etc/$!manpage("fstab")!$ | 
$!manpage("mount",8)!$ | 
$!manpage("mount_cd9660",8)!$ |
[FAQ 14](http://www.openbsd.org/faq/faq14.html) 

To simplify my installation process (low bandwidth people) I need
to configure access to my CD-ROM drive. Use 

`dmesg | less`

to look for the device name detected as the cdrom drive. 

CD drives are often detected as device cd# (like cd0 or cd1). '$!manpage("dmesg",1)!$' is a
command-line program in OpenBSD that lists boot-time information (such
as what OpenBSD detects as devices on your system during startup.) less
is another command-line program, this program lets you browse through a
file by using space (next page) up-arrow, down-arrow, and "q" for quit.

From the manpage $!manpage("dmesg")!$:

<pre clas="screen-output">
<b>dmesg</b> displays the contents of the system message buffer.  It is most
     commonly used to review system startup messages.
</pre>

#### <a name="instFSTable"></a>The File System Table - $!manpage("fstab")!$

I edit the /etc/fstab file to tell OpenBSD that I have the cdrom
drive setup and this helps simplify my mounting command. The /etc/fstab
file contains information about the filesystem.

File: /etc/fstab 

<pre class="screen-output">
# "#" starts comments
# 
# fs_spec fs_file fs_vfstype fs_mntops fs_freq fs_passno
# 
/dev/wd0a  /            ffs      auto,rw  1 1
# The following is an example of what you may need to add 
# 
/dev/cd0a  /mnt/cdrom   cd9660   noauto,ro    0
/dev/fd0a  /mnt/floppy  msdos    noauto,rw    0
</pre>

From the manpage $!manpage("fstab")!$ the format, as show above, is: 

<pre class="screen-output">
fs_spec fs_file fs_vfstype fs_mntops fs_freq fs_passno

fs_spec, is the block special device, or remote filesystem 
    to be mounted.

    e.g. /dev/cd0c, /dev/wd0a
    
fs_file, describes the mount point for the filesystem.

    e.g. /mnt, /cdrom

fs_vfstype, describes the type of the filesystem.
    e.g. cd9660, ffs, msdos, nfs, udf

fs_mntops, describes the mount options associated with 
    the filesystem.
    e.g. auto, noauto, userquota, groupquota
    
fs_freq, is used by the -W and -w options of dump(8) to
    recommend which filesystems should be backed up.
    
fs_passno, is used by the fsck(8) program to determine
    the order in which filesystem checks are done at reboot time.    
    e.g. 0, 1, 2
</pre>

Although the CDROM device is detected by the kernel during each
boot, and during installation the device is not automatically
configured for use. 

Included in the above example, is an example configuration for a floppy
disk device (assuming /dev/fd0 is the controller and /dev/fd0a is the a
drive.) I specify msdos file format since I mostly work with msdos
floppy drives (Winx) and have no need to transfer any other format
floppies. 

####  <a name="instMountPoints"></a>Mount Points for Removable Media (nodes)

I now create the nodes (mount points) for where the file systems can
be mounted by issuing the following commands:

<pre class="command-line">
# <b>mkdir /mnt </b>
# <b>mkdir /mnt/cdrom</b>
# <b>mkdir /mnt/floppy</b>
</pre>

We can now access a CD in the CD-ROM drive by entering the below command at
the system prompt.

<pre class="command-line">
# <b>mount /mnt/cdrom</b>
</pre>

You will receive a read error if a CD is not in the drive. 

Mount doesn't configure a device but attempts to find 
the file-system specified on the device to mount that 
filesystem to the 'mount-point'. To correctly mount a 
device, we require a valid file-system on that device.

For our cdrom device above, we are specifying that the 
filesystem is on partition 'a', for the floppy device
we again say the filesystem is on partition 'a'.

Similarly you can access a floppy disk in the the floppy drive.

#### <a name="instEX"></a>Example : CDs, and SCSI 

[Reference System: iwill motherboard with
ATAPI IDE CD, SCSI CDR and SCSI Zip drive]

I have 2 CDRoms on this machine, and a SCSI card with 
external storage connected to it (similar in purpose to
today's USB Thumb Drives.) $!manpage("dmesg")!$ outputs a lot of junk 
with the below information included that
seems valid for removable devices.

<pre class="screen-output">
cd0 at scsibus0 targ 1 lun 0: &lt;E-IDE, CD-ROM 45X, 32&gt; SCSI0 5/cdrom removable
cd1 at scsibus1 targ4 lun 0: &lt;PLEXTOR, CD-R PX-R412C, 1.04&gt; SCSI25/cdrom removable
sd0: 96MB, 96 cyl, 64 head, 32 sec, 512 bytes/sec, 196608 sec total
fd0 at fdc0 drive 0: 1.44MB 80 cyl, 2 head, 18 sec 
</pre>

The command "<b>dmesg | less</b>" lets us navigate up and down the
list (using arrow keys) and I can quit "less" by typing in "q" to quit.

##### <a name="instEXMountPoints"></a>The Mount Points / nodes

I test the ability to access the devices by first creating the
'node' or directory to mount the devices and using the mount command to
check where the 'fs_spec, the block special device ' is located.


<pre class="config-file">
/mnt/cdrom  - for the E-IDE CDROM (filesystem: cd9660)
/mnt/cdr    - for the CDR (filesystem: cd9660) 
/mnt/floppy - for the floppy drive (filesystem: msdos) 
/mnt/zip    - for the Iomega SCSI ZIP drive (filesystem:msdos)
</pre>

We're choosing cd9660 as the filesystem for CD drives as this is
OpenBSD's name for ISO-9660 CDROM filesystem. We use msdos in this
example since all my other machines sharing zip disks and floppies are
MSWin platforms which share MSDOS FAT filesystems (fat16, fat32).

<pre class="command-line">
# <b>mkdir /mnt</b>
# <b>mkdir /mnt/cdrom</b>
# <b>mkdir /mnt/cdr</b>
# <b>mkdir /mnt/floppy</b>
# <b>mkdir /mnt/zip</b> 
</pre>

##### <a name="instEXManualTest"></a>Manually Testing for a Connection

We start looking at the devices from /dev/???a ... b ... c ... until
we find it. Where ??? is the device we are reviewing. We need to make
sure we have a valid media (disk) inside each drive for the mount
process to find the file-system on the disk we want to mount. 
Put a CD with valid music or data into the CD Drive and/or floppies 
into floppy etc. 

We use the "-v Verbose mode" option so we can get some debugging 
output on the console from the mount command.

<pre class="command-line">
# <b>mount -v -t cd9660 /dev/cd0a /mnt/cdrom</b> 
</pre>
<pre class="screen-output">
/dev/cd0a on /mnt/cdrom type cd9660 (local, read-only)
</pre>
<pre class="command-line">
# <b>mount -v -t cd9660 /dev/cd1a /mnt/cdr</b>
</pre>
<pre class="screen-output">
/dev/cd1a on /mnt/cdr type cd9660 (local, read-only)
</pre>
<pre class="command-line">
# <b>mount -v -t msdos /dev/fd0a /mnt/floppy </b>
</pre>
<pre class="screen-output">
/dev/fd0a on /mnt/floppy type msdos (rw, local, uid=0, gid=0, mask=0755) 
</pre>

The above three devices seemed to work easily with the first
'device' but the mounted zip took a little while longer to find as
shown with the testing below.

<pre class="command-line">
# <b>mount -v -t msdos /dev/sd0a /mnt/zip</b> </pre>
<pre class="screen-output">
mount_msdos: /dev/sd0aon /mnt/zip: Device not configured </pre>
<pre class="command-line">
# <b>mount -v -t msdos /dev/sd0b /mnt/zip </b></pre>
<pre class="screen-output">
mount_msdos: /dev/sd0a on /mnt/zip: Device not configured </pre>
<pre class="command-line">
# <b>mount -v -t msdos /dev/sd0c /mnt/zip</b> </pre>
<pre class="screen-output">/dev/sd0c on /mnt/zip
type msdos (rw, local, uid=0, gid=0, mask=0755)
</pre>


##### <a name="instEXupdateFSTable"></a>Updating the File System Table

We now know where the devices can be located and can confidently
specify our devices into the /etc/fstab file system table.

Edit the file: /etc/fstab

<pre class="config-file">
# device    mount-point   filesystem  mount_options   check-priority    pass-number
  /dev/cd0a /mnt/cdrom    cd9660      ro,noauto         0                   0
  /dev/cd1a /mnt/cdr      cd9660      rw,noauto         0                   0
  /dev/sd0c /mnt/zip      msdos       rw,noauto         0                   0
  /dev/fd0a /mnt/floppy   msdos       rw,noauto         0                   0
</pre>
      
Now, all we need to do to access one of the devices above is to use
"mount /mnt/????" (where ???? is the directory created above) and mount
will look up the device setting/file system from the /etc/fstab file.

Sharing files through the FAT file system?
- Read $!manpage("mount_msdos") about support for long filenames.
- MSDOS Partitions may sometimes be found on partition 'i'
- CD9660 data partitions may sometimes be better read on partition 'c'

#### Fast Forward - doing it correctly?

After more years of misadventure, and the basic system above working, 
it seems that I haven't been doing it correctly, and there's a better
way of discovering and mounting attached storage devices(e.g. hard-disks,
flash-disks etc.)

##### dmesg - discovering attached devices

[ Host: Soekris net4801, OpenBSD 4.6 i386 ]

As per the previous discussion, '$!manpage("dmesg")!$' is our friend for discovering 
information about attached devices. When you plug a new device onto an
OpenBSD box, it is either recognised at startup or recognised at insertion
time. Use '$!manpage("dmesg")!$' to find out how it has been recognised.

Sample 'dmesg' output for a few USB External Storage Devices.

[ Device: Generic USB Thumbdrive 2GB]

<pre class="screen-output">
umass0 at uhub0 port 1 configuration 1 interface 0 "SMI Corporation USB DISK" rev 2.00/11.00 addr 2
umass0: using SCSI over Bulk-Only
scsibus0 at umass0: 2 targets, initiator 0
sd0 at scsibus0 targ 1 lun 0: <USB, Flash Disk, 1100> SCSI0 0/direct removable
sd0: 1983MB, 512 bytes/sec, 4062208 sec total
</pre>

We discover that the device is recognised at 'sd0'

[ Device: Generic Micro-SD 'Nokia' 128 MB ]

<pre class="screen-output">
umass0 at uhub0 port 1 configuration 1 interface 0 "SanDisk MobileMate Micro" rev 2.00/94.07 addr 2
umass0: using SCSI over Bulk-Only
scsibus0 at umass0: 2 targets, initiator 0
sd0 at scsibus0 targ 1 lun 0: <Generic, STORAGE DEVICE, 9407> SCSI0 0/direct removable
sd0: 121MB, 512 bytes/sec, 248320 sec total
</pre>

We discover that the device is recognised at 'sd0'

[ Device: External USB Chassis with Samsung 3.5" HDD 120GB ]

<pre class="screen-output">
umass0 at uhub0 port 1 configuration 1 interface 0 "Prolific Technology Inc. Mass Storage Device" rev 2.00/1.00 addr 2
umass0: using SCSI over Bulk-Only
scsibus0 at umass0: 2 targets, initiator 0
sd0 at scsibus0 targ 1 lun 0: <SAMSUNG, HM120JC, YL10> SCSI0 0/direct fixed
sd0: 114473MB, 512 bytes/sec, 234441648 sec total
</pre>

We discover that the device is recognised at 'sd0'

Not surprising discovery, since I only have one USB port on Soekris Net4801.
The point being, that finding exactly which device is attached, is not
a difficult ornerous job.

##### disklabel - discovering device filesystems

With the above devices connected, we run disklabel

[ Device: Generic USB Thumbdrive 2GB]

<pre class="command-line">
disklabel sd0
</pre>
<pre class="screen-output">
# /dev/rsd0c:
16 partitions:
#                size           offset  fstype [fsize bsize  cpg]
  c:          4062208                0  unused
  i:          4062145               63   MSDOS
</pre>

We've discovered partition 'c' as the marker for all of the device, and partition 'i' is an
MSDOS partition.

[ Device: Generic Micro-SD 'Nokia' 128 MB ]

<pre class="command-line">
disklabel sd0
</pre>
<pre class="screen-output">
# /dev/rsd0c:
16 partitions:
#                size           offset  fstype [fsize bsize  cpg]
  a:           240912               63  4.2BSD   2048 16384    1
  c:           248320                0  unused
</pre>

We've discovered partition 'c' as the marker for all of the device, and partition 'a' is a
4.2BSD partition.

[ Device: External USB Chassis with Samsung 3.5" HDD 120GB ]

<pre class="command-line">
disklabel sd0
</pre>
<pre class="screen-output">
# /dev/rsd0c:
16 partitions:
#                size           offset  fstype [fsize bsize  cpg]
  c:        234441648                0  unused
  i:        234436608             2048    NTFS
</pre>

We've discovered partition 'c' as the marker for all of the device, and partition 'i' is an
NTFS partition.

Of the three sample devices, 1 has the same file system used by OpenBSD (4.2BSD), 
1 has an MSDOS partition, and 1 has an NTFS partition.

##### mount - connecting device filesystems

[ ref: $!manpage("mount",2)!$ ]

As per the manpage, the 'mount' program uses the -t (type) to indicate the file system
type to be mounted (the default is FFS (aka 4.2BSD)

Sample invocations of mount to connect the partitions on the above noted drives
when physically connected include:

[ Device: Generic USB Thumbdrive 2GB - MSDOS]

<pre class="command-line">
mount -t msdos /dev/sd0i /mnt
</pre>

[ Device: Generic Micro-SD 'Nokia' 128 MB - 4.2BSD]

<pre class="command-line">
mount -t ffs /dev/sd0a /mnt
</pre>

[ Device: External USB Chassis with Samsung 3.5" HDD 120GB - NTFS]

Mounting NTFS partitions isn't supported in the GENERIC kernel,
basically implying that you don't want to connect to the
partition. Plug the drive into a proper NTFS box, and transfer
the files through some other means.

### <a name="instPackageManagement"></a>Package Management - adding programs

[Utility: $!manpage("pkg\_add")!$, $!manpage("pkg\_info")!$, $!manpage("pkg\_delete")!$ ]

[Config location: /usr/src ] 

[ref: [OpenBSD FAQ - Section 8](http://www.openbsd.com/faq/faq8.html#8.7)]
 
OpenBSD stores binary executables in what is termed 'packages.'
These packages store the information required to safely install the
binaries, libraries, and documentation distributed for that program.
Packages are generally pre-compiled binaries configured for the OpenBSD
disk layout and database of installed software. The benefits of
packages include resolving dependencies (on other libraries and
applications.)

Three utilities are used for administration (adding [pkg\_add],
deleting [pkg\_delete], and query [pkg\_info])

For those new to packages (like me) I change to the directory
containing the packages before using pkg\_add (this is not necessary and
is explained later in setting environment variables for bash, my
preferred shell.)

 The general format for using pkg\_add is:

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

<pre class="screen-output">
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
contains (by using pkg\_info.) To install the package we can simply use
pkg\_add.

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

#### <a name="instPMbash2"></a>Example - Installing Bash 2

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
example, the bash pkg\_add tells us to update the /etc/shells file to
include bash as a valid login shell.



<pre class="screen-output"># $OpenBSD: shells,v 1.5 1997/05/28 21:42:20 deraadt Exp $
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.
/bin/sh
/bin/csh
/bin/ksh</pre>

<pre class="command-line">
<b>/usr/local/bin/bash</b>
</pre>


Include the above line (/usr/local/bin/bash) into the /etc/shells
file.

#### <a name="instPMbash2ftp"></a>Example - Installing Bash 2 - ftp

For those without the release CDs, performing a pkg\_add from an ftp
connection is no more difficult than the above, as shown in the below
example for installing the same package.

I have downloaded the bash package from the Internet and have it on
my intranet ftp site: 192.168.101.77

<pre class="command-line"> # <b>pkg_add
ftp://192.168.101.77/OpenBSD/2.7/packages/i386/bash-2.04-static.tgz</b>
</pre>
<pre class="screen-output">&gt;&gt;&gt; ftp -o -
ftp://192.168.101.77/OpenBSD/2.7/packages/i386/bash-2.04-static.tgz 
# 
</pre>

pkg\_add uses ftp to retrieve from my internal ftp site
(192.168.101.77) the requested package and then extracts the files as
per the same operation above. You can replace 192.168.101.77 with any
valid ftp site which holds the package you wish to install.

##### <a name="instPMdontknow"></a>Example - Don't know the package or ftp directory ?

If you do not know what the package name is, or the specific
directory the file is located, you can still perform an ftp pkg\_add.
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

### <a name="instUserAdmin"></a>User Administration

[ref: adduser(8), group(8), rmuser(8)]
[Config info: user-name, account-type]

From the man pages:

<pre class="screen-output">
<b>DESCRIPTION</b>
The <b>adduser</b> program adds new users to the system. The <b>rmuser</b>
program removes users from the system. When not passed any arguments,
both utilities operate in interactive mode and prompt for any required
information.
</pre>

The first thing that OpenBSD warns of when you login is, do not
login as root but use su. This is saying that you should create a user
who can use su (the Switch User program) to change to the "root" user
when you want to perform administration tasks.

The following instructions guide you through the creation of a new
user with SuperUser access privileges.

OpenBSD supplies the <b>adduser</b> script to simplify adding new
users. All you have to know to create a new user is the name of the
person, and what you want the login account name to be. 

 The adduser script is started at the command prompt.

<pre class="command-line">
# <b>adduser</b> 
</pre>

When first started, queries you to set or change the default
settings. Once the standard configuration has be
en set, it will continue by prompting for adding new users. 

####  <a name="instAddUser"></a>Adding a New User

adduser support two flags -silent or -verbose. You don't really need
to know these at the beginning, but you can check the details in the
man pages. Read through the example below and then start adduser to
create your new account with root access privileges.

<pre class="command-line">
# adduser
</pre>
<pre class="screen-output">
Enter username [a-z0-9_-]: <b>bricker</b>
      
Enter full name [ ]: <b>Sven De La Palmer</b> 
Enter shell bash csh ksh nologin sh [bash]: <b>&lt;hit ENTER&gt;</b>
</pre>

The shell is your command line interpreter. It reads in the
commands you type and tries to decipher them. There are several
different shells to choose from. If bash does not show on the screen,
then review adding packages in the previous section. You can change
your settings at a later time so do not worry if some settings are not
as you want them right now. The documentation that comes with OpenBSD
says that 'most people' use bash, strange how they don't make it the
default though.


<pre class="screen-output">Enter home directory (full path)
[/home/bricker]: <b>&lt;hit ENTER&gt;</b>
Uid [1002]: <b>&lt;hit ENTER&gt;</b>
</pre>

The uid is the User ID number that the system uses to keep track of
people. These should be unique on the system. Use the default values
offered by the program unless you have good knowledge of previously
granted ID numbers.


<pre class="screen-output">Enter login class: default []: <b>&lt;hit ENTER&gt;</b> 
</pre>

The login class allows you to set up resource limits for groups of
users. 

#### <a name="instRootAccess"></a>Specifying root access privileges 

<pre class="screen-output">
Login group bricker [bricker]: <b>&lt;hit ENTER&gt;</b>
Login group is "bricker". Invite bricker into other groups: guest no 
[no]:  <b>wheel</b> 
</pre>

<b><font color="#0000ff">Important:</font></b> Your administrator
account should be a member of the group <b>wheel</b>. <i>Regular
users of your host should not be members of the wheel group.</i> If
this is your 1st account for the machine (and presumably your account)
then I suggest you add the account to the group "<b>wheel</b>."
Login groups are used to divide security privileges by account
groups. The group '<b>wheel</b>' is generally used for administrators
with special privileges including the ability to su (switch user) to
the SuperUser. Accounts who are not members of the group 'wheel' cannot
gain root access remotely. Invite user accounts you wish to grant
special security rights into the group '<b>wheel</b>,' or create a
separate security group for people who need to work together. 
<b>Do not</b> group normal users into wheel.

<pre class="screen-output">
Enter password []: 
Enter password again []: 
</pre>

 You will be asked for the user's password twice and it will not be
displayed. Afterwards, it will display all of the user's information
and ask if it is correct. 

<pre class="screen-output">
Name:     bricker 
Password: **** 
Fullname: Sven De La Palmer 
Uid:      1000 
Gid:      1000 (bricker) 
Class:    
Groups:   bricker wheel 
HOME:     /home/bricker 
Shell:    /bin/sh 
OK? (y/n) [y]: <b>&lt;hit ENTER&gt;</b> 
</pre>

If you make a mistake, you can start over, or its possible to
correct most of this information using the '$!manpage("chpass")!$' command (discussed
below). 

[ref: What to do AFTER you have BSD
installed by Chris Coleman,<a
 href="http://www.daemonnews.org/200005/chrisc@daemonnews.org">
http://www.daemonnews.org/200005/chrisc@daemonnews.org</a> 

#### <a name="instchpass"></a>Changing User Information 

 [ref: $!manpage("chpass",1)!$, $!manpage("vipw",8)!$]

Once you've configured the base system for working, we can look at
basic configuration of users. Note, for those with some previous Unix
experience, Do not just edit /etc/passwd or /etc/Master.passwd 

Use the $!manpage("chpass",1)!$ utility when adding or changing user information. If
you try to modify the user shell selection manually (by changing
/etc/passwd) it wont work, trust me I've made this mistake for weeks
before I found out my errorneous ways. 

Entered at the command line without a parameter (ie. typed by
itself,) chpass will edit your personal information. As root, you can
use it to modify any user account on the system. You can find more
details on chpass in the man pages, but let's go through an example
review of the account we created above.

<pre class="command-line"> # <b>chpass bricker</b> </pre>


This will bring up information about the user '<i>bricker</i>' in
the '<i>vi</i>' editor. The password line is encrypted, so don't change
it. If you want to disable the user, one method would be to add a # at
the beginning of the password string, so you can easily remove it later
when you want to reactivate the user. There are methods of disabling
user that may be better though.


<pre class="screen-output">
Login:
bricker 
Password: 
Uid [#]: 1000 
Gid [# or name]: 1000 
Change [month day year]: 
Expire [month day year]: 
Class: 
Home directory: /home/bricker 
Shell: /bin/sh 
Full Name: Sven De La Palmer 
Office Location: 
Office Phone: 
Home Phone: 
Other information: 
~ 
~ 
~ 
~ 
~ 
~ 
~ 
~ 
/path/temp-file: unmodified: line 1 
</pre>

Remember your vi commands ? <b>:q</b> (colon+q) quit, <b>:w </b>(colon+w)
write, <b>:q!</b> (colon+q+exlamation-mark) quit without saving. If
you're still having problems, remember [the tutorial](http://www.freebsd.org/tutorials/new-users)
 
[ref: [What to do AFTER you have BSD
installed by Chris Coleman](http://www.daemonnews.org/200005/chrisc@daemonnews.org)
]

### <a name="instSHELL"></a>Shell Profile (example) 

Files: .bash_profile, and .bashrc 

Since I like using the Bash shell largely due to my ignorance about
the other shells, here is an example of the files for initialisation.
The two user files which contain the shell settings are
~/.bash_profile, and ~/.bashrc. 

Note that these are templates and there are some things that MUST be
changed. I've put <b><font color="#0000ff">[path-to-&hellip;.]</font></b>
as designators of specific paths that have to be set by the user/admin.


<b>File: ~/.bash_profile </b>

<pre class="command-line">
# .bash_profile 
# 
# Things loaded once per session (by the login manager). 
# 
# Source of global definitions 
if [ -f /etc/bashrc ]; then 
   . /etc/bashrc 
fi 
    
PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/X11R6/bin
      
  
# Define variables useful for OpenBSD Installations 
# 
PKG_PATH=/<font color="#0000ff"><b><font color="#0000cc">[path-to-packages]</font></b></font>/packages/i386
      
export PKG_PATH PATH 
# Change the prompt to give current directory (\W) and 
# $ if regular user -or- # if root (\$). 
PS1='\[\033[1;30m\]\u@\h:\w \$\[\033[0m\] '
export PS1
# Useability  Items
export MANPAGER=less
</pre>

<b>File: ~/.bashrc</b>

<pre class="config-file">
# .bashrc 
# Put in here variables and stuff to be launched by subinvocations 
# of bash (like /usr/local/bin/bash)
PS1='\[\033[1;30m\]\u@\h:\w \$\[\033[0m\] '
export PS1 
</pre>

The tilde ~ is used here to refer to the home directory of the
current user. Therefore if you are logged in as 'bricker' then typing
in cd ~ should put you in the directory /home/bricker. Likewise if you
edit the file ~/.bash_profile the file is actually created as
/home/bricker/.bash_profile. If you were to su (switch user) to root
and then type cd ~ you should be moved to /root the home directory for
root.

## <a name="afterboot"></a>Afterboot Settings

The afterboot man pages list a sequence of issues to review after
the OpenBSD system has been configured and is up and running. For the
'expert' practioner many of the items seem trivial, for us newbies it
is a good time to review basic skills that will be re-used often and
will probably minimise problems that would otherwise occur just from
not checking 'basic' items. 

afterboot is a serious document if you want to ensure the stability
of your system. I recommend you read the document anyway and use these
pages as supportive material where possible. These notes are supportive
of afterboot material.

#### <a name="ab_date"></a>Date - Setting the System Date

You can check and configure the system date using the date command.
Without parameters, date command will display the current system date.
You can set the date by using the following template

<pre class="screen-output">
date YYYYMMDDHHMM
</pre>

Where YYYY is the four digit year, followed by MM a two digit month
of the year, DD a two digit date of the month, HH a two digit (24 hour)
representation of the hour, and MM for the minute in the hour.

Using the above specification, we can set (as per man afterboot
example)

<pre class="command-line">
# <b>date 199901271504</b>
</pre>

 Set the current date to January 27th, 1999 3:04pm. 

For those new to the convention used above (YYYYMMDDHHMM) it is the
ANSI specified date format for SQL. I also prefer the above date
formatting as it is less confusing when sharing things with the
Americans 8-)

#### <a name="ab_timezone"></a>TimeZone - Specifying the Time Zone

The time zone information is recorded as data files under the
/usr/share/zoneinfo directory. So if I want to set the timezone to
Paris, France then I can look it up using "find / -name "Paris" -print"
and I can specify the zone file by typing in:

<pre class="command-line">
/root # <b>cd /usr/share/zoneinfo</b> 
zoneinfo # <b>find . -name "Paris" -print</b> 
</pre>

<pre class="screen-output">
./Europe/Paris zoneinfo 
# <b>ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime</b>
</pre>

Of course for us people in Tonga with UTC+13 we use ln -fs
/usr/share/zoneinfo/Pacific/Tongatapu /etc/localtime (I thought you
might just want to know that ?)

### <a name="ab_network"></a>Checking the Network Base Services

Basic services for connecting on the network are generally covered
by these three items.

<ul>
  <li><a href="#net_host">host configuration,</a></li>
  <li><a href="#net_network">network interface configuration,</a> and</li>
  <li><a href="#net_routing">network routing.</a></li>
</ul>

##### <a name="net_host"></a>Host configuration details

Files: /etc/hosts, /etc/myname

For many network services to function they need to determine the
name of the current host. Host Details are checked by using the <b>hostname</b>
command. hostname will display what your current host name is. If you
need to change the hostname more details are available in the
hostname(1) man page. If you change the hostname, then you need to also
make the change to /etc/myname and possibly /etc/hosts.

/etc/hosts is a text file listing IP addresses and their related
hostnames. Your hostname should be in this file associated with the IP
address which you assigned your host during installation.

/etc/myname is a text file with just one line containing the
hostname of your machine. 

##### <a name="net_network"></a>Network interface configuration

Network interfaces are necessary if you wish to communicate to other
computers (at least if you want to communicate using the standard
tools.) In most cases the network interface device will be an ethernet
card. To list the network devices recognised by your system we use the
ifconfig -a command.

<pre class="command-line"># <b>ifconfig -a</b></td>
</pre>

The <b>ifconfig -a</b> command will list the network interfaces
currently active on the system. This will let you review what the
system knows of itself during this instance. You can set the default
configurations by editing the /etc/hostname.* file that corresponds to
the network interface.

If the <b>ifconfig -a</b> command lists an interface <b>le0 </b>than
the corresponding hostname file will be <b>/etc/hostname.le0</b>

Example: ifconfig -a displays the following ethernet device on my
compaq with a HP network card.

<pre class="screen-output">le1:
flags=8863 &lt;UP,BROADCAST,NOTRAILERS,RUNNING,SIMPLEX,MULTICAST&gt; mtu 1500 inet
192.168.101.130 netmask 0xffffff00 broadcast 192.168.101.255
inet6 fe80::260:b0ff:fea4:18d3%le1 prefixlen 64 scopeid 0x1 </span>
</pre>


The related hostname file is /etc/hostname.le1 which contains the
lines

<pre class="screen-output">
inet 192.168.101.130 255.255.255.0 NONE 
inet alias 207.124.66.156
</pre>

You can see that the inet line in hostname.le1 corresponds to the
inet line displayed by ifconfig -a. ifconfig allows you to manually
configure the network card, or at least check different configurations
before you insert the details into the hostname.interface file. Details
for configuring the network card are read from the
/etc/hostname.interface file during the boot sequence.

An example output for the loopback device will look like:


<pre class="screen-output">
lo0: flags=8009&lt;UP,LOOPBACK,MULTICAST&gt; mtu 32972
inet6 fe80::1%lo0 prefixlen 64 scopeid 0x3 inet6 ::1 prefixlen 128
inet 127.0.0.1 netmask 0xff000000
</pre>

If you have other network interfaces (example a ppp connection) then
these will also be listed. Check the afterboot and ifconfig pages for
more details.

The inet line specifies IPv4 information whereas the inet6 line
specifies IPv6 information. Since OpenBSD is an early adopter of IPv6
you will see this additional information for many network devices.

##### <a name="net_routing"></a>Routing Configuration

[ref: $!manpage("netstat")!$ | $!manpage("route")!$ ]
We can check the network routing using <b>netstat -r -n</b>

<pre class="command-line">
# <b>netstat -r -n</b></pre>
<pre class="screen-output">
Routing tables

Internet:   
Destination      Gateway          Flags  Refs  Use   Mtu   Interface

127/8            127.0.0.1        UGRS   0       0  32972    lo0
127.0.0.1        127.0.0.1        UH     4      42
192.168.101/24   link#1           UC     0       0   1500    le1
192.168.101.130  127.0.0.1        UGHS   0     122  32972    lo0
192.168.101.255  link#1           UHL    3      49   1500    le1
207.124.66/24    link#1           UC     0       0   1500    le1
207.124.66.156   127.0.0.1        UGHS   0       5  32972    lo0
224/4            127.0.0.1        URS    0       0  32972    lo0 
</pre>

If you are new to Unix, then just check to make sure the IP address
you specified specified for your host is listed and take a note that
the IP range (class) is gatewayed through the interface.

In the above example all 192.168.101/24 destinations (except for my
host ip address 192.168.101.130 nor the broadcast address
192.168.101.255) are sent through link#1 which is my network inteface
le1<i> [note: I need to verify more of this detail]</i> 

As I have an alias to the 207.124.66.156 the 207.124.66/24
destinations are also sent through link#1 (except for the host alias
207.124.66.156<i> [note: I need to verify more of this detail]</i>

The default gateway address is stored in the /etc/mygate file. If
you need to edit this file, a painless way to reconfigure the network
afterwards is route flush followed by a sh -x /etc/netstart command.
Or, you may prefer to manually configure using a series of route add
and route delete commands (see route(8))

<pre class="command-line">
# <b>route flush</b>
# <b>sh -x /etc/netstart</b>
</pre>

### <a name="ab_daily"></a>Daily, Weekly, Monthly Scripts

Actions that are scheduled to occur in a repetitive pattern such as
once each day, each week, each month can be placed into the
/etc/daily.local /etc/weekly.local /etc/monthly.local scripts.

The OpenBSD installation supplies a set of standard /etc/daily,
/etc/weekly, and /etc/monthly scripts. The scripts will check for
daily.local, weekly.local, and monthly.local so you should specify your
scripts as part of one of the above *.local files.

Finding and locating files. One of the more frequently asked
questions is how to find a file. The /etc/weekly script updates (on a
weekly basis) the locate.db file to index files on your system. To
manually execute the db update, see the notes below.

To manually execute any of the above scripts, they are sh shell
scripts, then use one of the examples below

<pre class="command-line">
# <b>sh /etc/daily</b>
# <b>sh /etc/weekly</b>
# <b>sh /etc/monthly</b>
</pre>

### Miscellaneous ?

####  <a name="findfile"></a>Making it easier to find files 

[ref: locate(8<span class="pFileReference">)
- find filenames quickly]
[ref: locate.updatedb(1) - update locate database]
[ref: find(1) - </span>walk a file hierarchy]

Unix has a nice file indexing utility accessible through '<b>locate</b>.'
The locate program interrogates a database created by locate.updatedb,
in this manner you do not have to traverse the hard-disk each time you
want to find a file. Update the file/location database by using the
locate.updatedb program and then interrogate (search in) the database
by using locate. Start locate.updatedb.

<pre class="command-line">#
/usr/libexec/locate.updatedb 
# locate filename
</pre>

 Now you can use 'locate filename' to find exactly where that file
is. As locate.updatedb updates information in the locate database
dependent on the user starting the program there is a potential risk
(since root has access to all files) of listing files in the database
that you do not want other users to be aware of.

To be safe, you could just manually start the /etc/weekly script
which is configured to execute locate.updated as user "nobody" without
the access priviliges available to root:

<pre class="command-line"># <b>sh /etc/weekly</b>
</pre>

Using the above weekly script is simpler than trying to figure out
how su, nice interact to minimise security holes through the locate db.

Otherwise you can still use the Unix 'find / -name "filename"'
command 


<pre class="command-line"># <b>find / -name "filename"</b>
</pre>

### <a name="singleuser"></a>Booting in Single User Mode

[ref: <a
 href="http://www.openbsd.org/faq/faq14.html">FAQ. 14.0 Disk Setup</a>]
 
Booting the system in Single User Mode is an important option when
you need to perform tasks on the machine that is sensitive to other
user activities on the system. Of course, you could be just like me and
have forgotten root's password or have zapped the shell you used for
root and other accounts and need to dive back into root to fix the
system.

When your system starts up, it momentarily offers the boot&gt;
prompt where we can force single user mode.

<pre class="screen-output"> Using Drive: 0
Partition: 3
reading boot....
probing: pc0 com0 com1 apm mem[639K 95M a20=on]
disk: fd0 hd0
&gt;&gt; OpenBSD/i386 BOOT 1<span class="Code">.</span>26 
boot&gt; <b>boot -s</b></pre>

Assuming you performed the above steps correctly and nothing has
gone wrong you should end up at a prompt asking you for a shell path or
press return. Press return to use sh. 

The single user mode starts with the "/" partition. This partition
has been mounted as read only (precautionary procedure). It is
advisable at this point to perform a file system check on the "/"
partition.

<pre class="command-line">shell # <b>fsck /</b>
</pre>

After the fsck we want to remount root in r/w mode as opposed to
read only. Issue the following command:

<pre class="command-line">shell # <b>mount -u -w /</b>
</pre>

The "-u" flag allows us to change the status of an already mounted
file system (because "/" was previously mounted by the startup. The
"-w" flag tells mount to make "/" read-write.

Once you have mounted "/" as read/write you can also mount the rest
of your file system or just do what it is you want to do in single user
mode and restart the system.

#### <a name="movdir"></a>Moving Directories Safely

Problem: How can I safely move all files/directories under /opt to
/home/opt ?

Sooner or later you'll come across the problem of running out of
disk-space on your partition scheme. The following is a set of methods
for 'safely' moving files from one folder to another.

For this example we will pretend that our /opt directory has just
filled our / partition and we need to move files from /opt to a less
congested partition (or a new drive) so we can continue developing
('acking'.) We find that /usr is getting tight on space and /home has
heaps of space (cause we have no users yet,) so we will move the files
to /home/opt for the time-being.

##### Option 1: [ref: OpenBSD FAQ and e-mail by H&aring;kan Olsson<!-- &lt;ho@crt.se&gt; --> ]

    cd /opt; find . -xdev -depth -print | cpio -pdmu /home/opt 
    
If the 'find' is run on the locally mounted filesystem, this is a
rather efficient method to copy the data. Also, if you move lots of
data and there is the chance it may change during copy/move time (say
user or project data on an NFS-exported partition), you can rerun once
without the 'u' flag to cpio, in which case only updated files are
copied, if any. Not foolproof certainly, but often good enough if you
have sane time in your network (ntp, et al). 

-xdev (x: do not search directories on other file systems/devices,
d: depth-first traversal; e: 

#####  Option 2: [ref: e-mail by Christopher Linn<!-- &lt;celinn@mtu.edu&gt; -->
] 

    cd /opt; tar cXf - . | (cd /home/opt; tar xpf - )
    
This would be if you have any other partitions mounted inside of
/usr, you don't want tar to cross filesystem boundary 

#####  Option 3: [ref: e-mail by Dan Harnett<!-- &lt;danh@nfol.com&gt; -->
] 

    cd /home/opt; dump -0uaf - /opt | restore -rf -
    
 It has been my experience that it is safer and more reliable.

[ref: OpenBSD <a href="http://www.openbsd.org/faq/faq14.html">FAQ.
14.0 Disk Setup</a> -&gt; <a
 href="http://www.openbsd.org/faq/faq14.html#14.3">14.3 Adding Extra
Disks</a> in OpenBSD]
Note: the use of the above names in no way implies these people want to
be associated with this information release

####  <a name="gentools"></a>My Selection of Tools for Configuring
OpenBSD 

 The OpenBSD base install has a number of standard features (web
server etc.) Below is just a list of tools that I used on a consistent
basis to be installing with each generic install I put together. 

<table>
  <tbody>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>bash-2.04</b> </td>
      <td valign="top"> GNU Bourne Again Shell (use the static version)</td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>m4-1.4 </b></td>
      <td valign="top"> GNU m4 </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>autoconf</b>   </td>
      <td valign="top"> automatically configure source code </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>automake</b> </td>
      <td valign="top"> GNU Makefile generator </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>bison</b> </td>
      <td valign="top"> another one of those tools that seems to be
needed when compiling various programs </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>gmake</b> </td>
      <td valign="top"> GNU version of make </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>mawk</b> </td>
      <td valign="top"> new/posix awk </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>samba</b> </td>
      <td valign="top"> SMB/CIF file/print resource sharer very useful
with MS Windows environments </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> <b>vnc</b> </td>
      <td valign="top"> display X &amp; Win32 desktops on remote
X/Win32/java displays </td>
    </tr>
  </tbody>
</table>

Around the time of OpenBSD 2.8 was the release of the <i>pico</i>
editor. I have a friend who lives on the pico editor so now I've come
to install this package as well. The user interface is much nicer than
vi, but there are some 'gotchas' as well, but to each their own
favourite.

The reason we choose to use the 'static' version of bash is because
of the times when you may choose to have bash as the default shell for
root. By using the static version of bash there is no need for the
binary to lookup libraries to complete its task. This is very important
when someone or some program may inadvertently (by mistake?) delete or
update a library that the dynamically linked version of Bash may need.
Also, when booting into single-user mode, not all libraries are
immediately available depending on how your partitions are set
(remember that in single-user mode only your "/" partition is
immediately available.) This also means that you have to make sure your
'bash' executable is in the "/" partition.

#### Available from ftp sites (&amp; distfiles) 

<table>
  <tbody>
    <tr>
      <td nowrap="nowrap" valign="top"> openssh </td>
      <td valign="top"> SSH1 and SSH2 binaries, clients installed by
default but servers require RSA libraries available on ftp sites. <i>(included
with OpenBSD 2.7 and later)</i></td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> openssl </td>
      <td valign="top"> ssl27 (ssl26) contains RSA code </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> </td>
      <td valign="top"> </td>
    </tr>
    <tr>
      <td nowrap="nowrap" valign="top"> Pgp-intl </td>
      <td valign="top"> Data Encryption package </td>
    </tr>
  </tbody>
</table>

<b><font color="#0000cc">Documentation? </font></b>Linux has the
LDP, OpenBSD has the man pages. Although the LDP are much nicer in hand
holding, OpenBSD's man pages are so convenient for us who are not
'live' on the NET. INSTALL.386 has a section "Using online OpenBSD
documentation," scan through it if you are new to Unix, it has some
helpful pointers on how to better make use of man pages. 

The initial purpose of this documentation was to record what I had
to do to get OpenBSD into a workable configuration. A few of my friends
wanted to try out Unix so here evolves my notes for my better
understanding and for others new to OpenBSD.

<a href="http://wks.uts.ohio-state.edu/unix_course/unix.html"
class="anchBlue">http://wks.uts.ohio-state.edu/unix_course/unix.html</a>

 