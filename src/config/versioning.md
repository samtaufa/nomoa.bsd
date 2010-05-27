##  cvs - Concurrent Version System

<div style="float:right">
    <ul>
      <li><a href="#serverConfig">Configuring A Server</a></li>
      <ul>
        <li><a href="#serverRepository" class="anchBlue2">Specifying and starting 
          a repository</a></li>
        <li><a href="#serverPrivileges" class="anchBlue2">Setting access priviliges</a></li>
        <li><a href="#serverPserver" class="anchBlue2">The password-authenticating 
          server</a></li>
      </ul>
      <li><a href="#accessServer">Accessing the Server</a></li>
      <ul>
        <li><a href="#accessRepository" class="anchBlue2">Accessing the repository</a></li>
        <ul>
          <li><a href="#accessLogin" class="anchBlue2">Logging in (pserver)</a></li>
          <li><a href="#accessSSH" class="anchBlue2">SSH for secured communications</a></li>
        </ul>
        <li><a href="#accessNewProject" class="anchBlue2">Starting a New Project</a></li>
        <li><a href="#accessCheckout" class="anchBlue2">Checking out the New Project</a></li>
      </ul>
      <li><a href="#projectUpdates">Project Updates</a></li>
      <ul>
        <li><a href="#projectReview" class="anchBlue2">Reviewing Changes to a file</a></li>
        <li><a href="#projectUpload" class="anchBlue2">Uploading a modified file</a></li>
        <li><a href="#projectDownload" class="anchBlue2">Downloading a modified file</a></li>
      </ul>
      <li><a href="#projectReleases" class="anchBlue">Project Releases</a></li>
      <ul>
        <li><a href="#projectRtag" class="anchBlue2">Tag the release point in CVS</a></li>
        <li><a href="#projectRexport" class="anchBlue2">Export the tagged release 
          to a versioned directory</a></li>
        <li><a href="#projectRarchive" class="anchBlue2">Archive the directory</a></li>
      </ul>
      <li><a href="#related">Related Reference</a></li>
      <li><a href="#author">Author and Copyright</a></li>
    </ul>
</div>


<p>cvs, the Concurrent Version System, is an integral part of OpenBSD's development 
  and most other things related to OpenBSD (as well as Open Source.) </p>

  <p>There's heaps of documentation regarding cvs so browse those things if you 
  need more in depth material. These notes came out of personal problems deciphering 
  the existing notes for my needs.</p>
  
<p>Introduced here is the process by which I was able to get something up and 
  running on my machines.</p>
  
<p>Fortunately, OpenBSD comes with CVS client and server built together with the 
  system, therefore we do not have to worry about how to install it and can get 
  straight into setting up a basic server and then start working with it.</p>
  
<p><i>[2002-06. In the midst of creating this document, testing, my experimental 
  server died with a failed hard-disk. I had hoped to reorganise the text to make 
  it 'clearer?' but that may never happen. Being that the LCD screen was already 
  shot, and we are in the middle of the South Pacific Ocean, it may not get fixed. 
  In the meantime i hope that these notes serves you in your learning of CVS and 
  OpenBSD.]</i></p>
  
### <a name="serverConfig"></a>Configuring a Server
<p>The whole point of CVS is to share a common set of resources, and since I'm 
  offline most of the time (ie. not on the Internet) I couldn't experiment without 
  1st getting up a server. Once figured out, it isn't that difficult after all.</p>
<p>The stages for configuring a server are:-</p>
<ul>
  <li>Specifying and starting a repository</li>
  <li>Setting access privileges</li>
  <li>The password-authenticating server</li>
</ul>
#### <a name="serverRepository"></a>Specifying and starting a repository

<p>We decide the location for our repository (/usr/local/CVSREPOSITORY) just to 
  make sure that we don't confuse things. To configure the location to store the 
  CVS repository, we use the 'init' command.</p>
<p class="Code">bash$ cvs -d /usr/local/CVSREPOSITORY init</p>

<p>This command generates the required configuration and reference files, and 
  can be checked by looking at the files now stored into /usr/local/CVSREPOSITORY 
  and the control directory /usr/local/CVSREPOSITORY/CVSROOT</p>
  
