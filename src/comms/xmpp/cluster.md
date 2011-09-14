## Realtime Communications - Clustered Servers

<div class="toc">

Table of Contents:

<ol>
	<li><a href="#cluster.cookies">Magic Cookies</a></li>
	<li><a href="#cluster.nodes">Nodes</a></li>
	<li><a href="#cluster.cleandb">Clean Database</a></li>
	<li><a href="#cluster.config">Node Configuration</a></li>
	<li><a href="#cluster.sync">Synchronise</a></li>
	<li><a href="#cluster.permissions">Permissions</a></li>			
</ol>

</div>

&#91;Ref: $!OpenBSD!$ 4.9, [ejabberd](http://www.process-one.net/en/ejabberd/)
 2.1.6, [XMPP](http://xmpp.org/about-xmpp/) | [Set up clustering in ejabberd](http://dev.esl.eu/blog/2008/09/30/set-up-clustering-in-ejabberd/) |
[Chapter 6 Clustering](http://www.process-one.net/docs/ejabberd/guide_en.html#htoc86)]

We have two sites where we want to have Realtime Communications. We want a separate
server at each site, but want to have the same accounts, administration
etc. 

-	*first* is the host name from */bin/hostname -s* on our primary node
-	*second* is the host name from */bin/hostname -s* on the secondary node

Install your [ejabberd](http://www.process-one.net/en/ejabberd/) *first* node, as per 
[Chat/XMPP](../xmpp.html) instructions, and install
the *second* node without configuring [user accounts](../xmpp.html#user.accounts),
access privileges since we will be taking that from the **first** node.

Make sure that the domain name used for **first** is resolvable at node **second**,
and likewise the domain name for **second** is resolvable at node **first**.

<a name="cluster.cookies"></a>

### Magic Cookies

&#91;Ref: [3.4 Distributed Programming](http://www.erlang.org/doc/getting_started/conc_prog.html)]

<blockquote>
Erlang systems which talk to each other must have the same <strong>magic cookie.</strong>
The easiest way to achieve this is by having a file called <em>.erlang.cookie</em> in you home
directory on all machines on which you are going to run Erlang systems communicating
with each other.
</blockquote>

Copy */var/db/ejabberd/.erlang.cookie* from the *first* node to replace the cookie in the
*second* node.

*/var/db/ejabberd* is the $!OpenBSD!$ Package default $HOME directory for the ejabberd server
user *_ejabberd*.

Keeping the cookie in the $HOME directory means that ejabberd on node *first* and *second* will
allow RPC between the two servers. When you need to run as root, with the same privileges, you
can specify the *-setcookie COOKIE-CONTENT*

<a name="cluster.nodes"></a>

### Nodes

<blockquote>
When you start an Erlang System which is going to talk to other Erlang systems,
you must give it a name.
</blockquote>

<!--(block|syntax("bash"))-->
erl -sname mynode
<!--(end)-->

*ejabberdctl* normally handles this for us, but as with the above $NAME definition
we can normally use the following as our node-name.

<pre class="command-line">
export EJHOME=/var/db/ejabberd
export NODE=ejabberd
export HOST=`hostname -s`
export NAME=${NODE}@${HOST}
</pre>

<a name="cluster.cleandb"></a>

### Second: Clean Database

We want to share the database from host *first* to host *second* so we clear out
our database configuration at host *second*.

On the *second* node:

<!--(block|syntax("bash"))-->
export EJHOME=/var/db/ejabberd
export NODE=ejabberd
export HOST=`hostname -s`
export NAME=${NODE}@${HOST}

rm -rf ${EJHOME}/${NODE}
<!--(end)-->

<a name="cluster.config"></a>

### Second: Node Configuration

On the *second* host, we need to make some configuration changes to connect
the server to the *first* host. From details in *ejabberdctl* we export the
following configurations:

<pre class="command-line">
export NAME=${NODE}@${HOST}
cd ${EJHOME}
</pre>

Start 

<!--(block|syntax("bash"))-->
# erl -sname $NAME -setcookie `cat ${EJHOME}/.erlang.cookie` \
    -mnesia dir '"/var/db/ejabberd/ejabberd"' \
	-mnesia extra_db_nodes "['ejabberd@first']" \
	-s mnesia
<!--(end)-->

This connects the current Erlang node to the Erlang node ejabberd@first and leaves you
in the *erl shell*. The database will be created in the *dir* path */var/db/ejabberd/ejabberd*.
We use this path, as it is the default SPOOLDIR used by */usr/local/sbin/ejabberdctl*

<pre class="screen-output">
Erlang R13B04 (erts-5.7.5) [source] [rq:1] [async-threads:0] [kernel-poll:false]

Eshell V5.7.5 (abort with ^G)
1> _
</pre>

If everything is working correctly, you should be able to see ejabberd@second as one of
the nodes in the web interface at http://first:5280/admin/nodes/

&#91;Ref: [mnesia:info().](http://www.erlang.org/doc/man/mnesia.html#info-0)]

Within this *erl shell* you can view some generic information about your current
database configuration using:

<pre class="command-line">
1> mnesia:info().
</pre>

The key output information we want to look at include:

<pre class="screen-output">
runnind db nodes   = [ejabberd@first, ejabberd@second]

% .. stuff left out ..

ram_copies         = [schema]
disc_copies        = []
</pre>

<a name="cluster.sync"></a>

### Synchronise Databases

<pre class="command-line">
2> mnesia:change_table_copy_type(schema, node(), disc_copies).
</pre>
<pre class="screen-output">
{atomic,ok}
</pre>
<pre class="command-line">
3> mnesia:info().
</pre>
<pre class="screen-output">
runnind db nodes   = [ejabberd@first, ejabberd@second]

% .. stuff left out ..

ram_copies         = []
disc_copies        = [schema]
</pre>

Alternatively, you can specify the synchronisation through the web interface,
by setting the Second Node's Database configuration for schema to be "**RAM and disc copy**"

The advantage, at this point, of reviewing the database tables at the Web Interface,
is getting a cleaner management view of the synchronisation settings for the tables.

Quit from Mnesia

<pre class="command-line">
4> q().
</pre>

The above quit may take some time depending on the database synchronisation changes you select.

<a name="cluster.permissions"></a>

### Permissions

Because we ran the erl command as root, we need to make sure that
the ejabberd user-account (**_ejabberd**) has all permissions to the
database directory.

<!--(block|syntax("bash"))-->
chown -R _ejabberd:_ejabberd /var/db/ejabberd/ejabberd
<!--(end)-->
