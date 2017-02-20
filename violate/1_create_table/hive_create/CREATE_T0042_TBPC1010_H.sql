use sor;

-- Hive建表脚本
-- 客户基本信息: T0042_TBPC1010_H

-- 外部表
DROP TABLE IF EXISTS EXT_T0042_TBPC1010_H;

CREATE EXTERNAL TABLE IF NOT EXISTS EXT_T0042_TBPC1010_H(
  -- 客户编号
   CST_ID                         string,
  -- #记录失效时间戳
   RCRD_EXPY_TMS                  string,
  -- #多实体标识
   MULTI_TENANCY_ID               string,
  -- 个人法定名称
   IDV_LGL_NM                     string,
  -- 个人姓名拼音全称
   IDV_NM_CPA_FULLNM              string,
  -- 证件类型代码
   CRDT_TPCD                      string,
  -- 证件号码
   CRDT_NO                        string,
  -- 出生日期
   BRTH_DT                        string,
  -- 性别代码
   GND_CD                         string,
  -- 国籍代码
   NAT_CD                         string,
  -- 居住国代码
   RSDNC_NAT_CD                   string,
  -- 首选语言代码
   PREF_LNG_CD                    string,
  -- 户籍行政区划代码
   HSHLDRGST_ADIV_CD              string,
  -- 婚姻状况代码
   MAR_STTN_CD                    string,
  -- 子女状况代码
   CHL_STTN_CD                    string,
  -- 民族代码
   ETHNCT_CD                      string,
  -- 宗教信仰代码
   RLG_CD                         string,
  -- 政治面貌代码
   PLTCLPARTY_CD                  string,
  -- 生命周期状态代码
   LCS_CD                         string,
  -- 所属机构编号
   BLNG_INSID                     string,
  -- 建行员工标志
   CCB_EMPE_IND                   string,
  -- 计划财务有效客户标志
   PLN_FNC_EFCT_IND               string,
  -- 重要人士标志
   IMPT_PSNG_IND                  string,
  -- 潜力VIP标志
   PTNL_VIP_IND                   string,
  -- 特殊vip标志
   SPCLVIP_IND                    string,
  -- 系统评定客户等级代码
   STM_EVL_CST_GRD_CD             string,
  -- 手工评定客户等级代码
   MNUL_EVL_CST_GRD_CD            string,
  -- 私人银行客户等级代码
   PRVT_BNK_CST_GRD_CD            string,
  -- 私人银行签约客户标志
   PRVT_BNK_SIGN_CST_IND          string,
  -- 月收入金额
   MO_INCMAM                      string,
  -- 客户经理编号
   CSTMGR_ID                      string,
  -- 最佳联系时间代码
   BEST_CTC_TM_CD                 string,
  -- 最佳联系方式代码
   BEST_CTC_MTDCD                 string,
  -- 特殊名单标志
   SPNMLT_IND                     string,
  -- 关联方标志
   RELPARTY_IND                   string,
  -- 监管认定关联方标志
   REG_AFM_RELPARTY_IND           string,
  -- 电话类型代码
   TEL_TPCD                       string,
  -- 最佳联系电话
   BEST_CTC_TEL                   string,
  -- 一级分行号
   LV1_BR_NO                      string,
  -- 偏好寄送方式代码
   PREF_MSND_MTDCD                string,
  -- 接收邮寄地址类型代码
   RCV_MAIL_ADR_TPCD              string,
  -- 企业高级管理人员标志
   ENTP_ADV_MGTPPL_IND            string,
  -- 企业实际控制人标志
   ENTP_ACT_CTRL_PSN_IND          string,
  -- 企业法人标志
   ENLGPS_IND                     string,
  -- 客户渠道商机标志
   CST_CHNL_BSOP_IND              string,
  -- #员工渠道商机标志
   EMPCHNL_BSOP_IND               string,
  -- 个人客户AUM余额
   IDCST_AUM_BAL                  string,
  -- #多实体标志
   MT_ENT_IND                     string,
  -- 非居民标志
   NON_RSDNT_IND                  string,
  -- 工作单位性质代码
   WRK_UNIT_CHAR_CD               string,
  -- 工作单位名称
   WRK_UNIT_NM                    string,
  -- #备用字段1信息
   RSRV_FLD1_INF                  string,
  -- #备用字段2信息
   RSRV_FLD2_INF                  string,
  -- #备用字段3信息
   RSRV_FLD3_INF                  string,
  -- 创建机构编号
   CRT_INSID                      string,
  -- 创建员工编号
   CRT_EMPID                      string,
  -- TODDC_CRATMDET_A
   LAST_UDT_INSID                 string,
  -- TODDC_CRATMDET_A
   LAST_UDT_EMPID                 string,
  -- #当前系统创建时间戳
   CUR_STM_CRT_TMS                string,
  -- #当前系统更新时间戳
   CUR_STM_UDT_TMS                string,
  -- #本地年月日
   LCL_YRMO_DAY                   string,
  -- #本地时分秒
   LCL_HR_GRD_SCND                string,
  -- #创建系统号
   CRT_STM_NO                     string,
  -- #更新系统号
   UDT_STM_NO                     string,
  -- #源系统创建时间戳
   SRCSYS_CRT_TMS                 string,
  -- #源系统更新时间戳
   SRCSYS_UDT_TMS                 string,
  -- P9开始日期
   P9_START_DATE                  string,
  -- P9_START_BATCH
   P9_START_BATCH                 string,
  -- P9结束日期
   P9_END_DATE                    string,
  -- P9_END_BATCH
   P9_END_BATCH                   string,
  -- P9_DEL_FLAG
   P9_DEL_FLAG                    string,
  -- P9_JOB_NAME
   P9_JOB_NAME                    string
)
STORED AS TEXTFILE
PARTITIONED BY (LOAD_DATE string);