<p class="Code">bash$ cd /usr/local/CVSREPOSITORY</p>
<p class="Code">bash$ ls</p>
<p class="pScreenOutput">CVSROOT</p>
<p class="Code">bash$ cd CVSROOT</p>
<p class="Code">bash$ ls</p>
<p>Of course, the user (if not root) must have write access.</p>

<p>Files in CVSROOT are used by cvs for administration purposes, but for our purposes 
  tells us that we have been successful this far.</p>
  
#### <a name="serverPrivileges"></a>Setting access privileges

<p>To hopefully limit uninvited users from whacking your repository, the next 
  step is to specify a means for controlling write access privileges to your repository. 
  We will achieve this (for the local user) through group privileges.</p>
<p>1. Create a group for CVS use (e.g. group cvs.) In this group we will include 
  local users who we will allow write access to the repository.</p>
<p class="Code">bash$ su -</p>
<p class="Code">bash# groupadd cvs</p>
<p class="Code">bash# usermod -G cvs user1</p>
<p class="Code">bash# usermod -G cvs user2</p>
<p>2. Change the repository's group ownership and permissions to allow rwx access 
  to the new group.</p>
<p class="Code">bash$ cd /usr/local/CVSREPOSITORY</p>
<p class="Code">bash$ chgrp -R cvs .</p>
<p class="Code">bash$ chmod ug+rwx . CVSROOT</p>
<p>Now, all users in the group 'cvs' have full access to the repository (i.e. 
  they can create new projects and get files from the repository.)</p>
#### <a name="serverPserver"></a>The password-authenticating server
<p>I wanted to play with the environment of accessing the CVS across the Internet, 
  so I went ahead and configured the password-authentication server. This allows 
  my WinXP machine to share with the server, and also a few other guys I work 
  with to access my repository from their Linux boxes.</p>
<p>To configure the server we need to ensure the cvs port is specified and configure 
  inetd to monitor/service the port.</p>
<p>Make sure there is a line in the /etc/services file that specifies cvspserver 
  is referenced at port 2401.</p>
<p class="pFileReference">Edit the file: /etc/services to include the following 
  line. </p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="pScreenOutput">
  <tr> 
    <td class="pScreenOutput" nowrap>cvspserver&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2401/tcp</td>
  </tr>
</table>
<p class="pFileReference">Edit the /etc/inetd.conf file to include the following 
  line.</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="pScreenOutput">
  <tr> 
    <td class="pScreenSmall" nowrap>cvspserver stream tcp nowait root /usr/bin/cvs 
      cvs --allow-root=/usr/local/CVSREPOSITORY pserver</td>
  </tr>
</table>
<p>Now, we just need to restart the inetd server and our CVS server will be listening.</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="pScreenOutput">
  <tr> 
    <td class="Code" nowrap>bash# kill -HUP `cat /var/run/inetd.pid`</td>
  </tr>
</table>
<p>Creating special password access to the server is the next topic, but for the 
  purpose of getting a system up and running, we'll continue with the current 
  configuration. Without any additional work, CVS will authenticate users from 
  your /etc/passwd file. This limits the number of developers to those with accounts 
  on your system, but this is ok for a start.</p>
### <a name="accessServer"></a>Accessing the Server
<p>Continuing our discussion, we will take a look at accessing the materials in 
  the Repository.</p>
<ul>
  <li>Accessing the Repository</li>
  <ul>
    <li>Logging in (pserver)</li>
    <li>SSH for secured communications</li>
  </ul>
  <li>Starting a New Project</li>
  <li>Checking out the New Project</li>
</ul>
<p>Using a sample configuration for a server:</p>
<p class="pFileReference">Server: nomoanet.to<br>
  Repository: /usr/local/CVSREPOSITORY</p>
#### <a name="accessRepository"></a>Accessing the Repository
<p>The general command format for accessing/using the repository is:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="pScreenOutput">
  <tr> 
    <td class="pScreenOutput">bash$ cvs REPOSITORY command</td>
  </tr>
</table>
<p>Where the REPOSITORY is a reference to the desired repository of the following 
  form. </p>
