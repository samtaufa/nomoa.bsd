## How to use these Guides ?

As discussed in the [Site Directions](directions.html) these notes
are morphing (or evolving) from my own needs to record what I've
gone through, and make it possible for me to rebuild or reinstall
a configuration with OpenBSD. In this context, I have a few close
friends who find these notes [in]valuable(?) so I continue to review
the notes when possible.

-	Read It in the context of greater OpenBSD documentation
-	Do not copy / paste
-	Use a Test Environment/Network
-	Have Fun

I have tried to go back and add some minimal set of information with
each guide/note (such as version of OpenBSD it was installed with.)

If the guides help you, we're excited, if it doesn't and some correction
may make it better, please feel free to [contact us with corrections](
mailto:nomoabsd@gmail.com)

###	Read It in the context of greater OpenBSD documentation

These notes are not authoritative, and may mindlessly lead you wrong.
Use the notes where useful, but when you're done with it (or better
yet while you're using it) refer to the ['real' documentation](
http://www.openbsd.org/cgi-bin/man.cgi "OpenBSD Online manpages")

I've tried most of these notes on multiple installations, but 

-	that doesn't mean I actually got it right (stable, secure, etc.)
-	these hosts were either i386 (and more recently) amd64 and as
	such is a very limited test for the context of OpenBSD
	
And, it gets worse, some of these notes are just placeholders for
documentation in the works (and there's no real distinction between
what is tried, and what is 'in development')

### Do not copy / paste

I present a lot of sample command-line, scripts, configurations
but their intentions are not for copy / paste (well, actually they 
are, but that will only work in a few contexts)

Please, do not copy and paste. Use the samples as something that
may have worked for me, but always make sure that the material
is relevant for your intended host design.

If you want to copy/paste, then I suggest a test install with
these notes as a beginning to your own internal documentation.

### Use a Test Environment/Network

When we first began, much of the work had to be on the 'live' network
(even if the new service wasn't actually active.) For example,
since Postfix really needs a working DNS environment to 'behave'
the test install works a lot better whne the host can connect
to the Internet.

With the current low cost of refurbished/2nd hand hardware, there 
really is no excuse for performing a test install outside of a 
test network. Network switches come in all sizes, and cheap, and
if you're really lazy, then you can use Virtual Machines to 
set up your environment.

Routing issues are just too difficult to find when you're test
environment is using a 'faked' context, side-loading, on the 
actual network. Putting everything into a test environment 
really simplifies the different issues that can go wrong, because
you can reset the whole test environment.

Test Network ? Highly Recommended.

The only time I've used real server-grade hardware in my test
networks, is because that hardware was what I was building
for deployment (example the server itself, or switches in test.)
The rest of the hardware have been requisitioned (acquired)
desktop hardware from different areas.

OpenBSD works great on low-end equipment, use that flexibility
to build your test network and get another step closer to having
a well tested configuration **before deployment**

### Have Fun

When ever I talk with my kids about what they've learned at school,
they haven't learned anything. Everything that has really been ingrained
are things that they've enjoyed, had fun with, and want to share 
with everyone at home. If you're mildly twisted, then you might
be just right for enjoying the OpenBSD experience.

Otherwise, if you're mildly paranoid and hate "interfering auditors"
then installing it correctly might just let them go to the next check-point
quickly.