use sor;

-- Hive建表脚本
-- CCBS 综合前置系统 无卡异地查询分析表


--(1)通过卡号获取开卡机构
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_OPENORG;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_OPENORG(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,

  CARD_BRANCH STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;


--(2)行为异地的查询
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_NOSAME;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_NOSAME(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,

  CARD_BRANCH STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;



--(3)不在排队机系统的日志信息
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_NOQUEUE;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_NOQUEUE(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,  

  CARD_BRANCH STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;


--(4)获取客户卡开户行机构名称
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_CARD_BRANCH;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_CARD_BRANCH(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,
  
  
  CARD_BRANCH STRING,
  CARD_BRANCH_NM STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;


--(5)获取添加柜员身份证号
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_OPER_PASSNUM;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_OPER_PASSNUM(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,


  
  CARD_BRANCH STRING,
  CARD_BRANCH_NM STRING,
  CM_ID_NO STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;



--(6)获取员工名称与员工所在机构名称
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_OPER_INFO;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_OPER_INFO(
  QUE_DATE STRING,
  QUERY_ORG STRING,
  QUE_TIME STRING,
  TLR_ID STRING,
  CARD_NO STRING,
  CUST_NO STRING,
  CRDT_NO STRING,
  
   CARD_BRANCH STRING,
   CARD_BRANCH_NM STRING,
   CM_ID_NO STRING,
   CM_OPR_NAME STRING,
   CM_OPUN_CODE STRING,
   CCBINS_CHN_SHRTNM STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;


--(7)获取父机构号
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_OPER_PARENT;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_OPER_PARENT(
   QUE_DATE STRING,
   QUE_TIME STRING,
   TLR_ID STRING,
   CM_ID_NO STRING,
   CM_OPR_NAME STRING,
   QUERY_ORG STRING,
   CM_OPUN_CODE STRING,
   CCBINS_CHN_SHRTNM STRING, 
   PARENT_ID STRING,
   PARENT_CHN_SHRTNM,
   CARD_NO STRING,
   CARD_BRANCH STRING,
   CARD_BRANCH_NM STRING,
   CUST_NO STRING,
   CRDT_NO STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;

--(8)过滤掉没有在ATM，非账务等交易的信息
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_NOTXN;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_NOTXN(
  QUE_DATE STRING,
   QUE_TIME STRING,
   TLR_ID STRING,
   CM_ID_NO STRING,
   CM_OPR_NAME STRING,
   QUERY_ORG STRING,
   CM_OPUN_CODE STRING,
   CCBINS_CHN_SHRTNM STRING, 
   PARENT_ID STRING,
   PARENT_CHN_SHRTNM,
   CARD_NO STRING,
   CARD_BRANCH STRING,
   CARD_BRANCH_NM STRING,
   CUST_NO STRING,
   CRDT_NO STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;


--(10)按日期统计
DROP TABLE IF EXISTS ILLEGAL_CCBS_ZHQZ_A;

CREATE EXTERNAL TABLE IF NOT EXISTS ILLEGAL_CCBS_ZHQZ_A(
   QUE_DATE STRING,
   TLR_ID STRING,
   CM_ID_NO STRING,
   CM_OPR_NAME STRING,
   QUERY_ORG STRING,
   CM_OPUN_CODE STRING,
   CCBINS_CHN_SHRTNM STRING,
   PARENT_ID STRING,
   PARENT_CHN_SHRTNM STRING,
   NUM STRING
)
PARTITIONED BY (P9_DATA_DATE string)
STORED AS ORC;