-- ORC内部表，节约存储空间
DROP TABLE IF EXISTS INN_T0042_TBPC1010_H;

CREATE TABLE IF NOT EXISTS INN_T0042_TBPC1010_H(
   -- 客户编号
   CST_ID                         string,
   -- #记录失效时间戳
   RCRD_EXPY_TMS                  string,
   -- #多实体标识
   MULTI_TENANCY_ID               string,
   -- 个人法定名称
   IDV_LGL_NM                     string,
   -- 个人姓名拼音全称
   IDV_NM_CPA_FULLNM              string,
   -- 证件类型代码
   CRDT_TPCD                      string,
   -- 证件号码
   CRDT_NO                        string,
   -- 出生日期
   BRTH_DT                        string,
   -- 性别代码
   GND_CD                         string,
   -- 国籍代码
   NAT_CD                         string,
   -- 居住国代码
   RSDNC_NAT_CD                   string,
   -- 首选语言代码
   PREF_LNG_CD                    string,
   -- 户籍行政区划代码
   HSHLDRGST_ADIV_CD              string,
   -- 婚姻状况代码
   MAR_STTN_CD                    string,
   -- 子女状况代码
   CHL_STTN_CD                    string,
   -- 民族代码
   ETHNCT_CD                      string,
   -- 宗教信仰代码
   RLG_CD                         string,
   -- 政治面貌代码
   PLTCLPARTY_CD                  string,
   -- 生命周期状态代码
   LCS_CD                         string,
   -- 所属机构编号
   BLNG_INSID                     string,
   -- 建行员工标志
   CCB_EMPE_IND                   string,
   -- 计划财务有效客户标志
   PLN_FNC_EFCT_IND               string,
   -- 重要人士标志
   IMPT_PSNG_IND                  string,
   -- 潜力VIP标志
   PTNL_VIP_IND                   string,
   -- 特殊vip标志
   SPCLVIP_IND                    string,
   -- 系统评定客户等级代码
   STM_EVL_CST_GRD_CD             string,
   -- 手工评定客户等级代码
   MNUL_EVL_CST_GRD_CD            string,
   -- 私人银行客户等级代码
   PRVT_BNK_CST_GRD_CD            string,
   -- 私人银行签约客户标志
   PRVT_BNK_SIGN_CST_IND          string,
   -- 月收入金额
   MO_INCMAM                      string,
   -- 客户经理编号
   CSTMGR_ID                      string,
   -- 最佳联系时间代码
   BEST_CTC_TM_CD                 string,
   -- 最佳联系方式代码
   BEST_CTC_MTDCD                 string,
   -- 特殊名单标志
   SPNMLT_IND                     string,
   -- 关联方标志
   RELPARTY_IND                   string,
   -- 监管认定关联方标志
   REG_AFM_RELPARTY_IND           string,
   -- 电话类型代码
   TEL_TPCD                       string,
   -- 最佳联系电话
   BEST_CTC_TEL                   string,
   -- 一级分行号
   LV1_BR_NO                      string,
   -- 偏好寄送方式代码
   PREF_MSND_MTDCD                string,
   -- 接收邮寄地址类型代码
   RCV_MAIL_ADR_TPCD              string,
   -- 企业高级管理人员标志
   ENTP_ADV_MGTPPL_IND            string,
   -- 企业实际控制人标志
   ENTP_ACT_CTRL_PSN_IND          string,
   -- 企业法人标志
   ENLGPS_IND                     string,
   -- 客户渠道商机标志
   CST_CHNL_BSOP_IND              string,
   -- #员工渠道商机标志
   EMPCHNL_BSOP_IND               string,
   -- 个人客户AUM余额
   IDCST_AUM_BAL                  string,
   -- #多实体标志
   MT_ENT_IND                     string,
   -- 非居民标志
   NON_RSDNT_IND                  string,
   -- 工作单位性质代码
   WRK_UNIT_CHAR_CD               string,
   -- 工作单位名称
   WRK_UNIT_NM                    string,
   -- #备用字段1信息
   RSRV_FLD1_INF                  string,
   -- #备用字段2信息
   RSRV_FLD2_INF                  string,
   -- #备用字段3信息
   RSRV_FLD3_INF                  string,
   -- 创建机构编号
   CRT_INSID                      string,
   -- 创建员工编号
   CRT_EMPID                      string,
   -- TODDC_CRATMDET_A
   LAST_UDT_INSID                 string,
   -- TODDC_CRATMDET_A
   LAST_UDT_EMPID                 string,
   -- #当前系统创建时间戳
   CUR_STM_CRT_TMS                string,
   -- #当前系统更新时间戳
   CUR_STM_UDT_TMS                string,
   -- #本地年月日
   LCL_YRMO_DAY                   string,
   -- #本地时分秒
   LCL_HR_GRD_SCND                string,
   -- #创建系统号
   CRT_STM_NO                     string,
   -- #更新系统号
   UDT_STM_NO                     string,
   -- #源系统创建时间戳
   SRCSYS_CRT_TMS                 string,
   -- #源系统更新时间戳
   SRCSYS_UDT_TMS                 string,
   -- P9开始日期
   P9_START_DATE                  string,
   -- P9结束日期
   P9_END_DATE                    string
)
PARTITIONED BY (LOAD_DATE string)
STORED AS ORC;


