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

Configuration File:
--
The setup.json file in the project folder must be edited for configuration definitions.

```json
{
  "genericCredentialFile": "config/.env",
  "logsDir": "logs/",
  "setupFile": {
    "rhel7": "NessusAgent-10.4.2-es7.x86_64.rpm",
    "rhel8": "NessusAgent-10.4.2-es8.x86_64.rpm",
    "ubuntu": "NessusAgent-10.4.2-ubuntu1404_amd64.deb"
  },
  "targetList": [
    {
      "ip": "10.10.10.123",
      "user": "root",
      "os": "rhel8",
      "authMethod": "genericuser"
    },
    {
      "ip": "10.10.10.122",
      "user": "root",
      "os": "ubuntu",
      "authMethod": "genericuser"
    },
    {
      "ip": "10.10.10.124",
      "user": "root",
      "os": "ubuntu",
      "authMethod": "genericuser"
    }
  ]
}
```

Error: [info] [agent] Failed to open global database
Solution: Disable Selinux


Usage:
--
Before starting modify setup.json and config/.env files.

```
[root@tenable-5cfxx56r nessus-agent-opmanager]# cat config/.env
export username="installeruser"
export password="MySecretPassword^^"
```

__Step 1:__ Setup and test configuration file
```
opctl -showconfig
opctl -testconfig
```
