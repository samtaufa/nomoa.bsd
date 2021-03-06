## Before you Install


&#91;Ref: 

-   [FAQ 4 - Installation Guide](http://www.openbsd.org/faq/faq4.html) |
-   [For People New to Both FreeBSD and Unix](http://andrsn.stanford.edu/FreeBSD/newuser.html) |
-   [The Goodness of Men and Machinery](http://bsdly.blogspot.com/2010/01/goodness-of-men-and-machinery.html) |
-   [Remote Simple Installation of OBSD 4.6](http://www.openbsd101.com/installation.html)

There is an abundance of documentation from the Project on
installing OpenBSD.

-   INSTALL.${ARCH} for each "ARCHI"tecture: examples, at /pub/OpenBSD/4.7/$ARCH/INSTALL.$ARCH

<ul>
    <ul>
        <li><a href="http://mirror.internode.on.net/pub/OpenBSD/4.7/i386/INSTALL.i386">INSTALL.i386</a> or</li> 
        <li><a href="http://mirror.internode.on.net/pub/OpenBSD/4.7/amd64/INSTALL.amd64">INSTALL.amd64</a></li>
    </ul>
</ul>
    
-   [FAQ 4 - Installation Guide](http://www.openbsd.org/faq/faq4.html) 
-   Glossy Print. Buy the CD.

The installation instructions that comes with OpenBSD is 
straight forward. Buy the CD the instructions for a colourful 
CD sleeve. If you've downloaded the files from the
Internet then read the <i>INSTALL</i>.<i><font color="#0000ff">$ARCH</font></i>
file (for example if you are installing it on an Intel class machine,
then the file to read is INSTALL.i386)

When you're too lazy to load the above files and read it, then click
onto Google and do a search for sample installations (with screenshots)
such as:

-   [The Goodness of Men and Machinery](
http://bsdly.blogspot.com/2010/01/goodness-of-men-and-machinery.html)
-   [Remote Simple Installation of OBSD 4.6](
http://www.openbsd101.com/installation.html)

Outlined here are installation items likely to be
helpful for someone new to OS installations or has come from another
Unix. For those really new to Unix I suggest you read the complete
section you are interested in before attempting to follow the
instructions.

<b>Warning</b>: If you are not familiar with using the vi text
editor, learn. It is installed with the base installation of
OpenBSD and although your favourite editor might be another few
command-lines away, it is always useful to be able to administer
your box (or someone else's) without having to install further
tools on the machine.

Many administration tasks in Unix revolve around editing text files.

There is a real nice introductory, short, tutorial 
[For People New to Both FreeBSD and Unix](http://andrsn.stanford.edu/FreeBSD/newuser.html)
You should at least read through the tutorial for a guide to what you
will do here (and reference.)

For the 1st time installer, I suggest either installing from a CD or
by downloading the main installation files onto a local network machine
or local hard-disk. Of course you can burn your own CD after
downloading. Current OpenBSD mirrors will also have an install*$version*.iso
that can be burned to a CD for installation.

### 1st Timer

For the 1st Time investigation into installing OpenBSD, you
may be more interested in the general things a new user
might come across, such as those previewed in [First
Time Installer](preview/first.html) and related topics always relevant when
you don't have the equipment, but wish to make some initial
installation investigations:

-   [First Time Installer](preview/first.html)
-   [Dual Booting](preview/multiboot.html)
-   [Start Up](preview/rc.conf.html) - 
    specifying what starts with the machine


The thing to remember, is to enjoy the new experience, and
where possible, __dig__ in and learn some more about the
environment (whether it is the base Operating System, a specific
tool you're using, or the hardware.)

### Build Consistency

Build consistency assumes a decent level of experience with 
the operating system and services being installed. In this 
section of the notes are some basic installation
issues surrounding a new OpenBSD install.


-   [Hardware tests](preview/hardware.html)
-   [Encrypting Partitions](preview/cryptpart.html)

