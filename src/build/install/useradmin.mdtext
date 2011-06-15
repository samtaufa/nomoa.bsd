## User Administration
    
<div class="toc">

Table of Contents

<ol>
    <li><a href="#instAddUser">Adding a New User</a>
        <ul>
            <li><a href="#instgroup">Specifying group access privileges</a></li>
        </ul></li>
    <li><a href="#instchpass">Changing details of a User</a></li>
    <li><a href="#rmuser">Deleting a User</a></li>
    <li><a href="#instGroupManagement">Group Management</a>
        <ul>
            <li><a href="#groupadd">Create a New Group</a></li>
            <li><a href="#usermod">Adding users to an existing Group</a></li>
        </ul></li>
    <li><a href="#instRoot">Root, Super Administrator</a>
		<ul>
			<li><a href="#instAssigningPrivilegesToOrdinaryUsers">Assigning Root Privileges 
			  to Ordinary</a> 
			<ol>
			  <li><a href="#instgroupwheel">Setting wheel during account 
				creation</a></li>
			  <li><a href="#instusermodwheel">Using the usermod -G command</a></li>
			  <li><a href="#instmanuallyeditgroupwheel">Manually Editing 
				the file /etc/group</a></li>
			</ol></li>
		</ul></li>
    <li><a href="#instmovetoroot">Moving from UserID to root</a></li>
</ol>
    
</div>

&#91;Ref: <a href="http://www.bsdcertification.org/downloads/user_management.pdf">BSD Certification</a> |
  <a href="useradmin.old.html">User Administration</a>| <a href="http://andrsn.stanford.edu/FreeBSD/newuser.html">New User (article)</a> |
  <a title="What to do AFTER you have BSD installed by Chris Coleman" 
  href="http://www.daemonnews.org/200005/chrisc@daemonnews.org">Daemon News (article)</a> |
  $!manpage("adduser",8)!$, $!manpage("group",8)!$, $!manpage("rmuser",8)!$ ]
  
[ Required Decisions: user-name, account-type]

From the man pages <i>adduser(8)</i>:

<pre class="manpage">
<b>DESCRIPTION</b>
    The <b>adduser</b> program adds new users to the system. The <b>rmuser</b> 
    program removes users from the system. When not passed any arguments, 
    both utilities operate in interactive mode and prompt for any required 
    information.
</pre>

The first thing that a fresh install of OpenBSD warns of when you login is, 
do not login as root but use su. This is saying that you should create a user 
who can use su (the Substitute User program) to change to the &quot;root&quot; 
user when you want to perform administration tasks.

The following instructions guide you through the creation of a new user with 
SuperUser access privileges.

OpenBSD supplies the <b>adduser</b> script to simplify adding new users. All 
you have to know to create a new user is the name of the person, and what you 
want the login account name to be.

The adduser script is started at the command prompt.
    
<pre class="command-line">
# <b>adduser</b> 
</pre>

When first started, <i>adduser </i>will query you to set or change the default 
settings. Once the standard configuration has been set, it will continue by 
prompting for adding new users.
    
####  <a name="instAddUser"></a>Adding a New User

adduser supports two flags -silent or -verbose. You don't really need to know 
these at the beginning, but you can check the details in the man pages. Read 
through the example below and then start adduser to create your new account.

<pre class="command-line">
# adduser
</pre>

<pre class="screen-output">
Enter username [a-z0-9_-]: <b>bricker</b>
Enter full name [ ]: <b>Sven De La Palmer</b>
Enter shell bash csh ksh nologin sh [bash]: <b>&lt;hit ENTER&gt;</b>
</pre>
        
The shell is your command line interpreter. It reads in the commands you type 
and tries to decipher them. There are several different shells to choose from. 
If bash does not show on the screen, then review adding packages in the <a href="installation.htm">1st 
Time Config introduction</a>. You can change your settings at a later time so 
do not worry if some settings are not as you want them right now. The documentation 
that comes with OpenBSD says that 'most people' use bash.
    
<pre class="screen-output">
Enter home directory (full path) [/home/bricker]: 
<b>&lt;hit ENTER&gt;</b>
Uid [1002]: <b>&lt;hit ENTER&gt;</b>
</pre>

The uid is the User ID number that the system uses to keep track of people. 
These should be unique on the system. Use the default values offered by the 
program unless you have good knowledge of previously granted ID numbers.
    
