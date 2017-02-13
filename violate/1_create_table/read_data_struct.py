#!/usr/bin/python
#coding:gbk

import sys, os, re, time
import xlrd


def read_excel():
    data = xlrd.open_workbook(r'..\..\doc\SIAM_������Դ��ṹ_201603.xlsx') 
    # for sheet in data.sheet_names():
    #     print sheet
        # print sheet.decode('utf-8')
    # print data.sheet_names()

    # table = data.sheet_by_name('������ԴԴ��')
    table_sheet = data.sheet_by_index(4)
    field_sheet = data.sheet_by_index(5)

    # ��ȡ����������
    nrows = table_sheet.nrows
    ncols = table_sheet.ncols

    # print nrows, ncols
    return table_sheet, field_sheet


def read_table_name(table_sheet):
    table_map = {}
    # ѭ����,�õ��������б�
    for rownum in range(1, table_sheet.nrows):
        # print table_sheet.row_values(rownum)
        table_en = table_sheet.cell(rownum,3).value
        table_cn = table_sheet.cell(rownum,4).value

        table_map[table_en.upper()] = table_cn

    # for en, cn in table_map.items():
    #     print '%s,%s' % (en, cn)

    return table_map


def read_field_name(field_sheet):
    table_map = {}
    # ѭ����,�õ��������б�
    for rownum in range(1, field_sheet.nrows):
        table_en = field_sheet.cell(rownum,1).value
        table_cn = field_sheet.cell(rownum,2).value
        field_en = field_sheet.cell(rownum,3).value
        field_cn = field_sheet.cell(rownum,4).value
        field_type = field_sheet.cell(rownum,5).value
        field_length = field_sheet.cell(rownum,6).value
        field_is_pk = field_sheet.cell(rownum,7).value
        field_is_dk = field_sheet.cell(rownum,8).value
        field_to_ctbase = field_sheet.cell(rownum,10).value
        index_describe = field_sheet.cell(rownum,11).value
        index_function = field_sheet.cell(rownum,12).value
        index_split = field_sheet.cell(rownum,13).value

        table_en = table_en.upper()
        field_en = field_en.upper()
        if table_en in table_map.keys():
            field_array = table_map[table_en]
        else:
            field_array = []
            table_map[table_en] = field_array

        if field_en == 'P9_START_DATE':
            field_cn = u'P9��ʼ����'

        if field_en == 'P9_END_DATE':
            field_cn = u'P9��������'

        if field_cn == 'N/A':
            field_cn = field_en

        #��ֵ�������ݣ����ȴ�,����
        length_array = field_length.split(',')
        if len(length_array) > 1:
            field_length = length_array[0]

        field_array.append((field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split))

    return table_map


#����ת�����Ӧ����
def define_change_field(field_array):

    change_field_array = []

    for field in field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        #���ռ���ֶ���Ҫ��ֳ������ֶ�
        if field_en == 'MON_INF':
            change_field_array.append(('TERM_QRY', u'��¼�豸��ѯ', 'VARCHAR(48)', '48', 'N', 'N', 'Y', 'IDX_TERM_QRY', 'reverse(TERM_QRY,2)', '0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'))
            change_field_array.append(('TERM_BIOS', u'PC��BIOS���к�', 'VARCHAR(9)', '9', 'N', 'N', 'Y', '', '', ''))
            change_field_array.append(('TERM_IMEI', u'�ֻ���ʶ', 'VARCHAR(48)', '48', 'N', 'N', 'Y', '', '', ''))
            change_field_array.append(('TERM_MAC', u'����Mac��ַ', 'VARCHAR(40)', '40', 'N', 'N', 'Y', '', '', ''))
        elif field_en == 'TERM_INF':
            change_field_array.append(('MOBILE', u'�ֻ���', 'VARCHAR(16)', '16', 'N', 'N', 'Y', 'IDX_MOBILE', 'reverse(MOBILE,2)', '0,1,2,3,4,5,6,7,8,9'))
            change_field_array.append(('IP', u'IP��ַ', 'VARCHAR(32)', '32', 'N', 'N', 'Y', 'IDX_IP', 'reverse(IP,2)', '0,1,2,3,4,5,6,7,8,9'))
        else:
            if field_en not in ('P9_START_BATCH', 'P9_END_BATCH', 'P9_DEL_FLAG', 'P9_JOB_NAME', 'P9_BATCH_NUMBER', 'P9_DEL_DATE', 'P9_DEL_BATCH', 'P9_SPLIT_BRANCH_CD'):
                change_field_array.append(field)

    return change_field_array