<table width="80%" border="0" cellspacing="0" cellpadding="0" class="Code">
  <tr>
    <td>
      <p>If using a '<b>local</b>' repository then we can use <br>
        &quot;<i>-d&nbsp;/usr/local/CVSREPOSITORY</i>&quot;. </p>
      <p>If you are accessing an <b>external </b>repository then<br>
        &quot;<i>-d&nbsp;:pserver:samt@externalhost.com:/usr/local/CVSREPOSITORY</i>&quot;.</p>
      <p>Of course, you want to use your own user-id and host.</p>
</td>
  </tr>
</table>
<p>To simplify your work, we set the environment variable $CVSROOT to the REPOSITORY 
  you wish to use (of course if you use more than one repository you may not want 
  to do this.) There are three methods that I've looked at, but for the beginning 
  you can simply use Option 1 (local directory.)</p>
<p>Option 1: For a <b>local</b> repository</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="Code"> 
      <p>bash$ export CVSROOT=/usr/local/CVSREPOSITORY</p>
    </td>
  </tr>
</table>
<p>Option 2: or, for an <b>external</b> <b>pserver </b>repository</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="Code"> 
      <p>bash$ export CVSROOT=:pserver:samt@nomoanet.to:/usr/local/CVSREPOSITORY</p>
    </td>
  </tr>
</table>
<p>Option 3: or, using an external program for authentication/access to repository</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="Code"> 
      <p>bash$ export CVSROOT=:ext:samt@nomoanet.to:/usr/local/CVSREPOSITORY</p>
    </td>
  </tr>
</table>
<p>We don't need to login using the local configuration, because we're already 
  logged into the system (remember the privilege settings we did earlier.) Local 
  users get whatever access privileges our file system gives them.</p>
##### <a name="accessLogin"></a>Logging In (pserver)
<p>To login, we use the &quot;login&quot; command, as shown below:</p>
<p>For <b>external pserver cvs</b> access.</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code" nowrap>
      <p>bash$ cvs -d :pserver:samt@nomoanet.to:/usr/local/CVSREPOSITORY login</p>
      </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap>
      <p>Logging in to :pserver:samt@nomoanet.to:2401/usr/local/CVSREPOSITORY<br>
        CVS password:</p>
      </td>
  </tr>
</table>
<p><b>or</b>, we can set the environment variable CVSROOT to the REPOSITORY and 
  login:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="Code"> 
      <p>bash$ export CVSROOT=:pserver:samt@nomoanet.to:/usr/local/CVSREPOSITORY<br>
        bash$ cvs login</p>
      </td>
  </tr>
  <tr> 
    <td nowrap class="pScreenOutput"> 
      <p>bash$ Logging in to :pserver:samt@nomoanet.to:2401/usr/local/CVSREPOSITORY<br>
        CVS Password:</p>
      </td>
  </tr>
</table>
<p>We're now into the repository</p>
##### <a name="accessSSH"></a>SSH for secured communications
<p>When accessing external CVS repositories, communications is through insecure 
  systems. You can improve the security of your access (passwords, information, 
  etc) by using SSH as the communications methodology. Do this by setting the 
  $CVS_RSH variable.</p>
<table width="80%" border="0" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="pScreenOutput"> 
      <p>bash$ export CVS_RSH=ssh</p>
    </td>
  </tr>
</table>
<p>Your communications with the CVS server can now be using the more secure ssh 
  system. To specify that we want to use the CVS_RSH system, we have to use the 
  :ext: method for accessing the server.</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td nowrap class="Code"> 
      <p>bash$ export CVSROOT=:ext:samt@nomoanet.to:/usr/local/CVSREPOSITORY</p>
    </td>
  </tr>
</table>
#### <a name="accessNewProject"></a>Starting a New Project
<p>Starting a new project is through &quot;import&quot;.</p>
<p class="pScreenOutput"><b>cvs import -m <font color="#000000">&quot;log message&quot;</font> 
  <font color="#0000FF">project_name</font> vendortag releasetag</b></p>
