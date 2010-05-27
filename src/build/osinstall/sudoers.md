## Configuring Sudo Privileges

[ref: $!manpage("sudo",8)!$, $!manpage("sudoers",5)!$ ]

There are two elements to modifying the /etc/sudoers configuration file.

* Make the changes as 'root' user
* Test the changes before you exit the root user account

Fail to follow the above warning and you may render your remote machine unmaintainable. (i.e. I've failed to follow the above precautions and summarily lost
access to the servers)
### Edit using visudo

There's a reason they built 'visudo', use it 

### Preview

Grep /etc/sudoers file for a quick overview of sudo's current configuration.

<pre class="command-line">
$ sudo grep -v "^#" /etc/sudoers  | grep -v "^$" | grep -v "^Defaults"
</pre>

<pre class="screen-output">
root    ALL=(ALL) SETENV: ALL
%wheel  ALL=(ALL) NOPASSWD: SETENV: ALL
</pre>

Checked the sudoers file to note who/which groups have access privileges. 
If the data is a worry, look at what may be wrong.