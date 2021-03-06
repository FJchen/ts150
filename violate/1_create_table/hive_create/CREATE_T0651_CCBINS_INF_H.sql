use sor;

-- Hive建表脚本
-- 建行机构信息: T0651_CCBINS_INF_H

-- 外部表
DROP TABLE IF EXISTS EXT_T0651_CCBINS_INF_H;

CREATE EXTERNAL TABLE IF NOT EXISTS EXT_T0651_CCBINS_INF_H(
  -- 建行机构编号
   CCBINS_ID                      string,
  -- 建行机构中文全称
   CCBINS_CHN_FULLNM              string,
  -- 建行机构中文简称
   CCBINS_CHN_SHRTNM              string,
  -- 建行机构英文全称
   CCBINS_ENG_FULLNM              string,
  -- 建行机构英文简称
   CCBINS_ENG_SHRTNM              string,
  -- 建行机构名称语种代码
   CCBINS_NM_LNG_CD               string,
  -- 建行机构其他语种全称
   CCBINSOTHRLNGFULL_NM           string,
  -- 建行机构类型代码
   CCBINS_TPCD                    string,
  -- 固定电话号码
   FIX_TELNO                      string,
  -- 传真电话号码
   FAX_TELNO                      string,
  -- 移动电话号码
   MOVE_TELNO                     string,
  -- 行政区划代码
   ADIV_CD                        string,
  -- 组织机构地域编号代码
   ORG_INST_RGON_ID_CD            string,
  -- 电子邮件地址内容
   EMAIL_ADR_CNTNT                string,
  -- Web地址
   WEB_ADR                        string,
  -- QQ号码
   QQ_NO                          string,
  -- MSN号码
   MSN_NO                         string,
  -- 微博地址
   MCRBLG_ADR                     string,
  -- 其他网络地址
   OTHR_NTW_ADR                   string,
  -- 人民银行金融机构编码
   PBC_FNC_INST_ECD               string,
  -- 机构撤销后归属建行机构编号
   INSTUDOAFBLGCCBINS_ID          string,
  -- 机构状态代码
   INST_STCD                      string,
  -- 机构核算层级代码
   INST_LDGR_HIER_CD              string,
  -- 工作日历编号
   WKCLD_ID                       string,
  -- 经营主体属性代码
   OPSBJ_ATTRCD                   string,
  -- 建行机构经营范围描述
   CCBINS_OPRT_SCOP_DSC           string,
  -- 金融许可证号
   FNC_LCNS_NO                    string,
  -- 营业执照号码
   BSNLCNS_NO                     string,
  -- 税务登记证号
   TAX_RGSCTF_NO                  string,
  -- 组织机构代码证件号
   ORCD_CRDT_NO                   string,
  -- 金融机构标识码
   FNC_INST_ID_CD                 string,
  -- 支付系统银行行号
   PSBC                           string,
  -- SWIFT号码
   SWIFT_NO                       string,
  -- 银联卡地区代码
   UNNPY_CRD_RGON_CD              string,
  -- 人行交换号
   PBC_EXG_NO                     string,
  -- 全国汇票机构号
   CTRYWD_DRFTBILL_INSNO          string,
  -- 全国联行号
   CTRYWD_BNKCD                   string,
  -- 编制本票密押标志
   DVPPRMSNOTETSKY_IND            string,
  -- 国内信用证议付行标志
   DMST_LC_NGTBNK_IND             string,
  -- 国内信用证通知行标志
   DMST_LC_ADVSBNK_IND            string,
  -- 国内信用证开证行标志
   DMST_LC_ISUBNK_IND             string,
  -- 对公对私证券业务标志代码
   CORPPRVTSCRTBNS_INDCD          string,
  -- 财税库行联网业务标志
   TXBSBKNTWRKGBSN_IND            string,
  -- 大额支付业务标志
   BIGAMT_PY_BSN_IND              string,
  -- 小额支付业务标志
   MICR_PY_BSN_IND                string,
  -- 支票影像业务标志
   CHK_IMG_BSN_IND                string,
  -- 跨行网银业务标志
   INTRBNK_EBNKG_BSN_IND          string,
  -- 个人住房类贷款业务标志
   IDVHSCGYLOANBSN_IND            string,
  -- 个人消费类贷款业务标志
   IDVCNSMCGYLNBSN_IND            string,
  -- 个人经营类贷款业务标志
   IDVOPRTCGYLOANBSN_IND          string,
  -- 个人公积金贷款业务标志
   IDV_PRFDLN_BSN_IND             string,
  -- 住房资金业务标志
   HS_CPTLBSN_IND                 string,
  -- 个人国际速汇业务银星标志
   IDVIEMTBSNSLVST_IND            string,
  -- 个人国际速汇业务西联标志
   IDVIEMTBSNWSTUN_IND            string,
  -- 西联汇款机构编码
   WSTUN_RMT_INST_ECD             string,
  -- 出入境服务中心标志
   EXETR_SVC_CNTR_IND             string,
  -- 个人贷款中心标志
   IDV_LOAN_CNTR_IND              string,
  -- 理财中心标志
   WLTHMGTCNTR_IND                string,
  -- 自助业务标志
   SLFSVC_BSN_IND                 string,
  -- 财富中心标志
   WLTH_CNTR_IND                  string,
  -- 提金点标志
   DRGDSPT_IND                    string,
  -- 贵金属金库标志
   PM_TRSR_IND                    string,
  -- 机构金融服务发展战略类型代码
   INSFCSVC_DPSTGTP_CD            string,
  -- 行别性质代码
   BNKCGY_CHAR_CD                 string,
  -- 机构经济区域代码
   INST_ECN_RGON_CD               string,
  -- 专线电话号码
   SPPLN_TELNO                    string,
  -- 理财柜台电话号码
   CHRTC_CNTER_TELNO              string,
  -- 建行机构行政层级代码
   CCBINS_ADMNHIER_CD             string,
  -- 责任中心类型代码
   RSPCNT_TPCD                    string,
  -- 员工人数
   EMPLNUM                        string,
  -- 机构负责人编号
   INST_PNP_ID                    string,
  -- 立档单位标志
   DOC_UNIT_IND                   string,
  -- 档案全宗编号
   FNDS_ID                        string,
  -- 建行机构其他语种简称
   CCBINSOTHRLNGSHRT_NM           string,
  -- OPICS号
   OPICS_NO                       string,
  -- POMS号
   POMS_NO                        string,
  -- 建行机构描述
   CCBINS_DSC                     string,
  -- 所在区域主要功能属性描述
   RGON_MAINFCN_ATTR_DSC          string,
  -- 所在区域次要功能属性描述
   RGON_MINRFCN_ATTR_DSC          string,
  -- 业务管理模式描述
   BSN_MGT_MODDSC                 string,
  -- 对理财中心业务指导标志
   TOWLMGCNTRBSNGD_IND            string,
  -- 离附行标志
   OFFINBNK_IND                   string,
  -- 穿墙标志
   NCLP_IND                       string,
  -- 纳税人规模代码
   TAXPYR_SZ_CD                   string,
  -- 企业规模代码
   ENTP_SZ_CD                     string,
  -- 上市企业标志
   LSTD_ENTP_IND                  string,
  -- 特殊经济区内企业标志
   SEACORP_IND                    string,
  -- 进出口权标志
   IMPEXPRGT_IND                  string,
  -- 企业环保达标标志
   ENTP_ENVPRT_CMPLN_IND          string,
  -- 建行机构总人数
   CCBINS_TOT_PNUM                string,
  -- 人行开户标志
   PBC_OPNACC_IND                 string,
  -- 建行机构注册资本金额
   CCBINSRGSTCPTLFND_AMT          string,
  -- 建行机构注册资本币种代码
   CCBINSRGSTCPTLCCY_CD           string,
  -- 建行机构主营业务描述
   CCBINS_MAINBSN_DSC             string,
  -- 建行机构兼营业务描述
   CCBINS_MIX_BSN_DSC             string,
  -- #最后更新日期时间
   LAST_UDT_DT_TM                 string,
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
   P9_JOB_NAME                    string,
  -- 建行机构成立日期
   CCBINS_ESTB_DT                 string,
  -- 机构变更日期
   INST_MDF_DT                    string,
  -- 机构撤销日期
   INST_UDO_DT                    string,
  -- 机构开始营业时间
   INST_STRT_OPRG_TM              string,
  -- 经营期限起始日期
   OPRT_TRM_STDT                  string,
  -- 经营期限结束日期
   OPRT_TRM_EDDT                  string,
  -- 开业日期
   BOPR_DT                        string,
  -- 承担费用标志
   CHRGTO_COSIND                  string,
  -- 部门主责任类型代码
   DEPT_PRIM_RSPL_TPCD            string,
  -- 电票经营权限标志
   EBILL_OPRT_AHR_IND             string,
  -- 记账标志
   BOOKENTR_IND                   string,
  -- 本部机构标志
   HDQRT_INST_IND                 string,
  -- 部门属性代码
   DEPT_ATTRCD                    string,
  -- 机构分账核算类型描述
   INST_SUBACC_LDGR_TPDS          string,
  -- HKICL分行编号
   HKICL_BR_ID                    string,
  -- HKICL银行编号
   HKICL_BNK_ID                   string
)
STORED AS TEXTFILE
PARTITIONED BY (LOAD_DATE string);

