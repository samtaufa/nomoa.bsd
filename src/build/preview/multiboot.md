## MultiBoot - OpenBSD and FAT/NTFS Windows

&#91;Ref: OpenBSD 2.7 i386, Windows NT 4 FAT32/NTFS]
    
<div class="toc">

Table of Contents

<ol>
  <li><a href="#fromdocs">From the Docs</a></li>
  <li><a href="#hdprep">Hard Disk Preparation</a>
  <ul>
      <li><a href="#partition">Partitioning the Hard Disk</a></li>
      <li><a href="#instOpenBSD">Installing OpenBSD</a>
        <ol>
          <li><a href="#fdisk">fdisk</a></li>
          <li><a href="#disklabel">disklabel</a></li>
        </ol></li>
  </ul></li>
  <li><a href="#bootManagers">Boot Managers </a> 
    <ul>
      <li><a href="#osbs1">OS Boot Selector</a> </li>
      <li><a href="#osbs2b8">OS-BS 2.0Beta8</a> </li>
      <li><a href="#mattsoft">mattsoft Boot Manager</a> </li>
      <li><a href="#pm5">Partition Magic 5.0</a></li>
      <li><a href="#GAG">GAG</a> </li>
    </ul></li>
  <li><a href="#ntfs">Windows NTFS File System and OpenBSD</a> </li>
  <li><a href="#ReaderComments">Reader Comments</a> </li>
  <li><a href="#relref">Relative Reference</a> </li>
</ol>
</div>

<p> These instructions should work well for installing OpenBSD dual-boot with 
  Microsoft Windows on the same hard-disk. Multi-booting between OpenBSD and other 
  operating systems gives you the opportunity to learn the advanced features of 
  OpenBSD while still using your favourite Windows applications in Microsoft Windows.</p>
  
<p>These instructions discuss how you can use Boot Managers to configure your 
  system to boot either OpenBSD or your MS Windows OS.</p>
  
<p>The following introduction items will help you better understand the steps 
  to configure dual-boot.</p>
  
<ol>
  <li>Read the section in INSTALL.386 titled <i>Preparing your System for OpenBSD 
    Installation:</i> These 
  instructions have not been tested on varied Hard Disks and controllers so make 
  sure potential problems mentioned in the above document are not going to cause 
  you problems. </li>
  <li>Familiarise yourself with the OpenBSD fdisk program on another OpenBSD installation, 
    by reading $!manpage("fdisk",8)!$  or the <a href="http://www.openbsd.org/faq/faq14.html">14.0 
    Disk Setup FAQ. </a> You should at least have read through the FAQ on using 
    fdisk and disklabel.</li>
</ol>

<p>Dualboot is achieved by using a third-party utility to configure the master 
  boot sector (which also contains the master boot record) to support multiple 
  operating system startup. OpenBSD ships with an early version of os-bs in the 
  2.7/tools directory.</p>
  
<p>For those who have already partitioned their hard disks, just read through 
  the next section to get an idea another way you could have partitioned your 
  system.</p>
  
### <a name="fromdocs"></a>From the Documentation

<p>Because it seems to come up often, here are really important stuff from the 
  documentation (INSTALL.386) please read the rest of the file for more complete 
  instructions. This is but a very brief summary</p>
  
<ol>
  <li>Backup, Backup, Backup. I've lost data doing this kind of stuff, and you 
    are almost guaranteed of doing the same thing.</li>
  <li>Research how DOS layed out the hard-disk (partitioning) and make sure how 
    you do it in OpenBSD are compatible.</li>
  <li>You will likely need to keep all bootable partitions below cylinder 1024. 
    This is usually a limitation for many BIOS's, you may not have this limitation 
    but many don't even check for this limitation and either can't dualboot or 
    experience data-loss, filesystem errors. Again, check the documentation before 
    you continue.</li>
  <li>Create DOS partitions using DOS's fdisk, create Linux partitions using Linux's 
    fdisk (or druid or whatever.) In short, use the partitioning software that 
    comes with an operating system for creating their partition.</li>
</ol>

### <a name="hdprep"></a>Hard Disk Preparation 

#### <a name="partition"></a>Partitioning the Hard Disk

