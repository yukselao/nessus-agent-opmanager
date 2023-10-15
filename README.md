About the project:
--
This project was developed to facilitate nessus agent installations and to facilitate problem solving related to agent management. It is an open source project that you cannot officially get support from Tenable.

Runtime Environment:
--

```
[root@tenable-5cfxx56r nessus-agent-opmanager]# cat /etc/redhat-release
CentOS Linux release 7.9.2009 (Core)
```
Dependicies:
--
Listed in requirements.txt
```
[root@tenable-5cfxx56r nessus-agent-opmanager]# yum install sshpass jq -y
```

Usage:
--
Help:
```
opctl -showconfig
opctl -testconfig
```
