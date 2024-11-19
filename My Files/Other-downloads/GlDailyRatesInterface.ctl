-- +=========================================================================+
-- | $Header: fusionapps/fin/gl/bin/GlDailyRatesInterface.ctl /st_fusionapps_pt-v2mib/4 2021/10/18 10:42:33 jenchen Exp $ |
-- +=========================================================================+
-- | Copyright (c) 2014 Oracle Corporation Redwood City, California, USA |
-- | All rights reserved. |
-- |=========================================================================+
-- | |
-- | |
-- | FILENAME |
-- | |
-- | GlDailyRatesInterface.ctl
-- | |
-- | DESCRIPTION
-- | Uploads CSV file data into GL_DAILY_RATES_INTERFACE
-- | Created by Dipesh Gupta 22/04/2014
-- | Tested by Anil Desu 22/04/2014
-- | History
-- | Initial version source controlled via bug 18629654 in FUSION release 11.1.9
-- |	CHAR(600) is added to handle multilang characters fields


load data
CHARACTERSET AL32UTF8 
BYTEORDERMARK CHECK 
append into table GL_DAILY_RATES_INTERFACE
fields terminated by "," optionally enclosed by '"' trailing nullcols
(
FROM_CURRENCY,
TO_CURRENCY,
FROM_CONVERSION_DATE "decode(:FROM_CONVERSION_DATE,null,null,to_date(:FROM_CONVERSION_DATE, 'YYYY/MM/DD'))",
TO_CONVERSION_DATE "decode(:TO_CONVERSION_DATE,null,null,to_date(:TO_CONVERSION_DATE, 'YYYY/MM/DD'))",
USER_CONVERSION_TYPE,
CONVERSION_RATE,
MODE_FLAG CONSTANT 'I',
INVERSE_CONVERSION_RATE,
ATTRIBUTE_CATEGORY  CHAR(600),
ATTRIBUTE1	    CHAR(600),
ATTRIBUTE2	    CHAR(600),
ATTRIBUTE3	    CHAR(600),
ATTRIBUTE4	    CHAR(600),
ATTRIBUTE5	    CHAR(600),
ATTRIBUTE6	    CHAR(600),
ATTRIBUTE7	    CHAR(600),
ATTRIBUTE8	    CHAR(600),
ATTRIBUTE9	    CHAR(600),
ATTRIBUTE10	    CHAR(600),
ATTRIBUTE11	    CHAR(600),
ATTRIBUTE12	    CHAR(600),
ATTRIBUTE13	    CHAR(600),
ATTRIBUTE14	    CHAR(600),
ATTRIBUTE15	    CHAR(600),
ATTRIBUTE_DATE1 "to_date(decode(:ATTRIBUTE_DATE1,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE1),'YYYY/MM/DD')",
ATTRIBUTE_DATE2 "to_date(decode(:ATTRIBUTE_DATE2,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE2),'YYYY/MM/DD')",
ATTRIBUTE_DATE3 "to_date(decode(:ATTRIBUTE_DATE3,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE3),'YYYY/MM/DD')",
ATTRIBUTE_DATE4 "to_date(decode(:ATTRIBUTE_DATE4,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE4),'YYYY/MM/DD')",
ATTRIBUTE_DATE5 "to_date(decode(:ATTRIBUTE_DATE5,null,null,'$null$','4712/12/31',:ATTRIBUTE_DATE5),'YYYY/MM/DD')",
ATTRIBUTE_NUMBER1 "decode(:ATTRIBUTE_NUMBER1,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER1)",
ATTRIBUTE_NUMBER2 "decode(:ATTRIBUTE_NUMBER2,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER2)",
ATTRIBUTE_NUMBER3 "decode(:ATTRIBUTE_NUMBER3,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER3)",
ATTRIBUTE_NUMBER4 "decode(:ATTRIBUTE_NUMBER4,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER4)",
ATTRIBUTE_NUMBER5 "decode(:ATTRIBUTE_NUMBER5,null,null,'$null$','-999999999999999999',:ATTRIBUTE_NUMBER5)",
OBJECT_VERSION_NUMBER CONSTANT 1,
CREATION_DATE expression "systimestamp",
CREATED_BY CONSTANT '#CREATEDBY#',
LAST_UPDATED_BY CONSTANT '#LASTUPDATEDBY#',
LAST_UPDATE_DATE expression "systimestamp",
LAST_UPDATE_LOGIN CONSTANT '#LASTUPDATELOGIN#',
LOAD_REQUEST_ID CONSTANT '#LOADREQUESTID#'
)