<p><b>Warning. </b>The following is definitely going to wipe all information from 
  your hard disk so make sure (a) you have backed up all data and programs 
  (b) your back-ups are reliable (c) you can recover from your backup 
  files.</p>
  
<p>Partition the hard-disk using Microsoft Windows 98's fdisk program. Divide 
  the size of your hard-disk as you wish and setup MSWindow's FAT partition as 
  the primary partition. (FAT32 works well with these instructions) For example, 
  on my 4GB HDD I'm just going to split the drive into two 2GB partitions.</p>
  
<p>For those relatively new to fdisk partitioning you take a major risk. Read 
  other documentation on FDISK before continuing.</p>
  
<ol>
    <li>FDISK will prompt during startup whether you wish to use Large File System 
    support (which translates to FAT32) <b>select YES</b> for this option.</li> 
    <li>Delete all partitions </li>
    <li>Create Primary MSDOS partition </li>
    <li>Do not use the full drive but specify the amount of 
    space you want to use (eg. 2GB on a 4GB drive) </li>
    <li>Set the partition as ACTIVE </li>
    <li>Exit FDISK </li>
    <li>Restart the Computer</li>
</ol>

<p>Install MS Windows (or format the primary partition, C:, as bootable using 
  format c: /s)</p>
  
#### <a name="instOpenBSD"></a>Installing OpenBSD

<p>During the installation of OpenBSD you will need to give directions for configuring 
  the Hard Disk. The following are guidelines for configuring the disk layout 
  with 'fdisk' and 'disklabel' which are both automatically initiated by the installation 
  process. </p>
  
##### <a name="fdisk"></a>fdisk

<p>Follow the installation process for OpenBSD to the point when it informs you 
  which hard-disks it has discovered on your system, and which disk you wish to 
  designate as the boot disk.</p>

<pre class="screen-output">
Available disks are: 
wd0 

Which disk is the root disk? [wd0] <b>&lt;HIT ENTER&gt;</b></pre>


<p>On many 386 class machines wd0 will be the device name for the hard-disk, continuing 
  with the installation and the next prompt should be whether you wish to use 
  the complete hard-disk for OpenBSD's exclusive use.</p>
  
<pre class="screen-output">
Do you want to use the *entire* disk for OpenBSD? [no] <b>&lt;HIT ENTER&gt;</b> 
</pre>
  
<p>NO. If you are going to be using the same hard-disk for OpenBSD and Windows, 
  then select NO as we choose to double-boot into at least another operating system 
  on the same hard-disk.</p>
  
<p>Selecting no should have started fdisk and placed the prompt inside fdisk working 
  on the primary boot disk (wd0 in this example.) Do not use reinit. </p>
  
<pre class="screen-output">
Only LBA values are valid in ending cylinder for partition #3. 
Enter 'help' for information 
fdisk: 1&gt;</pre>

<p>Doing a "print" at this command prompt should list for us at least four partitions</p>

<pre class="screen-output">
fdisk: 1&gt; <b>p</b>
Disk: wd0       geometry: 
790/255/63 [12691350 sectors]

Offset: 0       Signatures: 0xAA55,0x2F342F33
         Starting        Ending
#: id   cyl  hd sec -   cyl  hd sec [     start -       size]
-------------------------------------------------------------------------
*0: 0B    0   1   1 -   788 254  63 [        <b>63</b> -   <b>12675222</b>] Win95 FAT-32
 1: 00    0   0   1 -     0   0   0 [         0 -          0] unused
 2: 00    0   0   1 -     0   0   0 [         0 -          0] unused
 3: 00    0   0   1 -     0   0   0 [         0 -          0] unused 
</pre>

<p>The display shows the current allocation of partitions for the hard-drive. 
  In our case example, the initial partition "0" is allocated to Windows 95 (FAT32). 
  Since no other partition has been setup, partitions 1 through 3 are unallocated.</p>
  
<p>We pull out the calculator and do a little maths. Add the Offset and Size of 
  Partition 0 to find the offset where we will start our OpenBSD partition.</p>
  
<p>DOS Offset X + Size Y = OpenBSD Offset Z
  <b>63</b> + <b>12,675,222</b> = 12,675,285 </p>
  
