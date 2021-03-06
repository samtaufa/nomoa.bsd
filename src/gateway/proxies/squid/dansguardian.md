##  Content Filtering Web Access

<div class="toc">
    <p>Table of Contents: </p>
    <ol>
      <li>Content Filtering
      <li>Our Configuration
        <ul>
          <li>(a) authentication </li>
          <li>(b) DansGuardian</li>
          <li>(c) caching  </li>
        </ul>
		<li>Execution Script 
            <ul><li>Squid</li>
              <li>DansGuardian</li>
            </ul>
		</li>
    </ol>
    
</div>

<p >We had a requirement to support content filtering but we also still required 
  our overlook available from squid analysis tools that were not available from 
  our content filtering program (dansguardian.)</p>
  
<p >These notes are intended to be used together with the existing [notes on configuring squid](squid.4.9.html). Information already covered in those notes will not necessarily be reviewed here. </p>
<p >If you have not installed a working version of squid, then I recommend the above mentioned notes and ensure that you can get a standard install of squid working before delving further into these notes. </p>


### Content Filtering

<p>What is it?</p>
<p>People seem to take extreme views on the legitimacy of content filetering of the Internet, but nonetheless if you need to restrict web access in your environment then DansGuardian is a good Open Source program for the task. If you don't have our other requirement, then you can just install that.</p>
<p>Essentially, content-filtering is the ability to determine access privileges to websites, web-pages, depending on the 'content' of the page, instead of depending on the URL (host and links) of the pages.</p>
<p>Our additional requirement, as hinted above, was to retain knowledge of who was accessing what on the Internet and to limit access to the internet to legitimate users of our service (i.e. authentication) </p>

### Our Configuration:
<p>We have/had an OpenBSD server as our gateway, caching box between the WAN and the Internet.</p>
<p>The proposal is to send all connections to an Authentication Proxy, from that Proxy to the Content Filter (DansGuardian) and then to a Caching Server. </p>
<p>client --&gt; cache (authentication) --&gt; content filter --&gt; cache (caching)</p>
<p>In this workspace, we are running two instances of squid (a) authentication and (c) caching with the content filter (b) DansGuardian in between.</p>

#### (a) authentication 
<p>The (a) authentication instance of squid is configured to:</p>
<p>1. Listen on the standard squid port (3128)</p>
<p>2.  authenticate users before passing the request to DansGuardian using the <strong>cache_peer </strong>TAG. [Please refer to above mentioned <a href="squid.htm" class="anchBlue2">squid.htm</a> documentation for how to configure authentication] </p>
<p>3. don't cache anything, allow DansGuardian to review all connections</p>
<p>4. allow access from anyone on our network (only) </p>
<p>5. Distinguish this revision of squid by using log and caching names of <strong>*_authenticate</strong> </p>

#### (b) DansGuardian 

<p>Configuration is per its documentation with the following revisions.</p>
<p>1. Listen on port 8080 (or change the settings in this documentation)</p>
<p>2. Forward Internet Access to the caching squid proxy at port 3138 </p>

#### (c) caching