<p>To show the flexibility of this configuration, we'll even begin by accessing 
  the server externally. I produce the files for this website on a WindowsXP, 
  Cygwin laptop and I have been sharing it among different closed LANs here in 
  Tonga. I want to import it onto this new CVS system.</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ export CVSROOT=:pserver:samt@nomoanet.to:/usr/local/CVSREPOSITORY<br>
        bash$ cvs login</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>(Logging in to samt@nomoanet.to)<br>
        CVS password:</p>
    </td>
  </tr>
  <tr> 
    <td class="Code"> 
      <p>bash$ pwd</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>/cygdrive/c/My Documents/My Websites/nomoa.com</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ <b>cvs import -m<font color="#000000"> &quot;1st Import into CVS Tree&quot;</font> 
        <font color="#0000FF">nomoa.com</font> samt START</b></p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>I nomoa.com/CVS<br>
        N nomoa.com/index.html<br>
        N nomoa.com/nomoa.css<br>
        cvs server: Importing /usr/local/CVSREPOSITORY/nomoa.com/bsd</p>
      <p>[ ... stuff left out ... ]</p>
      <p>cvs server: Importing /usr/local/CVSREPOSITORY/nomoa.com/_notes<br>
        N nomoa.com/_notes/dwSiteColumnsMe.xml</p>
      <p>No conflicts created by this import</p>
      </td>
  </tr>
</table>
<p>Voila! We have now successfully placed our first files into the CVS repository.</p>
<p>&quot;import&quot; loads all files from the current directory (/cygdrive/c/My 
  Documents/My Websites/nomoa.com) onto the CVS server.</p>
<p>Equally important for the novice (i am) is the <b><font color="#0000FF">project_name</font></b>. 
  The project_name becomes the directory name that will be used by CVS to identify/store 
  your files on the server (likewise that will be the directory it creates when 
  extracting the files from the server.)</p>
<p>To check that the project has been started, check the server directory /usr/local/CVSREPOSITORY 
  and you should now have an extra directory nomoa.com.</p>
<p class="pFileReference">OpenBSD nomoanet.to</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cd /usr/local/CVSREPOSITORY<br>
        bash$ ls</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>CVSROOT&nbsp;&nbsp;&nbsp;&nbsp;nomoa.com</p>
    </td>
  </tr>
</table>
<p>Take a look inside the nomoa.com directory and you will see copies of the original 
  files. </p>
#### <a name="accessCheckout"></a>Checking out the New Project
<p>Before you commit changes to your files to the CVS repository, you have to 
  first obtain (checkout) a copy of the files as the CVS now understands them. 
  The general format for getting a CVS repository (checkout) is:</p>
<p class="pScreenOutput">bash$ cvs checkout project_name</p>
<p>Where project_name is the project name you specified above, or directory name 
  where the CVS now stores the files.</p>
<p>For the insanely paranoid, and you wouldn't be using OpenBSD unless there is 
  some level of paranoia, you should backup your original files. Just as important, 
  note that when you get your CVS copy (checkout) it creates a new sub-directory 
  (by the project name.)</p>
<p>1. Backup your original files</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ pwd</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>/cygdrive/c/My Documents/My Websites/nomoa.com</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ cd ..<br>
        bash$ mv nomoa.com nomoa.com.old<br>
        bash$ ls </p>
      </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>nomoa.com.old/</p>
      </td>
  </tr>
</table>
<p>2. Checkout your new CVS project</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ pwd</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>/cygdrive/c/My Documents/My Websites</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ ls </p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>nomoa.com.old/</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ cvs checkout <b>nomoa.com</b></p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>cvs server: Updating nomoa.com<br>
        U nomoa.com/index.html<br>
        U nomoa.com/nomoa.css<br>
        cvs server: Updating nomoa.com/_notes</p>
      <p>[ ... stuff left out ... ]</p>
      <p></p>
      <p></p>
      </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ ls</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>nomoa.com/ nomoa.com.old/</p>
    </td>
  </tr>
</table>
<p>We now have the original version of this project in nomoa.com.old and we also 
  have a CVS working copy of the website at nomoa.com</p>
<p class="pFileReference">OpenBSD nomoanet.to</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cd /var/www<br>
        bash$ ls</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p> cgi-bin htdocs conf icons logs</p>
    </td>
  </tr>
  <tr> 
    <td class="Code"> 
      <p>bash$ export CVS_RSH=ssh<br>
        bash$ export CVSROOT=:ext:samt@nomoanet.to:/usr/local/CVSREPOSITORY<br>
        bash$ cvs checkout nomoa.com</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>samt@nomoanet.to's password:</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap>
      <p>date time host sshd[19469]: Accepted password for samt from ip-address 
        port 32011 ssh2</p>
      </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>cvs server: Updating nomoa.com<br>
        cvs server: Updating nomoa.com/_notes<br>
        cvs server: Updating nomoa.com/bsd<br>
      </p>
      <p>[ ... stuff left out ... ]</p>
      <p></p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ ls</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>cgi-bin htdocs conf icons logs nomoa.com</p>
    </td>
  </tr>