<p><i>I've used commas for readability, do not use them when typing the results.
  12,675,285 is the final sector where the Win95 FAT-32 partition reaches, so 
  we start our next (OpenBSD) on the next sector if possible. </i></p>
<p><i>End 12,675,285; ==&gt; start 12,675,286?</i></p>
<p>Now, we create the OpenBSD partition by editing an available partition. We're 
  just picking 1, the next available partition slot from the above diagram.</p>
  
<pre class="screen-output">
fdisk: 1&gt; <b>e 1</b>
</pre>

<p>For the partition type we specify A6 (for OpenBSD). We will not edit the Cylinder/Head/Sector 
  (CHS) mode. For tha partition offset we will use our calculated number above. 
  For the partition size we can take the offered maximum size from the system 
  (the rest of available drive space)</p>
  
<pre class="screen-output">
fdisk: 1&gt; <b>e 1</b>
         
Starting        Ending
 #: id  cyl  hd sec -   cyl  hd sec [     start -       size]
-------------------------------------------------------------------------
 1: 00    0   0   1 -     0   0   0 [         0 -          0] unused
Partition id ('0' to disable)  [0 - FF]: [0] (? for help) <b>A6</b>
Do you wish to edit in CHS mode? [n]<b>&lt;HIT ENTER&gt;</b>
Partition offset [0 - 12691350]: [0] <b>12675286</b>
Partition size [1 - 16066]: [0] <b>16066</b>
fdisk:*1&gt;</pre>

<p>The result of our venture can be displayed by using "p" print. Just in case 
  we typed in something wrong. If you make a mistake you can go back by using 
  "e" edit again, or just "exit" without saving changes.</p>
  
<pre class="screen-output">
fdisk:*1&gt; <b>p</b>
Disk: wd0       geometry: 790/255/63 [12691350 sectors]
Offset: 0       Signatures: 0xAA55,0x2F342F33
         Starting        Ending
 #: id  cyl  hd sec -   cyl  hd sec [     start -       size]
-------------------------------------------------------------------------
*0: 0B    0   1   1 -   788 254  63 [        63 -   12675222] Win95 FAT-32
 1: A6  788 254  63 -   789 254  63 [  12675284 -      16066] OpenBSD
 2: 00    0   0   1 -     0   0   0 [         0 -          0] unused
 3: 00    0   0   1 -     0   0   0 [         0 -          0] unused
fdisk:*1&gt;
 
fdisk:*1&gt; <b>q</b> 
Writing current MBR to disk. 
</pre>

<p>After "q" Quit and Write, the changes you have been made are written to the 
  Master Boot Record and you should be continued into the rest of the installation 
  process. </p>
  
##### <a name="disklabel"></a>Disklabel

<p>The installation process should continue with the disklabel, and should show 
  the MSDOS partition as "i". Obviously you do not want to kill partition "i" 
  or this will seriously cause problems (?-)</p>
  

<pre class="screen-output">
Initial label editor (enter '?' for help at any prompt) 
&gt; <b>p</b> 
#        size   offset    fstype   [fsize bsize   cpg]
  a:    16066 12675284    unused        0     0         # (Cyl. 13412*- 13429)
  c: 12706470        0    unused        0     0         # (Cyl.    0 - 13445)
  i: 12675222       63     MSDOS                        # (Cyl.    0*- 13412) 
</pre>

<p>Once you complete installing OpenBSD you can continue with the boot configuration.</p>

<pre class="screen-output"> 
from disklabel -e wd0
Notes:
Up to 16 partitions are valid, named from 'a' to 'p'. Partition 'a' is 
your root filesystem, 'b' is your swap, and 'c' should cover your whole 
disk. Any other partition is free for any use. 'size' and 'offset' are 
in 512-byte blocks. fstype should be '4.2BSD', 'swap', or 'none' or some 
other values. fsize/bsize/cpg should typically be '1024 8192 16' for a 
4.2BSD filesystem (or '512 4096 16' except on alpha, sun4, amiga, sun3...) 
</pre>

### <a name="bootManagers"></a>Boot Managers 

