## Encrypting Disk Partitions

[OpenBSD 4.6]

<div style="float:right">

Table of Contents

-   Partition
-   vnode disk driver
-   Partition Encryption Node
-   New File System

</div>

Full disk encryption is not supported, and these notes review
the use of the svnd device for configuring encrypted partitions.

First, install OpenBSD, creating and mounting the home partition as usual.

Now, as root, do the following (/dev/mntpointpart is your 
home partition throughout):

### Partition

Pick a partition, or new drive we wish to encrypt.

Make sure it isn't mounted by using the following command.
    
<pre class="command-line">
umount /mntpoint
</pre>

### vnode disk driver

[ $!manpage("vnd",4)!$, $!manpage("vnconfig",8)!$ ]

The vnode disk driver supports associating the special
file _vnd\_dev_ with a regular file, or partition.

For our example, we'll associate the safe vnode disk drive
_svnd0_ to the physical partition.

<pre class="command-line">
vnconfig -k svnd0 /dev/DEVICE_PARTITION
</pre>

Where DEVICE_PARTITION is a device partition such as sd0d or sd2f.

The above command-line will associate an encryption key 
with the device, you will be prompted for a password.

<pre class="screen-output">
Encryption key:
</pre>

We now have a vnode encrypted device at /dev/DEVICE_PARTITION.

### Partition Encrypted Partition

Create partition a on the encrypted device

<pre class="command-line">
disklabel -E /dev/DEVICE_PARTITION
</pre>

Where DEVICE_PARTITION is a device partition such as sd0d or sd2f. 

### New File System

Create a new filesystem on the encrypted node
    
<pre class="screen-output">
newfs /dev/DEVICE_PARTITION
</pre>

Where DEVICE_PARTITION is a device partition such as sd0d or sd2f. 

### File System Table

Now, set up the /mntpoint partition in _fstab_:

<pre class="screen-output">
/dev/DEVICE_PARTITION /mntpoint ffs rw,nodev,nosuid 1 0
</pre>

Test that this configuration works by going:

<pre class="command-line">
    mount /mntpoint
</pre>

The final step is to ensure that the encrypted node is associated with the
partition on startup. First, we need to set the partition type to "unknown", or
OpenBSD will complain that the type does not match fstab on startup. To do this
run:

<pre class="command-line">
    disklabel -E /dev/DEVICE_PARTITION
</pre>

Use the command interface to change the partition type. Now add a line like the
following _before_ the line that mounts /mntpoint in _fstab_:

<pre class="command-line">
    /dev/DEVICE_PARTITION /dev/svnd0c vnd rw,nodev,nosuid,-k 1 0
</pre>

Reboot to test that this works. You should be prompted for a decryption
password on startup.

OpenBSD will use your entered password and attempt to use it for decrypting
the device, _OpenBSD does not validate the password_. If you enter your password
incorrectly, the mount process will fail horribly and you will have to _umount_
all the mount devices and remount manually.

Note that we have turned fsck off for both lines - this is necessary because
fsck tries to run before the encrypted node is mounted.
