##  Regular, Service Maintenance Checklist.

#### Weekly, High Frequencey

Short interval reviews exist for the following.

<table>
  <tr><th>What</th><th>With</th><th>When</th></tr>
  <tr>
    <td>Server Online State</td>
    <td>daily log, direct connections, groklog, ping, cacti</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Service Online State.

    <p>Verify that all specified services are online and operational.</p></td>
    <td>daily log, direct connections, groklog, cacti</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Service Performance.
    <p>Verify services are functional within guidelines for installation.</p>

    <p>Do not make performance changes with little projected improvements.</p>

    <p>Review, and where possible correct, issues blocking performance or
    causing performance problems (e.g. delays caused by DNS queries)</p>
    </td>
    <td>daily log, cacti</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Service Performance.

    <p>Consider a formal review of new controls and modification changes. Where
    appropriate document an RFC</p>

    </td>
    <td>Review</td>
    <td>half-yearly</td>
  </tr>
    <td>Backup State.

      <p>Review restorability and security aspects of the backup states.</p>
    </td>
    <td>daily log</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Resource Utilisation - Disk
    <p>Disk useage can have a significant impact on performance and is monitored regularly</p></td>
    <td>daily log, cacti</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Resource Utilisation - Other
    <p>other system resources that are monitored for abnormal changes include cpu use patterns,
    RAM utilisation.</td>
    <td>daily log, cacti, groklog</td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Mail Queue
    <p>Review unforeseen extended growths in the incoming and outgoing mailqueues.</p></td>
    <td>daily log, cacti </td>
    <td>twice weekly</td>
  </tr>
  <tr>
    <td>Web Proxy
    <p>Review proxy logs for noticeable performance issues</p>
    </td>
    <td>daily log, cacti</td>
    <td>twice weekly</td>
  </tr>

</table>

#### Monthly

Analysis and reviews requiring longer data collection periods for analysis (typically a month) include the following

<table>
  <tr><th>What</th><th>With</th><th>When</th></tr>
  <tr>
    <td>Firewall Reports.

    <p>Review a specific section of the networks firewall logs seeking insights to security and performance</p></td>
    <td>groklog, eyeballs</td>
    <td>Monthly</td>
  </tr>
  <tr>
    <td>VPN Report
      <p>Use and capacity performance report.</p>
    </td>
    <td>sawmill, webalizer(?)</td>
    <td>bi-monthly</td>
  </tr>
  <tr>
    <td>Web Proxy Report
      <p>Use and capacity performance report.</p>
    </td>
    <td></td>
    <td>bi-monthly</td>
  </tr>
</table>

#### Quarterly

<table>
  <tr><th>What</th><th>With</th><th>When</th></tr>
  <tr>
    <td>Firewall Document.

      <p>Report on the current firewall deployment and potential impact
      of network change proposals.</p>
    </td>
    <td>groklog, eyeballs</td>
    <td>semi-annually</td>
  </tr>
  <tr>
    <td>
    </td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>


#### Annually

<table>
  <tr><th>What</th><th>With</th><th>When</th></tr>
  <tr>
    <td>Authentication Keys.

    <p>Distribute new public SSH keys for all managed servers.
    Ensure managed hosts get new public keys as a security
    measure.</p></td>
    <td>daily log</td>
    <td>Annually</td>
  </tr>
  <tr>
    <td>Host Build Test Cycle.

      <p>Each host will be given a full pre-release security audit and review.</p>
    </td>
    <td>eyeball</td>
    <td>on commission</td>
  </tr>
  <tr>
    <td>Perfomance Assessment
      <p>Should the client concur, a review can be made assessing capacity of existing host
      to achieve required performance for next 12 months.
    </td>
    <td></td>
    <td>on commission</td>
  </tr>
</table>


A checklist is useful in ensuring a minimal level of consistency.  Of-course we accept that the check-lists  do not ensure the quality service. It still belongs in the hand of the code monkey, or admin monkey carrying the check-list around.

