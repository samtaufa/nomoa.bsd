## First Time - Miscellaneous

<div class="toc">

Table of Contents
<ul>
    <li><a href="#findfile">find files</a></li>
    <li><a href="#singleuser">Single User Mode</a></li>
    <li><a href="#movdir">Moving Directories</a></li>
</ul>

</div>

####  <a name="findfile"></a>Making it easier to find files 

&#91;Ref: $!manpage("locate",8)!$ - find filenames quickly |
$!manpage("locate.updatedb",1)!$ - update locate database |
$!manpage("find",1)!$ - walk a file hierarchy]

Unix has a nice file indexing utility accessible through $!manpage("locate")!$.
The locate program interrogates a database created by locate.updatedb,
in this manner you do not have to traverse the hard-disk each time you
want to find a file. Update the file/location database by using the
locate.updatedb program and then interrogate (search in) the database
by using locate. Start locate.updatedb.

<pre class="command-line">
# /usr/libexec/locate.updatedb 
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

&#91;Ref: [OpenBSD FAQ - 14.0 Disk Setup](http://www.openbsd.org/faq/faq14.html)&#93;

 
Booting the system in Single User Mode is an important option when
you need to perform tasks on the machine that is sensitive to other
user activities on the system. Of course, you could be just like me and
have forgotten root's password or have zapped the shell you used for
root and other accounts and need to dive back into root to fix the
system.

When your system starts up, it momentarily offers the boot&gt;
prompt where we can force single user mode.

<pre class="screen-output">
Using Drive: 0
Partition: 3
reading boot....
probing: pc0 com0 com1 apm mem[639K 95M a20=on]
disk: fd0 hd0
&gt;&gt; OpenBSD/i386 BOOT 1<span class="Code">.</span>26 
boot&gt; <b>boot -s</b>
</pre>

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

&#91;Ref: [OpenBSD FAQ - 14.0 Disk Setup](http://www.openbsd.org/faq/faq14.html)&#93;

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

##### Option 1: 

&#91;Ref: OpenBSD FAQ and e-mail by H&aring;kan Olsson ]

`cd /opt; find . -xdev -depth -print | cpio -pdmu /home/opt`
    
If the 'find' is run on the locally mounted filesystem, this is a
rather efficient method to copy the data. Also, if you move lots of
data and there is the chance it may change during copy/move time (say
user or project data on an NFS-exported partition), you can rerun once
without the 'u' flag to cpio, in which case only updated files are
copied, if any. Not foolproof certainly, but often good enough if you
have sane time in your network (ntp, et al). 

-xdev (x: do not search directories on other file systems/devices,
d: depth-first traversal; e: 

#####  Option 2: 

&#91;Ref: e-mail by Christopher Linn] 

`cd /opt; tar cXf - . | (cd /home/opt; tar xpf - )`
    
This would be if you have any other partitions mounted inside of
/usr, you don't want tar to cross filesystem boundary 

#####  Option 3: 

&#91;Ref: e-mail by Dan Harnett] 

`cd /home/opt; dump -0uaf - /opt | restore -rf -`
    
 It has been my experience that it is safer and more reliable.


Note: the use of the above names in no way implies these people want to
be associated with this information release
