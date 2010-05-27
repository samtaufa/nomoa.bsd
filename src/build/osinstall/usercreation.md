## Creating New Users

Table of Contents

-   <a href="#adduser">Add User</a>
    - User Shell
    - Random Passwords with spew.pl
    - Create Administrator Accounts
    - Create Regular Accounts
    - Create authpf Accounts
    - Set appropriate groups
    - Copy SSH public keys
    - Configure SUDO privileges
    - Audit
-   <a href="#remuser">Remove User</a>
    - Note user-id, user-#, group-#
    - Ensure user isn't logged in
    - Remove user account
    - Find orphaned files
    - Sanity check start-up configurations
    - Sanity check user configuration files in /etc
    - Sanity check user configuration files in other application space
    - Sanity check user accounts in databases

[ ref: <a href="http://www.bsdcertification.org/downloads/user_management.pdf">BSD Certification</a> |
  <a href="useradmin.html">User Administration</a> ]

If you are new to managing user accounts on OpenBSD, please refer to the above two resources. 
The <a href="http://www.bsdcertification.org/downloads/user_management.pdf"> 
BSD Certification notes</a>, are a very solid grounding in the theory and practise.

These notes discuss general 'principals' for creating and removing
user accounts, more specifics are in the above two posts, and in
the script file we use for creating new users.

### <a name="adduser">Add User</a>

We generally have three types of users, which simplifies our  
'standard' configuration. 

- Administrators (members of the wheel group)
- Regular users (not members of the wheel group)
- Authpf user accounts (no shell)
    
We also only support remote host access through SSH Public Key Infrastructure
which simplifies account creation, because we generate random passwords. We
thus require ssh public keys in our account creation process.

Adding users to a new host is generally sequenced in the following manner.

<ol>
    <li>Create Administrator Accounts
        <ul>
        - Users: samt, ...
        - Group: usergroup, wheel
        - Login Class: staff
        - Shell: /bin/ksh
        </ul>
    <li>Create Regular Accounts
        <ul>
        - Users: control
        - Group: usergroup
        - Login Class: default
        - Shell: /bin/ksh
        </ul>
    <li>Create authpf Accounts
        <ul>
        - Users: samt_authpf
        - Group: usergroup
        - Login Class: authpf
        - Shell: /usr/bin/authpf
        </ul>
    <li>Audit
</ol>

Where `usergroup` is the user's private group (normally the same name
as the user-account.)

Which has lead us to creating an 'sh' script to automate the sequence.

Operationally the sequence for creating standardised accounts on a new host are:

#### Random Passwords with spew.pl

<a href="http://www.perlmonks.org/?node_id=124838">spew.pl</a>) 
a perl script using OpenBSD's /dev/urandom for generating random 
passwords is used. The rationale for spew.pl is not to define what 
is a secure password generator, but an adequate tool using OpenBSD's 
base services (i.e. perl and /dev/urandom)

#### Copy SSH public keys

Install public keys for all accounts, by copying the users' public keys to the 'new' host, 
and copy the contents to their relevant user account.

#### Configure SUDO Privileges

Depending on policy, set the /etc/sudoers configuration appropriately.

Refer sudo(8) and <a href="sudoers.html">sudoers.html</a> for further assistance.

#### Audit

Check for basic account security items.

<ul>
    <li>/etc/passwd
    <li>/etc/group
    <li>/etc/sudoers
</ul>

##### /etc/passwd

Are there any other uses in /etc/passwd with 'root' (uid:0) or 'wheel' (group-id:0) level priviliges ?

<pre class="command-line">
$ sudo grep :0: /etc/passwd
</pre>

<pre class="screen-output">
root:*:0:0:Charlie &amp;:/root:/bin/ksh
</pre>

##### /etc/group

Who are members of the group with 'wheel (group-id:0) privileges.

<pre class="command-line">
$ sudo grep ":0:" /etc/group
</pre>

<pre class="screen-output">
wheel:*:0:root,samt
</pre>

##### /etc/sudoers

