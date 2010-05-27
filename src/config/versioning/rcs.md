
## rcs - Revision Control System

<div style="float:right">
    <p>Table of Contents: </p>
    <ul>
      <li><a href="#rcsEasyGuide">Easy Guide</a></li>
      <ol>
        <li><a href="#rcsRCS" class="anchBlue"> Create the RCS sub-directory for storing 
          files</a></li>
        <li> <a href="#rcsCI" class="anchBlue">Check-In the 1st revision</a></li>
        <li> <a href="#rcsCO" class="anchBlue">Check-Out the file, and lock it for 
          editing</a></li>
        <li> <a href="#rcsRCSDIFF" class="anchBlue">Check the differences in what 
          you have edited</a></li>
        <li> <a href="#rcsCIupdates">Check-In most recent updates</a></li>
      </ol>
      <li class="anchBlue"><a href="#rcsHOWTO">HOW TO</a></li>
      <ul>
        <li><a href="#rcsHTdiff" class="anchBlue">Compare different revisions</a></li>
        <li><a href="#rcsHTcilu" class="anchBlue">Check in without losing my file</a></li>
        <li><a href="#rcsHTrevert" class="anchBlue">Revert to a previous version</a></li>
      </ul>
    </ul>
</div>

<p class="pFileReference">[ref: rcsintro(1)]</p>

<p>Essentially, Revision Control System (RCS), provides an enhanced archiving/recording 
  system for tracking changes you make to 'important' files.</p>

  <p>I use it because I'm always fiddling with configuration files until I don't 
  know what changes I've made and when things crash I don't recall how to get 
  back to a working version.</p>
  
### <a name="rcsEasyGuide"></a>Easy Guide
<p class="pFileReference">[ref: rcsintro(1)]</p>
<p>To create an RCS entry we first have to:</p>
<ol>
  <li><a href="#rcsRCS" class="anchBlue"> Create the RCS sub-directory for storing 
    files</a></li>
  <li> <a href="#rcsCI" class="anchBlue">Check-In the 1st revision</a></li>
  <li> <a href="#rcsCO" class="anchBlue">Check-Out the file, and lock it for editing</a></li>
  <li> <a href="#rcsRCSDIFF" class="anchBlue">Check the differences in what you 
    have edited</a></li>
  <li> <a href="#rcsCIupdates">Check-In most recent updates</a></li>
</ol>
#### <a name="rcsRCS"></a>Create RCS Sub-directory
<p class="pFileReference">[file: /etc/rc.conf.local]</p>
<p>Create the repository, place where the RCS is to be 'stored.' This is usually 
  the directory RCS under the directory where your file is stored.</p>
<p>For example, if we are to edit the file /etc/rc.conf.local we would need to 
  create the directory RCS under /etc</p>
<table border="1" class="Code" width="80%">
  <tr> 
    <td class="Code"> $ <b>su -</b><br>
      # <b>cd /etc</b><br>
      # <b>mkdir RCS </b></td>
  </tr>
</table>
#### <a name="rcsCI"></a>Check in 1st Revision
<p class="pFileReference">[file: /etc/rc.conf.local]<br>
  [ref: ci(1)]</p>
<p><i>ci</i> (Check In RCS Revisions) stores new revisions of working files into 
  RCS files. When a totally new file is 'checked-in' <i>ci</i> will:</p>
<ol>
  <li> create a new entry using the contents of the working file. </li>
  <li> prompt for a descriptive text of the file and, </li>
  <li>initialise the revision number as 1.1.</li>
</ol>
<p>Let's begin our experiment by creating a skeleton of the /etc/rc.conf.local 
  file.</p>
<p class="pFileReference">File /etc/rc.conf.local:</p>
<table cellspacing="2" border="2" class="pScreenSmall" width="80%">
  <tr> 
    <td class="pScreenSmall"># $Id: rcs.htm,v 1.1.1.1 2002/06/10 02:09:57 samt Exp $<br>
	  # ##<br>
      # SECTION 1 - Turn Features on/off<br>
      # ##<br>
      <br>
      <br>
      # ##<br>
      # SECTION 2 - Switch Programs On/Off<br>
      # ##<br>
      <br>
      <br>
      # ##<br>
      # SECTION 3 - Configuration Options<br>
      # ##<br>
      <br>
      shlib_dirs=&quot;&quot; </td>
  </tr>
  <tr> 
    <td class="pScreenSmall"> 
      <div align="center">Template for /etc/rc.conf.local</div>
    </td>
  </tr>