<pre class="screen-output">
Enter login class: default []: <b>&lt;hit ENTER&gt;</b>
</pre>

The login class allows you to set up resource limits for groups of users. 


##### <a name="instGroup"></a>Specifying user-group privileges 

<pre class="screen-output">
Login group bricker [bricker]: <b>&lt;hit ENTER&gt;</b>
Login group is &quot;bricker&quot;. Invite bricker into other groups: 
guest no
[no]:&nbsp; <b>&lt;hit ENTER&gt;</b>
</pre>

Login groups are used to divide security privileges by account groups. For 
most users you can use the default setting (NO) and just hit <i>Enter</i> to 
continue.

If the account you are creating will be your Administrator account, then you 
must make sure that you have specified the <a href="#instRoot">group 'wheel' 
</a>in the above response. Don't worry if you make a mistake, we can fix it 
later.

<pre class="screen-output">
Enter password []: 
Enter password again []: 
</pre>

You will be asked for the user's password twice and it will not be displayed. 
Afterwards, it will display all of the user's information and ask if it is correct. 

    
<pre class="screen-output">
Name:&nbsp;&nbsp;&nbsp;&nbsp; bricker 
Password: **** 
Fullname: Sven De La Palmer 
Uid:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1000 
Gid:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1000 (bricker) 
Class:&nbsp;&nbsp;&nbsp; 
Groups:&nbsp;&nbsp; bricker
HOME:&nbsp;&nbsp;&nbsp;&nbsp; /home/bricker 
Shell:&nbsp;&nbsp;&nbsp; /bin/sh 
OK? (y/n) [y]: <b>&lt;hit ENTER&gt;</b> 
</pre>

If you make a mistake, you can start over, or its possible to correct most 
of this information using the '$!manpage('chpass')!$' command (discussed below).

<a name="instchpass"></a>    

#### Changing User Information 
    
&#91;Ref: $!manpage('chpass',1)!$, $!manpage('vipw',8)!$]

Once you've configured the base system for working, we can look at basic configuration of users. Note, for those
with some previous Unix experience, Do not just edit /etc/passwd or /etc/Master.passwd

    
Use the chpass utility when adding or changing user information. If you try 
to modify the user shell selection manually (by changing /etc/passwd) it wont 
work, trust me I've made this mistake for weeks before I found out my errorneous 
ways.
    
Entered at the command line without a parameter (ie. typed by itself,) chpass 
will edit your personal information. As root, you can use it to modify any user 
account on the system. You can find more details on chpass in the man pages, 
but let's go through an example review of the account we created above.</p>

<pre class="command-line">
# <b>chpass bricker</b> 
</pre>

This will bring up information about the user '<i>bricker</i>' in the '<i>vi</i>' 
editor. The password line is encrypted, so don't change it. If you want to disable 
the user, one method would be to add a # at the beginning of the password string, 
so you can easily remove it later when you want to reactivate the user. There 
are methods of disabling user that may be better though.
    
<pre class="screen-output">Login: bricker 
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

        
Remember your vi commands ?

-   <b>:q</b> (colon+q) quit, 
-   <b>:w </b>(colon+w) write, 
-   <b>:q!</b> (colon+q+exlamation-mark) quit without saving. 

If you're still having problems, remember [the tutorial](http://www.freebsd.org/tutorials/new-users)
    
Alternative tools, useful for batch processing include: usermod</p>

&#91;Ref: [What to do AFTER you have BSD installed](http://www.daemonnews.org/200005/chrisc@daemonnews.org)]
by Chris Coleman

<a name="rmuser"></a>

#### Deleting a User

&#91;Ref: $!manpage("rmuser",8)!$, $!manpage("user",8)!$, $!manpage("useradd",8)!$, $!manpage("userinfo",8)!$, $!manpage("usermod",8)!$, $!manpage("userdel",8)!$ ]
  
From the man page <i>$!manpage("userdel",8)!$</i>

<pre class="manpage">
The userdel utility removes a user from the system, 
optionally removing that user's home diretory and any subdirectories.
</pre>

The main options are used during account deletion.

<pre class="manpage">
<b>userdel [-prv]</b> <i>user</i>

The following command line options are recognised:

<b>-p</b> preserve the user information in the password file, but do 
not allow the user to login, by switching the password to an ``impossible'' 
one, and by setting the user's shell to the false(1) program. This option 
can be helpful in preserving a user's files for later use by members of 
that person's group after the user has moved on. This value can also be 
set in the /etc/usermgmt.conf file, using the `preserve' field. If the 
field has any of the values `true', `yes', or a non-zero number, then 
user information preservation will take place.

