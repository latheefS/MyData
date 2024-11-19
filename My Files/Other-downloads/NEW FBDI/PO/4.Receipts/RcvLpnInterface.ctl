-- +=========================================================================+
-- | $Header: fusionapps/scm/rcv/bin/RcvLpnInterface.ctl /st_fusionapps_pt-v2mib/5 2020/03/06 14:46:31 nveluthe Exp $ |
-- +=========================================================================+
-- | Copyright (c) 2012 Oracle Corporation Redwood City, California, USA |
-- | All rights reserved. |
-- |=========================================================================+
-- | |
-- | |
-- | FILENAME |
-- | |
-- | RcvLpnInterface.ctl
-- | |
-- | DESCRIPTION
-- | Uploads CSV file data into INV_LPN_INTERFACE
-- |
-- | Created by Anshuman 05/14/2012
-- |
-- | History
-- | Initial version source controled via bug 14019436

--OPTIONS (ROWS=1)
LOAD DATA                                                                                                                            
--INFILE 'rcvreceiptprocessor.csv'
--BADFILE 'rcvreceiptprocessor.bad'
--DISCARDFILE 'rcvreceiptprocessor.dsc' 

APPEND
INTO TABLE INV_LPN_INTERFACE
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
TRAILING NULLCOLS
(LPN_INTERFACE_ID EXPRESSION "INV_LICENSE_PLATE_NUMBERS_S1.NEXTVAL",
LICENSE_PLATE_NUMBER,
LAST_UPDATE_DATE                expression            "systimestamp",
LAST_UPDATED_BY                 CONSTANT              '#LASTUPDATEDBY#',
CREATION_DATE                   expression            "systimestamp",
CREATED_BY                      CONSTANT              '#CREATEDBY#',
LAST_UPDATE_LOGIN               CONSTANT              '#LASTUPDATELOGIN#',
PARENT_LICENSE_PLATE_NUMBER,
LPN_CONTEXT,
--SOURCE_GROUP_ID EXPRESSION "RCV_INTERFACE_GROUPS_S.NEXTVAL",
SOURCE_GROUP_NUM,
OBJECT_VERSION_NUMBER CONSTANT 1,
--LOAD_REQUEST_ID constant '1'
LOAD_REQUEST_ID constant '#LOADREQUESTID#'
)
