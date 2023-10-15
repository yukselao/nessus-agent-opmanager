About the project:
--
This project was developed to facilitate nessus agent installations and to facilitate problem solving related to agent management. It is an open source project that you cannot officially get support from Tenable. The project has been successfully tested in my test environment. All responsibility for the use of the tools included in the project belongs to the user.

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
Before starting modify setup.json and config/.env files.

```
[root@tenable-5cfxx56r nessus-agent-opmanager]# cat config/.env
export username="installeruser"
export password="MySecretPassword^^"
```

__Steps:__
1-
Setup and test configuration file
```
opctl -showconfig
opctl -testconfig
```