<b>-r</b> remove the user's home directory, any subdirectories, and 
any files and other entries in them.

<b>-v</b> perform any actions in a verbose manner.
</pre>

<a name="instGroupManagement"></a>

#### Group Management

&#91;Ref: $!manpage("group",8)!$, $!manpage("groupadd",8)!$, 
$!manpage("groupdel",8)!$, $!manpage("groupinfo",8)!$, $!manpage("groupmod",8)!$ ] 
  
Groups are important categorisations for users that allow administrators to 
specify privileges, restrictions to a range of users depending on their group 
allocation.

OpenBSD 2.7 included a set of group management tools, including the wrapper 
program 'group' which can be used as the interface into the separate tools. 
/usr/sbin/group merely takes the parameters given it on the command line and 
passes it to the appropriate program.

<a name="groupadd"></a>  

##### Create a new Group

&#91;Ref: $!manpage("group",8)!$, $!manpage("groupadd",8)!$ ]


To add new groups 'computerstaff' and 'class501' to the system, we can enter 
the commands.

<pre class="command-line">
# group info computerstaff
</pre>
<pre class="screen-output">
group: can't find group `computerstaff'
</pre>
<pre class="command-line">
# group add computerstaff
# group info computerstaff 
</pre>
<pre class="screen-output">
name computerstaff
passwd *
gid 1002
members 
</pre>


Note that gid (Group ID) is sequential to the last group I have on my system, 
and there are no members yet for computerstaff.
  
<pre class="command-line">
 # group info class501
</pre>
<pre class="screen-output">
group: can't find group `class501'
</pre>
<pre class="command-line">
# group add class501
# group info class501
</pre>
<pre class="screen-output">
name class501
passwd *
gid 1003
members 
</pre>

      
We have successfully created two new groups, and verified their creation.

<a name="usermod"></a>

##### Adding Users to an Existing Group

[ref $!manpage("user",8)!$, $!manpage("userinfo",8)!$, $!manpage("usermod",8)!$, $!manpage("group",8)!$, 
$!manpage("groupinfo",8)!$]

Now that we have created our groups, we can go through and allocate users to 
  the separate groups. The simplest method is to use the given utilities user 
  or usermod.</p>
  
In our small scenario, we only have one user (bricker) but since bricker is 
  going to be part of the 'computerstaff' we're putting that account into the 
  group.</p>
  
1st we can check what group 'bricker' is in, and we can review membership in 
  'computerstaff' again.</p>

<pre class="command-line"># userinfo bricker | grep &quot;^groups&quot;</pre>
<pre class="screen-output">groups bricker</pre>
<pre class="command-line"># group info computerstaff | grep &quot;^members&quot;</pre>
<pre class="screen-output">members</pre>

We can simply add bricker using <i>usermod -G</i> (or <i>user mod -G</i>).

<pre class="command-line"># user mod -G computerstaff bricker
</pre>
<pre class="command-line"># group info computerstaff | grep &quot;^members&quot;
</pre>
<pre class="screen-output">
members bricker
</pre>

<a name="instRoot"></a>

#### Root, Super Administrator

A common problem for novice Unix Administrators is not knowing how to setup 
a 'root' account or managing accounts with access to the 'root' account.

The Super Administrator 'root' is any account configured with UserID as '0' 
and GroupID as '0'. This user has near fatal authority on your machine and you 
must be very careful in selecting any accounts with 0:0 privileges.

You can quickly view the above by checking your /etc/passwd file, or by using 
a script similar that shown here.

<pre class="command-line">
$ /usr/bin/grep :0:0: /etc/passwd 
</pre>
<pre class="screen-output">
root:*:0:0:Charlie &amp;,,,:/root:/usr/local/bin/bash
</pre>

<a name="instAssigningPrivilegesToOrdinaryUsers"></a>

##### Assigning Root Privileges to Ordinary Users
  
Your administrator account should be a member of the group <b>wheel</b>. <i>Regular 
users of your host should not be members of the wheel group.</i>
  
You can specify the group in three ways:

-  at the creation of the account <a href="#instgroup">(as above)</a> or 
-  using <i>usermod -G</i> or
-  by manually editing the file /etc/group.

