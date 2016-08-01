#!/bin/sh

#脚本目录 脚本名
PID=$$
SCRIPT_NAME=`readlink /proc/${PID}/fd/255 | awk -F \/ {'print $NF'}`
SCRIPT_PATH=`readlink /proc/${PID}/fd/255 | awk -F ${SCRIPT_NAME} {'print $1'}`
SCRIPT_IP=`netstat -tln|grep "36000"|awk '{print $4}'|awk -F":" '{print $1}'`

#打印日志
function INFO()
{
    now=`date "+[%Y-%m-%d %H:%M:%S]"`
    aashell_file_name=${0##*/}
    echo -e "$now[INFO][${aashell_file_name}:$BASH_LINENO] $1"
}

function ERROR()
{
    now=`date "+[%Y-%m-%d %H:%M:%S]"`
    echo -e "$now[ERROR][$0:$BASH_LINENO] $1"
}

function SENDRTX()
{
    MSG_RECVER="$1"
    MSG_SUBJECT="$2"
    MSG_BODY="$3"
    now=`date "+%Y-%m-%d %H:%M:%S"`
    SENDRTX_EXE="/usr/local/bin/sendrtxproxy"
    if [ ! -f ${SENDRTX_EXE} ] ;then
        ERROR "${SENDRTX_EXE} is not exist!"
        return
    fi
    ${SENDRTX_EXE} "jasonyjiang" "${MSG_RECVER}" "${MSG_SUBJECT}" "${MSG_BODY}===[${now}][$SCRIPT_IP]" 0 >/dev/null
    ${SENDRTX_EXE} "jasonyjiang" "${MSG_RECVER}" "${MSG_SUBJECT}" "${MSG_BODY}===[${now}][$SCRIPT_IP]" 1 >/dev/null
}
