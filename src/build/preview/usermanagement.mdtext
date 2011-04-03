## First Time - User Management

&#91;Ref: $!manpage("adduser",8)!$, $!manpage("userdel",8)!$,
[FAQ 10 - System Management](http://www.openbsd.org/faq/faq10.html)]

<div class="toc">

Table of Contents

<ol>
    <li><a href="#instAddUser">New User</a></li>
    <li><a href="#instRootAccess">root privileges</a></li>
    <li><a href="#instchpass">Changing details</a></li>
    <li><a href="#instSHELL">Shell Profile</a></li>
</ol>

</div>

### <a name="instAddUser"></a> Adding a New User

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


<pre class="screen-output">
Enter home directory (full path)
[/home/bricker]: <b>&lt;hit ENTER&gt;</b>
Uid [1002]: <b>&lt;hit ENTER&gt;</b>
</pre>

The uid is the User ID number that the system uses to keep track of
people. These should be unique on the system. Use the default values
offered by the program unless you have good knowledge of previously
granted ID numbers.


<pre class="screen-output">
Enter login class: default []: <b>&lt;hit ENTER&gt;</b> 
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

&#91;Ref: What to do AFTER you have BSD
installed by Chris Coleman,<a
 href="http://www.daemonnews.org/200005/chrisc@daemonnews.org">
http://www.daemonnews.org/200005/chrisc@daemonnews.org</a> 

#### <a name="instchpass"></a>Changing User Information 

 &#91;Ref: $!manpage("chpass",1)!$, $!manpage("vipw",8)!$]

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
 
&#91;Ref: [What to do AFTER you have BSD
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