#����Ŀ����Դ���Ӧ����
def define_sor_field(change_field_array):
    sor_field_array = []
    partition_field = ""

    for field in change_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        # �����ֶβ������ֶ��б���
        if field_is_dk == "Y":
            partition_field = field_en
        else:
            sor_field_array.append(field)

    return (sor_field_array, partition_field)


#����Ŀ����Դ���Ӧ����
def define_ctbase_field(change_field_array):
    ctbase_field_array = []
    partition_field = ""

    for field in change_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        if field_to_ctbase == 'Y':
            ctbase_field_array.append(field)

            if field_is_dk == "Y":
                partition_field = field_en

    return (ctbase_field_array, partition_field)


#���ɽ�Hive���SQL�ű��ļ�
def build_hive_create_sql(table_en, table_cn, field_array):
    partition = ""
    add_partition = ""

    # ���� ��ʱ���ֶ�
    tmp_table_columns = "\n"
    for field in field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        # ���һ�в���,
        if field == field_array[-1]:
            field_line = "   %-30s string\n" % (field_en)
        else:
            field_line = "   %-30s string,\n" % (field_en)

        tmp_table_columns += field_line

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    sor_field_array, partition_field = define_sor_field(change_field_array)

    # �����ֶβ������ֶ��б���
    if partition_field != "":
        partition = 'PARTITIONED BY (%s string)' % partition_field
        add_partition = "ALTER TABLE CT_%s ADD PARTITION(%s='29991231');" % (table_en, partition_field)

    # ���� ��Դ���ֶ�
    table_columns = "\n"
    for field in sor_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        # ���һ�в���,
        if field == sor_field_array[-1]:
            field_line = "   %-30s string\n" % (field_en)
        else:
            field_line = "   %-30s string,\n" % (field_en)

        table_columns += field_line

    sql = u'''use ts150;

-- ������ԴHive����ű�
-- %(cn)s: %(en)s

DROP TABLE IF EXISTS CT_TMP_%(en)s;
DROP TABLE IF EXISTS CT_%(en)s;

CREATE EXTERNAL TABLE IF NOT EXISTS CT_TMP_%(en)s(%(tmp_cols)s)
STORED AS TEXTFILE
LOCATION '/bigdata/input/TS150/case_trace/%(en)s/';

CREATE TABLE IF NOT EXISTS CT_%(en)s(%(cols)s)
%(partition)s
STORED AS ORC;\n

%(add_partition)s
''' % {'en':table_en, 'cn':table_cn, 'tmp_cols':tmp_table_columns, 'cols':table_columns,
       'partition':partition, 'add_partition':add_partition}

    if not os.path.exists('./hive_create'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./hive_create')

    f = open(r'./hive_create/CREATE_%s.sql' % table_en, 'w')
    f.write(sql.encode('utf-8'))
    f.close()


#���ɴ��ⲿ��ʱ�������Դ���SQL�ű��ļ�
def build_hive_entity_insert_sql(table_en, table_cn, field_array):

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    sor_field_array, partition_field = define_sor_field(change_field_array)

    # ���� ��Դ���ֶ�
    table_change_columns = "\n"
    table_columns = "\n"
    pk_null_array = []
    pk_join_array = []
    for field in sor_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        if field_type == 'DATE':
            field_change_line = "   regexp_replace(a.%s, '-', '') as %s" % (field_en, field_en)
        else:
            field_change_line = "   a.%s" % (field_en)
        
        field_line = "   a.%s" % (field_en)

        if field_is_pk == 'Y':
            pk_null_array.append('b.%s IS NULL' % field_en)
            pk_join_array.append('a.%(en)s = b.%(en)s' % {'en':field_en})

        # ���һ�в���,
        if field != sor_field_array[-1]:
            field_line += ",\n"
            field_change_line += ",\n"

        table_change_columns += field_change_line
        table_columns += field_line

    join_condition = '\n   AND '.join(pk_join_array)
    null_condition = '\n   AND '.join(pk_null_array)
    '''
-- �޸���ʱ�ⲿ��λ�õ��ϴ�����Ŀ¼

-- Ϊ��ֹ����ʱ��ɾ������ע�͸���䣬�õڶ������ܱ����˳�
--ALTER TABLE CT_%(en)s DROP IF EXISTS PARTITION(%(partition)s='TMP_${log_date}');
    '''
    sql = u'''use ts150;

ALTER TABLE CT_TMP_%(en)s SET LOCATION 'hdfs://hacluster/bigdata/input/TS150/case_trace/%(en)s/${log_date}/';

ALTER TABLE CT_%(en)s PARTITION(%(partition)s='29991231') 
   RENAME TO PARTITION(%(partition)s='TMP_${log_date}');

INSERT OVERWRITE TABLE CT_%(en)s PARTITION(%(partition)s='29991231')
SELECT %(change_cols)s
 FROM CT_TMP_%(en)s a;

INSERT OVERWRITE TABLE CT_%(en)s PARTITION(%(partition)s='${log_date}')
SELECT %(cols)s
  FROM (SELECT * FROM CT_%(en)s WHERE %(partition)s = 'TMP_${log_date}') a
 INNER JOIN (SELECT * FROM CT_%(en)s WHERE %(partition)s = '29991231') b
    ON %(join)s;

INSERT OVERWRITE TABLE CT_%(en)s PARTITION(%(partition)s='TMP')
SELECT %(cols)s
  FROM (SELECT * FROM CT_%(en)s WHERE %(partition)s = 'TMP_${log_date}') a
  LEFT JOIN (SELECT * FROM CT_%(en)s WHERE %(partition)s = '29991231') b
    ON %(join)s
 WHERE %(null)s;

INSERT INTO TABLE CT_%(en)s PARTITION(%(partition)s='29991231')
SELECT %(cols)s
  FROM CT_%(en)s a
 WHERE %(partition)s = 'TMP';
''' % {'en':table_en, 'cn':table_cn, 'cols':table_columns, 'change_cols':table_change_columns,
       'partition':partition_field, 'join':join_condition, 'null':null_condition}

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


#���ɽ�CTBase���XML�ļ�
def build_ctbase_create_xml(table_en, table_cn, field_array):

    xml = u'''<?xml version="1.0" encoding="UTF-8"?>

<!--������ԴCTBase���������ļ�-->

<table>
    <!-- �۴ر���-->
    <clusterTable>
        <name>CT_%s_CLUS</name>
        <describe>%s</describe>
    </clusterTable>

    <userTable>
        <name>%s</name>
        <describe>%s</describe>
        <columns>''' % (table_en, table_cn, table_en, table_cn)

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    ctbase_field_array, partition_field = define_ctbase_field(change_field_array)

    # �����ֶ�
    for field in ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        # print '   %s,%s,%s,%s,%s,%s,%s,%s,%s,%s' % (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split)
        xml += '''        
            <column col_name="%s">
                <type>DataType.VARCHAR</type>
                <length>%s</length>
                <describe>%s</describe>
            </column>
''' % (field_en, field_length, field_cn)

    xml += u'        </columns>\n        <indexs>\n'

    # ����������
    index_map = {}
    for field in ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        if index_describe == '': continue

        index_describe_array = index_describe.split(':')

        index_name = index_describe_array[0]
        if len(index_describe_array) == 1:
            index_seq = 1
        else:
            index_seq = index_describe_array[1]

        if index_name in index_map.keys():
            index_array = index_map[index_name]
        else:
            index_array = []
            index_map[index_name] = index_array

        index_array.append((index_seq, field_en, index_function, index_split))
    
    # ��������
    pk_index_array = index_map["PK"]
    pk_index_array.sort()
    # ����������������ֶ�
    if "ALL" in index_map.keys():
        all_index_array = index_map["ALL"]

    many_index_list = []
    for index_name, index_array in index_map.items():
        if index_name in ("PK", "ALL"): continue
        # �������ж���������ͬӵ�е���
        if 'all_index_array' in locals():
            index_array.extend(all_index_array)
        index_array.sort()

        many_index_list.append((index_name, index_array))

    # ���ɽ�����ʹ�õ�XML
    many_index_list.sort()
    many_index_list.insert(0, ('PK', pk_index_array))
    for (index_name, index_array) in many_index_list:
        # print index_name, index_array
        xml += '            <index name="%s">\n' % index_name
        for index_desc in index_array:
            (index_seq, field_en, index_function, index_split) = index_desc
            if int(index_seq) == 1:
                if index_function == '': 
                    index_function = 'reverse(%s,2)' % field_en
                if index_split == '':
                    index_split = '0,1,2,3,4,5,6,7,8,9'

            xml += '                <column col_name="%s">\n' % field_en
            xml += '                    <function>%s</function>\n' % index_function
            xml += '                    <splitkey>%s</splitkey>\n' % index_split
            xml += '                </column>\n'
        xml += '            </index>\n'

    xml += '''        </indexs>
    </userTable>
</table>'''

    if not os.path.exists('./ctbase_create'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./ctbase_create')

    f = open(r'./ctbase_create/%s.xml' % table_en, 'w')
    f.write(xml.encode('utf-8'))
    f.close()


#���ɽ�CTBase���XML�ļ�
def build_ctbase_load_script(table_en, table_cn, field_array):
    hiveTable = 'CT_%s' % table_en

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    ctbase_field_array, partition_field = define_ctbase_field(change_field_array)
    
    i = 0
    partition = ""
    field_str = ""
    for field in ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field
        if index_describe != '':
            index_describe_array = index_describe.split(':')

            index_name = index_describe_array[0]
            if len(index_describe_array) == 1:
                index_seq = 1
            else:
                index_seq = int(index_describe_array[1])

            # �Ƕ���������һ���ֶΣ�������Ϊ��ʱת�����
            if index_name not in ('PK', 'ALL') and index_seq == 1:
                field_en = 'ts150_Empty2Random(%s)' % field_en

        i += 1
        if i % 5 == 0: field_str += '\n           '
        field_str += field_en + ','

    # ʵ��������������
    entity_condition = "";
    if table_en[-2:] in ("_H", 'SH'):
        entity_condition = '''
       OR (%s='29991231'
           AND P9_START_DATE='${log_date}'
          )''' % partition_field

    # ȥ��field_str���һ��,
    field_str = field_str[:-1]

    script = u'''#!/bin/sh
######################################################
#   ��Hive�ϵ�%(en)s���뵽CTBase��
#                   wuzhaohui@tienon.com
######################################################

#���û���Shell������
source /home/ap/dip/appjob/shelljob/TS150/case_trace/case_trace_base.sh

#���������в���
logdate_arg $*

export_from_hive()
{
    # %(en)s��: %(cn)s
    $hdsrun hdsHive USERNAME:$hadoop_user,INSTANCEID:EXPORT-%(en)s-${log_date}-0001 <<!

    use ts150;

    INSERT OVERWRITE DIRECTORY 'case_trace/%(en)s'
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' WITH SERDEPROPERTIES('serialization.null.format'='')
    SELECT %(field)s
    FROM %(en)s_SHORT
    WHERE %(partition)s='${log_date}' %(entity_condition)s;
!
}

import_to_ctbase()
{
    $hdsrun hbaseBatchLoader USERNAME:$hadoop_user,INSTANCEID:IMPORT-%(en)s-${log_date}-0001 SYS_NAME:TS150,TRDBEGDATE:${log_date},TRDENDDATE:${log_date},DATA_DATE:${log_date},ORG:000000000,INPUT:case_trace/%(en)s/,CLUSTERTABLE:%(en)s_CLUS,USERTABLE:%(table_en)s
}

export_from_hive
import_to_ctbase
''' % {'en':hiveTable, 'cn':table_cn, 'table_en':table_en, 'field':field_str, 
        'partition':partition_field, 'entity_condition':entity_condition}

    if not os.path.exists('./ctbase_load'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./ctbase_load')

    f = open(r'./ctbase_load/%s.sh' % table_en, 'w')
    f.write(script.encode('utf-8'))
    f.close()


def build_makefile(table_list):
    f = open(r'./ctbase_create/makefile.ct', 'w')
    for table_en in table_list:
        f.write('\tjava $(opt_cp) TsUtil TS150 %s\n' % table_en.upper().encode('utf-8'))

    f.write('\n\n')
    for table_en in table_list:
        f.write('hadoop fs -mkdir $hdfsinput/%s\n' % table_en.upper().encode('utf-8'))
        f.write('hadoop fs -chmod -R 755 $hdfsinput/%s\n' % table_en.upper().encode('utf-8'))

    f.write('\n\n')
    for table_en in table_list:
        f.write('beeline -f CREATE_%s.sql\n' % table_en.upper().encode('utf-8'))

    f.write('\n\n')
    entity_list = ''
    detail_list = ''
    for table_en in table_list:
        if table_en[-2:] == '_A' or table_en in ('T0281_S11T1_BILL_DTL_H', 'T0281_S11T1_BIL_DSP_D0_H'):
            detail_list += '%s ' % table_en
        else:
            entity_list += '%s ' % table_en
        
    f.write('entity_list="%s"\n' % entity_list)
    f.write('detail_list="%s"\n' % detail_list)

    f.close()


#���� ����ű� Hive��CTBase��������
def build_hive_entity_history_create_sql(table_en, table_cn, field_array):

    partition = ""
    add_partition = ""

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    ctbase_field_array, partition_field = define_ctbase_field(change_field_array)

    # ��Hive���ų� �����ֶ�
    # for i in range(len(ctbase_field_array)):
    #     (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = ctbase_field_array[i]
    #     if field_en == partition_field:
    #         # print i, field_en
    #         del ctbase_field_array[i]
    #         break

    # ���� Hive�� ֻ����CTBase�ֶ�
    table_columns = "\n"
    for field in ctbase_field_array:
        (field_en, field_cn, field_type, field_length, field_is_pk, field_is_dk, field_to_ctbase, index_describe, index_function, index_split) = field

        # ���һ�в���,
        if field == ctbase_field_array[-1]:
            field_line = "   %-30s string\n" % (field_en)
        else:
            field_line = "   %-30s string,\n" % (field_en)

        table_columns += field_line

    # print table_columns
 
    # �����ֶβ������ֶ��б���
    partition_field = 'DATA_TYPE'
    if partition_field != "":
        partition = 'PARTITIONED BY (%s string)' % partition_field
        add_partition = "ALTER TABLE CT_%s_MID ADD PARTITION(%s='SRC');\n" % (table_en, partition_field)
        add_partition += "ALTER TABLE CT_%s_MID ADD PARTITION(%s='CUR_NO_DUP');\n" % (table_en, partition_field)
        add_partition += "ALTER TABLE CT_%s_MID ADD PARTITION(%s='PRE_NO_DUP');\n" % (table_en, partition_field)

    sql = u'''use ts150;

-- ������ԴHive����ű�
-- %(cn)s: %(en)s

DROP TABLE IF EXISTS CT_%(en)s_MID;

CREATE TABLE IF NOT EXISTS CT_%(en)s_MID (%(cols)s)
%(partition)s
STORED AS ORC;\n

%(add_partition)s

DROP TABLE IF EXISTS CT_%(en)s_SHORT;

CREATE TABLE IF NOT EXISTS CT_%(en)s_SHORT (%(cols)s)
STORED AS ORC;\n

''' % {'en':table_en, 'cn':table_cn, 'cols':table_columns,
       'partition':partition, 'add_partition':add_partition}

    if not os.path.exists('./hive_create'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./hive_create')

    f = open(r'./hive_create/CREATE_%s_SHORT.sql' % table_en, 'w')
    f.write(sql.encode('utf-8'))
    f.close()


#�ؽ�ʵ�������
def build_hive_entity_history_insert_sql(table_en, table_cn, field_array):


    partition = ""
    add_partition = ""

    # ��Դ���ֶ�ɸѡ
    change_field_array = define_change_field(field_array)
    ctbase_field_array, partition_field = define_ctbase_field(change_field_array)
    partition_field = 'DATA_TYPE'

    #��Hive���ų� P9_START_DATE P9_END_DATE
    # ���� ʵ���������ֶ�
    main_fields = []
    all_fields = []
    pk_fields = []
    for field in ctbase_field_array:
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



    sql = u'''use ts150;
-- %(cn)s ��������

-- ���������ⲿ����
ALTER TABLE CT_TMP_%(en)s SET LOCATION 'hdfs://hacluster/bigdata/input/TS150/case_trace/%(en)s/${log_date}/';

-- ������Դ����
INSERT OVERWRITE TABLE CT_%(en)s_MID PARTITION(%(partition)s='SRC')
SELECT 
%(cols)s
 FROM CT_TMP_%(en)s a;

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
''' % {'en':table_en, 'cn':table_cn, 'cols':table_columns, 'flat_cols':table_flat_columns,
       'partition':partition_field, 'pk':pk_flat_columns}

    if not os.path.exists('./hive_insert'):  #Ŀ¼�����ڣ����½�
        os.mkdir('./hive_insert')

    f = open(r'./hive_insert/INSERT_%s_SHORT.sql' % table_en, 'w')
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

    f = open(r'./hive_insert/INSERT_%s_SHORT.sh' % table_en, 'w')
    f.write(shell.encode('utf-8'))
    f.close()


def main():
    table_sheet, field_sheet = read_excel()
    table_map = read_table_name(table_sheet)
    table_field_map = read_field_name(field_sheet)

    table_list = [
        #��˽�ͻ���Ϣ
        'T0042_TBPC1010_H', 'T0042_TBPC9030_H', 'T0042_TBPC1510_H', 
        #ECTIP
        'TODEC_TRAD_FLOW_A', 'TODEC_QUERY_TRAD_FLOW_A', 'TODEC_LOGIN_TRAD_FLOW_A',
        #CCBS ATM
        'TODDC_CRATMATM_SH', 'TODDC_CRATMDET_A',
        #CCBS POS
        'TODDC_CRPOSPOS_H', 'TODDC_CRDETDET_A',
        #CCBS ����
        'TODDC_CRCRDCRD_H', 'TODDC_SAACNACN_H',
        #CCBS ��ϸ��ˮ
        'TODDC_SAACNTXN_A', 'TODDC_SAETXETX_A',
        #CCBS ��Ա  
        'TODDC_FCMTLR0_H', 
        #������������ϵ��Ա��
        'T0651_CCBINS_INF_H', 'T0651_CCBINS_REL_H', 'T0861_EMPE_H',
        #���ÿ�
        'T0281_TBB1PLT0_H', 'T0281_S11T1_BILL_DTL_H', 'T0281_S11T1_BIL_DSP_D0_H'
        ]


    for table_en in table_list:
        table_en = table_en.upper()
        table_cn = table_map[table_en]
        field_array = table_field_map[table_en]

        # print '%s:%s' % (table_en, table_cn)

        #����CTBase�ű�
        build_ctbase_create_xml(table_en, table_cn, field_array)
        build_ctbase_load_script(table_en, table_cn, field_array)
        #���ɽ�Hive���SQL�ű��ļ�
        build_hive_create_sql(table_en, table_cn, field_array)

        if table_en[-2:] == '_A' or table_en in ('T0281_S11T1_BILL_DTL_H', 'T0281_S11T1_BIL_DSP_D0_H'):
            build_hive_detail_insert_sql(table_en, table_cn, field_array)
            pass
        else:
            # print '%s:%s' % (table_en, table_cn)
            build_hive_entity_insert_sql(table_en, table_cn, field_array)

            # ����������
            build_hive_entity_history_create_sql(table_en, table_cn, field_array)
            build_hive_entity_history_insert_sql(table_en, table_cn, field_array)

    # build_makefile(table_list)


if __name__ == '__main__':
    main()
    # a = ['1', '2', '3']
    # b = ['  %s' % x for x in a]

    # print ','.join(b)