
## Hardware Tests

<div style="float:right">

    <ul>
        <li><a href="#memory">Memory</a>: memtest86, memtest++, memtester
        <li><a href="#general">General</a>: stress
        <li><a href="#storage">Storage</a>: bonnie++
        <li><a href="#network">Network</a>: tcpbench, tcpblast, iperf
    </ul>

</div>

Because you can never know when you've been delivered a dud (broken)
machine and because having the hardware fail while testing is better
than the hardware failing in production.

Invariably, the use of commodity hardware may not deliver at the 
critical points of deployment. It's in your best interests to 'burn-in' 
the basic hardware with a standard sequence of performance tests, 
as well as to develop some performance tests that targets the system
configuration of your proposed system.

For example: if building a firewall, then include a performance test between
the separate network segments to ensure at least some minimal performance
is achievable.

<a name="memory"></a>

### Memory

Discussions on the Mailing Lists indicate generic RAM tests tools are inadequate 
to qualify a machine's RAM. An accepted stress/performance tool for RAM
is a full compile of the operating system.

[ ports: sysutils/memtest86 ]

- i386 specific

[ ports: sysutils/<a href="http://pyropus.ca/software/memtester/">memtester</a> ]

<blockquote>
    <strong>memtester</strong> memory-size [ iterations ]

    _Memory-size_ is the amount of memory memtester 
    will allocate and test per iteration.

    _Iterations_ is optional, and leaving it out 
    is equivalent to setting iterations to infinite
    
    ...
    
    memtester will malloc(3) the amount of memory specified,
    if possible. If this fails, it will decrease the amount
    of memory requested until it succeeds. It will then
    attempt to mlock(3) this memory; if it cannot do so,
    testing will be slower and less effective.
</blockquote>

For example:

<pre class="command-line">
memtester 512
</pre>
<pre class="screen-output">
memtester version 4.0.8 (64-bit)
Copyright (c) 2007 Charles Cazabon.
</pre>

<pre class="screen-output">
EXIT CODE
    memtester's exit code is 0 when everything works properly.
    Otherwise, it is the logical OR of the following values:
    
    x01     error allocating or locking memory, or invocation
            error
            
    x02     error during stuck address tests
    
    x04     error during one of the other tests
</pre>

To view the exit code, immediately after the memtester program
execuation:

<pre class="command-line">
echo $?
</pre>

<a name="general"></a>

### General System Testing

[ ports:benchmarks/stress ]

<a href="http://weather.ou.edu/~apw/projects/stress/">Example</a>

Here is an example invocation: a load average of four is imposed on the 
system by specifying two CPU-bound processes, one I/O-bound process, and one memory allocator process.

<pre class="command-line">
$ stress --cpu 2 --io 1 --vm 1 --vm-bytes 128M \
    --timeout 10s --verbose
</pre><pre class="screen-output">
   stress: info: [9372] dispatching hogs: 2 cpu, 1 io, 1 vm, 0 hdd
   stress: dbug: [9372] (243) using backoff sleep of 12000us
   stress: dbug: [9372] (262) setting timeout to 10s
   stress: dbug: [9372] (285) --> hogcpu worker 9373 forked
   stress: dbug: [9372] (305) --> hogio worker 9374 forked
   stress: dbug: [9372] (325) --> hogvm worker 9375 forked
   stress: dbug: [9372] (243) using backoff sleep of 3000us
   stress: dbug: [9372] (262) setting timeout to 10s
   stress: dbug: [9372] (285) --> hogcpu worker 9376 forked
   stress: dbug: [9375] (466) hogvm worker malloced 134217728 bytes
   stress: dbug: [9372] (382) <-- worker 9374 signalled normally
   stress: dbug: [9372] (382) <-- worker 9373 signalled normally
   stress: dbug: [9372] (382) <-- worker 9375 signalled normally
   stress: dbug: [9372] (382) <-- worker 9376 signalled normally
   stress: info: [9372] successful run completed in 10s
</pre>

<pre class="command-line">
$ stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --hdd 2 \
    --hdd-bytes 1G --verbose
</pre>

For more options read the stress <a href="http://weather.ou.edu/~apw/projects/stress/FAQ">FAQ.</a>

<a name="storage"></a>

### Storage

[ ports: benchmarks/bonnie++ ]

<pre class="command-line">
bonnie++ -s 1G -n 20 -u root 
</pre>
<pre class="screen-output">
Using uid:0, gid:0.
Writing with putc() ...
</pre>

-s memory-size : should be twice available RAM

<a name="network"></a>

### Network Interface with tcpbench, tcpblast, iperf

#### netstat

[ base ]

Use netstat to watch the packets, reviewing Input and Output errors.

<pre class="command-line">
$ netstat -i | grep -v "^lo" | grep -v "Link" \
    | awk '{ print $1"\t"$3"\t"$5"\t"$6"\t"$7"\t"$8 }' 
</pre>

#### tcpbench

[ base ]

<blockquote>
tcpbench(1) is a small tool that performs throughput benchmarking and con-
current sampling of kernel network variables.

tcpbench is run as a client/server pair.  The server must be invoked with
the -s flag, which will cause it to listen for incoming connections.  The
client must be invoked with the hostname of a listening server to connect
to.
</blockquote>

On the Server
<pre class="command-line">
# tcpbench -s -v -p 12345
</pre>

On clients
<pre class="command-line">
# tcpbench -p 12345 SERVERIP
</pre>

#### iperf

<a href="">iperf</a> is a tool for measuring maximum TCP and UDP bandwidth, reminiscent
of ttcp and nettest. It has been written to overcome the shortcomings of
those aging tools.

Iperf allows the user to set various parameters that can be used for testing a network, or 
alternately for optimizing or tuning a network. Iperf has a client and server functionality, 
and can measure the throughput between the two ends, either unidirectonally or bi-directionally. 
It is open source software and runs on various platforms including Linux, Unix and Windows.
It is supported by the National Laboratory for Applied Network Research.


On the Server
<pre class="command-line">
# iperf -s
</pre>

On clients
<pre class="command-line">
# iperf -i 1 -t 30 -c serverhostname    
</pre>