-- ORC内部表，节约存储空间
DROP TABLE IF EXISTS INN_T0651_CCBINS_INF_H;

CREATE TABLE IF NOT EXISTS INN_T0651_CCBINS_INF_H(
   -- 建行机构编号
   CCBINS_ID                      string,
   -- 建行机构中文全称
   CCBINS_CHN_FULLNM              string,
   -- 建行机构中文简称
   CCBINS_CHN_SHRTNM              string,
   -- 建行机构英文全称
   CCBINS_ENG_FULLNM              string,
   -- 建行机构英文简称
   CCBINS_ENG_SHRTNM              string,
   -- 建行机构名称语种代码
   CCBINS_NM_LNG_CD               string,
   -- 建行机构其他语种全称
   CCBINSOTHRLNGFULL_NM           string,
   -- 建行机构类型代码
   CCBINS_TPCD                    string,
   -- 固定电话号码
   FIX_TELNO                      string,
   -- 传真电话号码
   FAX_TELNO                      string,
   -- 移动电话号码
   MOVE_TELNO                     string,
   -- 行政区划代码
   ADIV_CD                        string,
   -- 组织机构地域编号代码
   ORG_INST_RGON_ID_CD            string,
   -- 电子邮件地址内容
   EMAIL_ADR_CNTNT                string,
   -- Web地址
   WEB_ADR                        string,
   -- QQ号码
   QQ_NO                          string,
   -- MSN号码
   MSN_NO                         string,
   -- 微博地址
   MCRBLG_ADR                     string,
   -- 其他网络地址
   OTHR_NTW_ADR                   string,
   -- 人民银行金融机构编码
   PBC_FNC_INST_ECD               string,
   -- 机构撤销后归属建行机构编号
   INSTUDOAFBLGCCBINS_ID          string,
   -- 机构状态代码
   INST_STCD                      string,
   -- 机构核算层级代码
   INST_LDGR_HIER_CD              string,
   -- 工作日历编号
   WKCLD_ID                       string,
   -- 经营主体属性代码
   OPSBJ_ATTRCD                   string,
   -- 建行机构经营范围描述
   CCBINS_OPRT_SCOP_DSC           string,
   -- 金融许可证号
   FNC_LCNS_NO                    string,
   -- 营业执照号码
   BSNLCNS_NO                     string,
   -- 税务登记证号
   TAX_RGSCTF_NO                  string,
   -- 组织机构代码证件号
   ORCD_CRDT_NO                   string,
   -- 金融机构标识码
   FNC_INST_ID_CD                 string,
   -- 支付系统银行行号
   PSBC                           string,
   -- SWIFT号码
   SWIFT_NO                       string,
   -- 银联卡地区代码
   UNNPY_CRD_RGON_CD              string,
   -- 人行交换号
   PBC_EXG_NO                     string,
   -- 全国汇票机构号
   CTRYWD_DRFTBILL_INSNO          string,
   -- 全国联行号
   CTRYWD_BNKCD                   string,
   -- 编制本票密押标志
   DVPPRMSNOTETSKY_IND            string,
   -- 国内信用证议付行标志
   DMST_LC_NGTBNK_IND             string,
   -- 国内信用证通知行标志
   DMST_LC_ADVSBNK_IND            string,
   -- 国内信用证开证行标志
   DMST_LC_ISUBNK_IND             string,
   -- 对公对私证券业务标志代码
   CORPPRVTSCRTBNS_INDCD          string,
   -- 财税库行联网业务标志
   TXBSBKNTWRKGBSN_IND            string,
   -- 大额支付业务标志
   BIGAMT_PY_BSN_IND              string,
   -- 小额支付业务标志
   MICR_PY_BSN_IND                string,
   -- 支票影像业务标志
   CHK_IMG_BSN_IND                string,
   -- 跨行网银业务标志
   INTRBNK_EBNKG_BSN_IND          string,
   -- 个人住房类贷款业务标志
   IDVHSCGYLOANBSN_IND            string,
   -- 个人消费类贷款业务标志
   IDVCNSMCGYLNBSN_IND            string,
   -- 个人经营类贷款业务标志
   IDVOPRTCGYLOANBSN_IND          string,
   -- 个人公积金贷款业务标志
   IDV_PRFDLN_BSN_IND             string,
   -- 住房资金业务标志
   HS_CPTLBSN_IND                 string,
   -- 个人国际速汇业务银星标志
   IDVIEMTBSNSLVST_IND            string,
   -- 个人国际速汇业务西联标志
   IDVIEMTBSNWSTUN_IND            string,
   -- 西联汇款机构编码
   WSTUN_RMT_INST_ECD             string,
   -- 出入境服务中心标志
   EXETR_SVC_CNTR_IND             string,
   -- 个人贷款中心标志
   IDV_LOAN_CNTR_IND              string,
   -- 理财中心标志
   WLTHMGTCNTR_IND                string,
   -- 自助业务标志
   SLFSVC_BSN_IND                 string,
   -- 财富中心标志
   WLTH_CNTR_IND                  string,
   -- 提金点标志
   DRGDSPT_IND                    string,
   -- 贵金属金库标志
   PM_TRSR_IND                    string,
   -- 机构金融服务发展战略类型代码
   INSFCSVC_DPSTGTP_CD            string,
   -- 行别性质代码
   BNKCGY_CHAR_CD                 string,
   -- 机构经济区域代码
   INST_ECN_RGON_CD               string,
   -- 专线电话号码
   SPPLN_TELNO                    string,
   -- 理财柜台电话号码
   CHRTC_CNTER_TELNO              string,
   -- 建行机构行政层级代码
   CCBINS_ADMNHIER_CD             string,
   -- 责任中心类型代码
   RSPCNT_TPCD                    string,
   -- 员工人数
   EMPLNUM                        string,
   -- 机构负责人编号
   INST_PNP_ID                    string,
   -- 立档单位标志
   DOC_UNIT_IND                   string,
   -- 档案全宗编号
   FNDS_ID                        string,
   -- 建行机构其他语种简称
   CCBINSOTHRLNGSHRT_NM           string,
   -- OPICS号
   OPICS_NO                       string,
   -- POMS号
   POMS_NO                        string,
   -- 建行机构描述
   CCBINS_DSC                     string,
   -- 所在区域主要功能属性描述
   RGON_MAINFCN_ATTR_DSC          string,
   -- 所在区域次要功能属性描述
   RGON_MINRFCN_ATTR_DSC          string,
   -- 业务管理模式描述
   BSN_MGT_MODDSC                 string,
   -- 对理财中心业务指导标志
   TOWLMGCNTRBSNGD_IND            string,
   -- 离附行标志
   OFFINBNK_IND                   string,
   -- 穿墙标志
   NCLP_IND                       string,
   -- 纳税人规模代码
   TAXPYR_SZ_CD                   string,
   -- 企业规模代码
   ENTP_SZ_CD                     string,
   -- 上市企业标志
   LSTD_ENTP_IND                  string,
   -- 特殊经济区内企业标志
   SEACORP_IND                    string,
   -- 进出口权标志
   IMPEXPRGT_IND                  string,
   -- 企业环保达标标志
   ENTP_ENVPRT_CMPLN_IND          string,
   -- 建行机构总人数
   CCBINS_TOT_PNUM                string,
   -- 人行开户标志
   PBC_OPNACC_IND                 string,
   -- 建行机构注册资本金额
   CCBINSRGSTCPTLFND_AMT          string,
   -- 建行机构注册资本币种代码
   CCBINSRGSTCPTLCCY_CD           string,
   -- 建行机构主营业务描述
   CCBINS_MAINBSN_DSC             string,
   -- 建行机构兼营业务描述
   CCBINS_MIX_BSN_DSC             string,
   -- #最后更新日期时间
   LAST_UDT_DT_TM                 string,
   -- P9开始日期
   P9_START_DATE                  string,
   -- P9结束日期
   P9_END_DATE                    string,
   -- 建行机构成立日期
   CCBINS_ESTB_DT                 string,
   -- 机构变更日期
   INST_MDF_DT                    string,
   -- 机构撤销日期
   INST_UDO_DT                    string,
   -- 机构开始营业时间
   INST_STRT_OPRG_TM              string,
   -- 经营期限起始日期
   OPRT_TRM_STDT                  string,
   -- 经营期限结束日期
   OPRT_TRM_EDDT                  string,
   -- 开业日期
   BOPR_DT                        string,
   -- 承担费用标志
   CHRGTO_COSIND                  string,
   -- 部门主责任类型代码
   DEPT_PRIM_RSPL_TPCD            string,
   -- 电票经营权限标志
   EBILL_OPRT_AHR_IND             string,
   -- 记账标志
   BOOKENTR_IND                   string,
   -- 本部机构标志
   HDQRT_INST_IND                 string,
   -- 部门属性代码
   DEPT_ATTRCD                    string,
   -- 机构分账核算类型描述
   INST_SUBACC_LDGR_TPDS          string,
   -- HKICL分行编号
   HKICL_BR_ID                    string,
   -- HKICL银行编号
   HKICL_BNK_ID                   string
)
PARTITIONED BY (LOAD_DATE string)
STORED AS ORC;