I have listed the Boot Managers as I have found them, 1st through the OpenBSD 
CD distributions, ftp site, and as I have come across discussions in the mailing 
lists. Hopefully this non-alphabetic listing helps you if you have difficulty 
in obtaining a boot manager.

Most of these Boot Managers have good documentation for installation and configuration. 
Please remember to read their documentation, together with this, to ensure your 
dual boot system works.

<p>My favourite, easiest to install (in most situations) is the GAG</p>

#### <a name="osbs1"></a>OS Boot Selector (os-bs 1.35)

&#91;Ref: installation CD, go on and get radical, buy one. 
It is also available from the OpenBSD ftp site.]
  
Operating System Boot Selector (OS-BS) is supplied as a self-extracting MSDOS 
program (os-bs135.exe) in the 2.X/tools directory. [It's there in 2.7, I think 
I recall seeing it in 2.6, and I have no idea where my 2.5 CDs gone to sleep, 
prior to that I didn't exist.]

If you are installing OpenBSD from the Internet, download the os-bs135.exe 
and place it on the FAT partition or save it to a floppy diskette.</p>
  
<ol>
  <li>Extract the OS-BS 1.35 files onto a floppy disk (or 
  onto your FAT partition, usually executing the program will extract files to 
  the \OS-BS directory, for example: c:\os-bs) </li>
  <li>Read the Instructions that come with OS-BS </li>
  <li>Boot the machine to the MSDOS command prompt. </li>
  <li>Execute the OS-BS.COM program</li>
</ol>

<p>The OS-BS program should display a list of partitions it recognises and prompt 
you to specify which partitions you wish to make bootable. After you have specified 
which partitions are bootable it will then list those partitions and ask you 
to </p>
  
<ul>
  <li>Specify which partitions to include in the boot menu </li>
  <li>Give a label to the bootable partitions. </li>
  <li>Specify which partition will be the default boot 
  partition </li>
  <li>Specify the delay during start-up for you to select an alternate partition 
    to boot from</li>
</ul>

<p>Your Boot Manager has been configured, restart your computer and OS-BS will 
prompt you to choose which OS to boot.</p>
  
<p>Features: </p>

-   Boot Manager allows setting a default OS, and startup 
    timer.
-   Install after both OSs have been installed
-   Tested with MS Windows FAT32 &amp; OpenBSD 2.7
-   Tested with MS Windows NTFS &amp; OpenBSD 2.7

<p>Note:</p>

<ul>
  <li>Does not support more than one hard-drive.</li>
  <li>booteasy is another Boot Manager also available on the Distribution CDs 
    and ftp site.</li>
</ul>

### <a name="osbs2b8"></a> OS Boot Selector 2.0Beta8

&#91;Ref: <a href="http://www.prz.tu-berlin.de/%7Ewolf/os-bs.html">http://www.prz.tu-berlin.de/~wolf/os-bs.html</a>]</p>

OS-BS 2.0Beta8 is an updated development from the 1.x serious <a href="http://www.prz.tu-berlin.de/%7Ewolf/os-bs.html">http://www.prz.tu-berlin.de/~wolf/os-bs.html</a> 
Fortunately a commercial venture bought up the distribution rights to the software, 
and fortunately the author released this version.
  
The 2.0 beta looks much nicer than version 1.x, a more GUIsh (text Windows) 
with easy navigation.
  
<b>Warning</b> from the Readme File:</p>

<pre class="screen-output">
Currently os-bs uses WITHOUT ASKING(!) the sectors 
2, 3, 4, 5 on cylinder 0, head 0 on the first disk. On almost all disks 
I ever saw these sectors (and the whole first track, except sector 1 which 
contains the Master Boot Record) are unused. (BTW, the reason why some boot 
viruses like this place...).
</pre>
      
If you don't like the warning above, don't use 2.0Beta8, buy the retail product 
or use 1.35. Of course it worked fine for me, but that's another story.</p>

There is some discussion in the documentation about how unco-operative most 
OS's are about where they must be located to boot. Fortunately OpenBSD has been 
real nice for me and there was no special configuration apart from just installing 
OpenBSD onto a second drive and setting up 2.0Beta8 (originally had it working 
fine with Partition Magic 5.0's Boot Manager)</p>

Windows NTFS Partition is listed as ID 07, System: OS/2 HPFS, QNX or Advanced 
Unix. </p>
  
Features: </p>

-   Boot Manager allows setting a default OS, and startup 
    timer. 
-   Multiple Drive Support 
-   Install after both OSs have been installed 
-   Tested with MS Windows FAT32 &amp; OpenBSD 2.7 
-   Tested with MS Windows NTFS &amp; OpenBSD 2.7


### <a name="mattsoft"></a>mattsoft Boot Manager

&#91;Ref: <a href="http://www.penguin.cz/%7Emhi/mbtmgr">http://www.penguin.cz/~mhi/mbtmgr</a>]</p>

<p>A heap of configuration options. The latest release should be especially useful 
  for Win9X users (ie. it comes with a Win32 installation program, although you 
  have to drop back to DOS to complete the installation.)</p>
  
<p>One interesting feature in mbtmgr is it supposedly allows you to specify which 
  partition information to make visable to the OS you are configuring. For some 
  reason this resolved an inability I had to configure my Win2000 FAT32 drive 
  so I can mount it in OpenBSD (or Linux Mandrake 7.) hmmmm.</p>
  
<p>I think the value of the Win32 installation is to get all the documentation 
  (html files) onto your system, as well as letting you install stuff programmers 
  love (assembly source code etc.) Urgghhh!!!! This boot manager seems to be maintained 
  so if you want to program some boot stuff, there's technical information here 
  that is most likely to be helpful, as well as like-hearted souls.</p>
  
<p>Features: </p>

<ul>
  <li>Boot Manager allows setting a default OS, and startup 
  timer. </li>
  <li>Multiple Drive Support </li>
  <li>Install after both OSs have been installed </li>
  <li>Tested with MS Windows FAT32 &amp; OpenBSD 2.7 </li>
  <li>Tested with MS Windows NTFS &amp; OpenBSD 2.7</li>
</ul>

#### <a name="pm5"></a>Partition Magic 5.0 Boot Magic (Commercial  Ware)
  
<p>Almost forgot to put this in. Commercial software does work (although this 
  one didn't live up the the speal for which I had originally bought the package.)</p>
  
<p>Partition Magic's Boot Manager works fine with FAT32 and OpenBSD (across multiple 
  drives even.) Real nice graphical screen after boot up, I can't remember what 
  I did to install it, but it must have been easy otherwise I would have dug in 
  to write something. </p>
  
<p>Wonderful thing having well written manuals. Go commercial ware (now where 
  did I put that CD, I've got to get my machine back together 8.p</p>
  
<p>Features: </p>

<ul>
  <li>Boot Manager allows setting a default OS, and startup 
  timer. </li>
  <li>Multiple Drive Support </li>
  <li>Install after both OSs have been installed </li>
  <li>Tested with MS Windows FAT32 &amp; OpenBSD 2.7</li>
</ul>

#### <a name="GAG"></a>GAG

&#91;Ref: <a href="http://www.rastersoft.com/gageng.htm">http://www.rastersoft.com/gageng.htm</a>]</p>

<p>The best thing I liked about this ? You just create a boot disk (whether from 
  Unix or DOS) and your ready to install. Unfortunately (?) this means that your 
  system must support a 3 1/2&quot; High Density Floppy drive.</p>
<p>Installation is well documented and a brief outline is listed:</p>
<ol>
  <li>Download the Image file from the Net</li>
  <li>Extract the Files</li>
  <li>Write the disk image using rawrite or ntrw, or from your unix box.</li>
  <li>Boot from the floppy diskette</li>
  <li>Set configuration using a nice easy to follow graphical system</li>
</ol>
<p>rawrite is supplied with the image file and also available together with ntrw 
  from the CD Distribution or ftp site. The Unix instructions (for raw writing 
  to the floppy disk) may be incorrect.</p>
  
<p>I used the following to create the boot disk onto my floppy:</p>

<pre class="command-line">dd if=disk.dsk of=/dev/fd0a bs=512 count=2880
</pre>

<p>Features: </p>
<ul>
  <li>Boot Manager allows setting a default OS, and startup timer. </li>
  <li>Supports booting from separate drives (eg. HD1, HD2, Floppy)</li>
  <li>Install after both OSs have been installed </li>
  <li>Graphical installation and startup menu (nice sexy touch)</li> 
  <li>Well documented </li>
  <li>Tested with MS Windows FAT32 &amp; OpenBSD 2.9</li>
  <li>You don't need to keep looking for that DOS boot CD/floppy</li>
</ul>

### <a name="ntfs"></a>Windows NTFS File System and OpenBSD 

<p>Dualbooting is possible between an OpenBSD setup and Windows NT 4/2000 formatted 
  with the NTFS file system. As most of the above Boot Managers require some FAT 
  partition on which to install (ie execute from a DOS command prompt) I have 
  previously had to follow the below long route to have the more secure NTFS file 
  system and OpenBSD dualboot. Of course an advantage of retaining FAT32 is that 
  you can mount that drive space into OpenBSD if you wish.</p>

  <p>You may not need to follow the procedures listed below, they were a just the 
  configuration I went through to get it to work.</p>

  <p>1. Install Windows NT/2000 (FAT32 - use FAT for install, convert to NTFS afterwards.)
  2. Install OpenBSD
  3. Boot in DOS
  4. Install/Configure Dual-boot package 
  (success using both mattsoft Boot Manager, GAG, and OS-BS 2.0B8)
  5. Boot in Windows NT/2000 and convert the FAT32 partition to NTFS</p>
  
<p>Now I can multiboot between Windows 2000 (NTFS partition) and OpenBSD 2.7 (A6 
  OpenBSD partition) </p>
  
### <a name="ReaderComments"></a>Reader Commentts

From sickrotten &lt;protected-email&gt;  Wed Mar 21 12:22:23 2001Subject: OpenBSD articles

<pre class="command-line">HI, ,
#1: Big-big tnx. for your _excellent_ OpenBSD tutorial !
I'm a newbie in the world of UNIX (btw. 1-2 weeks of OpenBSD-ing,
i never use any *NIX before), and i found your tutorial
very useful !

#2: In section &quot;DualBoot&quot; you wrote about various bootmanagers.
I can recommend you one nice proggy called &quot;System Commander&quot; -
see it @ <a href="http://www.v-com.com">http://www.v-com.com</a> Besides multibooting    it also
allow partitioning/repartitioning HDDisks ;-) very good tool.
This prog. is commercial.

Fuf. English is tight for me ;-)

