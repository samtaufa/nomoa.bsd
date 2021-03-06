## First Time - Partitioning

&#91;Ref: $!manpage("disklabel",8)!$, $!manpage("fdisk",8)!$, 
[FAQ 14 - Disk Setup](http://www.openbsd.org/faq/faq14.html)]

Partitioning is the process where you divide up your Hard Disk
into logical segments (partitions) for storing files. A good 
approach is to not pre-optimise how your partition should look.
This is to say, no single configuration will work for you in
every possible system installation. 

$!Image("partitioning_sample.png", title="Sample Partition", klass="imgcenter")!$

Be prepared to build a few test systems to gauge the relative 
sizes your disk usage and requirements (if not already known.)
Set your standard as something that will change as your needs 
and understanding grows.

For a 1st time installer, just building a test environment, you
have to early options during your learning process:

-   use the full drive as "/"? 
    That will allow you to use up all the hard disk for improving 
    other knowledge of the OpenBSD system, without letting "out of disk space" 
    errors clutter yourlearning.
-   use recommended settings from post 4.6 installers.
    The installation system, from 4.6 onwards provide a recommendation
    for a partitioning of your available disk-space.

Try those out, and again, monitor how your disk space is used.

Use $!manpage("du")!$ and $!manpage("df")!$ to gather information about
your actual usage pattern for a better understanding, determination
of your partition needs.

`du -h /partition`

or

`df -h`

The following is on simple partitioning scheme, on the premise that
data on this configuration will not grow, the only partition 
expected to grow after installation being the /var/logs partition.

<table>
  <tr><th>Slice</th><th>Mount Point</th><th>Capacity</th><th>dump;fsck</th></tr>
  <tr>
      <td>a</td><td>/</td>
      <td>5G</td><td>(default)</td>
  </tr>
  <tr>
      <td>b</td><td>(swap)</td>
      <td>2G</td><td>~</td>
  </tr>
  <tr>
      <td>c</td><td>(disk-slice)</td>
      <td>(disk)</td><td>~</td>
  </tr>
  <tr>
      <td>d</td><td>/tmp</td>
      <td>4G</td><td>(default)</td>
  </tr>
  <tr>
      <td>e</td><td>/usr</td>
      <td>10G</td><td>(default)</td>
  </tr>
  <tr>
      <td>f</td><td>/home</td>
      <td>10G</td><td>(default)</td>
  </tr>
  <tr>
      <td>g</td><td>/var/log</td>
      <td>20G</td><td>(default)</td>
  </tr>
  <tr>
      <td>h</td><td>/var</td>
      <td>10G</td><td>(default)</td>
  </tr>
  <tr>
      <td>i</td><td>/storage</td>
      <td>* (available left-over)</td><td>0 0</td>
  </tr>
</table>

The above works well for us on 50G + Hard Disk Drives, for systems 
functioning primarily as non-caching proxies and firewalls.