In the absence of a good automated system, the more mundane manual process still needs to be completed.

#### What activities do we want to perform, and why is that beneficial for us and our clients.

Below is a quick list of activities that should/could be reviewed and an argument (for or against) their value to clients and Nullcube. Otherwise known as the feature checklist of what would be nice in a monitoring system that is scalable.

The suggestion to use Control, Histogram, and Pareto Charts allow us to discuss Policy Procedures. The nature of the charts give specific data points that can be connected to specific Policy or Flag items enabling both Nullcube and clients to pre-allocate behaviour and resources.

We all benefit from a visual indicator that can become a common "language" between different skill levels and orientation.

###### All Hosts

For all managed hosts, the following are points of interest to regularly monitor.

<table>
  <tr><th>Item</th><th>Monitor</th><th>Purpose</th><th>Audit tools</th></tr>
  <tr><td>Uptime</td>
      <td>Control Chart</td>
      <td>
      <p>Set boundaries for median and maximum uptime.</p>

      <p>The graph should be linear and interesting factors exist both below a pre-determined minimum and maximum control bars. Where the system spends too much time below the minimum uptime (e.g. set minimum uptime of 2 days, so when a machine is below that bar for more than a week this should flag a review of the installation.) There should be a maximum number of days live control, above this control should begin to worry us whether the system can survive a restart on the occassion of a <strong>forced restart</strong>.</p>

      <p>Clients may neglect or are themselves not aware of power cycling of servers due to various issues such as short-term power failure onsite.</p>

      <p>Benefits - see above reference to Policy and Behaviour</p>
    </td>
    <td>groklog, daily output</td>
  </tr>
  <tr>
      <td>Resource Utilisation</td>
      <td>Control Charts</td>
      <td>

      <p>Set boundaries for median and maximum disk use.</p>

      <p>The maximum value is critical, but we also need to know if there is a pattern
      of use that is systematically driving use towards the control borders.</p>
      <table>
                <tr>
                    <th>Item
                    </th>
                    <th>Description
                    </th>
                    <th>Tool
                    </th>
                  </tr>
                <tr>
                    <td>Disk
                    </td>
                    <td>Load, expansion
                    </td>
                    <td></td>
                  </tr>
                <tr>
                    <td>Ram
                    </td>
                    <td>Load, expansion
                    </td>
                    <td>Cacti</td>
                  </tr>
                  <tr>
                    <td>CPU.
                    </td>
                    <td>Load, expansion
                    </td>
                    <td>Cacti</td>
                  </tr>
    </table>
      </td>
    <td>groklog, </td>
  </tr>
  <tr>
      <td>Network Links</td>
      <td>Control Chart</td>
      <td>

      <p>Set boundaries for median and maximum state behaviour of link.</p>

      <p>Benefits - see above reference to Policy and Behaviour</p>

    </td>
    <td>groklog, netstat</td>
  </tr>
  <tr>
      <td>Changes to Configuration Files</td>
      <td>Change List</td>
      <td>

      <p>Track changes to configuration files such as /etc/pf.conf, /etc/samba/smb.conf, /etc/samba/arp.allowed</p>

      <p><table>
                <tr>
                    <td>/etc/pf.conf
                    </td>
                    <td>Firewall rules
                    </td>
                  </tr>
                <tr>
                    <td>/etc/rc, /etc/rc.local, /etc/rc.conf.local, /etc/login.conf, root's cron
                    </td>
                    <td>Startup changes
                    </td>
                  </tr>
                <tr>
                    <td>/etc/mail/*, /etc/samba/*, /etc/squid/*
                    </td>
                    <td>Sendmail, Samba and Squid configuration files
                    </td>
                  </tr>
                <tr>
                    <td>/home/*/.ssh;/home/*/.bash_profile;/home/*/.profile
                    </td>
                    <td>
                    </td>
                  </tr>
              </table>
      </p>
      </td>
    <td>groklog, </td>
  </tr>

  <!--
  <tr>
      <td></td>
      <td>Control Chart</td>
      <td>

      <p>Set boundaries for median and maximum XXXXXX use.</p>

      <p>Benefits - see above reference to Policy and Behaviour</p>

      </td>
    <td>groklog, </td>
  </tr>
  -->
