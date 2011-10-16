## Building from Source

Everything's in the <a href="http://www.openbsd.org/faq/faq5.html">
FAQ - 5 Building the System from Source</a>, these are corruptions
of those fine notes I maintain for a localised interpretation.

<div class="toc">

Table of Contents

<ol>
    <li> Grab the Source</li>
    <li> Build the Kernel</li>
    <li> Build Userland</li>
    <li> Build Xenocara</li>
</ol>

</div>      
    
### Grab the Source

If you are maintaining multiple releases of OpenBSD, then the 
question you may need to consider is which version you are going
to follow:

- current: no tag
- stable: tagged (OPENBSD_X_Y)

Where X_Y is the release version such as 4_2 3_5 or 5_0.
In our environment, we use a central cvs, using cvsync and from
this local repository distribute to the various build hosts.

<!--(block|syntax("bash"))-->
for subdir in src ports xenocara; do
    cd /usr/${subdir};
    cvs update -Pd &
done
<!--(end)-->

### Prepping for Offline Distribution

If we want to release source in a distribution then we can use cvs
for a special export such as:

<!--(block|syntax("bash"))-->
USERNAME=samt
HOSTNAME=fw
DIRECTORY=/var/cvs
SRCDISTRIB=/usr/src-distrib
#SRCLIST="ports src xenocara"
SRCLIST="ports"
BUILDVER="OPENBSD_4_4"

export CVSROOT=${USERNAME}@${HOSTNAME}:${DIRECTORY}
mkdir -p ${SRCDISTRIB}
cd ${SRCDISTRIB}

for SRC in ${SRCLIST}; do
        cvs -d${CVSROOT} -q export -r${BUILDVER} -d ${SRC} ${SRC};
done

<!--(end)-->

### Building the Kernel

<!--(block|syntax("bash"))-->
#!/bin/sh
ARCH=amd64

cd /usr/src/sys/arch/${ARCH}/conf
config GENERIC
cd ../compile/GENERIC
make clean &amp;&amp; make depend &amp;&amp; make
make install
<!--(end)-->

### Building Userland

<pre class="command-line">
#!/bin/sh
rm -rf /usr/obj/*
cd /usr/src
make obj
cd /usr/src/etc &amp;&amp; env DESTDIR=/ make distrib-dirs
cd /usr/src
make build
</pre>


### Building a Release

For OpenBSD 4.4 and earlier
<pre class="command-line">
#!/bin/ksh
cd /usr/src/distrib/crunch &amp;&amp; make obj depend all install
</pre>

Rest of the Build Process
<pre class="command-line">
#!/bin/ksh
export DESTDIR=/usr/dest
export RELEASEDIR=/usr/rel

# clear DESTDIR
test -d ${DESTDIR} &amp;&amp; mv ${DESTDIR} ${DESTDIR}.old &amp;&amp; rm -rf ${DESTDIR}.old &
mkdir -p ${DESTDIR} ${RELEASEDIR}

# make the release
cd /usr/src/etc
make release

# verify distribution set
cd /usr/src/distrib/sets
sh checkflist

</pre>

### Xenocara

#### Build Userland

<pre class="command-line">
cd /usr/xenocara
rm -rf /usr/xobj/*
make bootstrap
make obj
make build
</pre>

#### Make Release

<pre class="command-line">
export DESTDIR=/usr/xen-dest
export RELEASEDIR=/usr/xen-rel
test -d ${DESTDIR} &amp;&amp; mv ${DESTDIR} ${DESTDIR}- &amp;&amp; \
     rm -rf ${DESTDIR}- &amp;
mkdir -p ${DESTDIR} ${RELEASEDIR}
make release
</pre>

<!--( block | syntax("bash") )-->
$!showsrc("toolkit/build/mkopenbsd.sh")!$
<!--(end)-->