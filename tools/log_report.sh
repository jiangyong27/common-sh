#!/bin/sh

NSQD_ADDR="112.74.134.9:3601"
TOPIC="cs_vps_log"
FLAG="$1"

function report_log()
{
	log_name=$1
	nohup /tmp/tail_log.sh "${NSQD_ADDR}" "${TOPIC}" "$log_name" >/dev/null 2>&1 &
	echo $!
}

function INFO()
{
    now=`date "+[%Y-%m-%d %H:%M:%S]"`
    aashell_file_name=${0##*/}
    echo -e "$now[INFO][${aashell_file_name}:$BASH_LINENO] $1"
}

function check()
{
	proc_num=`ps aux|grep $0|grep "$FLAG"|grep -v grep|wc -l`
	if [ $proc_num -gt 2 ];then
		exit 1
	fi
}

function kill_pid()
{
	allpid=`ps -ef|grep $pid|grep -v grep|awk '{print $2}'`
	INFO "kill $pid and child"
	for pid in $allpid;do
		kill -9 $pid
		INFO "kill -9 $pid"
	done
}

function run() 
{
	day=`date +"%Y-%m-%d"`
	tom=`date -d"1 days" +"%Y-%m-%d"`
	log_day=run.log.$day
	log_tom=run.log.$tom
	pid=`report_log "$log_day" "errcode"`
	INFO "start log_report $pid ... "

	while((1));do
		if [ -f ${log_tom} ];then
			kill_pid ${pid}
			INFO "stop $pid $log_day $log_tom"
			pid=`report_log "$log_tom" "errcode"`
			day=`date +"%Y-%m-%d"`
			tom=`date -d"1 days" +"%Y-%m-%d"`
			log_day=run.log.$day
			log_tom=run.log.$tom
			INFO "start $pid $log_day $log_tom"
		fi
		sleep 1
	done
}
function gen_tmp_shell()
{
if [ ! -f /usr/local/bin/nsq_report ];then
	wget "http://113.31.82.185:12000/downloads/nsq_report"
	chmod +x nsq_report
	mv nsq_report /usr/local/bin/nsq_report
fi

cat > /tmp/tail_log.sh << EOF
#!/bin/sh

NSQD_ADDR=\$1
TOPIC=\$2
LOG_NAME=\$3

tail -f \${LOG_NAME}|grep "MSG_LOG"|grep "op=10"|/usr/local/bin/nsq_report -lookupd="\${NSQD_ADDR}" -topic="\${TOPIC}" >/dev/null 2>&1
EOF

chmod +x /tmp/tail_log.sh
}

check
gen_tmp_shell
run
