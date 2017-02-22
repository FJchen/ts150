use sor;



--��ȡ��Ҫ����������ˮ���ʱ�䡢��Ա�š���������
insert overwrite table ILLEGAL_REFINE_DETAIL_FCM partition (p9_data_date = '$p9_data_date')
select distinct a.cm_tx_dt as tx_dt,
       b.CM_OPUN_CODE as Branch_Id,
       c.pass_num
  from (select *
          from TODDC_FCMARLD_A a
         where (cm_acct_no IS not NULL and cm_acct_no <> '')
           and cm_tx_dt = '$p9_data_date') a
 inner join TODDC_FCMTLR0_H b on a.oper_code = b.CM_OPR_NO
   and b.P9_END_DATE = '2999-12-31'
 inner join SIAM_CARD_INFO_H c 
   on (a.cm_acct_no = c.card_no or a.cm_acct_no = c.pass_num 
       or a.cm_acct_no = c.CUSTNO);
       

--ATM��ȡʱ�䡢��Ա�š���������
insert overwrite table ILLEGAL_REFINE_DETAIL_ATM partition (p9_data_date = '$p9_data_date')
select distinct a.tx_dt, a.Branch_ID, b.pass_num
  from (select distinct k.CR_ENTR_DT as tx_dt,
               k.CR_CRD_NO as card_no,
               k.CR_TX_NETP_NO as Branch_ID,
               k.CR_CPU_DT
          from TODDC_CRATMDET_A k
         where k.CR_ENTR_DT = '$p9_data_date') a
 inner join SIAM_CARD_INFO_H b on a.card_no = b.CARD_NO;


--��ȡǩԼ����ˮ��ͻ��š����֤�š������š�ʱ�䣨��ͬ�ı�
insert overwrite table ILLEGAL_REFINE_DETAIL_QY partition (p9_data_date = '$p9_data_date')
select distinct  a.SIGN_DATE tx_dt,
                a.sign_bran as Branch_ID,              
                (case
                  when (a.CERT_ID IS not NULL and a.CERT_ID <> '') then
                   a.CERT_ID
                  else
                   a.CHANL_CUST_NO
                end) as pass_num
  from TODEC_SIGN_MAIN_FLOW_A a
 where a.SIGN_DATE = '$p9_data_date'
   and sign_bran <> '999999999'
   and (a.sign_bran IS not NULL and a.sign_bran <> '')
   and ((a.CHANL_CUST_NO IS not NULL and a.CHANL_CUST_NO <> '') or
       (a.CERT_ID IS not NULL and a.CERT_ID <> ''))
       
union

select distinct a.SIGN_DATE tx_dt,
                a.sign_bran as Branch_ID,
                (case
                  when (a.CERT_ID IS not NULL and a.CERT_ID <> '') then
                   a.CERT_ID
                  else
                   a.CHANL_CUST_NO
                end) as pass_num
  from T1000_SIGN_MAIN_FLOW_A a
 where a.SIGN_DATE = '$p9_data_date'
   and sign_bran <> '999999999'
   and (a.sign_bran IS not NULL and a.sign_bran <> '')
   and ((a.CHANL_CUST_NO IS not NULL and a.CHANL_CUST_NO <> '') or
       (a.CERT_ID IS not NULL and a.CERT_ID <> ''));
   


--��ȡ������ϸ����潻�׵�ʱ��,����,�����,���֤��
insert overwrite table ILLEGAL_REFINE_DETAIL_GM partition (p9_data_date = '$p9_data_date')
select distinct a.SA_TX_DT as tx_dt,
                a.SA_OPUN_COD as branch_id,
                b.pass_num
  from (select *
          from TODDC_SAACNTXN_A
         where sa_tx_dt = '$p9_data_date'
           and SA_DSCRP_COD in
               ('0045', '0046', '0047', '6617', '6620', '6621', '1104',
                '1105', '1106', '1107', '0127', '0128', '1537')) a
 inner join SIAM_CARD_INFO_H b on a.SA_TX_CRD_NO = b.card_no;


#���ܽ�����ϸ��ʱ��,����,�����,���֤��
beeline <<!
use mid;

insert overwrite table Refine1Detail partition (p9_data_date = '$p9_data_date')
select distinct tx_dt, Branch_Id, pass_num
  from FCMARLDDetail
 where p9_data_date = '$p9_data_date'
union
select tx_dt, Branch_Id, pass_num
  from ATMDetail
 where p9_data_date = '$p9_data_date'
union
select tx_dt, Branch_Id, pass_num
  from MainFlowDetail
 where p9_data_date = '$p9_data_date'
union
select tx_dt, Branch_Id, pass_num
  from TXEVENTDetail
 where p9_data_date = '$p9_data_date';
   
!