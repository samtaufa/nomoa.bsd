# Blocking Instant Messaging, Skype

My primary purpose, is to block general access to Skype and Instant 
Messaging, because they are out of context for our organisation
provisioned services. Came across the WWW howtos, and did something slightly differently
(aggregating what knowledge is out there) so I'm recording it here
so I can readily get at the information for other squid installs
I deploy.

Skype, and other Instant Mesaging (IM) clients, make it their business
to circumvent Proxies so they can reach as many clients as possible
(even if you don't want those clients connecting through the 
Internet.) Some of the methods used by IMs you can block using
Squid, providing you have broad controls of how your internal
users gain access to the Internet.

If all Internet access is proxied by one service or another, then
you are in a good position for successfully blocking IMs.

There are generally 3 different ways that you can identify Instant
Message clients.

-	The Domain Name's they are trying to contact
-	The Browser Id they use
-	The method of connection

## Domain Name

Most clients will initially attempt to connect to their parent/central
host by the hosts' domain name. Such as:

-	skype.com
-	messenger.live.com

With the above case, we can begin the 1st layer of blocking IMs by
blocking access to the above domain names:

File Snippet: /etc/squid/squid.conf

<pre class="config-file">
acl block_im dstdom -i "/etc/squid/block_im.txt"

http_access deny block_im
</pre>

File snippet: /etc/squid/block_im dstdom

<pre class="config-file">
^skype\.com$
\.skype\.com$
^messenger\.live\.com$
\.messenger\.live\.com$
</pre>

Now, as we're using regular expressions, we are going to be explicit with
our domain names so as not to inadvertently block legitimate sites that
may have the same ending domain name.

Use "^" to specify DOM begins at this point, and explicitly specify a
"." by using "\." because "." by itself generally means "any character".

## Browser Identification

Not as useful, because remember as mentioned above the IM providers
don't want to be blocked, and have no obligation to make life easier
for you by telling us who they are.



## CONNECT and Numeric IPs

An avoidance method used by IM clients, and malware sites, is to:

-	use HTTPS to prevent casual viewing of their data
-   use the HTTPS CONNECT method to provide a real-time communications mechanism.
-	use Numeric IP addresses, to bypass standardfilters

In practise, port 443 is the "accepted" standard for HTTPS traffic,
so our first inclination is to not allow HTTPS traffic on any other
port.


The next step, as per above, is to identify connections to Numeric IP
Addresses, and explicitly deny use of the HTTPS CONNECT METHOD for these
addresses.