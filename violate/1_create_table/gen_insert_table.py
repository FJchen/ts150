#!/usr/bin/python
#coding:gbk

import sys, os, re, time
from read_data_struct import *


#生成从外部临时表插入贴源表的SQL脚本文件
def build_hive_entity_insert_sql(td):

    # 生成 贴源表字段插入语句
    sor_field_stmt_list = ["   -- %s\n   %s" % 
                           ((field[1], field[0]) if field[2] != 'DATE' else (field[1], "regexp_replace(%s, '-', '')" % field[0]))
                           for field in td.sor_field_array]
    sor_field_stmt = ",\n".join(sor_field_stmt_list)

    sql = u'''use sor;

# Hive贴源数据处理
# %(cn)s: %(en)s

-- 指定新数据日期分区位置
ALTER TABLE EXT_%(en)s DROP IF EXISTS PARTITION(LOAD_DATE='${log_date}');
ALTER TABLE EXT_%(en)s ADD PARTITION (LOAD_DATE='${log_date}') LOCATION 'hdfs://hacluster/bigdata/input/case_trace/%(en)s/${log_date}/';

-- 备份贴源数据到ORC内部表
INSERT OVERWRITE TABLE INN_%(en)s PARTITION(LOAD_DATE='${log_date}')
SELECT 
%(cols)s
  FROM EXT_%(en)s
 WHERE LOAD_DATE='${log_date}';
''' % {'en':td.table_en, 'cn':td.table_cn, 'cols':sor_field_stmt}

    f = open(r'./hive_insert/INSERT_EXT_%s.sql' % td.table_en, 'w')
    f.write(sql.encode('utf-8'))
    f.close()

    shell=u'''#!/bin/sh
######################################################
#   %(cn)s: EXT_%(en)s临时表导入到贴源表中
#                   wuzhaohui@tienon.com
######################################################

#引用基础Shell函数库
source /home/ap/dip_ts150/ts150_script/base.sh

#登录Hadoop
hadoop_login

#解释命令行参数
logdate_arg $*

# 依赖数据源--当天数据
IN_CUR_HIVE=
IN_CUR_HDFS=/bigdata/input/TS150/case_trace/%(en)s/

# Hive输出表，判断脚本是否已成功运行完成
OUT_CUR_HIVE=INN_%(en)s

run()
{
   beeline -f ./hive_insert/INSERT_EXT_%(en)s.sql --hivevar log_date=${log_date}
}
''' % {'en':td.table_en, 'cn':td.table_cn, 'sql':sql}

    f = open(r'./hive_insert/INSERT_EXT_%s.sh' % td.table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


#重建实体表拉链
def build_hive_entity_history_insert_sql(td):
    partition = ""
    add_partition = ""

    partition_field = 'DATA_TYPE'

    #建Hive表排除 P9_START_DATE P9_END_DATE
    # 生成 实体拉链表字段
    main_fields = []
    pk_fields = []
    i = 1
    sub_fields = []
    for field in td.ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        if field_en not in ('P9_START_DATE', 'P9_END_DATE'):
            if i % 9 == 0:
                sub_fields = []
                main_fields.append(sub_fields)
            sub_fields.append(field_en)
        if field_is_pk == 'Y':
            pk_fields.append(field_en)

    table_columns = ",\n".join(["       -- %s\n       a.%s" % (f[1], f[0]) for f in td.ctbase_field_array])
    # table_flat_columns = ",".join(["%s" % f[0] for f in td.ctbase_field_array 
    #                                if f[0] not in ('P9_START_DATE', 'P9_END_DATE')])
    table_flat_columns = ', '.join([[sf for sf in sf_list] for sf_list in main_fields])
    pk_flat_columns = ", ".join(pk_fields)

    sql = u'''use sor;
-- %(cn)s %(en)s 拉链处理

-- 复制贴源数据
INSERT OVERWRITE TABLE INN_%(en)s_MID PARTITION(%(partition)s='SRC')
SELECT 
%(cols)s
  FROM EXT_%(en)s a
 WHERE LOAD_DATE='${log_date}';

-- 去重
INSERT OVERWRITE TABLE CT_%(en)s_MID PARTITION(%(partition)s='CUR_NO_DUP')
SELECT 
%(cols)s
  FROM (SELECT %(flat_cols)s, P9_START_DATE, P9_END_DATE,
               row_number() over (
                    partition by %(flat_cols)s
                    order by P9_START_DATE
                   ) rownum
         FROM CT_%(en)s_MID 
        WHERE %(partition)s in ('SRC', 'PRE_NO_DUP') 
        ) a
 WHERE a.rownum = 1;

-- Hive动态分区参数设置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=strick;

-- 重建拉链
INSERT OVERWRITE TABLE CT_%(en)s PARTITION(P9_END_DATE)
SELECT %(flat_cols)s, P9_START_DATE, 
       lead(P9_START_DATE, 1, '29991231') over (partition by %(pk)s order by P9_START_DATE) as P9_END_DATE
  FROM CT_%(en)s_MID
 WHERE %(partition)s='CUR_NO_DUP';

------------ 以下操作可以导致数据丢失 ---------------
-- 备份当前非重复数据 到 PRE_NO_DUP 分区
ALTER TABLE CT_%(en)s_MID DROP IF EXISTS PARTITION(%(partition)s='PRE_NO_DUP');

ALTER TABLE CT_%(en)s_MID PARTITION(%(partition)s='CUR_NO_DUP') 
   RENAME TO PARTITION(%(partition)s='PRE_NO_DUP');

ALTER TABLE CT_%(en)s_MID ADD IF NOT EXISTS PARTITION(%(partition)s='CUR_NO_DUP');
''' % {'en':td.table_en, 'cn':td.table_cn, 'cols':table_columns, 'flat_cols':table_flat_columns,
       'partition':partition_field, 'pk':pk_flat_columns}

    f = open(r'./hive_insert/INSERT_%s.sql' % td.table_en, 'w')
    f.write(sql.encode('utf-8'))
    f.close()

    shell=u'''#!/bin/sh
######################################################
#   %(cn)s: %(en)s表拉链处理
#                   wuzhaohui@tienon.com
######################################################

#引用基础Shell函数库
source /home/ap/dip_ts150/ts150_script/base.sh

#登录Hadoop
hadoop_login

#解释命令行参数
logdate_arg $*

# 依赖数据源--当天数据
IN_CUR_HIVE=INN_%(en)s
IN_CUR_HDFS=

# 依赖数据源--昨天数据（昨天拉链处理成功）
IN_PRE_HIVE=CT_%(en)s

# Hive输出表，判断脚本是否已成功运行完成
OUT_CUR_HIVE=CT_%(en)s

run()
{
   beeline -f ./hive_insert/INSERT_%(en)s.sql --hivevar log_date=${log_date}
}
''' % {'en':td.table_en, 'cn':td.table_cn, 'sql':sql}

    f = open(r'./hive_insert/INSERT_%s.sh' % td.table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


def main():
    if not os.path.exists('./hive_insert'):  #目录不存在，则新建
        os.mkdir('./hive_insert')

    sts = SlideTableStruct()

    # build_hive_entity_insert_sql(sts.TODDC_CRCRDCRD_H)
    # build_hive_entity_history_insert_sql(sts.TODDC_CRCRDCRD_H)

    for table_en, td in sts.exist_table_map.items():
        build_hive_entity_insert_sql(td)
        build_hive_entity_history_insert_sql(td)
        print 'table: %s finish' % table_en


if __name__ == '__main__':
    main()
