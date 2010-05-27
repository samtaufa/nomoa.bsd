## Configuration Management

<div style="float:right">

The strategy for this Configuration Management involves.

-   Client - Archiving Configuration Files at a host
-   Server - Aggregating the above files to a 'central' host
-   Building a Restoration System

</div>

Many tools exist for Configuration Management. 

This document discusses a simple(?) system of archiving OpenBSD 
configuration files (such as stored in /etc) and the mechanisms 
to rebuild the host.

Expediting the restoration of a failed host begins with a minimal
set of requirements.

Principally, restoring a host will either be to the same host
(e.g. component failure is replaced) or very similar hardware
configuration.

<img src='@!urlTo("media/images/sync_general.png")!@'>

To simplify things, maintain a build document for your hosts that 
will record the following minimal information:

<table>
    <tr>
        <td>Item</td>
        <td>Sample</td>
        <td>Description</td>
    </tr>
    <tr>
        <td>Hostname</td>
        <td>jasper | mailserver | volcanoe</td>
        <td>Host Name - for posterity and for use in the archiving/restoration process</td>
    </tr>
    <tr>
        <td>Machine</td>
        <td>i386 | AMD64</td>
        <td>Machine Architecture</td>
    </tr>
    <tr>
        <td>OS Revision</td>
        <td>4.0 | 5.1</td>
        <td>Version of OpenBSD installed</td>
    </tr>
    <tr>
        <td>HDDs</td>
        <td>1 | 2</td>
        <td>Physical HDD's installed on Host</td>
    </tr>
    <tr>
        <td>HDD Types</td>
        <td>ATA | SATA | SCSI</td>
        <td>HDD Connectors</td>
    </tr>
    <tr>
        <td>HDD Partitions</td>
        <td>&nbsp;</td>
        <td>HDD Partitioning Deployed
            <table>
                <tr><td>Slice</td>
                    <td>Size</td>
                    <td>FS Type</td>
                    <td>Mount Point</td>
                </tr>
                <tr><td>a</td>
                    <td>5 G</td>
                    <td>4.2BSD</td>
                    <td>/</td>
                </tr>
                <tr><td>b</td>
                    <td>2 G</td>
                    <td>(swap)</td>
                    <td>&nbsp;</td>
                </tr>
                <tr><td>c</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr><td>d</td>
                    <td>10 G</td>
                    <td>4.2BSD</td>
                    <td>/usr</td>
                </tr>
                <tr><td>e</td>
                    <td>10 G</td>
                    <td>4.2BSD</td>
                    <td>/home</td>
                </tr>
                <tr><td>f</td>
                    <td>5G</td>
                    <td>4.2BSD</td>
                    <td>/tmp</td>
                </tr>
                <tr><td>g</td>
                    <td>20G</td>
                    <td>4.2BSD</td>
                    <td>/var/log</td>
                </tr>
                <tr><td>h</td>
                    <td>*</td>
                    <td>4.2BSD</td>
                    <td>/var</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>NIC</td>
        <td>em0, bge0 | fxp0, em0</td>
        <td>Network Interface Devices (specify which connections are on which device)</td>
    </tr>
    <tr>
        <td>Applications</td>
        <td>bzip2, jack's piece </td>
        <td>Installed Applications, good for monitoring published vulnerabilities</td>
    </tr>
</table>

The syncback toolset involves a client and control host components.

### Client - Archiving Configuration Files at a host

Standard <a href="config/client.html">scripts on the client</a> 
provide snapshots of the client configuration retaining:

*   system information
*   configuration files
*   installed packages
*   custom tools (not installed by ports collection packages)
*   custom restoration script


### Server - Aggregating the above files to a 'central' host

The Central Server Host aggregates client configuration archives.

Aggregating to a separate hosts allows a number of things to be
done with that data:

* Sanity Check: 
    Compare changes in configuration from a 'sane' master   
* Restore ISO.