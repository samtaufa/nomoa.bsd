## Remove Users

&#91;Ref: [BSD Certification](http://www.bsdcertification.org/downloads/user_management.pdf) |
[User Administration](../install/useradmin.html)  | 
[FAQ 10](http://www.openbsd.org/faq/faq10.html#AddDelUser)]

<div class="toc">

Table of Contents

<ol>
    <li>Note username, user-#, group-#</li>
    <li>Ensure user isn't logged in</li>
    <li>Remove user account
        <ul>
            <li>Home Directory</li>
            <li>$USERNAME cron settings</li>
            <li>$USERNAME /etc/passwd settings</li>
            <li>$USERNAME /etc/groups settings</li>
        </ul>
    </li>
    <li>Sanity Check
        <ul>
            <li>SSH Authorized Keys</li>
            <li>Orphaned Files</li>
            <li>Root Password</li>
            <li>Start-up configurations</li>
            <li>User configuration files in /etc</li>
            <li>WWW configuration files</li>
            <li>Accounts in Databases</li>
        </ul>
    </li>
</ol>

</div>

If you are new to managing user accounts on OpenBSD, please refer to the above two resources. 
The [BSD Certification](http://www.bsdcertification.org/downloads/user_management.pdf), 
are a very solid grounding in the theory and practise of user administration. 
Refer [FAQ 10](http://www.openbsd.org/faq/faq10.html#AddDelUser) for explicit review
of available command-line tools.

These notes discuss general 'principals' we currently practise for removing
user accounts, more specifics are in the above two posts, and in
the script file we use for creating new users.

Removing users should follow an established procedure, where
we present opportunities to reconsider activities, review the process, 
and minimise potential for forgetting important elements
in the removal of the account, privileges.

A good list of items to confirm during the account removal
include:

-   Note username, user-#, group-#
-   Ensure user isn't logged in
-   Remove user account
-   Find orphaned files
-   Sanity check start-up configurations
-   Sanity check user configuration files in /etc
-   Sanity check user configuration files in other application space
-   Sanity check user accounts in databases

Using the user login name (username) that we know we want to remove, we first establish 
a few 'related' details that will be important when we want to
make later searches, to 'complete' the removal process.

<pre class="command-line">
USERNAME=username
</pre>

### 1. Note username, user-#, group-#

Grab the user-id and group-id, this information is linked to at least
file ownership throughout the system. The user may own files outside
their home directory. It is important to ensure that those files are
dealt with correctly.

One command-line method of reviewing the uid, gid is below.

<pre class="command-line">
grep "^$USERNAME:" /etc/passwd
</pre>

The above grep will show the 'username' details from the /etc/passwd file.
Or, we can explicitly extract the User ID, which is field #3, and the
group id, field #4.

<pre class="command-line">
grep "^$USERNAME:" /etc/passwd | awk -F : '{ print "uid:"$3", gid:" $4}'
</pre>

 We can either manually note down the above uid, gid, or we can put them 
 into another set of shell variables, such as in the below.

<pre class="command-line">
USER_ID=`grep $USERNAME /etc/passwd | awk -F : '{ print $3 }'`
GROUP_ID=`grep $USERNAME /etc/passwd | awk -F : '{ print $4 }'`
</pre>


### 2. Ensure user isn't currently logged in'

&#91;Ref: $!manpage("w",1)!$]

Preferably the fewer people logged in during this process the saner the
environment, but especially we don't need the user being logged
in at this time.

$!manpage("w",1)!$ is a great tool for noting which users are currently
online. In particular, we are mostly concerned that the user we've
specified in $USERNAME is not currently logged in.

So, execute w and grab headers (1st 2 lines) and see if there's
any instance of the user active on the system.

<pre class="command-line">
/usr/bin/w | /usr/bin/head -2
/usr/bin/w | /usr/bin/grep "^$USERNAME"
</pre>

If they're still active on the system, WHAT??? are they doing, 
and WHY!!!????

(At this point, it would be useful to check the users cron settings
to ensure none of the cron jobs are currently active as well)

`cat /var/cron/tabs/$USERNAME`

### 3. Remove the user account(s)

&#91;Ref: $!manpage("rmuser")!$]

Before removing a user account, a sanity review of the users cron and /home directory
may be preferred, because in a scripted configuration we're just going to
blow away the user home directory.

$!manpage("rmuser")!$ username behaves differently amongst the Unix variants, and
under OpenBSD will remove:

* Home Directory - /home/$USERNAME (optional during interactive session)
* $USERNAME cron settings (/var/cron/tabs/$USERNAME)
* $USERNAME settings in /etc/passwd (and related files such as master.passwd)
* $USERNAME settings in /etc/groups

#### 3.1 Home Directory 

Normally at /home/$USERNAME, but you can/should obviously verify the 
setting from the /etc/passwd file.

Blowing away a users home directory is sometimes a good idea, other times
it's not so bright. Make sure you know what your policy, procedures are
for 'retired' user files.

#### 3.2 Cron settings (/var/cron/tabs/$USERNAME)

You should check the users cron jobs, they may have been instrumental
in some activity for the organisation and it's hidden in their cron job.

#### 3.3 Settings in /etc/passwd (and related files such as master.passwd)

Verify this is really the user that you want to 'blow away.'

#### 3.4 Settings in /etc/groups

A basic check list of the username's Group involvement.

-   What groups were they in
-   Did they  own any particular groups
-   After deletion, verify that the user has been correctly 
    removed from all those places.

After you've performed your preliminary sanity check, go ahead and blow
away the user with $!manpage("rmuser")!$

<pre class="command-line">
sudo rmuser $USERNAME
</pre>


### 4. Sanity Check 

#### 4.1 SSH Authorized Keys

Check the system authrised keys files for any immediately visible
changes such as the authorised file, modification times.

A more thorough check would check the authorised key per the /home directories
listed in the /etc/passwd. Make sure the users SSH key settings are
not in another user accounts __authorized_keys__

After all, no value in deleting the user account, if the user can just
hop in on another person's account, with their existing SSH keys.

#### 4.2 Find orphaned files

Check for orphaned files that may cause functionality issues at a later time
or may be vectors for other forms of instability.

Some files may need to be maintained, but there's generally a problem with leaving files
on the system that are associated with someone who has been removed (i.e. a new user may
inherit the group/username and thus have the privileges of those files)

You will need to make a judgement call on who the new user/group owners for orphaned
files may be, for example:

<pre class="command-line">
find / -user $USER_ID -exec chown root:wheel "{}" ";"
find / -user $USER_ID -type f -exec chmod 600 root:wheel "{}" ";"
</pre>

#### 4.3 Root Password

If the user had root access, then a lot of other sanity checks come into play,
the simplest being to  change the root password.

<pre class="command-line">
# passwd root 
</pre>

If the user had password access to other user accounts, 
change the password on those accounts as well.

#### 4.4 Startup Configuration.

Check current user account settings for unintentional openings, 
such as root access being available in a non-standard way.

#### 4.5 Go into /etc and grep for the userid, 

Verify in the configuration path (/etc) there are no
other configurations in which the user was registered

<pre class="command-line">
/usr/bin/grep -r $USERNAME /etc/*  | grep -v "Binary file" |  grep -v "^/etc/termcap"
</pre>

Remember that these are not the only paths where user settings
are noted in text files.

#### 4.6 WWW

Go into /var/www and (and other application configuration directories 
where user accounts may have been created) and search for instances
of the username.

<pre class="command-line">
DIRECTORIES="conf htdocs etc"
for i in $DIRECTORIES do
    /usr/bin/grep -r $USERNAME /var/www/$i | \
        grep -v "Binary file"
done
</pre>

Obviously, with applications the user may not be using the same username
as for host access.

#### 4.7 Accounts in Databases

Various services are operational across the spectrum of machines, 
make sure you have some sort of procedure for verifying whether
user accounts are administered seperately for users.

General Services often installed with OpenBSD include:

-   Databases: MySQL, PostGreSQL
-   E-mail: sendmail, postfix
-   User VPN: OpenVPN
-   Web Services: apache, content-management systems, nagios