<p>The (c) caching instance of squid is configured to:</p>
<p>1. Listen on a non-standard squid port (3138) or whichever you choose.</p>
<p>2. DO NOT AUTHENTICATE users.</p>
<p>3. Cache everything (practically) </p>
<p>4. ONLY allow access from localhost (i.e. DansGuardian) </p>
<p>5. Distinguish this revision of squid by using log and caching names of <strong>*_cache</strong> </p>
<p>&nbsp;</p>
<p>The standard configuration settings we have used are shown below. </p>
<table width="80%" border="0">
  <tr bgcolor="#CCFF33"> 
    <td width="17%" bgcolor="#CCFF33"><div align="center"><strong>TAG</strong></div></td>
    <td width="42%"><div align="center"><strong>Squid authentication</strong></div></td>
    <td width="41%"><div align="center"><strong>Squid caching</strong></div></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">filename</td>
    <td><font face="Arial, Helvetica, sans-serif">/etc/squid/squid_authenticate.conf</font></td>
    <td><font face="Arial, Helvetica, sans-serif">/etc/squid/squid_cache.conf</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">http_port</td>
    <td><font face="Arial, Helvetica, sans-serif">3128</font></td>
    <td><font face="Arial, Helvetica, sans-serif">3138</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">icp_port</td>
    <td><font face="Arial, Helvetica, sans-serif">3130</font></td>
    <td><font face="Arial, Helvetica, sans-serif">3140</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">cache_peer</td>
    <td nowrap><font face="Arial, Helvetica, sans-serif">127.0.0.1 parent 8080 7 allow-miss 
      no-digest no-netdb-exchange no-query proxy-only </font></td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">hierarchy_stoplist</td>
    <td><font face="Arial, Helvetica, sans-serif">(remove cgi-bin ?)</font></td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">no_cache</td>
    <td><font face="Arial, Helvetica, sans-serif">#We recommend you to use the 
      following two lines.<br>
      acl allhttp proto HTTP<br>
      acl QUERY urlpath_regex cgi-bin \?<br>
      acl localnet src LAN_SUBNET/LAN _MASK 
      <p>no_cache deny QUERY<br>
        no_cache deny allhttp<br>
        no_cache deny localnet</p>
      </font></td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
  </tr>
  <tr>
    <td bgcolor="#CCFF33">cache_access_log</td>
    <td>/var/squid/logs/access_authenticate.log</td>
    <td>/var/squid/logs/access_cache.log</td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">cache_mem</td>
    <td><font face="Arial, Helvetica, sans-serif">8 MB</font></td>
    <td><font face="Arial, Helvetica, sans-serif">8 MB</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">&nbsp;</td>
    <td><font face="Arial, Helvetica, sans-serif">Size should match size in cache_dir</font></td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">cache_dir</td>
    <td nowrap><font face="Arial, Helvetica, sans-serif">ufs /var/squid/cache_authenticate 
      8 16 256 read-only</font></td>
    <td><font face="Arial, Helvetica, sans-serif">ufs /var/squid/cache 100 16 
      256</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">cache_log</td>
    <td><font face="Arial, Helvetica, sans-serif">/var/squid/logs/access_authenticate.log</font></td>
    <td><font face="Arial, Helvetica, sans-serif">/var/squid/logs/access_cache.log</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">cache_store_log</td>
    <td><font face="Arial, Helvetica, sans-serif">/var/squid/logs/store_authenticate.log</font></td>
    <td><font face="Arial, Helvetica, sans-serif">/var/squid/logs/store_cache.log</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">pid_filename</td>
    <td><font face="Arial, Helvetica, sans-serif">/var/run/squid_authenticate.pid</font></td>
    <td><font face="Arial, Helvetica, sans-serif">/var/run/squid_cache.pid</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">authenticate_ip_ttl</td>
    <td><font face="Arial, Helvetica, sans-serif">60 seconds</font></td>
    <td><font face="Arial, Helvetica, sans-serif">1 hour</font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">http_access</td>
    <td><font face="Arial, Helvetica, sans-serif">allow our_networks</font></td>
    <td><p><font face="Arial, Helvetica, sans-serif">allow localhost<br>
        deny our_networks<br>
        </font></p></td>
  </tr>
  <tr> 
    <td bgcolor="#CCFF33">&nbsp;</td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
    <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
  </tr>
</table>
<p>&nbsp;</p>

### Execution Script

<p>Because three different servers need to be initiated (started) and there 
are times you may just wish to stop / start these things, I've set up documenting 
a script for the squid processes, and DansGuardian comes with a script that seems 
to work well enough for it.</p>

#### squid.sh  

<p>To ensure required squid processes are both running, the below script can be 
  used. A good place to locate the script would be /etc/rc.d/init.d/squid.sh</p>
  
<p>File: squid.sh</p>

<pre class="command-line">
#!/bin/sh
echo -n ' Squid '

case "$1" in
        start)
            /usr/local/sbin/squid -D -f /etc/squid/squid_authenticate.conf
            /usr/local/sbin/squid -D -f /etc/squid/squid_cache.conf
            ;;
        stop)
            /usr/local/sbin/squid -f /etc/squid/squid_authenticate.conf -k shutdown
            /usr/local/sbin/squid -f /etc/squid/squid_cache.conf -k shutdown
            ;;
        restart)
            /usr/local/sbin/squid -f /etc/squid/squid_authenticate.conf -k reconfigure
            /usr/local/sbin/squid -f /etc/squid/squid_cache.conf -k reconfigure
            ;;
        rotate)
            /usr/local/sbin/squid -f /etc/squid/squid_authenticate.conf -k rotate
            /usr/local/sbin/squid -f /etc/squid/squid_cache.conf -k rotate
           ;;
        *)
        echo "Usage: `basename $0` {start|stop|restart|rotate}"
        ;;
esac
</pre>

<p>The script merely ensures that both versions of the running squid are terminated, 
  started, restarted when required.</p>
  
#### dansguardian

<p>The following script is generally supplied with dansguardian and is placed 
    here for completeness of documentation.</p>
<p class="pFileReference">File: dansguardian.sh</p>

<pre class="command-line">
#!/bin/sh
#
# BSD startup script for dansguardian
# partly based on httpd startup script
#
# description: A web content filtering plugin for web \
#              proxies, developed to filter using lists of \
#              banned phrases, MIME types, filename \
#              extensions and PICS labling.
# processname: dansguardian


# See how we were called.

case "$1" in
    start)
        [ -x /usr/sbin/dansguardian ] && /usr/sbin/dansguardian > /dev/null && echo -e ' dansguardian'        ;;
    stop)
        /usr/sbin/dansguardian -q
        [ -r /tmp/.dguardianipc ] && echo -e ' dansguardian'        rm -f /tmp/.dguardianipc
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage: configure {start|stop|restart}" >&2
        ;;
esac
exit 0
</pre>