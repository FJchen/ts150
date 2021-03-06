use sor;
-- 客户基本信息 T0042_TBPC1010_H 拉链处理

-- 复制贴源数据
INSERT OVERWRITE TABLE INN_T0042_TBPC1010_H_MID PARTITION(DATA_TYPE='SRC')
SELECT 
       -- 客户编号
       a.CST_ID,
       -- 个人法定名称
       a.IDV_LGL_NM,
       -- 证件类型代码
       a.CRDT_TPCD,
       -- 证件号码
       a.CRDT_NO,
       -- 出生日期
       a.BRTH_DT,
       -- 性别代码
       a.GND_CD,
       -- 国籍代码
       a.NAT_CD,
       -- 居住国代码
       a.RSDNC_NAT_CD,
       -- 首选语言代码
       a.PREF_LNG_CD,
       -- 户籍行政区划代码
       a.HSHLDRGST_ADIV_CD,
       -- 婚姻状况代码
       a.MAR_STTN_CD,
       -- 子女状况代码
       a.CHL_STTN_CD,
       -- 民族代码
       a.ETHNCT_CD,
       -- 宗教信仰代码
       a.RLG_CD,
       -- 政治面貌代码
       a.PLTCLPARTY_CD,
       -- 生命周期状态代码
       a.LCS_CD,
       -- 所属机构编号
       a.BLNG_INSID,
       -- 建行员工标志
       a.CCB_EMPE_IND,
       -- 计划财务有效客户标志
       a.PLN_FNC_EFCT_IND,
       -- 重要人士标志
       a.IMPT_PSNG_IND,
       -- 潜力VIP标志
       a.PTNL_VIP_IND,
       -- 特殊vip标志
       a.SPCLVIP_IND,
       -- 系统评定客户等级代码
       a.STM_EVL_CST_GRD_CD,
       -- 手工评定客户等级代码
       a.MNUL_EVL_CST_GRD_CD,
       -- 私人银行客户等级代码
       a.PRVT_BNK_CST_GRD_CD,
       -- 私人银行签约客户标志
       a.PRVT_BNK_SIGN_CST_IND,
       -- 月收入金额
       a.MO_INCMAM,
       -- 客户经理编号
       a.CSTMGR_ID,
       -- 最佳联系电话
       a.BEST_CTC_TEL,
       -- 企业高级管理人员标志
       a.ENTP_ADV_MGTPPL_IND,
       -- 企业实际控制人标志
       a.ENTP_ACT_CTRL_PSN_IND,
       -- 企业法人标志
       a.ENLGPS_IND,
       -- 非居民标志
       a.NON_RSDNT_IND,
       -- 工作单位性质代码
       a.WRK_UNIT_CHAR_CD,
       -- P9开始日期
       a.P9_START_DATE,
       -- P9结束日期
       a.P9_END_DATE
  FROM EXT_T0042_TBPC1010_H a
 WHERE LOAD_DATE='${log_date}';

-- 去重
INSERT OVERWRITE TABLE CT_T0042_TBPC1010_H_MID PARTITION(DATA_TYPE='CUR_NO_DUP')
SELECT 
       -- 客户编号
       a.CST_ID,
       -- 个人法定名称
       a.IDV_LGL_NM,
       -- 证件类型代码
       a.CRDT_TPCD,
       -- 证件号码
       a.CRDT_NO,
       -- 出生日期
       a.BRTH_DT,
       -- 性别代码
       a.GND_CD,
       -- 国籍代码
       a.NAT_CD,
       -- 居住国代码
       a.RSDNC_NAT_CD,
       -- 首选语言代码
       a.PREF_LNG_CD,
       -- 户籍行政区划代码
       a.HSHLDRGST_ADIV_CD,
       -- 婚姻状况代码
       a.MAR_STTN_CD,
       -- 子女状况代码
       a.CHL_STTN_CD,
       -- 民族代码
       a.ETHNCT_CD,
       -- 宗教信仰代码
       a.RLG_CD,
       -- 政治面貌代码
       a.PLTCLPARTY_CD,
       -- 生命周期状态代码
       a.LCS_CD,
       -- 所属机构编号
       a.BLNG_INSID,
       -- 建行员工标志
       a.CCB_EMPE_IND,
       -- 计划财务有效客户标志
       a.PLN_FNC_EFCT_IND,
       -- 重要人士标志
       a.IMPT_PSNG_IND,
       -- 潜力VIP标志
       a.PTNL_VIP_IND,
       -- 特殊vip标志
       a.SPCLVIP_IND,
       -- 系统评定客户等级代码
       a.STM_EVL_CST_GRD_CD,
       -- 手工评定客户等级代码
       a.MNUL_EVL_CST_GRD_CD,
       -- 私人银行客户等级代码
       a.PRVT_BNK_CST_GRD_CD,
       -- 私人银行签约客户标志
       a.PRVT_BNK_SIGN_CST_IND,
       -- 月收入金额
       a.MO_INCMAM,
       -- 客户经理编号
       a.CSTMGR_ID,
       -- 最佳联系电话
       a.BEST_CTC_TEL,
       -- 企业高级管理人员标志
       a.ENTP_ADV_MGTPPL_IND,
       -- 企业实际控制人标志
       a.ENTP_ACT_CTRL_PSN_IND,
       -- 企业法人标志
       a.ENLGPS_IND,
       -- 非居民标志
       a.NON_RSDNT_IND,
       -- 工作单位性质代码
       a.WRK_UNIT_CHAR_CD,
       -- P9开始日期
       a.P9_START_DATE,
       -- P9结束日期
       a.P9_END_DATE
  FROM (SELECT , P9_START_DATE, P9_END_DATE,
               row_number() over (
                    partition by 
                    order by P9_START_DATE
                   ) rownum
         FROM CT_T0042_TBPC1010_H_MID 
        WHERE DATA_TYPE in ('SRC', 'PRE_NO_DUP') 
        ) a
 WHERE a.rownum = 1;

-- Hive动态分区参数设置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=strick;

-- 重建拉链
INSERT OVERWRITE TABLE CT_T0042_TBPC1010_H PARTITION(P9_END_DATE)
SELECT , P9_START_DATE, 
       lead(P9_START_DATE, 1, '29991231') over (partition by CST_ID order by P9_START_DATE) as P9_END_DATE
  FROM CT_T0042_TBPC1010_H_MID
 WHERE DATA_TYPE='CUR_NO_DUP';

------------ 以下操作可以导致数据丢失 ---------------
-- 备份当前非重复数据 到 PRE_NO_DUP 分区
ALTER TABLE CT_T0042_TBPC1010_H_MID DROP IF EXISTS PARTITION(DATA_TYPE='PRE_NO_DUP');

ALTER TABLE CT_T0042_TBPC1010_H_MID PARTITION(DATA_TYPE='CUR_NO_DUP') 
   RENAME TO PARTITION(DATA_TYPE='PRE_NO_DUP');

ALTER TABLE CT_T0042_TBPC1010_H_MID ADD IF NOT EXISTS PARTITION(DATA_TYPE='CUR_NO_DUP');
