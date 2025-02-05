-- +=========================================================================+
-- | $Header: fusionapps/fin/gl/bin/GlInterface.ctl /st_fusionapps_pt-v2mib/11 2021/10/18 10:42:33 jenchen Exp $ |
-- +=========================================================================+
-- | Copyright (c) 2012 Oracle Corporation Redwood City, California, USA |
-- | All rights reserved. |
-- |=========================================================================+
-- | |
-- | |
-- | FILENAME |
-- | |
-- | gljournalimport.ctl
-- | |
-- | DESCRIPTION
-- | Uploads CSV file data into GL_INTERFACE |
-- | Created by Srini Pala 05/02/2012
-- | Tested by Dhaval T 04/29/2012
-- | History
-- | Initial version source controled via bug 14027978
-- |	CHAR(600) is added to handle multilang characters fields

load data
CHARACTERSET UTF8
append into table GL_INTERFACE
fields terminated by "," optionally enclosed by '"' trailing nullcols
(
   LOAD_REQUEST_ID                 CONSTANT '#LOADREQUESTID#',
   STATUS,
   LEDGER_ID   "decode(:LEDGER_ID,null,(select ledger_id from gl_ledgers where name = :LEDGER_NAME),:LEDGER_ID)",
   ACCOUNTING_DATE                 "to_date(:ACCOUNTING_DATE, 'YYYY/MM/DD')",
   USER_JE_SOURCE_NAME,
   USER_JE_CATEGORY_NAME,
   CURRENCY_CODE,
   DATE_CREATED                    "to_date(:DATE_CREATED, 'YYYY/MM/DD')",
   ACTUAL_FLAG,
   SEGMENT1,
   SEGMENT2,
   SEGMENT3,
   SEGMENT4,
   SEGMENT5,
   SEGMENT6,
   SEGMENT7,
   SEGMENT8,
   SEGMENT9,
   SEGMENT10,
   SEGMENT11,
   SEGMENT12,
   SEGMENT13,
   SEGMENT14,
   SEGMENT15,
   SEGMENT16,
   SEGMENT17,
   SEGMENT18,
   SEGMENT19,
   SEGMENT20,
   SEGMENT21,
   SEGMENT22,
   SEGMENT23,
   SEGMENT24,
   SEGMENT25,
   SEGMENT26,
   SEGMENT27,
   SEGMENT28,
   SEGMENT29,
   SEGMENT30,
   ENTERED_DR                     "fun_load_interface_utils_pkg.replace_decimal_char(:ENTERED_DR)",
   ENTERED_CR                     "fun_load_interface_utils_pkg.replace_decimal_char(:ENTERED_CR)",
   ACCOUNTED_DR                   "fun_load_interface_utils_pkg.replace_decimal_char(:ACCOUNTED_DR)",
   ACCOUNTED_CR                   "fun_load_interface_utils_pkg.replace_decimal_char(:ACCOUNTED_CR)",
   REFERENCE1   CHAR(400),
   REFERENCE2   CHAR(960),
   REFERENCE3   CHAR(400),
   REFERENCE4   CHAR(400),
   REFERENCE5   CHAR(960),
   REFERENCE6   CHAR(400),
   REFERENCE7   CHAR(400),
   REFERENCE8	CHAR(400)		  "decode(:REFERENCE8,null,null,decode((select ENABLE_AVERAGE_BALANCES_FLAG from gl_ledgers where ledger_id = :LEDGER_ID),'N' , :REFERENCE8 ,'Y', to_date(:REFERENCE8,'YYYY/MM/DD' ), decode((select ENABLE_AVERAGE_BALANCES_FLAG from gl_ledgers where name = :LEDGER_NAME) , 'N' , :REFERENCE8 ,'Y', to_date(:REFERENCE8,'YYYY/MM/DD' ) , :REFERENCE8)))" ,
   REFERENCE9   CHAR(400),
   REFERENCE10  CHAR(960),
   REFERENCE21  CHAR(960),
   REFERENCE22  CHAR(960),
   REFERENCE23  CHAR(960),
   REFERENCE24  CHAR(960),
   REFERENCE25  CHAR(960),
   REFERENCE26  CHAR(960),
   REFERENCE27  CHAR(960),
   REFERENCE28  CHAR(960),
   REFERENCE29  CHAR(960),
   REFERENCE30  CHAR(960),
   STAT_AMOUNT                    "fun_load_interface_utils_pkg.replace_decimal_char(:STAT_AMOUNT)",
   USER_CURRENCY_CONVERSION_TYPE,
   CURRENCY_CONVERSION_DATE       "decode(:CURRENCY_CONVERSION_DATE,null,null,to_date(:CURRENCY_CONVERSION_DATE, 'YYYY/MM/DD'))",
   CURRENCY_CONVERSION_RATE       "fun_load_interface_utils_pkg.replace_decimal_char(:CURRENCY_CONVERSION_RATE)",
   GROUP_ID,
   ATTRIBUTE_CATEGORY   CHAR(600),
   ATTRIBUTE1           CHAR(600),
   ATTRIBUTE2           CHAR(600),
   ATTRIBUTE3           CHAR(600),
   ATTRIBUTE4           CHAR(600),
   ATTRIBUTE5           CHAR(600),
   ATTRIBUTE6           CHAR(600),
   ATTRIBUTE7           CHAR(600),
   ATTRIBUTE8           CHAR(600),
   ATTRIBUTE9           CHAR(600),
   ATTRIBUTE10           CHAR(600),
   ATTRIBUTE11           CHAR(600),
   ATTRIBUTE12           CHAR(600),
   ATTRIBUTE13           CHAR(600),
   ATTRIBUTE14           CHAR(600),
   ATTRIBUTE15           CHAR(600),
   ATTRIBUTE16           CHAR(600),
   ATTRIBUTE17           CHAR(600),
   ATTRIBUTE18           CHAR(600),
   ATTRIBUTE19           CHAR(600),
   ATTRIBUTE20           CHAR(600),
   ATTRIBUTE_CATEGORY3   CHAR(600),
   AVERAGE_JOURNAL_FLAG,
   ORIGINATING_BAL_SEG_VALUE,
   LEDGER_NAME,
   ENCUMBRANCE_TYPE_ID,
   JGZZ_RECON_REF,
   PERIOD_NAME                     "decode(trim(replace(replace(:PERIOD_NAME,chr(13),' '),chr(10),' ')),'END',null,:PERIOD_NAME)",
   REFERENCE18  CHAR(400),
   REFERENCE19  CHAR(400),
   REFERENCE20  CHAR(400),
   ATTRIBUTE_DATE1 "to_date(decode(trim(replace(replace(:ATTRIBUTE_DATE1,chr(13),' '),chr(10),' ')),'END',null,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE1),'YYYY/MM/DD')",
   ATTRIBUTE_DATE2 "to_date(decode(:ATTRIBUTE_DATE2,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE2),'YYYY/MM/DD')", 
   ATTRIBUTE_DATE3 "to_date(decode(:ATTRIBUTE_DATE3,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE3),'YYYY/MM/DD')",
   ATTRIBUTE_DATE4 "to_date(decode(:ATTRIBUTE_DATE4,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE4),'YYYY/MM/DD')",
   ATTRIBUTE_DATE5 "to_date(decode(:ATTRIBUTE_DATE5,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE5),'YYYY/MM/DD')",
   ATTRIBUTE_DATE6 "to_date(decode(:ATTRIBUTE_DATE6,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE6),'YYYY/MM/DD')",
   ATTRIBUTE_DATE7 "to_date(decode(:ATTRIBUTE_DATE7,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE7),'YYYY/MM/DD')",
   ATTRIBUTE_DATE8 "to_date(decode(:ATTRIBUTE_DATE8,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE8),'YYYY/MM/DD')",
   ATTRIBUTE_DATE9 "to_date(decode(:ATTRIBUTE_DATE9,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE9),'YYYY/MM/DD')",
   ATTRIBUTE_DATE10 "to_date(decode(:ATTRIBUTE_DATE10,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE10),'YYYY/MM/DD')",
   ATTRIBUTE_NUMBER1 "decode(:ATTRIBUTE_NUMBER1,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER1)",
   ATTRIBUTE_NUMBER2 "decode(:ATTRIBUTE_NUMBER2,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER2)",
   ATTRIBUTE_NUMBER3 "decode(:ATTRIBUTE_NUMBER3,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER3)",
   ATTRIBUTE_NUMBER4 "decode(:ATTRIBUTE_NUMBER4,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER4)",
   ATTRIBUTE_NUMBER5 "decode(:ATTRIBUTE_NUMBER5,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER5)",
   ATTRIBUTE_NUMBER6 "decode(:ATTRIBUTE_NUMBER6,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER6)",
   ATTRIBUTE_NUMBER7 "decode(:ATTRIBUTE_NUMBER7,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER7)",
   ATTRIBUTE_NUMBER8 "decode(:ATTRIBUTE_NUMBER8,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER8)",
   ATTRIBUTE_NUMBER9 "decode(:ATTRIBUTE_NUMBER9,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER9)",
   ATTRIBUTE_NUMBER10 "decode(:ATTRIBUTE_NUMBER10,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER10)",
   GLOBAL_ATTRIBUTE_CATEGORY           CHAR(600),
   GLOBAL_ATTRIBUTE1           CHAR(600),
   GLOBAL_ATTRIBUTE2           CHAR(600),
   GLOBAL_ATTRIBUTE3           CHAR(600),
   GLOBAL_ATTRIBUTE4           CHAR(600),
   GLOBAL_ATTRIBUTE5           CHAR(600),
   GLOBAL_ATTRIBUTE6           CHAR(600),
   GLOBAL_ATTRIBUTE7           CHAR(600),
   GLOBAL_ATTRIBUTE8           CHAR(600),
   GLOBAL_ATTRIBUTE9           CHAR(600),
   GLOBAL_ATTRIBUTE10           CHAR(600),
   GLOBAL_ATTRIBUTE11           CHAR(600),
   GLOBAL_ATTRIBUTE12           CHAR(600),
   GLOBAL_ATTRIBUTE13           CHAR(600),
   GLOBAL_ATTRIBUTE14           CHAR(600),
   GLOBAL_ATTRIBUTE15           CHAR(600),
   GLOBAL_ATTRIBUTE16           CHAR(600),
   GLOBAL_ATTRIBUTE17           CHAR(600),
   GLOBAL_ATTRIBUTE18           CHAR(600),
   GLOBAL_ATTRIBUTE19           CHAR(600),
   GLOBAL_ATTRIBUTE20           CHAR(600),
   GLOBAL_ATTRIBUTE_DATE1 "to_date(decode(trim(replace(replace(:GLOBAL_ATTRIBUTE_DATE1,chr(13),' '),chr(10),' ')),'END',null,null,null,'$null$','4712/12/31',:GLOBAL_ATTRIBUTE_DATE1),'YYYY/MM/DD')",
   GLOBAL_ATTRIBUTE_DATE2 "to_date(decode(:GLOBAL_ATTRIBUTE_DATE2,null,null,'$null$','4712/12/31',:GLOBAL_ATTRIBUTE_DATE2),'YYYY/MM/DD')", 
   GLOBAL_ATTRIBUTE_DATE3 "to_date(decode(:GLOBAL_ATTRIBUTE_DATE3,null,null,'$null$','4712/12/31',:GLOBAL_ATTRIBUTE_DATE3),'YYYY/MM/DD')",
   GLOBAL_ATTRIBUTE_DATE4 "to_date(decode(:GLOBAL_ATTRIBUTE_DATE4,null,null,'$null$','4712/12/31',:GLOBAL_ATTRIBUTE_DATE4),'YYYY/MM/DD')",
   GLOBAL_ATTRIBUTE_DATE5 "to_date(decode(:GLOBAL_ATTRIBUTE_DATE5,null,null,'$null$','4712/12/31',:GLOBAL_ATTRIBUTE_DATE5),'YYYY/MM/DD')",
   GLOBAL_ATTRIBUTE_NUMBER1 "decode(:GLOBAL_ATTRIBUTE_NUMBER1,null,null,'$null$','-999999999999999999',:GLOBAL_ATTRIBUTE_NUMBER1)",
   GLOBAL_ATTRIBUTE_NUMBER2 "decode(:GLOBAL_ATTRIBUTE_NUMBER2,null,null,'$null$','-999999999999999999',:GLOBAL_ATTRIBUTE_NUMBER2)",
   GLOBAL_ATTRIBUTE_NUMBER3 "decode(:GLOBAL_ATTRIBUTE_NUMBER3,null,null,'$null$','-999999999999999999',:GLOBAL_ATTRIBUTE_NUMBER3)",
   GLOBAL_ATTRIBUTE_NUMBER4 "decode(:GLOBAL_ATTRIBUTE_NUMBER4,null,null,'$null$','-999999999999999999',:GLOBAL_ATTRIBUTE_NUMBER4)",
   GLOBAL_ATTRIBUTE_NUMBER5 "decode(:GLOBAL_ATTRIBUTE_NUMBER5,null,null,'$null$','-999999999999999999',:GLOBAL_ATTRIBUTE_NUMBER5)",
   CREATED_BY                      CONSTANT              '#CREATEDBY#',
   CREATION_DATE                   expression            "systimestamp",
   LAST_UPDATE_DATE                expression            "systimestamp",
   LAST_UPDATE_LOGIN               CONSTANT              '#LASTUPDATELOGIN#',
   LAST_UPDATED_BY                 CONSTANT              '#LASTUPDATEDBY#',
   OBJECT_VERSION_NUMBER           CONSTANT                1
 )
