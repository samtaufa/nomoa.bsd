$!manpage("pfctl",8)!$  control the packet filter (PF) device

<pre class="screen-output">
NAME
     pfctl - control the packet filter (PF) device

SYNOPSIS
     pfctl [-deghmnqrvz] [-a anchor] [-D macro= value] [-F modifier] [-f file]
     [-i interface] [-K host | network] [-k host | network | label | id] [-L
     statefile] [-o level] [-p device] [-S statefile] [-s modifier] [-t table
     -T command [address ...]] [-x level]

DESCRIPTION
     The pfctl utility communicates with the packet filter device using the
     ioctl interface described in $!manpage("pf",4)!$ .  It allows ruleset and parameter
     configuration and retrieval of status information from the packet filter.
     
</pre>

## pfctl samples

After boot, PF operation can be managed using the pfctl(8) program. Some example commands are: 

<pre class="command-line">
# pfctl -f /etc/pf.conf     Load the pf.conf file
# pfctl -nf /etc/pf.conf    Parse the file, but don't load it
# pfctl -Nf /etc/pf.conf    Load only the NAT rules from the file
# pfctl -Rf /etc/pf.conf    Load only the filter rules from the file

# pfctl -sn                 Show the current NAT rules 
# pfctl -sr                 Show the current filter rules
# pfctl -ss                 Show the current state table
# pfctl -si                 Show filter stats and counters
# pfctl -sa                 Show EVERYTHING it can show
</pre>


### Tables

Some sample Tables related commands

<pre class="command-line">
# pfctl -s Tables                   Show Tables
# pfctl -Tshow -t table-name        Display entries in table 'table-name'
# pfctl -Tshow -vt table-name       Display table counters for 'table-name'
# pfctl --vs Tables                 Display global information
</pre>

## Show more details

To get more detailed usage data for each show values option, pfctl can be invoked with the "-v" (verbose) option. The following example shows how to get detailed usage data for each firewall rule:

<pre class="command-line">
% sudo pfctl -v -s rules
</pre>
<pre class="screen-output">
scrub in all no-df fragment reassemble
  [ Evaluations: 373620187  Packets: 179290329  Bytes: 45895535624  States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
scrub out all no-df fragment reassemble
  [ Evaluations: 194329858  Packets: 194329858  Bytes: 58848165945  States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
block drop in log on ! lo0 inet from 127.0.0.0/8 to any
  [ Evaluations: 2934066   Packets: 0         Bytes: 0           States: 0     ]
  [ Inserted: uid 0 pid 24100 ]
</pre>

### Killing State

When refreshing firewall rules, you can kill state information 
by explicitly using the "-k | -K" pfctl option.

<pre class="screen-output">
     -K host | network
             Kill all of the source tracking entries originating from the
             specified host or network.  A second -K host or -K network option
             may be specified, which will kill all the source tracking entries
             from the first host/network to the second.

     -k host | network | label | id
             Kill all of the state entries matching the specified host,
             network, label, or id.

             For example, to kill all of the state entries originating from
             ``host'':

                   # pfctl -k host

             A second -k host or -k network option may be specified, which
             will kill all the state entries from the first host/network to
             the second.  To kill all of the state entries from ``host1'' to
             ``host2'':

                   # pfctl -k host1 -k host2

             To kill all states originating from 192.168.1.0/24 to
             172.16.0.0/16:

                   # pfctl -k 192.168.1.0/24 -k 172.16.0.0/16

             A network prefix length of 0 can be used as a wildcard.  To kill
             all states with the target ``host2'':

                   # pfctl -k 0.0.0.0/0 -k host2

             It is also possible to kill states by rule label or state ID.  In
             this mode the first -k argument is used to specify the type of
             the second argument.  The following command would kill all states
             that have been created from rules carrying the label ``foobar'':

                   # pfctl -k label -k foobar

             To kill one specific state by its unique state ID (as shown by
             pfctl -s state -vv), use the id modifier and as a second argument
             the state ID and optional creator ID.  To kill a state with ID
             4823e84500000003 use:

                   # pfctl -k id -k 4823e84500000003

             To kill a state with ID 4823e84500000018 created from a backup
             firewall with hostid 00000002 use:

                   # pfctl -k id -k 4823e84500000018/2
</pre>