// KOT (aka ROTTEN), Russia.
</pre>

### <a name="relref"></a>Relative Reference 
<ul>
  <li><a href="http://webhostingrating.com/libs/nomoa-dualboot-be">Belorussian translation</a> by Mikalay Lisica</li>
  <li><a href="http://www.openbsd.org/faq/faq14.html">FAQ 14. Disk Setup</a> 
  <li> $!manpage("fdisk",8)!$  
  <li><a href="http://geodsoft.com/howto/dualboot/">Dual and Multi Booting FreeBSD, 
    Linux, and OpenBSD</a> George Shaffer's tutorial
  <li> J. Joseph Max Katz' Using OSBS and Windows95 <a href="http://www.monkey.org/openbsd/FUQ/">http://www.monkey.org/openbsd/FUQ/</a> 
  <li> OS-BS 2.0 Beta 8 - OS Boot Selector: <a href="http://www.prz.tu-berlin.de/%7Ewolf/os-bs.html">http://www.prz.tu-berlin.de/~wolf/os-bs.html</a> 
  <li> The Retail Version of OS-BS, the tool that ships with OpenBSD <a href="http://www.bootmanager.com">http://www.bootmanager.com</a> 
  <li>Mattsoft Boot Manager <a href="http://martin.hinner.info/mbtmgr/">http://www.penguin.cz/~mhi/mbtmgr</a> 
  <li>Jim Rees' <a href="http://www.citi.umich.edu/users/rees/openbsd/multi.html">Multi-booting OpenBSD</a></li>
  <li><a href="http://www.ranish.com/part/">Ranish Partition Manager</a> - It will help you to install and dualboot Linux 
    and multiple copies of Windows.</li>
  <li><a href="http://www.ranish.com/part/">XOSL Boot Manager</a> Extended Operating System Loader (XOSL)</li>
</ul>
