#!/bin/sh

function DELETE()
{
    db=$1
    table=$2
    days=$3
    host="host"
    sql="DELETE FROM ${table} WHERE DATE(create_time) < DATE_SUB(CURDATE(),INTERVAL ${days} DAY)"
    echo "${sql}"|/usr/bin/mysql -uroot -p"" -h${host} -D${db}
    echo "${sql}"
}



DELETE "uxin_im_daily" "tb_cs_conn_alive" 90
DELETE "uxin_im_daily" "tb_cs_conn_uid" 90
