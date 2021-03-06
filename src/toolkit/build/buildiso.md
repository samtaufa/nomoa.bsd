## Building a Release CDR

The installation ISO is important for our needs, where the physical
install media is generally required.

Creating the ISO Image requires either the mkisofs tool from cdrtools (an installable
package) or using mkhybrid (part of the base install.)

### Build the Current | Stable Release

Build the Current or Stable release following the FAQ Build instructions

### Compile the Files


There are two parts to compiling the contents for the CD, one is to collect
the files, and the second is to 'layout' the files in a rational manner.

OpenBSD's install process presumes a certain layout and it is good to 
maintain that consistency in our custom CDs such that files are stored
in a hierarchy as below.

<pre class="manpage">
cd-root
+$version
 -$architecture
 +packages
 --$architecture

cd-root
+4.4
 -amd64
 +packages
 --amd64

</pre>

#### Base Environment

Standard environment configuration (since I may want to use copy / paste all over the place
instead of one nice script

#### Create the layout


We'll create our CD layout from within a temporary staging location.

Make space and move the files into a staging area that should reflect the structure of
how we intend to present the CD. THe staging location has to have enough
capacity to handle the collated files as well as the built ISO image

#### Collect the files into the layout

The release build process (see FAQ) creates the release set of files in RELEASEDIR
which normally refers to the /usr/rel directory.

We need to copy these files to our CD layout.

We are now ready to create our ISO file, but for convenience the above CD Layout
gives us a good opportunity to include other relevant files onto the CD.

We can put the current ports tree onto the ISO, with something like:

Files that may be relevant may include packages, source files, or other archive files.

A strandard location for packages is:    ${STAGING_DIR}/${REV}/packages/${ARCH}

### Build the ISO Image

With OpenBSD 4.4 the <a href="https://calomel.org/bootable_openbsd_cd.html">cdrom$REV.fs 
file is replaced by cdbr,</a> and requires the use of the -no-emul-boot
option for mkisofs.

OpenBSD 4.3 and earlier created cdrom$REV.fs used as the bootfile when generating an ISO, 
and did not use the -no-emul-boot option. The .fs is no longer generated with the standard release build.

### Mount ISO Image

[ <a href="http://www.openbsd.org/faq/faq14.html">FAQ 14.10 - Mounting disk images in OpenBSD</a> ]

<pre class="command-line">
vnconfig svnd3 ISOPATH
mount -t cd9600 /dev/svnd0c /MOUNTPOINT
</pre>

When testing is completed, restore the virtual devices.
<pre class="command-line">
umount /MOUNTPOINT
vnconfig -u snvd3
</pre>

### Burn the CD

&#91;Ref: <a href="http://www.openbsd.org/faq/faq13.html#burnCD">FAQ: How do I burn CDs and DVDs</a>]
    <ul>
        <li>Locate your CDR Drive
        <li>Record the ISO file to CDR
    </ul>
    
### Locate your CDR Drive

Determine where OpenBSD thinks your cdr is found
<pre class="command-line">
dmesg | grep ^cd
</pre>

<pre class="screen-output">
cd0 at scsibus0 targ 0 lun 0: &lt;ATAPI, DVD A DH16A1L, KH37&gt; ATAPI 5/cdrom removable
cd0(pciide0:0:0): using BIOS timings, Ultra-DMA Mode 5
</pre>

The above dmesg indicates our device is located at /dev/cd0 with partitions a ... (onwards)

### Record the ISO file to CDR(W)

<pre class="command-line">
cdio -v -f cd0c tao file-to-burn.iso
</pre>

<pre class="screen-output">
track 01 'd' 00327142/00327142 100%
Closing session
</pre>

### Test new CDR

<pre class="command-line">
mount -t cd9660 /dev/cd0c /mnt
</pre>

## Appendix

<!--( block | syntax("py") )-->
$!showsrc("toolkit/build/mkopenbsd.sh")!$
<!--(end)-->
