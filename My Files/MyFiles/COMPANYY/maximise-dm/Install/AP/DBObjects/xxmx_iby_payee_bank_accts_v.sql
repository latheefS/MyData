
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_IBY_PAYEE_BANK_ACCTS_V" ("EXT_PAYEE_ID", "PAYEE_LEVEL", "PAYEE_PARTY_ID", "ORG_ID", "SUPPLIER_SITE_ID", "INSTRUMENT_PAYMENT_USE_ID", "ORDER_OF_PREFERENCE", "EXT_BANK_ACCOUNT_ID") AS 
  SELECT    iepa.ext_payee_id
              ,DECODE(
                      iepa.supplier_site_id
                           ,NULL ,'SUPPLIER_PAYEE'
                                 ,'SUPPLIER_SITE_PAYEE'
                     )                          AS payee_level
              ,iepa.payee_party_id
              ,iepa.org_id
              ,iepa.supplier_site_id
              ,ipiua.instrument_payment_use_id
              ,ipiua.order_of_preference
              ,ieba.ext_bank_account_id
     FROM      apps.iby_external_payees_all@MXDM_NVIS_EXTRACT    iepa
              ,apps.iby_pmt_instr_uses_all@MXDM_NVIS_EXTRACT     ipiua
              ,apps.iby_ext_bank_accounts@MXDM_NVIS_EXTRACT      ieba
     WHERE     1 = 1
     AND       SYSDATE < NVL(iepa.inactive_Date, SYSDATE+1)
     AND       ipiua.ext_pmt_party_id       = iepa.ext_payee_id
     AND       ipiua.instrument_type        = 'BANKACCOUNT'
     AND       ipiua.payment_function       = 'PAYABLES_DISB'
     AND       SYSDATE                BETWEEN NVL(ipiua.start_date,SYSDATE-1)
                                          AND NVL(ipiua.end_Date,SYSDATE+1)
     AND       ieba.ext_bank_account_id     = ipiua.instrument_id
     ORDER BY  iepa.payee_party_id
              ,DECODE(
                      iepa.supplier_site_id
                           ,NULL ,0
                                 ,iepa.supplier_site_id
                     );
/