-- 拉链表中间数据
DROP TABLE IF EXISTS CT_T0042_TBPC1010_H_MID;

CREATE TABLE IF NOT EXISTS CT_T0042_TBPC1010_H_MID (
   -- 客户编号
   CST_ID                         string,
   -- 个人法定名称
   IDV_LGL_NM                     string,
   -- 证件类型代码
   CRDT_TPCD                      string,
   -- 证件号码
   CRDT_NO                        string,
   -- 出生日期
   BRTH_DT                        string,
   -- 性别代码
   GND_CD                         string,
   -- 国籍代码
   NAT_CD                         string,
   -- 居住国代码
   RSDNC_NAT_CD                   string,
   -- 首选语言代码
   PREF_LNG_CD                    string,
   -- 户籍行政区划代码
   HSHLDRGST_ADIV_CD              string,
   -- 婚姻状况代码
   MAR_STTN_CD                    string,
   -- 子女状况代码
   CHL_STTN_CD                    string,
   -- 民族代码
   ETHNCT_CD                      string,
   -- 宗教信仰代码
   RLG_CD                         string,
   -- 政治面貌代码
   PLTCLPARTY_CD                  string,
   -- 生命周期状态代码
   LCS_CD                         string,
   -- 所属机构编号
   BLNG_INSID                     string,
   -- 建行员工标志
   CCB_EMPE_IND                   string,
   -- 计划财务有效客户标志
   PLN_FNC_EFCT_IND               string,
   -- 重要人士标志
   IMPT_PSNG_IND                  string,
   -- 潜力VIP标志
   PTNL_VIP_IND                   string,
   -- 特殊vip标志
   SPCLVIP_IND                    string,
   -- 系统评定客户等级代码
   STM_EVL_CST_GRD_CD             string,
   -- 手工评定客户等级代码
   MNUL_EVL_CST_GRD_CD            string,
   -- 私人银行客户等级代码
   PRVT_BNK_CST_GRD_CD            string,
   -- 私人银行签约客户标志
   PRVT_BNK_SIGN_CST_IND          string,
   -- 月收入金额
   MO_INCMAM                      string,
   -- 客户经理编号
   CSTMGR_ID                      string,
   -- 最佳联系电话
   BEST_CTC_TEL                   string,
   -- 企业高级管理人员标志
   ENTP_ADV_MGTPPL_IND            string,
   -- 企业实际控制人标志
   ENTP_ACT_CTRL_PSN_IND          string,
   -- 企业法人标志
   ENLGPS_IND                     string,
   -- 非居民标志
   NON_RSDNT_IND                  string,
   -- 工作单位性质代码
   WRK_UNIT_CHAR_CD               string,
   -- P9开始日期
   P9_START_DATE                  string,
   -- P9结束日期
   P9_END_DATE                    string
)
PARTITIONED BY (DATA_TYPE string)
STORED AS ORC;

