# bash2.0

Some more advanced BASH scripts which I have written to assist me:

1. dumptool.sh - a tool to extract information from large sized "tcpdump" logs, which looks like this:


00:24:45.605000 IP 10.0.84.140.10588 > 10.100.0.83.2424: UDP, length 49

00:24:46.579000 IP 10.0.19.2.3950 > 10.100.0.115.2424: UDP, length 181

00:24:47.483000 IP 10.0.64.140.8588 > 10.100.0.116.2424: UDP, length 919

00:24:48.452000 IP 10.0.30.236.5284 > 10.100.0.178.2424: UDP, length 405

00:24:48.880000 IP 10.0.77.150.9898 > 10.100.0.146.2424: UDP, length 1023

00:24:49.710000 IP 10.0.101.82.12230 > 10.100.0.53.2424: UDP, length 615


and can represent the information the following way:

 * Top 10 servers receiving the most packets
    Showing the amount of packets received by each

  * Percentage of "small packets" (maximum 512 bytes)

  * Percentage of "large packets" (over 512 bytes)

  * Top 10 clients sending the most bytes
    Showing the IP address and the number of bytes sent for each
