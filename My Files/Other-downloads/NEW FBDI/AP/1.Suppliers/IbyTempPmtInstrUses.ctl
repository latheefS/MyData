  -- +=========================================================================+
  -- |  $Header: fusionapps/fin/iby/bin/IbyTempPmtInstrUses.ctl /st_fusionapps_pt-v2mib/2 2016/07/13 08:35:32 lvarallo Exp $         |
  -- +=========================================================================+
  -- |  Copyright (c) 1989 Oracle Corporation Belmont, California, USA         |
  -- |                          All rights reserved.                           |
  -- |=========================================================================+
  -- |                                                                         |
  -- |                                                                        |
  -- | FILENAME                                                               |
  -- |                                                                         |
  -- |    IbyTempPmtInstrUses.ctl (Upload Supplier Payee/Bank Accounts )               |
  -- |                                                                         |
  -- | DESCRIPTION                                                             |
  -- | 
  -- +==========================================================================+
 
 LOAD DATA
 APPEND
 INTO TABLE IBY_TEMP_PMT_INSTR_USES
 fields terminated by ',' optionally enclosed by '"' trailing nullcols
 (
  CREATION_DATE              expression	"systimestamp"
 ,CREATED_BY                 CONSTANT	'#CREATEDBY#'
 ,LAST_UPDATE_DATE           expression	"systimestamp"
 ,LAST_UPDATED_BY            CONSTANT	'#LASTUPDATEDBY#'
 ,LAST_UPDATE_LOGIN          CONSTANT	'#LASTUPDATELOGIN#'
 ,OBJECT_VERSION_NUMBER      CONSTANT	1
 ,LOAD_REQUEST_ID            CONSTANT	'#LOADREQUESTID#'
 ,INSTRUMENT_TYPE            CONSTANT   'BANKACCOUNT' 
 ,PAYMENT_FLOW               CONSTANT	'DISBURSEMENTS' 
 ,PAYMENT_FUNCTION           CONSTANT   'PAYABLES_DISB'
 ,STATUS                     CONSTANT	'NEW' 
 ,FEEDER_IMPORT_BATCH_ID
 ,TEMP_EXT_PARTY_ID   
 ,TEMP_INSTRUMENT_ID    
 ,TEMP_PMT_INSTR_USE_ID  
 ,PRIMARY_FLAG           
 ,START_DATE		     "to_date(nvl(:START_DATE, to_char(sysdate,'YYYY/MM/DD')),'YYYY/MM/DD')"
 ,END_DATE		     "to_date(nvl(:END_DATE, '4712/12/31'),'YYYY/MM/DD')"
 )
