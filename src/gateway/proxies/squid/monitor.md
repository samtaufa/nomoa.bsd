# Monitoring and Performance Questions

Where can we go to investigate status and performance issues
with respect to Squid ?


## DNS

Make sure that your DNS service is responding quickly/effectively,
the speed of your DNS service will impact the performance of
Squid.

## Access

<!--(block|syntax("bash"))-->
# tail -f /var/squid/logs/access | awk '{ print $3" "$4" "$8" "$7 }'
<!--(end)-->

## Login Class

[Ref: $!manpage("login.conf")!$]

<!--(block|syntax("bash"))-->
userinfo _squid
<!--(end)-->
<pre class="screen-output">
login    _squid
passwd   *****************
uid      515
groups   _squid
change   NEVER
class    daemon
gecos    Squid Account
dir      /nonexistent
shell    /sbin/nologin
expire   NEVER
</pre>


The login-class (/etc/login.conf)

Key attributes:

<!--(block|syntax("squid"))-->
default:\
	:path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/
	:openfiles-cur=XXX:\
	:openfiles-max=XXX:\
	
daemon:\
	:ignorenologin:\
	:datasize=infinity:\
	:maxproc=infinity:\
	:openfiles-cur=128:\
	:stacksize-cur=8M:\
	:localcipher=blowfish,8:\
	:tc=default
<!--(end)-->

Whenever you make changes $!manpage("cap_mkdb")!$

<!--(block|syntax("bash"))-->
cap_mkdb /etc/login.conf
<!--(end)-->


## Memory Configuration

<!--(block|syntax("bash"))-->
<!--(end)-->

## File Descriptors

[Ref: cache.log]

<!--(block|syntax("bash"))-->
grep WARNING /var/squid/logs/cache.log
<!--(end)-->
<pre class="screen-output">
YYYY/MM/DD HH:MM:SS| WARNING: Your cache is running out of filedescriptors
</pre>

<!--(block|syntax("bash"))-->
ulimit -a
<!--(end)-->
<pre class="screen-output">
time(cpu-seconds)     unlimited
file(blocks)          unlimited
coredump(blocks)      unlimited
data(kbytes)          2097152
stack(kbytes)         8192
lockedmem(kbytes)     296673
memory(kbytes)        887008
nofiles(descripters)  128
processes             1310
</pre>


More simply

<!--(block|syntax("bash"))-->
ulimit -n
<!--(end)-->
<pre class="screen-output">
128
</pre>