</table>
<p>We can now take a look at committing the 1st version of our file by using the 
  command 'ci <i>filename</i>'</p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="CodeSmall"> # <b>ci rc.conf.local</b> </td>
  </tr>
  <tr> 
    <td class="pScreenSmall" nowrap>RCS/rc.conf.local,v &lt;-- rc.conf.local<br>
      enter description, terminated with single '.' or end of file:<br>
      NOTE: This is NOT the log message!<br>
      &gt;&gt;</td>
  </tr>
  <tr> 
    <td class="CodeSmall" nowrap> &gt;&gt; <b>Contains Startup Configuration for 
      initialising OpenBSD startup</b><br>
      &gt;&gt; <b>This file should be edited when customising Startup, and not 
      /etc/rc.conf</b><br>
      &gt;&gt; <b>.</b> </td>
  </tr>
  <tr> 
    <td class="pScreenSmall" nowrap> initial revision 1.1<br>
      done </td>
  </tr>
</table>
<p>When you run 'ci' the displayed information tells you:</p>
<ol>
  <li> that rc.conf.local has now been committed the working file to an RCS entry: 
    RCS/rc.conf.local,v 
    <table border="0" class="Code" nowrap width="80%">
      <tr> 
        <td class="pScreenSmall">RCS/rc.conf.local,v &lt;-- rc.conf.local</td>
      </tr>
    </table>
    <p>You can readily confirm this by listing the contents of the directory RCS, 
      and the created file <i>rc.conf.local,v</i></p>
  </li>
  <li> then 'ci' prompts you for a descriptive text of the file we are committing
<table border="0" class="Code" nowrap width="80%">
      <tr> 
        <td class="pScreenSmall">enter description, terminated with single '.' 
          or end of file:<br>
          NOTE: This is NOT the log message!<br>
          &gt;&gt;</td>
      </tr>
    </table>
    <p>In our example above, we have stated the value of the file we are editing.</p>
    <table border="0" class="Code" nowrap width="80%">
      <tr> 
        <td class="CodeSmall" nowrap> &gt;&gt; <b>Contains Startup Configuration 
          for initialising OpenBSD startup</b><br>
          &gt;&gt; <b>This file should be edited when customising Startup, and 
          not /etc/rc.conf</b><br>
          &gt;&gt; <b>.</b> </td>
      </tr>
    </table>
  </li>
  <li>The <b>.</b> on the new line ended our input and RCS has initialised the 
    revision at 1.1, we are done.<br>
    <table border="0" class="Code" nowrap width="80%">
      <tr> 
        <td class="pScreenSmall" nowrap> initial revision 1.1<br>
          done </td>
      </tr>
    </table>
  </li>
</ol>
<p>We have successfully created our RCS entry.</p>

#### <a name="rcsCO"></a>Check-Out the file, and lock it for editing 
<p class="pFileReference">[file: /etc/rc.conf.local]<br>
  [ref: co(1)]</p>
<p></p>
<p>To make changes to our example file /etc/rc.conf.local, we need to 'check-it-out' 
  from RCS, and to lock it using the '<i>co -l filename</i>' command</p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="CodeSmall" nowrap># <b>co -l rc.conf.local</b></td>
  </tr>
  <tr> 
    <td class="pScreenSmall" nowrap>RCS/rc.conf.local,v --&gt; rc.conf.local<br>
      revision 1.1 (locked)<br>
      done </td>
  </tr>
</table>
<p>The check-out command 'co' extracts the latest revision from the RCS file and 
  writes it to '<i>rc.conf.local</i>' We lock the file before editing to ensure 
  that we are the only one editing the file, and the only one allowed to update 
  the file.</p>
<p>From the program response above, we are told the existing revision is <b>1.1</b> 
  and it is now <b>locked</b>.</p>
<p>If we take a look at the file, you will see that the $Id: rcs.htm,v 1.1.1.1 2002/06/10 02:09:57 samt Exp $ line at the very 
  beginning of the file has now been expanded to provide some details about the 
  RCS process on the file. </p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="pScreenSmall" nowrap># $Id: rc.conf.local,v 1.1 2002/02/03 09:26:36 
      samt Exp samt $</td>
  </tr>
</table>
<p>For more information on this, check the co(1) man pages.</p>
<p>Now, (a) we can make changes to the file, and (b) No other person has write 
  privileges to the file.</p>
#### <a name="rcsRCSDIFF"></a>Check the differences in what you have edited 
<p class="pFileReference">[file: /etc/rc.conf.local]<br>
  [ref: rcsdiff(1)]</p>
<p><i>rcsdiff</i> runs a diff to compare the differences between two versions 
  of a file. By default it will compare the working file with the latest revision 
  in the RCS tree.</p>
<p>TO look at how changes can be reported by RCS, we make the following modifications 
  to SECTION 1 of the rc.conf.local file.<br>
</p>
<table cellspacing="2" border="0" class="pScreenOutput" width="80%">
  <tr> 
    <td nowrap class="pScreenSmall"> # ##<br>
      # SECTION 1 - Turn Features on/off<br>
      # ##<br>
      xdm_flags = &quot;&quot;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# 
      use two double-quotes<br>
      sendmail = &quot;-bd &#150;q30m&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
      # for normal use: &quot;-bd -q30m&quot; <br>
      ftpd_flags= &quot;-DllUSA&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# 
      for non-inetd use: ftpd_flags=&quot;-D&quot; </td>
  </tr>
  <tr> 
    <td class="pScreenSmall"> 
      <div align="center"><b>Diagram - Sample of Update to Section 1</b></div>
    </td>
  </tr>
