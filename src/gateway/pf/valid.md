## Test Environment

The test environment provides a secure environment for validating
presumptions of traffic flow behaviour encapsulated in our Policy 
and subsequent firewall ruleset.

Test conditions should provide checklists and methodologies for
subsequent verification of the firewall in the live environment.

The base test environment, as pictured below minimises a number of 
network routing issues that can occur when testing your new
firewall rules while the test firewall is connected to your live
network.

<div style="text-align: center">
    $!Image("fw/fw_flow_lab.png", title="Firewall - Traffic Flow")!$
</div>

?????

-   Clear routes, arp state
-   Inspect PFE states (refer pfctl notes)
-   Inspect Traffic Flow (refer flow notes)
-   Writing Tests (in these notes)
-   Verify Performance

?????

Our test/validation strategy involves securing an environment to verify our 
Policy and subsequent ruleset interpretation.

The rest of these notes covers these strategies.

-   Using pfctl to parse and inspect PFE states
-   Using tcpdump to inspect traffic flow
-   Using other tools to inject traffic

The test environment is generally as in the below diagram.

### Writing Tests

Tests are gleaned from the proposed firewall rules, as moving betweeen 
rule symantics into flow semantics.

from ruleset: 
<pre class="config-file">
pass in on $int_if inet proto tcp from &lt;lan> to any
pass out on $ext_if
</pre>

evolves to flow routes

<pre class="screen-output">
&lt;lan> to dmz {tcp}
&lt;lan> to inet {tcp}
</pre>

The firewall/gateways should remain essentially static during the test
and various changes will be needed on the Internal and External hosts
to simulate the appropriate IP Addresses to validate the rulesets

During IP Address and routing changes on the hosts, ensure route states
are cleared (or the hosts restarted) to minimise errors caused by
stagnant routing information.