</table>
<p></p>
<p>We now have another CVS checkout (work files). This copy is on the OpenBSD 
  machine and can act as the approved website after developments are done on the 
  WindowsXP machine.</p>
### <a name="projectUpdates"></a>Project Updates
<p>To continue the demonstration we will assume that I continue to update this 
  file within the Web site (filename: bsd/cvs.htm) and we now want to look at 
  how we can upload updates to the working files.</p>
#### <a name="projectReview"></a>Reviewing Changes to a file 
<p>There are a number of ways to review whether files on the CVS Repository have 
  changed relative to the working copy.</p>
##### Which files have changed
<p>&quot;-n update&quot; and &quot;status&quot; give a different summaries of 
  file changes. The &quot;-n&quot; (no change?) before update tells cvs to report 
  what would happen if the update were performed, but not to perform an update.</p>
<p>For example: cvs -n update from the WindowsXP/Cygwin laptop will tell us whether 
  things are different between the current working copy and the material on the 
  Repository.</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cd nomoa.com</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ cvs -n update</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>cvs server: Updating .<br>
        cvs server: Updating _notes<br>
        cvs server: Updating bsd<br>
        M bsd/cvs.htm<br>
        cvs server: Updating bsd/mmedia<br>
        cvs server: Updating bsd/sysadmin<br>
        cvs server: Updating mmedia<br>
        cvs server: Updating proj<br>
        cvs server: Updating python<br>
        cvs server: Updating texts</p>
      </td>
  </tr>
</table>
<p>Note the &quot;M&quot; indicates that the file bsd/cvs.htm has been modified 
  on the local copy and out of synch with the Repository copy. Oh, yes, I've continued 
  to make changes to this document as I've tested the examples.</p>
##### What kind of change has occurred.<br>

<p>The &quot;status&quot; command gives a summary of the current state of a file 
  or directory. </p>
<p>We take a look at the operation on the &quot;development machine&quot; which 
  has new updates not yet uploaded (Windows)</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop - Web page development machine</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cd nomoa.com/bsd</p>
    </td>
  </tr>
  <tr> 
    <td class="Code" nowrap> 
      <p>bash$ cvs status cvs.htm</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>Checking in cvs.htm;<br>
        /usr/local/CVSREPOSITORY/nomoa.com/bsd/cvs.htm,v &lt;-- cvs.htm<br>
        new revision: 1.1; previous revision: 1.1<br>
        done<br>
        bash-2.05a$ cvs status cvs.htm<br>
        ===================================================================<br>
        File: cvs.htm Status: <b>Locally Modified</b></p>
      <p> Working revision: 1.1<br>
        Repository revision: 1.1 /usr/local/CVSREPOSITORY/nomoa.com/bsd/cvs.htm,v<br>
        Sticky Tag: (none)<br>
        Sticky Date: (none)<br>
        Sticky Options: (none)</p>
    </td>
  </tr>
</table>
<p>CVS clearly indicates &quot;Locally Modified&quot; that the contents of the 
  local work files is later (modified) to the current Repository.</p>
<p class="pFileReference">OpenBSD nomoanet.to - Web server release machine</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cd nomoa.com/bsd<br>
        bash$ cvs status cvs.htm</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p> bsd #cvs status cvs.htm<br>
        ===================================================================<br>
        File: cvs.htm Status: <b>Up-to-date</b></p>
      <p> Working revision: 1.1 Mon Jun 10 04:29:22 2002<br>
        Repository revision: 1.1 /usr/local/CVSREPOSITORY/nomoa.com/bsd/cvs.htm,v<br>
        Sticky Tag: (none)<br>
        Sticky Date: (none)<br>
        Sticky Options: (none)</p>
    </td>
  </tr>
