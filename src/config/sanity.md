
## Change Management - Configurations

Reviewing, approving, sanitising configuration changes is documented
below:

<ol>
    <li><a href="#retrieve">Retrieve active configurations and compare to current sanitised archives</a>
    <li><a href="#review">Manually Review differences</a>
    <li><a href="#maintain">Maintain permissions for files</a>
    <li><a href="#build.approved.archives">Build Archive Backups of approved configuration settings</a>
    <li><a href="#build.iso">Build DR ISO</a>
    <li><a href="#archive.iso">Archive DR ISO</a>
</ol>

The <b>/usr/local/sbin/dailychklist</b> script will automate 'retrieving active configurations'

After running the /usr/local/sbin/dailychklist there are three important sets of configuration files.

- /var/syncback/approved - Approved configuration sets

- /var/syncback/archives - tarr'd version of approved configuration sets

- /var/syncback/sync - Current configuration sets
   
The approval process is to revert or confirm changes in the current configuration set to the approved set.

The configuration sets are stored by hostname as per below example as a directory or `tar` compressed file:

<pre class="screen-output">
/var/syncback/approved/sydintfw01/
/var/syncback/approved/sydintfw02/
:::
/var/syncback/archives/sydintfw01.tgz
/var/syncback/archives/sydintfw02.tgz
:::
/var/syncback/sync/sydintfw01/
/var/syncback/sync/sydintfw02/
</pre>


### <a name="retrieve">Retrieve active configurations and compare to current sanitised archives</a>

To manually retrieve the current configuration files, you can manually execute the appropriate command.

<pre class="command-line">/usr/bin/env python2.5 /usr/local/sbin/syncback/syncback.py --quiet --retain \
    > syncback.info 2> /dev/null</pre>

The /usr/local/sbin/dailychklist sends an email with the syncback.py `diff` output comparing the remote 
configuration and the approved configuration. That list is then used to confirm whether the changes need to be approved, or removed.

### <a name="review">Manually Review differences</a>

To approve changes, we copy the remote configuration file over the existing approved configuration.

    - /var/syncback/sync - Remote Configuration Files for review
    - /var/syncback/approved - Approved Configuration files

<pre class="command-line">cp -p $SRCFILE $DSTDIR</pre>

For example:

If we approve changes made to the __pf.conf__ file on sydintfw01 then the approval process will be as below:

<pre class="command-line">
cp -p /var/syncback/sync/__sydintfw01/etc/pf.conf__ /var/syncback/approved/__sydintfw01/etc__
</pre>


### <a name="maintain">Maintain permissions for files</a>

Permissions are important security items for sensitive files and are maintained by using the "-p" option of the copy
command.

<pre class="screen-output">
.-p      Preserve in the copy as many of the modification time, access
         time, file flags, file mode, user ID, and group ID as allowed by
         permissions_.

         If the user ID and group ID cannot be preserved, no error message
         is displayed and the exit value is not altered.

         If the source file has its set-user-ID bit on and the user ID
         cannot be preserved, the set-user-ID bit is not preserved in the
         copy's permissions.  If the source file has its set-group-ID bit
         on and the group ID cannot be preserved, the set-group-ID bit is
         not preserved in the copy's permissions.  If the source file has
         both its set-user-ID and set-group-ID bits on, and either the us-
         er ID or group ID cannot be preserved, neither the set-user-ID
         nor set-group-ID bits are preserved in the copy's permissions.
</pre>

### <a name="build.approved.archives">Build Archive Backups of approved configuration settings</a>

Once completed with approving changes, build the archives using the below script.

<pre class="command-line">
/usr/local/sbin/buildarchive.sh
</pre>

### <a name="build.iso">Build DR ISO</a>

Build a CDR for installing configuration files, using the configurations from built archives.

<pre class="command-line">
# /usr/local/sbin/drdata_build.sh
</pre>

The current configuration ISO will be located in:

<pre class="screen-output">
/mnt/logs/drdata-YYYY.MM.DD.iso
</pre>

This location is automatically archived to tape each night.

<pre class="screen-output">
TEST Using:

    vnconfig svnd0 /mnt/logs/drdata-2010.02.26.iso
    mkdir -p /mnt/iso
    mount -t cd9660 /dev/svnd0c /mnt/iso
    export CONFIGS=/mnt/iso/configs
    export PKG_PATH=/mnt/iso/packages

    for i in `ls /mnt/iso/configs/ | grep .tgz | sed s'/.tgz//g'`; do \
        /mnt/iso/verifypackages.sh $i; \
    done

    umount /mnt/iso
    vnconfig -u svnd0


BURN Using:

    /usr/bin/cdio -v -f /dev/rcd0c tao /mnt/logs/drdata-2010.02.26.iso
</pre>

### <a name="archive.iso">DLS Archive DR ISO</a>

To make a CDR for the DR Library, move the current ISO to a folder that can
be accessed from another system for burning to CDR

For example:

<pre class="command-line">
cp /mnt/logs/drdata-YYY.MMM.DD.iso /var/reports
</pre>

Burn the ISO to a CDR and give it to Leon.

