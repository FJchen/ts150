#!/bin/sh
######################################################
# ccbs �ۺ�ǰ�� �޿���ز�ѯ����
######################################################

#���û���Shell������
source /home/ap/dip_ts150/ts150_script/base.sh

#��¼Hadoop
hadoop_login

#���������в���
logdate_arg $*


# ��������Դ--��������
IN_PRE_HIVE=ILLEGAL_CCBS_ZHQZ_A
IN_CUR_HDFS=

# Hive������жϽű��Ƿ��ѳɹ��������
OUT_CUR_HIVE=ILLEGAL_CCBS_ZHQZ_A

run()
{
   beeline -f ./hive_insert/INSERT_ILLEGAL_CCBS_ZHQZ_A.sql --hivevar p9_data_date=${log_date}
}


