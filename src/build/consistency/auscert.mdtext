## Checklist - courtesy of AusCERT

Based on <a href="http://www.auscert.org.au/render.html?it=5816&template=1">AusCERT UNIX and Linux Security Checklist v3.0</a>
_current as of 2008.06_

There are various sections of the checklist dependent on Management practises, those are ignored and the specific host items are listed below.

### B. Installation

Incorporated into the build documentation

### C. Apply all Patches and Updates

Double edged sword, as there are no guarantees that post-release patches do not introduce further problems of their own.

Major releases historically seem to have had more man and machine resources provisioned for the testing cycle, and subsequently gain a broader 'verification' assessment on live customer sites. Patches, by their own release cycle do not gain the same level of testing and corner cases not tested during development can be the cause of serious damage for users.

* Assess each post-release patch for their potential impact on the purpose of a production machine, if a patch is appropriate then perform required tests before scheduling a patch, update.

### D. Minimise

Security through simplicity.

The foundation of border control is that only trusted users are allowed on the "wall." This minimal level of security is mandatory to securing services in a practical manner.

#### D.1 Minimise network services

* Locate services and remove or disable
* Minimise inetd/xinetd
* Minimise portmapper and RPC services
* Specific Services (
  remove "r" commands,
  remove fingerd,
  disable snmp daemon)

<a href="../audittools.html">Audit: </a> scanning all network interfaces

#### D.2 Disable all unnecessary startup scripts

<a href="../audittools.html">Audit: </a> scanning all network interfaces

#### D.3 Mimimise SetUID/SetGID programs

<a href="../audittools.html">Audit: </a> scanning all network interfaces

#### D. 4 Other minimisations


### E. Secure Base OS

#### E.1 Physical, console and boot security

Because the server is physically secured, the situation where physical access to the box is necessary generally implies an authorised user with a task that cannot be remotely completed.

Console access is required.

#### E.2 User Logons

Note when disabling accounts

* search for and remove all files owned by that UID (in case the UID gets reallocated to a new user)
* check that the account have no cron or at jobs
* use ps to check for and kill any processes running under that UID

##### E.2.2 Special Accounts

* Disable shared accounts, other than root.
* Disable guest accounts
* Disable vendor accounts
* Disable accounts with no password, and execute single commands (for example shutdown, or sync)
* Ensure non-functional login shells (such as /bin/false, /bin/nologin) are assigned to system accounts such as bin and daemon

##### E.2.3 Root Account

* Restrict number of people with root access
* No direct logins too root
* Secure terminal

##### E.2.4 PATH advice

* Check "." _current path_ is not in the path
* Ensure directories writable by users are not specified before system directories
* Specify absolute path-names when writing scripts and cron jobs
  >> explicitly specify path at beginning of each script
* use "/bin/su -"  to reset the environment when switching to a privileged user

##### E.2.5 User session controls

* Use disk-usage quotas
* Use resource limiting
* Configure autologout

#### E.3 Authentication

##### E.3.1 Password Authentication

* Evaluate two-factor authentication
* Shadow passwords
* Ensure all accounts have passwords or are disabled
* Password Policy (what is it, is it conformant?)
* Enforce password complexity
* Password ageing and password history (1 year?)

##### E.3.2 One-time passwords

##### E.3.3 PAM Pluggable Authentication Module

* Check it isn't misconfigured (deny access by default)
* Enforce password policy
* Enforce resource limits with PAM

##### E.3.4 NIS / NIS+

Kill all occurrences.

##### E.3.5 LDAP

N/A

#### E.4 Access Control

##### E.4.1 File Permissions

* check permissions for key files and directories
* protect programs run by root
* Ensure root's login files do not source any other files not owned by root or which are group world writable
* Check ~/.login, ~/.profile, ~/.bashrc, ~/.cshrc and similar shell initialization
* Check ~/.logout and similar session cleanup files
* Check program configuration files in home directory such as .vimrc and .exrc
* Check crontab and at entries
* Check /etc/rc* and similar startup and shutdown scripts
* Protect directories written by root
* Group membership
* Umask for users (077)
* Permissions for user home directories (0700)

##### E.4.2 Filesystem attributes

##### E.4.3 Role Based Access Control

##### E.4.4 sudo

#### E.5 Other

* Cron (verify root's crontab to 600)
* Configure nosuid,nodev,noexec for /home, /var, /tmp
* Turn on non-executable stack protection
* umask startup scripts as 022 or better