</table>
<p>We save the changes to /etc/rc.conf.local and take a look at how rcs views 
  our changes by using '<i>rcsdiff filename'</i></p>
<table width="80%" border="0" class="Code">
  <tr> 
    <td class="Code"># <b>rcsdiff rc.conf.local</b> </td>
  </tr>
  <tr> 
    <td class="kernelO"> 
      <pre class="command-line">===================================================================
RCS file: RCS/rc.conf.local,v
retrieving revision 1.1
diff -r1.1 rc.conf.local
4a5,8
> xdm_flags = ""                   # use two double-quotes
> sendmail = "-bd q30m"            # for normal use: "-bd -q30m"
> ftpd_flags= "-DllUSA"            # for non-inetd use: ftpd_flags="-D"
&gt;
</pre>
      <p></p>
    </td>
  </tr>
</table>
<p>rcsdiff reads our working file /etc/rc.conf.local and compares it to the current 
  revision (1.1) in the RCS tree.</p>
<p>The default display outputs the changes we made.</p>
#### <a name="rcsCIupdates"></a>Check-In most recent updates 
<p class="pFileReference">[ref: ci(1)]<br>
  [file: /etc/rc.conf.local]</p>
<p>We can check-in the update above using (ci.) By using the unlock (-u) or lock 
  (-l) option we tell ci not to delete the working file after checking it in.</p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="CodeSmall" nowrap># <b>ci -u rc.conf.local</b></td>
  </tr>
  <tr> 
    <td class="pScreenSmall" nowrap>RCS/rc.conf.local,v &lt;-- rc.conf.local<br>
      new revision: 1.2; previous revision: 1.1<br>
      enter log message, terminated with single '.' or end of file:<br>
      &gt;&gt; </td>
  </tr>
  <tr> 
    <td class="CodeSmall" nowrap>&gt;&gt; updated: xdm_flags<br>
      &gt;&gt; updated: sendmail (standard)<br>
      &gt;&gt; updated: ftp (configure as non-inetd Anonymous)<br>
      &gt;&gt; .</td>
  </tr>
  <tr> 
    <td class="pScreenSmall" nowrap>done</td>
  </tr>
</table>
<p>In the situation of the /etc/rc.conf.local file, we are using RCS to maintain 
  a trace log of changes so we can recover from any serious editorial faults. 
  In such a scenario it is valid to keep the 'lock' on, or remove locking altogether 
  (see the man pages.)</p>
### <a name="rcsHOWTO"></a>HOW TO
#### <a name="rcsHTdiff"></a>Compare Different Revisions
<p class="pFileReference">[ref: rcsdiff(1)]</p>
<p>You can compare different revisions of your file by using rcsdiff (releaseA) 
  (releaseB) filename.</p>
<p>For example, to compare the differences between release 1.1 and release 1.3 
  we can use the following command-line.</p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="Code" nowrap>rcsdiff -r1.1 -r1.3 filename</td>
  </tr>
</table>
<p>&nbsp;</p>
#### <a name="rcsHTcilu"></a>Check In without losing my File
<p class="pFileReference">[ref: rcsintro, ci]</p>
<p>Checking in a file automatically removes the file from the current location 
  and places it into the repository.</p>
<p>To prevent ci from deleting your working file, you can use either </p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="pScreenOutput" nowrap>ci -l <i>filename </i>(check in lock) <b>or</b></td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap>ci -u <i>filename </i>(check in unlock)</td>
  </tr>
</table>
<p>These two commands implicitly check out the file after check-in.</p>
#### <a name="rcsHTrevert"></a>Revert to a previous Revision
<p>To revert to a previous edit, you simply check-out the version you wish to 
  be the 'current' release, and then check it in again.</p>
<p>For example, if I wish to revert to the original file (release 1.1) and I am 
  current up to release 1.4.</p>
<table border="0" class="Code" nowrap width="80%">
  <tr> 
    <td class="Code" nowrap>rcsdiff -r1.4 -r1.1 filename</td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap>describes difference between the current 
      build and<br>
      initial release</td>
  </tr>
  <tr> 
    <td class="Code" nowrap>co -r1.1 <i>filename</i></td>
  </tr>
  <tr> 
    <td class="Code" nowrap>ci -u <i>filename</i></td>
  </tr>
  <tr> 
    <td class="Code" nowrap>rcsdiff -r1.4 -r1.1 filename</td>
  </tr>
  <tr> 
    <td class="pScreenOutput" nowrap>should be exactly the same as above diff 
      comparison</td>
  </tr>
</table>