-- 拉链表中间数据
DROP TABLE IF EXISTS CT_T0651_CCBINS_INF_H_MID;

CREATE TABLE IF NOT EXISTS CT_T0651_CCBINS_INF_H_MID (
   -- 建行机构编号
   CCBINS_ID                      string,
   -- 建行机构中文全称
   CCBINS_CHN_FULLNM              string,
   -- 建行机构中文简称
   CCBINS_CHN_SHRTNM              string,
   -- 机构状态代码
   INST_STCD                      string,
   -- P9结束日期
   P9_END_DATE                    string
)
PARTITIONED BY (DATA_TYPE string)
STORED AS ORC;

ALTER TABLE CT_T0651_CCBINS_INF_H_MID ADD PARTITION(DATA_TYPE='SRC');
ALTER TABLE CT_T0651_CCBINS_INF_H_MID ADD PARTITION(DATA_TYPE='CUR_NO_DUP');
ALTER TABLE CT_T0651_CCBINS_INF_H_MID ADD PARTITION(DATA_TYPE='PRE_NO_DUP');

-- 最终拉链表
DROP TABLE IF EXISTS CT_T0651_CCBINS_INF_H;

CREATE TABLE IF NOT EXISTS CT_T0651_CCBINS_INF_H (
   -- 建行机构编号
   CCBINS_ID                      string,
   -- 建行机构中文全称
   CCBINS_CHN_FULLNM              string,
   -- 建行机构中文简称
   CCBINS_CHN_SHRTNM              string,
   -- 机构状态代码
   INST_STCD                      string
)
PARTITIONED BY (P9_END_DATE string)
STORED AS ORC;