</table>
<p>CVS is telling us on the OpenBSD box that the contents are still the same as 
  that in the repository (although we do not know changes have been made on the 
  Windows machine.)</p>
#### Reviewing Changes
<p>The command for reviewing changes between your working files and the repository 
  is:</p>
<p class="Code">bash$ cvs diff -r revision filename</p>
<p>When you omit the 'revision' number, the filename is 'diff'd', compared, to 
  the most recent revision in the Repository.</p>
<p>To review the current changes to cvs.htm to to that in the Repository.</p>
<p class="pFileReference">WindowsXP/Cygwin Laptop</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cvs diff cvs.htm</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap> 
      <p>[ ... stuff left out ... ]</p>
      
    </td>
  </tr>
</table>
<p>This displays the changes between cvs.htm and the copy on the Repository. </p>
<p>We can compare to different versions on the repository (or between different 
  repository versions) by using</p>
<p class="Code">bash$ cvs diff -r1.2 cvs.htm</p>
<p class="Code">bash$ cvs diff -r1.1 -r1.3 cvs.htm</p>
<p class="pFileReference">From the man page:</p>
<p class="pScreenSmall">diff Show differences between files in working directory 
  and source repository, or between two revisions in source repository. (Does 
  not change either repository or working directory.)<br>
</p>
#### <a name="projectUpload"></a>Uploading a modified file 
<p>The command for updating the repository, sending files to the repository, is 
  'commit' and follows the form:</p>
<p class="pScreenOutput">bash$ cvs commit file</p>
<p>As we continue to work on this document (cvs.htm) we make changes on our development 
  machine (WindowsXP/Cygwin) and update to the repository.</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> 
      <p>bash$ cvs commit cvs.htm</p>
    </td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> 
      <p>Checking in cvs.htm;<br>
        /usr/local/CVSREPOSITORY/nomoa.com/bsd/cvs.htm,v &lt;-- cvs.htm<br>
        new revision: 1.2; previous revision: 1.1<br>
        done</p>
    </td>
  </tr>
</table>
<p>Notice that CVS keeps an internal revision number for your files. Do not worry 
  about these numbers, they are internal to CVS's administration and are not related 
  to the versioning you may choose for releasing your code.</p>
#### <a name="projectDownload"></a>Downloading Updates
<p>The fastest way to update all your working files to the current version on 
  the repository is to use the update command.</p>
<p class="Code">bash$ cvs update</p>
<p class="pFileReference">From the man page:</p>
<p class="pScreenSmall">Bring your working directory up to date with changes from 
  the repository. Merges are performed automatically when possible; a warning 
  is issued if manual resolution is required for conflicting changes. (Changes 
  working directory; does not change repository.)</p>
<p class="anchBlue">Example:</p>
<p class="anchBlue">I want to update the current working files on the OpenBSD 
  machine.</p>
<p class="pFileReference">OpenBSD nomoanet.to</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code_td"> bash# pwd</td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> bash# /var/www</td>
  </tr>
  <tr> 
    <td class="Code"> bash# cd nomoa.com</td>
  </tr>
  <tr> 
    <td class="Code"> bash# cvs update</td>
  </tr>
  <tr> 
    <td class="pScreenOutput"> cvs update: Updating .<br>
      cvs update: Updating _notes<br>
      cvs update: Updating bsd<br>
      <b>U bsd/cvs.htm</b><br>
      cvs update: Updating bsd/mmedia<br>
      cvs update: Updating bsd/sysadmin<br>
      cvs update: Updating mmedia<br>
      cvs update: Updating proj<br>
      cvs update: Updating python<br>
      cvs update: Updating texts</td>
  </tr>
</table>
<p class="anchBlue">The 'update' command prints a summary that includes saying 
  that the nomoa.com/bsd/cvs.htm file has been '<b>U</b>pdated' from the repository. 
  In this example, no other files were '<b>U</b>pdated'<br>
</p>
### <a name="projectReleases"></a>Project Releases
<p>The really neat feature of CVS that took forever to find, was how they do that 
  product release thing. Controlling binary distributions of source code, without 
  bloating the source code with CVS administration files (such as directory/CVS.) 
  Essentially the approach is:</p>
<ul>
  <li>Tag the point in the CVS for the release</li>
  <li>Export the tagged release to a versioned directory</li>
  <li>Archive the directory for release</li>
