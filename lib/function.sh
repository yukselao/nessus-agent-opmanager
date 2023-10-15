


export logdir=$(cat setup.json  |jq '.logsDir' | tr -d '"')
mkdir -p $logdir &>/dev/null
export logfile=$logdir/app.log

function logger {
	severity="$1"
	message="$(echo $@ | awk '{$1=""; print $0}' | awk '{$1=$1};1')"
	logmsg="$(date "+%F %T") [$severity]: $message" 
	echo "$logmsg" >> $logfile
	if [[ "$severity" == "ERROR" ]]; then
		echo "$logmsg" >> ${logfile}.error
	fi
}
function genericssh {
        ip=$1
        username=$2
        password=$3
        commandtype=$4
        command=$5
        if [[ "$commandtype" == "connectioncheck" ]]; then
                sshpass -p "$password" ssh -q -n -o ConnectTimeout=2 -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -o "LogLevel=ERROR" ${username}@${ip} uptime &>/dev/null
                if [ $? -eq 0 ]; then
			echo "success"
                        logger "INFO" $ip ssh success
                else
			echo "failed"
                        logger "ERROR" $ip ssh failed
                fi
        elif [[ "$commandtype" == "runcommand" ]]; then
                sshpass -p "$password" ssh -q -n -o ConnectTimeout=2 -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -o "LogLevel=ERROR" ${username}@${ip} "$command" 2>/dev/null
        fi

}

function help {
	echo 'opctl -showconfig: show config file
opctl -testconnection: test connectivity for target systems'

}