ALTER TABLE CT_T0042_TBPC1010_H_MID ADD PARTITION(DATA_TYPE='SRC');
ALTER TABLE CT_T0042_TBPC1010_H_MID ADD PARTITION(DATA_TYPE='CUR_NO_DUP');
ALTER TABLE CT_T0042_TBPC1010_H_MID ADD PARTITION(DATA_TYPE='PRE_NO_DUP');

-- 最终拉链表
DROP TABLE IF EXISTS CT_T0042_TBPC1010_H;

CREATE TABLE IF NOT EXISTS CT_T0042_TBPC1010_H (
   -- 客户编号
   CST_ID                         string,
   -- 个人法定名称
   IDV_LGL_NM                     string,
   -- 证件类型代码
   CRDT_TPCD                      string,
   -- 证件号码
   CRDT_NO                        string,
   -- 出生日期
   BRTH_DT                        string,
   -- 性别代码
   GND_CD                         string,
   -- 国籍代码
   NAT_CD                         string,
   -- 居住国代码
   RSDNC_NAT_CD                   string,
   -- 首选语言代码
   PREF_LNG_CD                    string,
   -- 户籍行政区划代码
   HSHLDRGST_ADIV_CD              string,
   -- 婚姻状况代码
   MAR_STTN_CD                    string,
   -- 子女状况代码
   CHL_STTN_CD                    string,
   -- 民族代码
   ETHNCT_CD                      string,
   -- 宗教信仰代码
   RLG_CD                         string,
   -- 政治面貌代码
   PLTCLPARTY_CD                  string,
   -- 生命周期状态代码
   LCS_CD                         string,
   -- 所属机构编号
   BLNG_INSID                     string,
   -- 建行员工标志
   CCB_EMPE_IND                   string,
   -- 计划财务有效客户标志
   PLN_FNC_EFCT_IND               string,
   -- 重要人士标志
   IMPT_PSNG_IND                  string,
   -- 潜力VIP标志
   PTNL_VIP_IND                   string,
   -- 特殊vip标志
   SPCLVIP_IND                    string,
   -- 系统评定客户等级代码
   STM_EVL_CST_GRD_CD             string,
   -- 手工评定客户等级代码
   MNUL_EVL_CST_GRD_CD            string,
   -- 私人银行客户等级代码
   PRVT_BNK_CST_GRD_CD            string,
   -- 私人银行签约客户标志
   PRVT_BNK_SIGN_CST_IND          string,
   -- 月收入金额
   MO_INCMAM                      string,
   -- 客户经理编号
   CSTMGR_ID                      string,
   -- 最佳联系电话
   BEST_CTC_TEL                   string,
   -- 企业高级管理人员标志
   ENTP_ADV_MGTPPL_IND            string,
   -- 企业实际控制人标志
   ENTP_ACT_CTRL_PSN_IND          string,
   -- 企业法人标志
   ENLGPS_IND                     string,
   -- 非居民标志
   NON_RSDNT_IND                  string,
   -- 工作单位性质代码
   WRK_UNIT_CHAR_CD               string,
   -- P9开始日期
   P9_START_DATE                  string
)
PARTITIONED BY (P9_END_DATE string)
STORED AS ORC;