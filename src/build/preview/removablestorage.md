## Removable Storage

<div class="toc">

Table of Contents

<ol>
	<li><a href="#identify">Identifying</a>
		<ul>
			<li><a href="#identify.device">Device</a></li>
			<li><a href="#identify.filesystem">Filesystem</a></li>
		</ul></li>
	<li><a href="#filesystem">Connect File Systems</a>
		<ul>
			<li><a href="#mount.points">Mount Points</a></li>
			<li><a href="#mounting">Mounting</a></li>
		</ul></li>
	<li><a href="#eg">Examples</a>
		<ul>
			<li><a href="#eg.identify">Identifying</a>
				<ol>
					<li><a href="#eg.identify.device">Device</a></li>
					<li><a href="#eg.identify.filesystem">Filesystem</a></li>
				</ol></li>
			<li><a href="#eg.filesystem">Connect File Systems</a>
			<ol>
				<li><a href="#eg.mount.points">Mount Points</a></li>
				<li><a href="#eg.mounting">Mounting</a></li>
			</ol></li>
		</ul></li>
	<li><a href="#retained">Retained Information</a></li>
	
</ol>

</div>

&#91;Ref: $!manpage("fstab")!$ | $!manpage("mount",8)!$ | $!manpage("mount_cd9660",8)!$ |
[FAQ 14 - Disk Setup](http://www.openbsd.org/faq/faq14.html) ]

(e.g. CD Drives, External Drives, etc.) 

I have always needed access to either the USB Port, or CDR when
configuring or maintaining an OpenBSD host.  In many cases, my
installation is by using boot media (bootable CDR) and after the
installation I have/share files using the CDR. To simplify the
installation process (low bandwidth people) I need to configure 
access to my CD-ROM drive. Use this guide for identifying and
using detachable media storage devices.

OpenBSD understands storage devices in at least two layers,
the physical device and the logical layout of how files
are to be stored and retrieved from the device.

-	The physical device needs software (device drivers?) to understand
	how to manipulate the device.
-	Another software layer (filesystem) is used to work with the 'standard'
	used for storing and retrieving files.
	
As such, two things need to be done before we can use our
removable storage devices.

-	Identify Device (Controller, Filesystem)
-	Connect Filesystem

We need to identify how OpenBSD has recognised the storage device (in this
context, which device controller and what filesystem is recognisable
on the device), and with that knowledge we can then connect to the 
filesystem on the device.

### <a name="identify"></a> Identify

Identify the Device and any recognisable filesystem on that device.

#### <a name="identify.device"></a> Identify Device

Two basic methods are available to determine what removable devices 
you connected to your host. The first, uses, dmesg seems the shortest
path. The 'dmesg' lists all detected/identified devices. In general
the devices are identified by the vendor and the device ports are
generally (cdXY) where XY is the Drive unit (0~999) partition (a-m).

<pre class="command-line">
dmesg | less
</pre>

or

<pre class="command-line">
cat /var/run/dmesg.boot
</pre>

CD drives are often detected as device cd# (like cd0 or cd1). 
$!manpage("dmesg",1)!$ is a command-line program in OpenBSD that 
lists boot-time information (such as what OpenBSD detects as devices 
on your system during startup.) $!manpage("less",1)!$ is another command-line program, 
this program lets you browse through a file by using space (next page) 
up-arrow, down-arrow, and "q" for quit.

<pre class="manpage">
$!manpage("dmesg")!$ displays the contents of the system message buffer.  It is most
     commonly used to review system startup messages.
</pre>

#### <a name="identify.filesystem"></a> Identify Filesystem

&#91;Ref: $!manpage("disklabel")!$ ]

Knowing the device driver connected to the storage device, we can now use
$!manpage("disklabel")!$ to peek at what filesystems on the device OpenBSD
can recognise. 

### <a name="filesystem"></a>Connect File System

&#91;Ref: $!manpage("fstab")!$ $!manpage("mount",8)!$ $!manpage("newfs",8)!$]

After identifying the device driver and filesystem that contains the
files, we need to determine:

-	'mount point' where on our existing filestructure to connect 
	the storage devices' filesystem, and
-	'mount' connect that filesystem (requires knowledge of the 
	filesystem 'standard' used on the device.

Files stored on a CD or DVD are usually stored using a 
standard called ISO 9660, some DVDs may use a later standard UDF. 
These standards have any OpenBSD related $!manpage("filesystem")!$ 
($!manpage("mount_cd9660",8)!$, $!manpage("mount_udf",8)!$) for reading 
and writing  

My USB Memory Sticks are generally formatted on MS Windows hosts
in the MSDOS FAT16/FAT32 format which is supported by OpenBSD  
$!manpage("mount_msdos",8)!$ for physical file transfer between
these different Operating Systems.

#### <a name="mount.point"></a> Mount Points

The required connection 'point' on our existing file system tree where 
we can connect an remote/external filesystem, is "an existing directory"

In practise, many OpenBSD systems I've seen use the generic path

<pre class="manpage">
/mnt
</pre>

as the mount point for connecting filesystems. It should already exist
on your new installation, or can be created as the 'root' user
such as below:

<pre class="command-line">
# mkdir /mnt
</pre>

### <a name="mounting"></a> Mounting

The term for connecting the remote/external filesystem to the
host filesystem is to '$!manpage("mount")!$'

<pre class="manpage">
The **mount** command invokes a file system specific program to prepare and
graft the *special* device or remote node (rhost:path) on to the file sys-
tem tree at the point *node*. If either *special* or *node* are not provided
the appropriate information is taken from the $!manpage("fstab",5)!$ file.
</pre>

Since we are mounting a filesystem, and not the physical device, we generally
find that the device is divided into physical segments called 'partitions' and
these separate partitions may contain different filesystems.

CDROMs are simple, in that they generally have the filesystem on partition 'a'
or 'c'

An example of getting at files on a CDR, on a device identified at
/dev/cd0 would look something like this.

<pre class="command-line">
# mount -t cd9660 /dev/cd0c /mnt
</pre>

Mount is told the filesystem is ISO 9660 (cd9660) on the device /dev/cd0, in partition 'c' 
and to connect it to the existing directory '/mnt'
 
### <a name="eg"></a> Examples

The following are examples of identifying, and then connecting to the
storage that has those files you need access to.

#### <a name="eg.identify"></a> Identifying

First, are examples of identifying the device driver managing
the storage device, and then the filesystem on that device.

##### <a name="eg.identify.device"></a> Device

After more years of misadventure, and the basic system above working, 
it seems that I haven't been doing it correctly, and there's a better
way of discovering and mounting attached storage devices(e.g. hard-disks,
flash-disks etc.)

As per previous discussions, '$!manpage("dmesg")!$' is our friend for discovering 
information about devices recognised/detected by the OpenBSD Kernel. 
When you plug a new device onto an OpenBSD box, it is either recognised 
at startup or recognised at insertion time. Use '$!manpage("dmesg")!$' 
to find out how it has been recognised.

/var/run/dmesg.boot contains the dmesg at boot time.

[Reference System: iwill motherboard with ATAPI IDE CD, SCSI CDR and SCSI Zip drive]

I have 2 CDROM Drives in this machine, and a SCSI card with 
external storage connected to it. $!manpage("dmesg")!$ output
includes the following that have descriptions that describe
storage devices.

<pre class="screen-output">
cd0 at scsibus0 targ 1 lun 0: &lt;E-IDE, CD-ROM 45X, 32&gt; SCSI0 5/cdrom removable
cd1 at scsibus1 targ4 lun 0: &lt;PLEXTOR, CD-R PX-R412C, 1.04&gt; SCSI25/cdrom removable
sd0: 96MB, 96 cyl, 64 head, 32 sec, 512 bytes/sec, 196608 sec total
fd0 at fdc0 drive 0: 1.44MB 80 cyl, 2 head, 18 sec 
</pre>

We discover the following:

- cd0 is attached to an E-IDE CDROM Drive
- cd1 is attached to my Plextor CDR Drive
- sd0 is attached to a 96MB Drive, and
- fd0 is attached to my floppy drive

[ Host: Soekris net4801, OpenBSD 4.6 i386 ]

Sample 'dmesg' output for a few USB External Storage Devices plugged into
the USB port on my Soekris net4801.

[ Device: Generic USB Thumbdrive 2GB ]

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

##### <a name="eg.identify.filesystem"></a> Filesystem

With the above devices connected, we can use $!manpage("disklabel")!$
to determine the filesystem(s) on a device.

[ Device: Generic USB Thumbdrive 2GB on at sd0 ]

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

#### <a name="eg.filesystem"></a> Connect File Systems

##### <a name="eg.mount.points"></a> Mount Points

A mount point needs to be an existing directory on the host filesystem.
If you only ever expect to use the CD/DVD on your host, or only ever
one removable storage device, then maintain the /mnt convention.

For the sake of experimentation, and inserting/removing various 
storage devices, I create the mount points with the following
logical structure:

<pre class="command-line">
# mkdir /mnt 
# mkdir /mnt/cdrom
# mkdir /mnt/floppy
</pre>

This provides a flexibility of one 'root' directory for removable
storage. 

##### <a name="eg.mount"></a> Mounting

&#91;Ref: $!manpage("mount",2)!$ ]

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

### <a name="retained"></a> Retained Information

The Filesystem Table $!manpage("fstab",8)!$ is a configuration
setting that is used to retain Filesystem information between
system restarts. Most commonly, you will find in $!manpage("fstab",8)!$
the device/partition and mount point information for the installed OpenBSD.

In $!manpage("fstab",8)!$ we can set device/partition/filesystems that
are mounted at startup, and we can also add device/partition/filesystem
configurations so that we do not need to specify complete details
for mount to connect the device/partition to our filesystem.

A basic install may bring up something like the below in your
fstab file:

<pre class="config-file">
|| Need some sample here ||
</pre>

The CDROM drive is normally always connected to the host, and
is automatically detected by the kernel at each boot, likewise
whenever media is inserted the kernel is notified by the device
driver. But, the device and mount points are not automatically
configured (mounted) because of the uncertainty of whether
a valid media or filesystem exists. 

Using the above example CDROM drives, we could add the following
to our fstab file.

<pre class="config-file">
# device    mount-point   filesystem  mount_options   check-priority    pass-number
  /dev/cd0a /mnt/cdrom    cd9660      ro,noauto         0                   0
  /dev/cd1a /mnt/cdr      cd9660      rw,noauto         0                   0
  /dev/sd0c /mnt/zip      msdos       rw,noauto         0                   0
  /dev/fd0a /mnt/floppy   msdos       rw,noauto         0                   0
</pre>

Included in the above example, is an example configuration for a floppy
disk device (assuming /dev/fd0 is the controller and /dev/fd0a is the a
drive.) I specify msdos file format since I mostly work with msdos
floppy drives (Winx) and have no need to transfer any other format
floppies. 

With the above example, I can insert a CDR into my Plextor and if it's not
a blank CDR, mount the filesystem with the following command-line:

<pre class="command-line">
# mount /mnt/cdr
</pre>