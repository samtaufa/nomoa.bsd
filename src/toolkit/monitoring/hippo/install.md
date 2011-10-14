## Install

Some early notes, while we're developing it.

Toolkit: [hippo](http://github.com/cortesi/hippo)

Dependencies: 

1. 	[Git](http://git-scm.com) v1.7.1 or later
2.	[GitPython](http://gitorious.org/git-python) v0.3 or later
	- [distribute](http://packages.python.org/distribute)
	- [gitdb](http://pypi.python.org/packages/source/g/gitdb/gitdb-0.5.2.tar.gz)
	- [async](http://pypi.python.org/packages/source/a/async/async-0.6.1.tar.gz)

To simpify distribution to multiple hosts, use packages, or build
python packages.

### [distribute](http://packages.python.org/distribute)

<pre class="command-line">
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py
</pre>

For easy distribution, onto multiple hosts

<pre class="command-line">
tar -zxvpf distribute-0.6.14.tgz
cd distribute-0.6.14
python setup.py install
easy_install pip
</pre>

You can copy the distribute-X.Y.tgz to new hosts for installation.

Other dependencies for git-python include:

-	[async](http://gitorious.org/git-python/async)
-	

#### [async](http://gitorious.org/git-python/async)

<pre class="command-line">

</pre>

### [GitPython](http://gitorious.org/git-python) v0.3 or later

<pre class="command-line">
cd ~/src/
git clone git://gitourious.org/git-python/mainline.git git-python
cd git-python
python setup.py bdist_egg
easy_install dist/GitPython-X.Y.Z-py2.X.egg
</pre>

You can copy the GitPython EGG to hosts for installation.



### [Git](http://git-scm.com) v1.7.1 or later

Install it from ports (OpenBSD 4.8 or later)

### [hippo](http://github.com/cortesi/hippo)

<!--(block | syntax("bash") )-->
cd ~/src
git clone git://github.com/cortesi/hippo
cd hippo
<!--(end)-->
