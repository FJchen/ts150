#!/bin/sh
######################################################
#   内外客户号对照信息: T0042_TBPC9030_H表拉链处理
#                   wuzhaohui@tienon.com
######################################################

#引用基础Shell函数库
source /home/ap/dip_ts150/ts150_script/base.sh

#登录Hadoop
hadoop_login

#解释命令行参数
logdate_arg $*

# 依赖数据源--当天数据
IN_CUR_HIVE=INN_T0042_TBPC9030_H
IN_CUR_HDFS=

# 依赖数据源--昨天数据（昨天拉链处理成功）
IN_PRE_HIVE=CT_T0042_TBPC9030_H

# Hive输出表，判断脚本是否已成功运行完成
OUT_CUR_HIVE=CT_T0042_TBPC9030_H

run()
{
   beeline -f ./hive_insert/INSERT_T0042_TBPC9030_H.sql --hivevar log_date=${log_date}
}
