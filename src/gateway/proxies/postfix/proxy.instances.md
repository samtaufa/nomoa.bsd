## MX Proxy Extended, using Multiple Instances

<div class="toc">

Table of Contents

<ul>
	<li><a href="#package.install">1. Package Install</a>
		<ul>
			<li>Aliases</li>
			<li>Relay Domains</li>
			<li>Relay Transport</li>
			<li>Update Databases</li>
			<li>Start and Reload</li>
		</ul>
	</li>
	<li><a href="#instances">2. MTA Instances</a>
	</li>
	<li><a href="#inbound">3. Inbound Instance</a>
		<ul>
			<li>Incorporate chroot files</li>
			<li>Relay Domains</li>
			<li>Relay Transport</li>
			<li>SMTP Connection Restrictions</li>
			<li>Sender Restriction</li>
			<li><a href="#3.recipient">Recipient Restriction</a></li>
			<li>Start and Reload</li>
			<li>Advanced Recipient Restrictions</li>
			<li>Unknown Cost/Value</li>
		</ul>
	</li>
	<li><a href="#outbound">4. Outbound Instance</a>
		<ul>
			<li>Incorporate choort files</li>
			<li>Trusted SMTP Hosts</li>
			<li>Start and Reload</li>
		</ul>
	</li>
	<li><a href="#log">5. Logging</a></li>
	<li><a href="#verify">6. Verify</a></li>
	<li><a href="#monitor">7. Monitoring</a></li>
</ul>

</div>

OpenBSD 4.8 AMD64, Postfix 2.7.1

Expanding on our [MX Proxy](proxy.html) example, we evolve a scenario where our needs
are a little more complicated, and likewise our increased requirements for the [MX Proxy](proxy.html) 
In our new scenario, we deploy 3 purposed hosts, prioritising on performing 
their tasks while maintaining high availability:

- 	The Internal Mail Server services mailbox and client access for internal users.
-	The Scanner, Filtering Server administers organisation security and useage policies.
-	The MX Proxy acts as the gateway between the internal systems and the Internet.

Our expanded mail chain looks like the below:


$!Image("mail/mailchain.png", title="SMTP Proxy", klass="imgcenter")!$

<pre>
<strong>
[ user ] <--> [ mail server ] <--> [ filter ] <--> [ MX Proxy ] <--> {Internet}
</strong>
</pre>

