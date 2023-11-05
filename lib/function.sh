


export logdir=$(cat setup.json  |jq '.logsDir' | tr -d '"')
export NESSUSAGENT_KEY=$(cat setup.json  |jq '.nessusagent|.key' | tr -d '"')
export NESSUSAGENT_HOST=$(cat setup.json  |jq '.nessusagent|.host' | tr -d '"')
export NESSUSAGENT_PORT=$(cat setup.json  |jq '.nessusagent|.port' | tr -d '"')
mkdir -p $logdir &>/dev/null
export logfile=$logdir/app.log


function plog {
        severity="$1"
        message="$(echo $@ | awk '{$1=""; print $0}' | awk '{$1=$1};1')"
        logmsg="$(date "+%F %T") [$severity]: $message"
        if [[ "$verbose" == "true" ]]; then
                echo "$logmsg"
        fi
}

function logger {
	severity="$1"
	message="$(echo $@ | awk '{$1=""; print $0}' | awk '{$1=$1};1')"
	logmsg="$(date "+%F %T") [$severity]: $message" 
	echo "$logmsg" >> $logfile
	if [[ "$severity" == "ERROR" ]]; then
		echo "$logmsg" >> ${logfile}.error
	fi
}

function installerfile {
	find $ppwd/agent-setup/$1 -mindepth 1 -maxdepth 1 -type f ! -name "*.sh"|head -1
}

function installerscript {
	find $ppwd/agent-setup/$1 -type f -name nessus-agent-install.sh |head -1
}


function genericscp {
        ip=$1
        username=$2
        password=$3
	source=$4
	target=$5
	sshpass -p "$password" scp "$source" "${username}@${ip}:$target"
        if [ $? -eq 0 ]; then
		echo "success"
        	logger "INFO" $ip scp success cmd:scp "$source" "${username}@${ip}:$target"
        else
		echo "failed"
        	logger "ERROR" $ip scp failed cmd:scp "$source" "${username}@${ip}:$target"
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
	echo -e "Usage:\n--"
	echo 'opctl -showconfig: show config file
opctl -testconnection: test connectivity for target systems
opctl -testconnection -copyonly
'

}