<a name="instgroupwheel"></a>

###### Setting wheel during account creation

During account creation (using adduser) you are given the option to set the 
group an account belongs to, and any additional groups to include the user into.</p>

<pre class="screen-output"> 
Login group bricker [bricker]: <b>&lt;hit ENTER&gt;</b>
Login group is &quot;bricker&quot;. Invite bricker into other groups: 
guest no 
[no]:&nbsp; <b>wheel</b>
</pre>

During the user creation, you can specify that you want the userid to be invited, 
or included into the 'wheel' group.

<a name="instusermodwheel"></a>
  
###### Using the usermod -G command

From the man page usermod(8)</p>

<pre class="screen-output">
-G  secondary-group[,group,...]
    are the secondary groups the user will be a member of in the 
    /etc/group file.
</pre>
      
First we check to make sure that 'wheel' is the superuser group.

<pre class="command-line">
# /usr/bin/grep ':0:' /etc/group
</pre>
<pre class="screen-output">
wheel:*:0:root
</pre>

In this scenario, bricker has not been added to the group 'wheel' which is 
the superuser group.

To add the group wheel to the groups allocated for <i>bricker</i> you use the 
following usermod command.
  
<pre class="command-line">
# usermod -G wheel bricker
</pre>
<pre class="command-line">
# user info bricker | /usr/bin/grep &quot;^groups&quot;
</pre>
<pre class="screen-output">
groups bricker computerstaff wheel
</pre>

    
Our user information tells us bricker is now part of three groups: bricker, 
computerstaff, and wheel.

We can verify the contents of the /etc/group file, specific to the group wheel 
by using group info or just grep:

<pre class="command-line">
# /usr/bin/grep ':0:' /etc/group
</pre>
<pre class="screen-output">
wheel:*:0:root,bricker
</pre> 
<pre class="command-line">
# group info wheel | grep &quot;^members&quot; 
</pre>
<pre class="screen-output">
members root bricker
</pre>

<a name="instmanuallyeditgroupwheel"></a>
    
###### Manually Editing the file /etc/group

The third method for adding a new user to the group 'wheel' is to edit the 
entry.
  
The format of the file is a line for each record, of the form

<pre class="command-line">
'GroupName:*:GroupIDNumber:UserIDA[[,UserIDn]...]
</pre>

and no spaces are allowed(?)

For example file: /etc/group

<pre class="screen-output">
wheel:*:0:root<b>,bricker</b>
daemon:*:1:daemon
kmem:*:2:root
sys:*:3:root
tty:*:4:root
operator:*:5:root
bin:*:7:
news:*:8:
wsrc:*:9:
users:*:10:
</pre>

As indicated in the above example, edit the file and add your userid 'bricker' 
to the line 'wheel'. Remember that the special group is the group that corresponds 
to GroupID '0'.
  
<a name="instmovetoroot"></a>  
  
#### Moving from your UserID to root

With your administrator account in the 'wheel' group you can substitute/switch 
user from bricker to root using the 'su' command.

For example, while logged in as bricker, you can use 'su' to switch to root 
and perform the necessary tasks as 'root' before returning to your 'bricker' 
account.

<pre class="command-line">
$ whoami
</pre>
<pre class="screen-output">
bricker
</pre>
<pre class="command-line">
$ su -
</pre>
<pre class="screen-output">
Password:
</pre>
<pre class="command-line">
# 
# whoami
</pre>
<pre class="screen-output">
root
</pre>

    
From the man page $!manpage("su",1)!$:

<pre class="manpage">
If group 0 (normally ``wheel'') has users 
listed then only those users
can su to ``root''. It is not sufficient to change a user's /etc/passwd
entry to add them to the ``wheel'' group; they must explicitly be listed
in /etc/group. If no one is in the ``wheel'' group, it is ignored, and
anyone who knows the root password is permitted to su to ``root''.
</pre>

      
For a more granular control of what applications you allow users to perform, 
take a look at the $!manpage("sudo")!$ command.

#### Relative Reference

Red Hat Linux Administrator's Handbook 2nd Edition. Mohammed J. Kabir, (<a href="http://www.mandtbooks.com">M&amp;T 
  Books</a>, Foster City, 2001)</p>
Essential System Administration 2nd Edition. AEleen Frisch (<a href="http://www.ora.com">O'Reilly 
  &amp; Associates</a>, Inc., Sebastopol, 1995)</p>

