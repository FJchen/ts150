#!/bin/sh
######################################################
# PBCSϵͳ �޿���ز�ѯ����
######################################################

#���û���Shell������
source /home/ap/dip_ts150/ts150_script/base.sh

#��¼Hadoop
hadoop_login

#���������в���
logdate_arg $*


# ��������Դ--��������
IN_PRE_HIVE=ILLEGAL_PBCS_A
IN_CUR_HDFS=

# Hive������жϽű��Ƿ��ѳɹ��������
OUT_CUR_HIVE=ILLEGAL_PBCS_A

run()
{
   beeline -f ./hive_insert/INSERT_ILLEGAL_PBCS.sql --hivevar p9_data_date=${log_date}
}


