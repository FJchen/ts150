#!/usr/bin/python
#coding:gbk

import sys, os, re, time
from read_data_struct import *


#���ɴ��ⲿ��ʱ�������Դ���SQL�ű��ļ�
def build_hive_entity_insert_sql(td):

    # ���� ��Դ���ֶβ������
    # sor_field_stmt_list = ["   a.%-30s" % field[0]  for field in td.sor_field_array]
    sor_field_stmt_list = ["   %s" % (field[0] if field[2] != 'DATE' else "regexp_replace(%s, '-', '')" % field[0])
                           for field in td.sor_field_array]
    sor_field_stmt = ",\n".join(sor_field_stmt_list)

    sql = u'''use sor;

# Hive��Դ���ݴ���
# %(cn)s: %(en)s

-- ���������ⲿ����
ALTER TABLE EXT_%(en)s DROP IF EXISTS PARTITION(LOAD_DATE='${log_date}');
ALTER TABLE EXT_%(en)s ADD PARTITION (LOAD_DATE='${log_date}') LOCATION 'hdfs://hacluster/bigdata/input/case_trace/%(en)s/${log_date}/';

-- ������Դ���ݵ�ORC�ڲ���
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
#   ��Hive�ϵ�CT_TMP_%(en)s��ʱ���뵽��Դ����
#                   wuzhaohui@tienon.com
######################################################

#���û���Shell������
source /home/ap/dip/appjob/shelljob/TS150/case_trace/case_trace_base.sh

#���������в���
logdate_arg $*

log "��ʼִ�нű����������û���:$hadoop_user,log_date:${log_date}"

# ������ԴHive��������ű�
# %(cn)s: %(en)s

$hdsrun hdsHive USERNAME:$hadoop_user,INSTANCEID:IMPORT-%(en)s-${log_date}-0000 <<!

%(sql)s
!

log "���ִ�нű�"
''' % {'en':td.table_en, 'cn':td.table_cn, 'sql':sql}

    f = open(r'./hive_insert/INSERT_EXT_%s.sh' % td.table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


#���ɴ��ⲿ��ʱ�������Դ���SQL�ű��ļ�
def build_hive_detail_insert_sql(table_en, table_cn, field_array):

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    sor_field_array, partition_field = define_sor_field(change_field_array)

    # ���� ��Դ���ֶ�
    table_change_columns = "\n"
    for field in sor_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        if field_type == 'DATE':
            field_change_line = "   regexp_replace(a.%s, '-', '') as %s" % (field_en, field_en)
        else:
            field_change_line = "   a.%s" % (field_en)
        
        # ���һ�в���,
        if field != sor_field_array[-1]:
            field_change_line += ",\n"

        table_change_columns += field_change_line

    sql = u'''use ts150;

ALTER TABLE CT_TMP_%(en)s SET LOCATION 'hdfs://hacluster/bigdata/input/TS150/case_trace/%(en)s/${log_date}/';

ALTER TABLE CT_%(en)s ADD IF NOT EXISTS PARTITION(%(partition)s='${log_date}');

INSERT OVERWRITE TABLE CT_%(en)s PARTITION(%(partition)s='${log_date}')
SELECT %(change_cols)s
 FROM CT_TMP_%(en)s a;
''' % {'en':table_en, 'cn':table_cn, 'change_cols':table_change_columns, 'partition':partition_field}

    if not os.path.exists('./hive_insert'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./hive_insert')

    f = open(r'./hive_insert/INSERT_%s.sql' % table_en, 'w')
    f.write(sql.encode('utf-8'))
    f.close()

    shell=u'''#!/bin/sh

######################################################
#   ��Hive�ϵ�CT_TMP_%(en)s��ʱ���뵽��Դ����
#                   wuzhaohui@tienon.com
######################################################

#���û���Shell������
source /home/ap/dip/appjob/shelljob/TS150/case_trace/case_trace_base.sh

#���������в���
logdate_arg $*

log "��ʼִ�нű����������û���:$hadoop_user,log_date:${log_date}"

# ������ԴHive��������ű�
# %(cn)s: %(en)s

$hdsrun hdsHive USERNAME:$hadoop_user,INSTANCEID:IMPORT-%(en)s-${log_date}-0000 <<!

%(sql)s
!

log "���ִ�нű�"
''' % {'en':table_en, 'cn':table_cn, 'sql':sql}

    f = open(r'./hive_insert/INSERT_%s.sh' % table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


#�ؽ�ʵ�������
def build_hive_entity_history_insert_sql(td):
    partition = ""
    add_partition = ""

    partition_field = 'DATA_TYPE'

    #��Hive���ų� P9_START_DATE P9_END_DATE
    # ���� ʵ���������ֶ�
    main_fields = []
    all_fields = []
    pk_fields = []
    for field in td.ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        all_fields.append(field_en)
        if field_en not in ('P9_START_DATE', 'P9_END_DATE'):
            # print i, field_en
            main_fields.append(field_en)
        if field_is_pk == 'Y':
            pk_fields.append(field_en)

    table_columns = ",\n".join(["       a.%s" % x for x in all_fields])
    table_flat_columns = ', '.join(main_fields)
    pk_flat_columns = ", ".join(pk_fields)

    sql = u'''use sor;


''' % {'en':td.table_en, 'cn':td.table_cn, 'cols':table_columns, 'flat_cols':table_flat_columns,
       'partition':partition_field, 'pk':pk_flat_columns}


    sql += u'''use sor;
-- %(cn)s ��������

-- ������Դ����
INSERT OVERWRITE TABLE INN_%(en)s_MID PARTITION(%(partition)s='SRC')
SELECT 
%(cols)s
 FROM EXT_%(en)s a;

-- ȥ��
INSERT OVERWRITE TABLE CT_%(en)s_MID PARTITION(%(partition)s='CUR_NO_DUP')
SELECT 
%(cols)s
  FROM (SELECT %(flat_cols)s, P9_START_DATE, P9_END_DATE,
               row_number() over (
                    partition by %(flat_cols)s
                    order by P9_START_DATE
                   ) rownum
         FROM CT_%(en)s_MID 
        WHERE %(partition)s = 'SRC' or %(partition)s = 'PRE_NO_DUP') a
 WHERE a.rownum = 1;

-- �ؽ�����
INSERT OVERWRITE TABLE CT_%(en)s_SHORT
SELECT %(flat_cols)s, P9_START_DATE, 
       lead(P9_START_DATE, 1, '29991231') over (partition by %(pk)s order by P9_START_DATE) as P9_END_DATE
  FROM CT_%(en)s_MID
 WHERE %(partition)s='CUR_NO_DUP';

-- ���ݵ�ǰ���ظ����� �� PRE_NO_DUP ����
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
#   ��Hive�ϵ�CT_TMP_%(en)s��ʱ���뵽��Դ����
#                   wuzhaohui@tienon.com
######################################################

#���û���Shell������
source /home/ap/dip/appjob/shelljob/TS150/case_trace/case_trace_base.sh

#���������в���
logdate_arg $*

log "��ʼִ�нű����������û���:$hadoop_user,log_date:${log_date}"

# ������ԴHive��������ű�
# %(cn)s: %(en)s

$hdsrun hdsHive USERNAME:$hadoop_user,INSTANCEID:IMPORT-%(en)s-${log_date}-0000 <<!

%(sql)s
!

log "���ִ�нű�"
''' % {'en':td.table_en, 'cn':td.table_cn, 'sql':sql}

    f = open(r'./hive_insert/INSERT_%s_SHORT.sh' % td.table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


def main():
    if not os.path.exists('./hive_insert'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./hive_insert')

    sts = SlideTableStruct()

    build_hive_entity_insert_sql(sts.TODDC_CRCRDCRD_H)
    build_hive_entity_history_insert_sql(sts.TODDC_CRCRDCRD_H)

if __name__ == '__main__':
    main()
