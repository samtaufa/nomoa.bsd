Validating a firewall configuration involves tests on a number of areas
such as a fundamental review the firewall ruleset, performance throughput,
and validation that traffic flows as expected (and where possible prevented
where expected.)

<ul>
    <li>Firewall Ruleset Review
        <ul>
            <li>pfctl
        </ul>
    </li>
    <li> Performance / Throughput
        <ul>
            <li>tcpbench from base
            <li> tcpblast from ports/benchmarks
        </ul>
    </li>
    <li>Traffic Flow
        <ul>
            <li> netcat from base
            <li> route, arp tables
            <li>tcpdump
                <ul>
                    <li> pflog0
                    <li> Interface/CARP-in
                    <li> Interface/CARP-out
                    <li> source host
                    <li> destination host
                </ul>
            </li>
        </ul>
    <li> nmap from ports/net
</ul>

