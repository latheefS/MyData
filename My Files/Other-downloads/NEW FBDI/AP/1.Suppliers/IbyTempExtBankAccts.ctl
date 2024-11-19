  -- +=========================================================================+
  -- |  $Header: fusionapps/fin/iby/bin/IbyTempExtBankAccts.ctl /st_fusionapps_pt-v2mib/4 2021/04/15 09:29:22 jenchen Exp $         |
  -- +=========================================================================+
  -- |  Copyright (c) 1989 Oracle Corporation Belmont, California, USA         |
  -- |                          All rights reserved.                           |
  -- |=========================================================================+
  -- |                                                                         |
  -- |                                                                        |
  -- | FILENAME                                                               |
  -- |                                                                         |
  -- |    IbyTempExtBankAccts.ctl (Upload Supplier Payee/Bank Accounts )               |
  -- |                                                                         |
  -- | DESCRIPTION                                                             |
  -- | 
  -- +==========================================================================+
 
 LOAD DATA
 APPEND
 INTO TABLE IBY_TEMP_EXT_BANK_ACCTS
 fields terminated by ',' optionally enclosed by '"' trailing nullcols
 (
 PAYMENT_FLOW                CONSTANT	'DISBURSEMENTS'         
 ,CREATION_DATE              expression	"systimestamp"
 ,CREATED_BY                 CONSTANT	'#CREATEDBY#'
 ,LAST_UPDATE_DATE           expression	"systimestamp"
 ,LAST_UPDATED_BY            CONSTANT	'#LASTUPDATEDBY#'
 ,LAST_UPDATE_LOGIN          CONSTANT	'#LASTUPDATELOGIN#'
 ,OBJECT_VERSION_NUMBER      CONSTANT	1
 ,LOAD_REQUEST_ID            CONSTANT	'#LOADREQUESTID#'
 ,OWNER_PRIMARY_FLAG         CONSTANT   'Y'
 ,STATUS                     CONSTANT	'NEW' 
 ,FEEDER_IMPORT_BATCH_ID
 ,TEMP_EXT_PARTY_ID
 ,TEMP_EXT_BANK_ACCT_ID  
 ,BANK_NAME    CHAR(360)
 ,BRANCH_NAME  CHAR(360)               
 ,COUNTRY_CODE   
 ,BANK_ACCOUNT_NAME  
 ,BANK_ACCOUNT_NUM            
 ,CURRENCY_CODE  
 ,FOREIGN_PAYMENT_USE_FLAG  
 ,START_DATE		     "to_date(nvl(:START_DATE, to_char(sysdate,'YYYY/MM/DD')), 'YYYY/MM/DD')"
 ,END_DATE		     "to_date(nvl(:END_DATE, '4712/12/31'),'YYYY/MM/DD')"
 ,IBAN  
 ,CHECK_DIGITS                
 ,BANK_ACCOUNT_NAME_ALT CHAR(320)       
 ,BANK_ACCOUNT_TYPE           
 ,ACCOUNT_SUFFIX              
 ,DESCRIPTION                 
 ,AGENCY_LOCATION_CODE  
 ,EXCHANGE_RATE_AGREEMENT_NUM 
 ,EXCHANGE_RATE_AGREEMENT_TYPE
 ,EXCHANGE_RATE               
 ,SECONDARY_ACCOUNT_REFERENCE 
 ,ATTRIBUTE_CATEGORY      
 ,ATTRIBUTE1                  
 ,ATTRIBUTE2                  
 ,ATTRIBUTE3                  
 ,ATTRIBUTE4                  
 ,ATTRIBUTE5                  
 ,ATTRIBUTE6                  
 ,ATTRIBUTE7                  
 ,ATTRIBUTE8                  
 ,ATTRIBUTE9                  
 ,ATTRIBUTE10                 
 ,ATTRIBUTE11                 
 ,ATTRIBUTE12                 
 ,ATTRIBUTE13                 
 ,ATTRIBUTE14                 
 ,ATTRIBUTE15  
 )

