  -- +=========================================================================+
  -- |  $Header: fusionapps/fin/iby/bin/IbyTempExtPayees.ctl /st_fusionapps_pt-v2mib/3 2021/04/15 09:29:22 jenchen Exp $         |
  -- +=========================================================================+
  -- |  Copyright (c) 1989 Oracle Corporation Belmont, California, USA         |
  -- |                          All rights reserved.                           |
  -- |=========================================================================+
  -- |                                                                         |
  -- |                                                                        |
  -- | FILENAME                                                               |
  -- |                                                                         |
  -- |    IbyTempExtPayees.ctl (Upload Supplier Payee/Bank Accounts )               |
  -- |                                                                         |
  -- | DESCRIPTION                                                             |
  -- | 
  -- +==========================================================================+
 
 LOAD DATA
 APPEND
 INTO TABLE IBY_TEMP_EXT_PAYEES
 fields terminated by ',' optionally enclosed by '"' trailing nullcols
 (         
  CREATION_DATE               expression  "systimestamp"
 ,CREATED_BY                  CONSTANT	  '#CREATEDBY#'
 ,LAST_UPDATE_DATE            expression  "systimestamp"
 ,LAST_UPDATED_BY             CONSTANT	  '#LASTUPDATEDBY#'
 ,LAST_UPDATE_LOGIN           CONSTANT	  '#LASTUPDATELOGIN#'
 ,OBJECT_VERSION_NUMBER       CONSTANT	  1
 ,LOAD_REQUEST_ID             CONSTANT	  '#LOADREQUESTID#'
 ,START_DATE		      expression  "to_date(SYSDATE, 'YYYY/MM/DD')"
 ,END_DATE		      expression  "to_date('4712/12/31', 'YYYY/MM/DD')"
 ,PAYMENT_FUNCTION            CONSTANT    'PAYABLES_DISB'     
 ,STATUS                      CONSTANT    'NEW' 
 ,FEEDER_IMPORT_BATCH_ID 
 ,TEMP_EXT_PAYEE_ID 
 ,BUSINESS_UNIT                      "trim(:BUSINESS_UNIT)"
 ,VENDOR_CODE			     "trim(:VENDOR_CODE)"
 ,VENDOR_SITE_CODE                   "trim(:VENDOR_SITE_CODE)"
 ,EXCLUSIVE_PAYMENT_FLAG             "nvl(:EXCLUSIVE_PAYMENT_FLAG, 'N')"
 ,DEFAULT_PAYMENT_METHOD_CODE 
 ,DELIVERY_CHANNEL_CODE  
 ,SETTLEMENT_PRIORITY  
 ,REMIT_ADVICE_DELIVERY_METHOD 
 ,REMIT_ADVICE_EMAIL           
 ,REMIT_ADVICE_FAX   
 ,BANK_INSTRUCTION1_CODE       
 ,BANK_INSTRUCTION2_CODE       
 ,BANK_INSTRUCTION_DETAILS  
 ,PAYMENT_REASON_CODE          
 ,PAYMENT_REASON_COMMENTS 
 ,PAYMENT_TEXT_MESSAGE1   CHAR(256)  
 ,PAYMENT_TEXT_MESSAGE2   CHAR(256)
 ,PAYMENT_TEXT_MESSAGE3   CHAR(256)
 ,BANK_CHARGE_BEARER
 )
 
