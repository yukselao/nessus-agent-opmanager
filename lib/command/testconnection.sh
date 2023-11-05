#!/bin/bash


function testconnection {
cat setup.json | jq '.targetList[] | (.ip + "|" + .user + "|" + .os + "|" + .authMethod + "|" + .name + "|" + .group)' | while read line; do
        ip=$(echo $line | tr -d '"' |cut -d'|' -f1)
        user=$(echo $line | tr -d '"' |cut -d'|' -f2)
        os=$(echo $line | tr -d '"' |cut -d'|' -f3)
        authmethod=$(echo $line | tr -d '"' |cut -d'|' -f4) #--key=$1 --name=$2 --groups="$3" --host=$4 --port=$5
        agentname=$(echo $line | tr -d '"' |cut -d'|' -f5)
        agentgroup=$(echo $line | tr -d '"' |cut -d'|' -f6)
	
        if [[ "$connectiontest" == "true" ]]; then
                ping -c1 -w2 $ip &>/dev/null
                if [ $? -eq 0 ]; then
                        logger "INFO" "$ip is up"
                        plog "INFO" "$ip is up"
                else
                        logger "ERROR" "$ip is down"
                        plog "INFO" "$ip is up"
                fi
                if [[ "$authmethod" == "genericuser" ]]; then
                        sshcheck="$(genericssh "$ip" "$username" "$password" "connectioncheck")"
                        if [[ "$sshcheck" == "success" ]]; then
                                uid=$(genericssh "$ip" "$username" "$password" "runcommand" "id -u")
                                accessdetails=$(genericssh "$ip" "$username" "$password" "runcommand" "id")
                                if [[ "$uid" == "0" ]]; then
                                        logger "INFO" "$ip permission is ok"
                                        plog "INFO" "$ip permission is ok"
                                else
                                        logger "ERROR" "$ip permission failed, access details: $accessdetails"
                                        plog "ERROR" "$ip permission failed, access details: $accessdetails"
                                fi
                                if [[ "$copyonly" == "true" ]]; then
                                        setupfile=$(installerfile $os)
                                        setupfilename=$(installerfile $os |xargs basename)
                                        ret=$(genericscp "$ip" "$username" "$password" "$setupfile" "/tmp/")
                                        if [[ "$ret" == "success" ]]; then
                                                plog "INFO" "$setupfile copied to /tmp/$setupfilename"
                                        else
                                                plog "ERROR" "$setupfile cannot copy to /tmp/$setupfilename"
                                        fi
                                fi 
                                if [[ "$checksetupfiles" == "true" ]]; then
                                        setupfile=$(installerfile $os)
                                        setupfilename=$(installerfile $os |xargs basename)
                                        out=$(genericssh "$ip" "$username" "$password" "runcommand" "ls -al /tmp/$setupfilename")
					plog "INFO" "$ip: $out"
                                fi 
                                if [[ "$installpackage" == "true" ]]; then
                                        setupscript=$(installerscript $os)
                                        setupscriptname=$(installerscript $os |xargs basename)
                                        plog "INFO" "installpackage setup script is $setupscript"
                                        ret=$(genericscp "$ip" "$username" "$password" "$setupscript" "/tmp/")
                                        out=$(genericssh "$ip" "$username" "$password" "runcommand" "ls -al /tmp/$setupscriptname")
                                        plog "INFO" "$ip setup script: $out" 
					cmd="/tmp/$setupscriptname '$NESSUSAGENT_KEY' '$agentname' '$agentgroup' '$NESSUSAGENT_HOST' '$NESSUSAGENT_PORT'"
					plog "WARNING" $cmd
                                        out=$(genericssh "$ip" "$username" "$password" "runcommand" "/tmp/$setupscriptname '$NESSUSAGENT_KEY' '$agentname' '$agentgroup' '$NESSUSAGENT_HOST' '$NESSUSAGENT_PORT'") #--key=$1 --name=$2 --groups="$3" --host=$4 --port=$5
                                        plog "INFO" "$ip installation output:"
					echo -e $out
                                fi
                        fi
                fi
        fi
done
}
