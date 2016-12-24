#!/bin/sh

#脚本目录 脚本名
PID=$$
SCRIPT_NAME=`readlink /proc/${PID}/fd/255 | awk -F \/ {'print $NF'}`
SCRIPT_PATH=`readlink /proc/${PID}/fd/255 | awk -F ${SCRIPT_NAME} {'print $1'}`

#******************************************************************#
# Description: set value through keyname to ini config file
#*****************************************************
function SETV
{
    filename=$1
    keyname=$2
    keyvalue=$3     # 可以为空
    keynametxt=$(echo $keyname | sed "s/\[/\\\[/g; s/\]/\\\]/g")
    targetLine=`grep "^${keynametxt}=" ${filename}`
    if [ "$targetLine"  ]; then
        sed --in-place "s%^${keynametxt}=.*%${keynametxt}=${keyvalue}%" ${filename}
    else
        echo "${keyname}=${keyvalue}" >>${filename}
    fi
}

#******************************************************************#
# Description: print infomatioin message by green to terminal
#*******************************************************
function TERM_INFO()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -en "\e[0;32;1m"
    echo -e "[$now][INFO][${file}:$BASH_LINENO] $1"
    echo -en "\e[0m"
}

#******************************************************************#
# Description: print error message by red to terminal
#*******************************************************
function TERM_ERROR()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -en "\e[0;31;1m"
    echo -e "[$now][INFO][${file}:$BASH_LINENO] $1"
    echo -en "\e[0m"
}

#******************************************************************#
# Description: print warnning message by yellow to terminal
#*******************************************************
function TERM_WARN()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -en "\e[0;33;1m"
    echo -e "[$now][INFO][${file}:$BASH_LINENO] $1"
    echo -en "\e[0m"
}

#******************************************************************#
# Description: print infomatioin message 
#*******************************************************
function LOG_INFO()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -e "[$now][INFO][${file}:$BASH_LINENO] $1"
}

#******************************************************************#
# Description: print error message 
#*******************************************************
function LOG_ERROR()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -e "[$now][ERROR][${file}:$BASH_LINENO] $1"
}

#******************************************************************#
# Description: print warnning message 
#*******************************************************
function LOG_WARN()
{  
    local now=`date +"%Y-%m-%d %H:%M:%S"`
    local file=${0##*/}
    echo -e "[$now][WARN][${file}:$BASH_LINENO] $1"
}