Who have we given privileges to in the /etc/sudoers file. 

<pre class="command-line">
$ sudo grep -v "^#" /etc/sudoers  | grep -v "^$" | grep -v "^Defaults"
</pre>

<pre class="screen-output">
root    ALL=(ALL) SETENV: ALL
%wheel  ALL=(ALL) NOPASSWD: SETENV: ALL
</pre>

### <a name="remuser">Remove Users</a>

<ol>
  <li>Note user-id, user-#, group-#
  <li>Ensure user isn't logged in
  <li>Remove user account
  <li>Find orphaned files
  <li>Sanity check start-up configurations
  <li>Sanity check user configuration files in /etc
  <li>Sanity check user configuration files in other application space
  <li>Sanity check user accounts in databases
</ol>

Let's define the user we're going to be ridding from the hosts up front, 
so the value can be reused later on.

<pre class="command-line">
export DEL_USER="give-me-a-name"
</pre>

#### 1. Note user-id, user-#, group-#

We grab the user-id and group-id as this will be useful later.

<pre class="command-line">
grep $DEL_USER /etc/passwd
grep $DEL_USER /etc/passwd | awk -F : '{ print "uid:"$3", gid:" $4}'
DEL_USERID=`grep $DEL_USER /etc/passwd | awk -F : '{ print $3 }'`
DEL_GROUPID=`grep $DEL_USER /etc/passwd | awk -F : '{ print $4 }'`
</pre>


#### 2. Ensure user isn't currently logged in'

Preferably the fewer people logged in during this process the saner the
environment, but especially we don't need the user being logged
in at this time and presents a number of warning flags (if they are 
logged in.)

<pre class="command-line">
/usr/bin/w
/usr/bin/w | /usr/bin/grep $DEL_USER
</pre>

#### 3. Remove the user account(s)

Before removing a user account, a sanity review of the users cron and /home directory
may be preferred

rmuser user-id (under OpenBSD) will remove:

   * /home/$DEL_USER (optional during interactive session)
   * crontab
   * /etc/passwd settings
   * /etc/groups settings

<pre class="command-line">
sudo rmuser $DEL_USER
</pre>

#### 4. Sanity Check - SSH Authorized Keys

Check the system authrised keys files for any immediately visible
changes such as the authorised file, modification times.

A more thorough check would check the authorised key per the /home directories
listed in the /etc/passwd file as it is readily feasible to 

#### 5. Find orphaned files and make a call on what to do with them.

Check for orphaned files that may cause stability issues at a later time
or may be vectors for other forms of instability.

Some files may need to be maintained, but there's generally a problem with leaving files
on the system that are associated with someone who has been removed (i.e. a new user may
inherit the group/user-id and thus have the privileges of those files)

You will need to make a judgement call on who the new user/group owners for any found
files may be, for example:

<pre class="command-line">
find / -user $DEL_USERID -exec chown root:wheel "{}" ";"
</pre>

#### 6. Security Sanity Check - Change Root Password

If the user had root access, then change the root password.

<pre class="command-line">
# passwd root 
</pre>

#### 7. Security Sanity Check of Startup Configuration.

Check current user account settings for unintentional openings, such as root access being
available in a non-standard way.

#### 8. Go into /etc and grep for the userid, incase there are other configurations in which the user was registered

<pre class="command-line">
/usr/bin/grep -r $DEL_USER /etc/*  | grep -v "Binary file" |  grep -v "^/etc/termcap"
</pre>

#### 9. Go into /var/www and (and other application configuration directories where user accounts may have been created) grep for the userid.

<pre class="command-line">
/usr/bin/grep -r $DEL_USER /var/www | grep -v "Binary file" \   
    | grep -v "/var/www/log" | grep -v "/var/log"
</pre>

#### 10. Review applications who store their account details in databases, or has files.

<ul>
  <li>Databases: MySQL, PostGreSQL
  <li>E-mail: sendmail, postfix
  <li>User VPN: OpenVPN
  <li>Web Services: nagios
</ul>