</ul>
##### <a name="projectRtag"></a>Tag the point in the CVS
<p>Placing a 'tag' in the CVS allows us to trace back to the point from whence 
  the release is linked. The form for 'taging' the CVS is:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> bash$ cvs -q tag NAME_FOR_RELEASE</td>
  </tr>
</table>
<p>Some basic rules for the Tag name is to:</p>
<ul>
  <li>do not use &quot;.&quot; and other special characters</li>
  <li>do make the tag easy to interpret</li>
</ul>
<p>For example, to make a release of our nomoa.com website we can do the followin:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> bash$ cvs -q tag CDROM_RELEASE_1_0</td>
  </tr>
</table>
##### <a name="projectRexport"></a>Export the Tagged version
<p>Once the CVS is marked, tag'd, we can export using the &quot;-d&quot; option 
  to export into a directory named differently from the CVS project name. The 
  format is:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code" nowrap>bash$ cvs -q export -r (revision to use) -d project-revision 
      project </td>
  </tr>
</table>
<p>From this example of the export command we can already see that we can use 
  any 'revision' in the CVS, such as -D now, or -D tomorrow. To follow our example 
  we can continue with:</p>
<table width="80%" border="1" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code" nowrap> bash$ cvs -q export -r CDROM_RELEASE_1_0 -d nomoa.com-1.0 
      nomoa.com</td>
  </tr>
</table>
<p>Of course, this is a good time for a reminder on the <a href="http://www.linuxdoc.org/LDP/HOWTO/Software-Release-Practice-HOWTO.html#AEN142" class="anchBlue2">GNU-Style 
  convention on names with a stem and major.minor.patch numbering</a>. Summarised 
  the naming convention is:</p>
<table class="pScreenOutput" width="80%">
  <tr> 
    <td class="pScreenOutput"> 
      <ol>
        <li>project name</li>
        <li>dash</li>
        <li>major version number &quot;dot&quot; minor version number &quot;dot&quot; 
          level number</li>
        <li>dot</li>
        <li>&quot;src&quot; or &quot;bin&quot; (optional)</li>
        <li>dot or dash (dot preferred)</li>
        <li>binary type and options (optional)</li>
        <li>archiving and compression extensions</li>
      </ol>
    </td>
  </tr>
</table>
<p>As shown in our example above, this leads to</p>
<table class="Code" width="80%">
  <tr> 
    <td class="Code"> 
      <ol>
        <li><font color="#000000"><b>nomoa.com</b></font></li>
        <li><font color="#000000"><b>-</b></font></li>
        <li><font color="#000000"><b>1.0</b></font></li>
        <li><font color="#000000"><b>.</b></font></li>
        <li></li>
        <li></li>
        <li></li>
        <li><font color="#000000"><b>tar.gz</b></font></li>
      </ol>
    </td>
  </tr>
</table>

##### <a name="projectRarchive"></a>Archive the Directory
<p>Now we have a new release directory (nomoa.com-1.0cdr) without the CVS administration 
  files we merely package the files for distribution.</p>
<table width="80%" border="0" cellspacing="0" cellpadding="0" class="Code">
  <tr> 
    <td class="Code"> bash$ tar -cvf nomoa.com-1.0.tar nomoa.com-1.0.tar<br>
      bash$ gzip nomoa.com-1.0.tar <br>
      bash$ ls nomoa.com-*</td>
  </tr>
  <tr> 
    <td class="pScreenOutput">nomoa.com-1.0.tar &nbsp;&nbsp;&nbsp;&nbsp;<font color="#000000">&nbsp;<b>nomoa.com-1.0.tar.gz</b></font></td>
  </tr>
</table>
<p>There we have the beginnings of releasing our source code like the professionals 
  (aka. real programmers.)</p>
### <a name="related"></a>Related References
<p>Fogel, Karl Franz. Open Source Development with CVS (<a href="http://www.coriolis.com" class="anchBlue">CoriolisOpen</a> 
  Press, Scottsdale, 1999)</p>
<p>Purdy, Gregor N. CVS Pocket Reference (<a href="http://www.oreilly.com" class="anchBlue">O'Reilly 
  &amp; Associates</a>, Sebastopol, 2000) </p>