Alluding to the ["Single Purpose Host" principle](http://www.letmebingthatforyou.com/?q=single+purpose+host)
each server in the mail flow foci defined realm.
. 
In reality, such segmentation is difficult with various access controls and filtering 
activities best implemented, at different points of the mail-chain. 

A key requirement for enhanced security is greater access controls on the MX Proxy, 
differentiated between inbound and outbound mail. But differentiation requires multiple
Mail Transfer Agents, individually listening for mail from:

<ol>
	<li>the host</li>
	<li>trusted/local network systems, and</li>
	<li>external systems.</li>
</ol>

Differentiation requires either: 

-	Multiple [ MX Proxy ] hosts to differentiate traffic, or 
-	Multiple MTA instances on the same host, one for each task.

Our priorities for the MX Proxy Service is to provide another layer of **security** between the
Internet and the organisations network, while ensuring **no mail is lost**. Thus access
controls (filters) on the MX Proxy must meet the following goals:

1.	Improve the security profile, documented.
2.	Low-cost performance, resource utilisation.
3. 	Failover pass-through. 
4. 	Best performed at message entry point (MX Proxy.)

All other access controls, filtering, scanning, is delayed for the *[filter]* server and 
internal *[mail server]* as appropriate.

Installing a **Multiple MTA Instances** requires fewer resources.

$!Image("mail/proxy.instances.png", title="SMTP Proxy Instances", klass="imgcenter")!$

The above diagram highlights the mail flow using our three MTA instances:

* MTA  Instance **Primary** for local submissions
* MTA Instance **Inbound** filters and relays Inbound Mail (postfix-inbound)
* MTA Instance **Outbound** relays Outbound Mail (postfix-outbound)

$!Image("mail/proxy.instances.filters.png", title="Multiple MTA Instance - Filters", klass="imgcenter", kaption="""MTA Instance "Summary Filters" """)!$



### <a name="package.install"></a> 1. Package Install


Install the OpenBSD Postfix Package.
The Postfix "multi-instance" configuration tool uses the default install
paths as the first instance, our "Primary Instance."

The compiled postfix binaries expect configuration files in 
*/etc/postfix* and the  mail/queue in */var/spool/postfix*
These settings can be adjusted in our secondary instances:

<pre class="config-file">
config_directory=/etc/postfix
queue_directory=/var/spool/postfix
</pre>

Update the Postfix configuration files, such that it accepts
mail only from the localhost and relay's mail for internal
users to the [Mail Filter Server]

File excerpt: /etc/postfix/main.cf

<pre class="config-file">
config_directory=/etc/postfix
queue_directory=/var/spool/postfix

alias_database = hash:$config_directory/aliases
alias_maps   = hash:$config_directory/aliases
message_size-limit = 20480000
mynetworks = 127.0.0.1
relay_domains = $config_directory/relaydomains
transport_maps = hash:$config_directory/transport

inet_interfaces = loopback-only

syslog_name = postfix-default
</pre>

Because our intentions will be to run the default instance of Postfix
only listening to the loop-back device, we update the master.cf file
to not listen to the rest of the network.

File excerpt: /etc/postfix/master.cf

<pre class="config-file">
#smtp           inet    n   -   -   -   -   smtpd
127.0.0.1:smtp  inet    n   -   -   -   -   smtpd
</pre>

#### Aliases

File excerpt: /etc/postfix/aliases

<pre class="config-file">
root:		control
</pre>

#### Relay Domains

Because we support local mail delivery, we are also going
to be explicit on where we want to deliver e-mail from
the 'root' user. Our relay_domains file will contain
the internally supported domains

File excerpt: /etc/postfix/relaydomains

<pre class="config-file">
example.org
example.com
example.net
</pre>

Because parent_domain_matches_subdomain is the default, this
will support subdomain.example.com etc.

#### Transport

File excerpt: /etc/postfix/transport

<pre class="config-file">
example.org			smtp:[ip-address]
example.com			smtp:[ip-address]
example.net			smtp:[ip-address]
</pre>

#### Update Databases

<pre class="command-line">
/usr/local/sbin/postmap /etc/postfix/transport
/usr/local/sbin/postalias /etc/postfix/aliases
</pre>

#### Start and Reload

<pre class="command-line">
/usr/local/sbin/postfix reload
</pre>

### <a name="instances"></a> 2. MTA Instances

&#91;Ref: [Adding a second postfix instance](http://advosys.ca/papers/email/58-postfix-instance.html) |
[Managing multiple Postfix instances on a single host](http://www.postfix.org/MULTI_INSTANCE_README.html)]

Postfix is good enough to use the same binaries to execute with different configurations,
we'll configure our Instances using the ability to reference different configuration
settings.

Per the Postfix documentation, we enable multi-instance support in our default instance

<pre class="command-line">
/usr/local/sbin/postmulti -e init
</pre>

Which adds the following configuration settings:

File extract /etc/postfix/main.cf

<pre class="config-file">
multi_instance_directories =
multi_instance_enable = yes
</pre>

We want some additional operational items defined, so we add the following
configuration items.

File extract /etc/postfix/main.cf (add these settings if not already in the file)

<pre class="config-file">
multi_instance_wrapper = ${command_directory}/postmulti -p --
multi_instance_name = postfix-default
multi_instance_group = mta
</pre>

Verify the configuration is operational as previously expected, including
viewing the postmulti view of running services.

<pre class="command-line">
/usr/local/sbin/postmulti -l
</pre>

### <a name="inbound"></a> 3. Inbound Instance

After which we can initialise the other MTA instances (inbound and outbound)

<pre class="command-line">
/usr/local/sbin/postmulti -I postfix-inbound -G mta -e create
</pre>

The command creates the /etc/postfix-inbound configuration directory with the following modifications:

File excerpt: /etc/postfix-inbound/main.cf

<pre class="config-file">
queue_directory = /var/spool/postfix-inbound
data_directory = /var/postfix-inbound

master_service_disable = 
authorized_submit_users = root
multi_instance_group = mta
multi_instance_name = postfix-inbound
multi_instance_enable = yes
</pre>

Note we change the initial values for *master_service_disable* and *authorized_submit_users*
so that we can accept email through *inet*, and accept e-mail from the *root* 
account during verification of our service.

We add the following customisations for our configuration

<pre class="config-file">
# -- Customisations for our configuration
relay_domains    = $config_directory/relaydomains
transport_maps   = hash:$config_directory/transport
message_size     = 20480000

mynetworks       =

# -- No Local Delivery
mydestination    =
alias_maps       =
alias_database   =
local_recipient_maps =
local_transport  = error:5.1.1 Mailbox unavailable

smtp_bind_address = 0.0.0.0
smtpd_delay_reject = yes
smtpd_helo_requried = yes

smtpd_helo_restrictions =
	reject_invalid_helo_hostname,
	reject_non_fqdn_helo_hostname,
	check_helo_access hash:$config_directory/helo_access,
	permit
	
smtpd_sender_restrictions =
	reject_unauth_destination,
	reject_non_fqdn_sender,
	check_sender_access hash:$config_directory/sender_access,
	reject_unknown_sender_domain,
	permit
</pre>

File excerpt: /etc/postfix-inbound/master.cf

<pre class="config-file">
smtp           inet    n   -   -   -   -   smtpd
</pre>

#### Incorporate chroot files

Incorporate custom configuration settings involved with
OpenBSD's default chroot installation

<pre class="command-line">
/usr/local/sbin/postfix -c /etc/postfix-inbound check
export SUBDIR="etc usr lib"
export SRC=/var/spool/postfix
export DST=/var/spool/postfix-inbound
for subdir in $SUBDIR; do
	if [ -d $SRC/$subdir ]; then
		cp -pR $SRC/$subdir $DST
	fi
done
</pre>

#### Relay Domains

File excerpt: /etc/postfix-inbound/relaydomains

<pre class="config-file">
example.org
example.com
example.net
</pre>

#### Relay Transport

File excerpt: /etc/postfix-inbound/transport

<pre class="config-file">
example.org         smtp:[ip-address]
example.com         smtp:[ip-address]
example.net         smtp:[ip-address]
</pre>

#### SMTP Connection Restrictions

File excerpt: /etc/postfix-inbound/helo_access

<pre class="config-file">
MY-PUBLIC-IP			REJECT Forged Source. If I needed a mirror I'd visit the bathroom
example.com				REJECT Forged Source. If I needed a mirror I'd visit the bathroom
example.org 			REJECT Forged Source. If I needed a mirror I'd visit the bathroom 
subdomain.example.org  	REJECT Forged Source. If I needed a mirror I'd visit the bathroom 
</pre>

Where example.com and example.org are domains hosted by our Inbound.

Remember to update the db file by using postmap, and to start the  your configuration
files.

<pre class="command-line">
/usr/local/sbin/postmap /etc/postfix-inbound/helo_access
/usr/local/sbin/postmulti -i postfix-inbound -p start
</pre>

#### Sender restrictions

<pre class="config-file">
check_sender_access hash:/etc/postfix-inbound/sender_access
</pre>

Because we get a lot of emails purporting to be from internal, it's important to
verify this before relaying mail. Remember that this instance, will only receive
mail messages from external hosts.

File excerpt: /etc/postfix-inbound/sender_access

<pre class="config-file">
example.com				REJECT forged account 
example.org				REJECT forged account
subdomain.example.com	REJECT forged account
</pre>

<pre class="command-line">
/usr/local/sbin/postmap /etc/postfix-inbound/sender_access
/usr/local/sbin/postmulti -i postfix-inbound -p reload
</pre>


#### <a name="3.recipient"></a>Recipient Restriction

Progressing through the initial stages of connection, mail receipt, we have focussed on
low-cost activities. A few 

<pre class="config-file">
smtpd_recipient_restrictions =
	reject_unauth_pipelining,
	reject_non_fqdn_recipient,
	reject_unknown_recipient_domain,
	permit_mynetworks,
	permit_sasl_authenticated,
	reject_unauth_destination,
	check_sender_access hash:/etc/postfix-inbound/sender_access,
	check_recipient_access hash:/etc/postfix-inbound/recipient_access,
	permit
</pre>

The advantage of these is that, being later in the processing stage of
e-mail, it has also recieved more information about the potential
message.

Expanding the generic rule, we can add blacklists with instructions
such as the following.

<pre class="config-file">
	smtpd_recipient_restrictions =
		permit_mynetworks,
		reject_unauth_destination,
		reject_invalid_hostname,
		reject_unauth_pipelining,
		reject_non_fqdn_sender,
		reject_unknown_sender_domain,
		reject_non_fqdn_recipient,
		reject_unknown_recipient_domain,
		check_helo access		hash:$config_directory/helo_access,
		check_sender_access     hash:$config_directory/sender_access,
		check_recipient_access  hash:$config_directory/recpient_access,
		reject_rhsbl_recipient  bogusmx.rfc-ignorant.org,
		reject_rhsbl_recipient  dsn.rfc-ignorant.org,
		reject_rbl_client       zen.spamhaus.org,
		reject_rbl_client       dnsbl.njabl.org,
		permit		
</pre>

Take care to monitor the effectiveness, or stability of the remote services
being used. Likewise, ensure that your use is compliant with the
acceptable use of those remote services.

File excerpt: /etc/postfix-inbound/recipient_access

<pre class="config-file">
10.20.30.40				REJECT forged account 
127.0.0.1				REJECT forged account
10.11.32.55				OK
</pre>

<pre class="command-line">
/usr/local/sbin/postmap /etc/postfix-inbound/recipient_access
/usr/local/sbin/postmulti -i postfix-inbound -p reload
</pre>


#### Start and Reload

Normally, we would need to enable the postfix-inbound instance
with the following command

<pre class="command-line">
/usr/local/sbin/postmulti -i postfix-inbound -e enable
</pre>

which would make at least the following addition to the main.cf
file.

<pre class="config-file">
multi_instance_enable = yes
</pre>

and we can start using the below command.

<pre class="command-line">
/usr/local/sbin/postmulti -i postfix-inbound -p start
</pre>

#### Unknown Cost/Value

The **reject_unverified_sender** is another anti-spam feature that will reject
a large number of UCE, but at a cost that needs to be verified before 
enabled in your configuration.

<pre class="manpage">	 
reject_unverified_sender
</pre>

### <a name="outbound"></a> Outbound Instance

Use submission port instead of smtp, and enable
smtp for localhost.

<pre class="command-line">
/usr/local/sbin/postmulti -I postfix-outbound -G mta -e create
</pre>

Creates the postfix-outbound instance with the following initial 
settings, customised.

File excerpt: /etc/postfix-outbound/main.cf

<pre class="config-file">
queue_directory = /var/spool/postfix-outbound
data_directory = /var/postfix-outbound

# -- initially created by postmulti 
#    the first 2 tuned before starting
master_service_disable = 
authorized_submit_users = root
multi_instance_group = mta
multi_instance_name = postfix-outbound
multi_instance_enable = yes

# -- Customisations for our configuration
message_size     = 20480000

mynetworks       = $config_directory/mynetworks

# -- No Local Delivery
mydestination    =
alias_maps       =
alias_database   =
local_recipient_maps =
local_transport  = error:5.1.1 Mailbox unavailable
</pre>

File excerpt: /etc/postfix-outbound/master.cf

<pre class="config-file">
#smtp	        inet	n	-	-	-	-	smtpd
submission	    inet	n	-	-	-	-	smtpd
</pre>

The submission port (587) differs from the smtp (25)
but simplifies our configuration. For the Outbound
configuration (no filtering.).

#### Incorporate chroot files

Incorporate custom configuration settings involved with
OpenBSD's default chroot installation

<pre class="command-line">
/usr/local/sbin/postfix -c /etc/postfix-outbound check
export SUBDIR="etc usr lib"
export SRC=/var/spool/postfix
export DST=/var/spool/postfix-outbound
for subdir in $SUBDIR; do
	if [ -d $SRC/$subdir ]; then
		cp -pR $SRC/$subdir $DST
	fi
done
</pre>

#### Trusted SMTP Hosts

File excerpt: /etc/postfix-outbound/mynetworks

<pre class="config-file">
# List ip-addresses of hosts in your network you trust
# - in our context: either the [Mail Server] or [Internal Firewall]
# - or both
</pre>


#### Start and Reload

Normally, we would need to enable the postfix-outbound instance
with the following command

<pre class="command-line">
/usr/local/sbin/postmulti -i postfix-outbound -e enable
</pre>

which would make at least the following addition to the main.cf
file.

<pre class="config-file">
multi_instance_enable = yes
</pre>

and we can start|reload using the below command.

<pre class="command-line">
/usr/local/sbin/postmulti -i postfix-outbound -p start
</pre>

### <a name="log"></a> 5. Logs

Do not forget to add the new postfix logs to $!manpage("newsyslog")!$

We should have a line in /etc/rc.conf.local with at least the following:

<pre class="config-file">
syslogd_flag="-a /var/spool/postfix/dev/log -a /var/spool/postfix-inbound/dev/log -a /var/spool/postfix-outbound/dev/log"
</pre>

### <a name="verify"></a> 6. Verification

You can test, verify, behaviour of the above options by using the <b>warn_if_reject</b>
to increase verbosity in your log file.

<pre class="manpage">
	<b>warn_if_reject</b>
	
	Change the meaning of the next restriction, so that it logs a warning instead of rejecting
	a request (look for logfile records that contain "reject_warning"). This is useful for
	testing new restrictions in a "live" environment without risking unnecessary loss of mail. 
</pre>

### <a name="monitor"></a> 7. Monitoring

use [postmulti](#) to monitor the status of running services. Postmulti makes it easier
to review all running instances, or individual instances.

For example:

Instead of using [mailq](#) to look at the mail queue, you would use

To view all instances

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/postmulti -x mailq
<!--(end)-->

or to see the mailq for a a specific postfix instance

<!--(block|syntax("bash"))-->
$ sudo /usr/local/sbin/postmulti -i postfix-inbound -x mailq
<!--(end)-->