</table>

###### Specific Services

For  special services on hosts, below is the beginnings of a list of issues to monitor.

<table>
  <tr><th>Service</th><th>Item</th><th>Monitor</th><th>Purpose</th><th>Audit Tools</th></tr>
  <tr>
      <td>Firewall</td>
      <td>Traffic </td>
      <td>Control, Histogram, and Pareto Chart</td>
      <td>

      <p>Control Charts can be used for visualising overall traffic patterns as well as behavioural changes
      for different types of traffic.</p>

      <p>Histogram Chart: </p>

      <p>Pareto Chart: Visually highlight volume differences in types of traffic.</p>

      <p>Benefits - see above reference to Policy and Behaviour</p>
      </td>
    <td>groklog, </td>

  </tr>
 <tr>
      <td>Mail Server</td>
      <td>Mail Queue</td>
      <td>Control, Histogram Chart</td>
      <td>

      <p>Set boundaries for median and maximum disk use.</p>

      <p>Benefits - see above reference to Policy and Behaviour</p>

      </td>
    <td>groklog, </td>
  </tr>
  <tr>
      <td>Mail Server</td>
      <td>Traffic</td>
      <td>Control, Histogram Chart</td>
      <td>

      <p>There are various issues with mail traffic that should be of value to ourselves and to clients. Some of these, charted would significantly improve ability to react.</p>

<table>
  <tr><th>Item</th><th>Description</th></tr>
  <tr><td>activity</td>
          <td>end-user activity. Histogram highlighting ends of user activity. Heavy users provide a pattern of behaviour. We anticipate that the interest will be mostly with things on the extreme. Someone sending out 10GB of email should raise some sort of flag somewhere. A sudden major increase in use should also raise a flag.</td>
  </tr>
  <tr><td>Denied/Failed</td>
          <td>Denied and failed send-to accounts could imply a user error or some sort of
                  software misconfiguration. A huge denial/failure may indicate a potential security
                  data point.</p>

                  If the user has failed to adjust their behaviour from the mailserver error messages, then we may
                  need to look at other means of resolving the problem.</td>
  </tr>
  <tr><td>Denied/Failed</td>
          <td>Analysis of high incoming denied/failed will give us a better lead towards DOS and SPAM.</td>
  </tr>
  <tr><td></td>
          <td></td>
  </tr>
  <tr><td></td>
          <td></td>
  </tr>

</table>

      </td>
    <td>groklog, </td>
  </tr>
  <tr>
      <td>Web Proxy</td>
      <td>Traffic</td>
      <td>Control, Histogram Chart</td>
      <td>


<table>
  <tr><th>Item</th><th>Description</th></tr>
  <tr><td>activity</td>
          <td>end-user activity. Histogram highlighting ends of user activity. Heavy users provide a pattern of behaviour. We anticipate that the interest will be mostly with things on the extreme. Someone sending out 10GB of email should raise some sort of flag somewhere. A sudden major increase in use should also raise a flag.</td>
  </tr>
  <tr><td>Denied/Failed</td>
          <td>Denied and failed send-to accounts could imply a user error or some sort of
                  software misconfiguration. A huge denial/failure may indicate a potential security
                  data point.</p>

                  If the user has failed to adjust their behaviour from the mailserver error messages, then we may
                  need to look at other means of resolving the problem.</td>
  </tr>
  <tr><td>Denied/Failed</td>
          <td>Analysis of high incoming denied/failed will give us a better lead towards DOS and SPAM.</td>
  </tr>
  <tr><td></td>
          <td></td>
  </tr>
  <tr><td></td>
          <td></td>
  </tr>

</table>

      <p>Benefits - see above reference to Policy and Behaviour</p>

      </td>
    <td>groklog, </td>
  </tr>
</table>


