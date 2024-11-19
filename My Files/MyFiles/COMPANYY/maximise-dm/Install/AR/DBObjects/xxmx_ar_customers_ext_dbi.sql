EXEC DropTable ('XXMX_HZ_PARTY_CLASSIFS_EXT')
CREATE TABLE "XXMX_CORE".XXMX_HZ_PARTY_CLASSIFS_EXT
   ( FILE_SET_ID       VARCHAR2(30),	 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CLASSIFIC_ORIG_SYSTEM VARCHAR2(30), 
     CLASSIFIC_ORIG_SYSTEM_REF VARCHAR2(240), 
     CLASS_CATEGORY VARCHAR2(30), 
     CLASS_CODE VARCHAR2(30), 
     START_DATE_ACTIVE VARCHAR2(20), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     PRIMARY_FLAG VARCHAR2(1), 
     END_DATE_ACTIVE VARCHAR2(20), 
     RANK NUMBER, 
     ATTRIBUTE_CATEGORY VARCHAR2(30), 
     ATTRIBUTE1 VARCHAR2(150), 
     ATTRIBUTE2 VARCHAR2(150), 
     ATTRIBUTE3 VARCHAR2(150), 
     ATTRIBUTE4 VARCHAR2(150), 
     ATTRIBUTE5 VARCHAR2(150), 
     ATTRIBUTE6 VARCHAR2(150), 
     ATTRIBUTE7 VARCHAR2(150), 
     ATTRIBUTE8 VARCHAR2(150), 
     ATTRIBUTE9 VARCHAR2(150), 
     ATTRIBUTE10 VARCHAR2(150), 
     ATTRIBUTE11 VARCHAR2(150), 
     ATTRIBUTE12 VARCHAR2(150), 
     ATTRIBUTE13 VARCHAR2(150), 
     ATTRIBUTE14 VARCHAR2(150), 
     ATTRIBUTE15 VARCHAR2(150), 
     ATTRIBUTE16 VARCHAR2(150), 
     ATTRIBUTE17 VARCHAR2(150), 
     ATTRIBUTE18 VARCHAR2(150), 
     ATTRIBUTE19 VARCHAR2(150), 
     ATTRIBUTE20 VARCHAR2(150), 
     ATTRIBUTE21 VARCHAR2(150), 
     ATTRIBUTE22 VARCHAR2(150), 
     ATTRIBUTE23 VARCHAR2(150), 
     ATTRIBUTE24 VARCHAR2(150), 
     ATTRIBUTE25 VARCHAR2(150), 
     ATTRIBUTE26 VARCHAR2(150), 
     ATTRIBUTE27 VARCHAR2(150), 
     ATTRIBUTE28 VARCHAR2(150), 
     ATTRIBUTE29 VARCHAR2(150), 
     ATTRIBUTE30 VARCHAR2(255), 
     ATTRIBUTE_NUMBER1 NUMBER, 
     ATTRIBUTE_NUMBER2 NUMBER, 
     ATTRIBUTE_NUMBER3 NUMBER, 
     ATTRIBUTE_NUMBER4 NUMBER, 
     ATTRIBUTE_NUMBER5 NUMBER, 
     ATTRIBUTE_NUMBER6 NUMBER, 
     ATTRIBUTE_NUMBER7 NUMBER, 
     ATTRIBUTE_NUMBER8 NUMBER, 
     ATTRIBUTE_NUMBER9 NUMBER, 
     ATTRIBUTE_NUMBER10 NUMBER, 
     ATTRIBUTE_NUMBER11 NUMBER, 
     ATTRIBUTE_NUMBER12 NUMBER, 
     ATTRIBUTE_DATE1 VARCHAR2(20), 
     ATTRIBUTE_DATE2 VARCHAR2(20), 
     ATTRIBUTE_DATE3 VARCHAR2(20), 
     ATTRIBUTE_DATE4 VARCHAR2(20), 
     ATTRIBUTE_DATE5 VARCHAR2(20), 
     ATTRIBUTE_DATE6 VARCHAR2(20), 
     ATTRIBUTE_DATE7 VARCHAR2(20), 
     ATTRIBUTE_DATE8 VARCHAR2(20), 
     ATTRIBUTE_DATE9 VARCHAR2(20), 
     ATTRIBUTE_DATE10 VARCHAR2(20), 
     ATTRIBUTE_DATE11 VARCHAR2(20), 
     ATTRIBUTE_DATE12 VARCHAR2(20)
   )
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_PARTY_CLASSIFS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_PARTY_CLASSIFS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

EXEC DropTable ('XXMX_HZ_PARTIES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_PARTIES_EXT"
(
FILE_SET_ID                       VARCHAR2(30),        
PARTY_ORIG_SYSTEM                 VARCHAR2(30), 
PARTY_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
INSERT_UPDATE_FLAG                VARCHAR2(1) ,  
PARTY_TYPE                        VARCHAR2(30),  
PARTY_NUMBER                      VARCHAR2(30),  
SALUTATION                        VARCHAR2(60),  
PARTY_USAGE_CODE                  VARCHAR2(30),  
JGZZ_FISCAL_CODE                  VARCHAR2(60),  
ORGANIZATION_NAME                 VARCHAR2(360), 
DUNS_NUMBER_C                     VARCHAR2(30),  
PERSON_FIRST_NAME                 VARCHAR2(150), 
PERSON_LAST_NAME                  VARCHAR2(150), 
PERSON_LAST_NAME_PREFIX           VARCHAR2(30),  
PERSON_SECOND_LAST_NAME           VARCHAR2(150), 
PERSON_MIDDLE_NAME                VARCHAR2(60),  
PERSON_NAME_SUFFIX                VARCHAR2(30),  
PERSON_TITLE                      VARCHAR2(60),  
ATTRIBUTE_CATEGORY                VARCHAR2(30),  
ATTRIBUTE1                        VARCHAR2(150), 
ATTRIBUTE2                        VARCHAR2(150), 
ATTRIBUTE3                        VARCHAR2(150), 
ATTRIBUTE4                        VARCHAR2(150), 
ATTRIBUTE5                        VARCHAR2(150), 
ATTRIBUTE6                        VARCHAR2(150), 
ATTRIBUTE7                        VARCHAR2(150), 
ATTRIBUTE8                        VARCHAR2(150), 
ATTRIBUTE9                        VARCHAR2(150), 
ATTRIBUTE10                       VARCHAR2(150), 
ATTRIBUTE11                       VARCHAR2(150), 
ATTRIBUTE12                       VARCHAR2(150), 
ATTRIBUTE13                       VARCHAR2(150), 
ATTRIBUTE14                       VARCHAR2(150), 
ATTRIBUTE15                       VARCHAR2(150), 
ATTRIBUTE16                       VARCHAR2(150), 
ATTRIBUTE17                       VARCHAR2(150), 
ATTRIBUTE18                       VARCHAR2(150), 
ATTRIBUTE19                       VARCHAR2(150), 
ATTRIBUTE20                       VARCHAR2(150), 
ATTRIBUTE21                       VARCHAR2(150), 
ATTRIBUTE22                       VARCHAR2(150),
ATTRIBUTE23                       VARCHAR2(150),
ATTRIBUTE24                       VARCHAR2(150), 
ATTRIBUTE25                       VARCHAR2(150), 
ATTRIBUTE26                       VARCHAR2(150), 
ATTRIBUTE27                       VARCHAR2(150), 
ATTRIBUTE28                       VARCHAR2(150), 
ATTRIBUTE29                       VARCHAR2(150), 
ATTRIBUTE30                       VARCHAR2(255) 
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_PARTIES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_PARTIES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

EXEC DropTable ('XXMX_HZ_PARTY_SITES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_PARTY_SITES_EXT"
(
FILE_SET_ID                       VARCHAR2(30),            
PARTY_ORIG_SYSTEM                    VARCHAR2(30),  
PARTY_ORIG_SYSTEM_REFERENCE          VARCHAR2(240), 
SITE_ORIG_SYSTEM                     VARCHAR2(30) , 
SITE_ORIG_SYSTEM_REFERENCE           VARCHAR2(240), 
LOCATION_ORIG_SYSTEM                 VARCHAR2(30) , 
LOCATION_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
INSERT_UPDATE_FLAG                   VARCHAR2(1)  , 
PARTY_SITE_NAME                      VARCHAR2(240), 
PARTY_SITE_NUMBER                    VARCHAR2(30) , 
START_DATE_ACTIVE                    VARCHAR2(20)         , 
END_DATE_ACTIVE                      VARCHAR2(20)         , 
MAILSTOP                             VARCHAR2(60) , 
IDENTIFYING_ADDRESS_FLAG             VARCHAR2(1)  , 
PARTY_SITE_LANGUAGE                  VARCHAR2(4)  , 
ATTRIBUTE_CATEGORY                   VARCHAR2(30) , 
ATTRIBUTE1                           VARCHAR2(150), 
ATTRIBUTE2                           VARCHAR2(150), 
ATTRIBUTE3                           VARCHAR2(150), 
ATTRIBUTE4                           VARCHAR2(150), 
ATTRIBUTE5                           VARCHAR2(150), 
ATTRIBUTE6                           VARCHAR2(150), 
ATTRIBUTE7                           VARCHAR2(150), 
ATTRIBUTE8                           VARCHAR2(150), 
ATTRIBUTE9                           VARCHAR2(150), 
ATTRIBUTE10                          VARCHAR2(150), 
ATTRIBUTE11                          VARCHAR2(150), 
ATTRIBUTE12                          VARCHAR2(150), 
ATTRIBUTE13                          VARCHAR2(150), 
ATTRIBUTE14                          VARCHAR2(150), 
ATTRIBUTE15                          VARCHAR2(150), 
ATTRIBUTE16                          VARCHAR2(150), 
ATTRIBUTE17                          VARCHAR2(150), 
ATTRIBUTE18                          VARCHAR2(150), 
ATTRIBUTE19                          VARCHAR2(150), 
ATTRIBUTE20                          VARCHAR2(150), 
ATTRIBUTE21                          VARCHAR2(150), 
ATTRIBUTE22                          VARCHAR2(150), 
ATTRIBUTE23                          VARCHAR2(150), 
ATTRIBUTE24                          VARCHAR2(150), 
ATTRIBUTE25                          VARCHAR2(150), 
ATTRIBUTE26                          VARCHAR2(150), 
ATTRIBUTE27                          VARCHAR2(150), 
ATTRIBUTE28                          VARCHAR2(150), 
ATTRIBUTE29                          VARCHAR2(150), 
ATTRIBUTE30                          VARCHAR2(255), 
REL_ORIG_SYSTEM                      VARCHAR2(30) , 
REL_ORIG_SYSTEM_REFERENCE            VARCHAR2(240) 
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_PARTY_SITES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_PARTY_SITES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
  
EXEC DropTable ('XXMX_HZ_PARTY_SITE_USES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_PARTY_SITE_USES_EXT"
(
FILE_SET_ID                       VARCHAR2(30),   
PARTY_ORIG_SYSTEM                 VARCHAR2(30),  
PARTY_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
SITE_ORIG_SYSTEM                  VARCHAR2(30) , 
SITE_ORIG_SYSTEM_REFERENCE        VARCHAR2(240), 
SITE_USE_TYPE                     VARCHAR2(30) , 
PRIMARY_FLAG                      VARCHAR2(1)  , 
INSERT_UPDATE_FLAG                VARCHAR2(1)  , 
START_DATE                        VARCHAR2(20)         , 
END_DATE                          VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY                VARCHAR2(30) , 
ATTRIBUTE1                        VARCHAR2(150), 
ATTRIBUTE2                        VARCHAR2(150), 
ATTRIBUTE3                        VARCHAR2(150), 
ATTRIBUTE4                        VARCHAR2(150), 
ATTRIBUTE5                        VARCHAR2(150), 
ATTRIBUTE6                        VARCHAR2(150), 
ATTRIBUTE7                        VARCHAR2(150), 
ATTRIBUTE8                        VARCHAR2(150),
ATTRIBUTE9                        VARCHAR2(150), 
ATTRIBUTE10                       VARCHAR2(150), 
ATTRIBUTE11                       VARCHAR2(150), 
ATTRIBUTE12                       VARCHAR2(150), 
ATTRIBUTE13                       VARCHAR2(150), 
ATTRIBUTE14                       VARCHAR2(150), 
ATTRIBUTE15                       VARCHAR2(150), 
ATTRIBUTE16                       VARCHAR2(150), 
ATTRIBUTE17                       VARCHAR2(150), 
ATTRIBUTE18                       VARCHAR2(150), 
ATTRIBUTE19                       VARCHAR2(150), 
ATTRIBUTE20                       VARCHAR2(150),
ATTRIBUTE21                       VARCHAR2(150), 
ATTRIBUTE22                       VARCHAR2(150), 
ATTRIBUTE23                       VARCHAR2(150), 
ATTRIBUTE24                       VARCHAR2(150), 
ATTRIBUTE25                       VARCHAR2(150), 
ATTRIBUTE26                       VARCHAR2(150), 
ATTRIBUTE27                       VARCHAR2(150), 
ATTRIBUTE28                       VARCHAR2(150), 
ATTRIBUTE29                       VARCHAR2(150), 
ATTRIBUTE30                       VARCHAR2(255), 
SITEUSE_ORIG_SYSTEM               VARCHAR2(30) , 
SITEUSE_ORIG_SYSTEM_REF           VARCHAR2(240)  
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_PARTY_SITE_USES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_PARTY_SITE_USES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  
  
  

EXEC DropTable ('XXMX_HZ_CUST_ACCOUNTS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_ACCOUNTS_EXT"
(
FILE_SET_ID                       VARCHAR2(30),  
CUST_ORIG_SYSTEM                  VARCHAR2(30),  
CUST_ORIG_SYSTEM_REFERENCE        VARCHAR2(240), 
PARTY_ORIG_SYSTEM                 VARCHAR2(30) , 
PARTY_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
ACCOUNT_NUMBER                    VARCHAR2(30) , 
INSERT_UPDATE_FLAG                VARCHAR2(1)  , 
CUSTOMER_TYPE                     VARCHAR2(30) , 
CUSTOMER_CLASS_CODE               VARCHAR2(30) , 
ACCOUNT_NAME                      VARCHAR2(240), 
ACCOUNT_ESTABLISHED_DATE          VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY                VARCHAR2(30) , 
ATTRIBUTE1                        VARCHAR2(150), 
ATTRIBUTE2                        VARCHAR2(150), 
ATTRIBUTE3                        VARCHAR2(150), 
ATTRIBUTE4                        VARCHAR2(150), 
ATTRIBUTE5                        VARCHAR2(150), 
ATTRIBUTE6                        VARCHAR2(150), 
ATTRIBUTE7                        VARCHAR2(150), 
ATTRIBUTE8                        VARCHAR2(150), 
ATTRIBUTE9                        VARCHAR2(150), 
ATTRIBUTE10                       VARCHAR2(150), 
ATTRIBUTE11                       VARCHAR2(150), 
ATTRIBUTE12                       VARCHAR2(150), 
ATTRIBUTE13                       VARCHAR2(150), 
ATTRIBUTE14                       VARCHAR2(150), 
ATTRIBUTE15                       VARCHAR2(150), 
ATTRIBUTE16                       VARCHAR2(150), 
ATTRIBUTE17                       VARCHAR2(150), 
ATTRIBUTE18                       VARCHAR2(150), 
ATTRIBUTE19                       VARCHAR2(150), 
ATTRIBUTE20                       VARCHAR2(150), 
ATTRIBUTE21                       VARCHAR2(150), 
ATTRIBUTE22                       VARCHAR2(150), 
ATTRIBUTE23                       VARCHAR2(150), 
ATTRIBUTE24                       VARCHAR2(150), 
ATTRIBUTE25                       VARCHAR2(150), 
ATTRIBUTE26                       VARCHAR2(150), 
ATTRIBUTE27                       VARCHAR2(150), 
ATTRIBUTE28                       VARCHAR2(150), 
ATTRIBUTE29                       VARCHAR2(150), 
ATTRIBUTE30                       VARCHAR2(255), 
ACCOUNT_TERMINATION_DATE          VARCHAR2(20)            
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_ACCOUNTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_ACCOUNTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
  
EXEC DropTable ('XXMX_HZ_CUST_ACCT_SITES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_ACCT_SITES_EXT"
( 
FILE_SET_ID                       VARCHAR2(30), 
CUST_ORIG_SYSTEM                 VARCHAR2(30), 
CUST_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
ACCOUNT_NUMBER                   VARCHAR2(30),
CUST_SITE_ORIG_SYSTEM            VARCHAR2(30),  
CUST_SITE_ORIG_SYS_REF           VARCHAR2(240), 
SITE_ORIG_SYSTEM                 VARCHAR2(30),  
SITE_ORIG_SYSTEM_REFERENCE       VARCHAR2(240),
PARTY_SITE_NUMBER                VARCHAR2(30),  
ACCT_SITE_LANGUAGE               VARCHAR2(4) ,  
INSERT_UPDATE_FLAG               VARCHAR2(1) ,  
CUSTOMER_CATEGORY_CODE           VARCHAR2(30),  
TRANSLATED_CUSTOMER_NAME         VARCHAR2(360), 
SET_CODE                         VARCHAR2(30) , 
START_DATE                       VARCHAR2(20)         , 
END_DATE                         VARCHAR2(20)         , 
KEY_ACCOUNT_FLAG                 VARCHAR2(1)  , 
ATTRIBUTE_CATEGORY               VARCHAR2(30) , 
ATTRIBUTE1                       VARCHAR2(150), 
ATTRIBUTE2                       VARCHAR2(150), 
ATTRIBUTE3                       VARCHAR2(150), 
ATTRIBUTE4                       VARCHAR2(150), 
ATTRIBUTE5                       VARCHAR2(150), 
ATTRIBUTE6                       VARCHAR2(150), 
ATTRIBUTE7                       VARCHAR2(150), 
ATTRIBUTE8                       VARCHAR2(150), 
ATTRIBUTE9                       VARCHAR2(150), 
ATTRIBUTE10                      VARCHAR2(150), 
ATTRIBUTE11                      VARCHAR2(150), 
ATTRIBUTE12                      VARCHAR2(150), 
ATTRIBUTE13                      VARCHAR2(150), 
ATTRIBUTE14                      VARCHAR2(150), 
ATTRIBUTE15                      VARCHAR2(150), 
ATTRIBUTE16                      VARCHAR2(150), 
ATTRIBUTE17                      VARCHAR2(150), 
ATTRIBUTE18                      VARCHAR2(150), 
ATTRIBUTE19                      VARCHAR2(150), 
ATTRIBUTE20                      VARCHAR2(150), 
ATTRIBUTE21                      VARCHAR2(150), 
ATTRIBUTE22                      VARCHAR2(150), 
ATTRIBUTE23                      VARCHAR2(150), 
ATTRIBUTE24                      VARCHAR2(150), 
ATTRIBUTE25                      VARCHAR2(150), 
ATTRIBUTE26                      VARCHAR2(150),
ATTRIBUTE27                      VARCHAR2(150), 
ATTRIBUTE28                      VARCHAR2(150), 
ATTRIBUTE29                      VARCHAR2(150), 
ATTRIBUTE30                      VARCHAR2(255)   
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_ACCT_SITES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_ACCT_SITES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  

EXEC DropTable ('XXMX_HZ_CUST_SITE_USES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_SITE_USES_EXT"
( 
FILE_SET_ID                       VARCHAR2(30),
ACCOUNT_NUMBER                  VARCHAR2(30) , 
PARTY_SITE_NUMBER               VARCHAR2(30) , 
CUST_SITE_ORIG_SYSTEM           VARCHAR2(30) , 
CUST_SITE_ORIG_SYS_REF          VARCHAR2(240), 
CUST_SITEUSE_ORIG_SYSTEM        VARCHAR2(30) , 
CUST_SITEUSE_ORIG_SYS_REF       VARCHAR2(240) , 
SITE_USE_CODE                   VARCHAR2(30) , 
PRIMARY_FLAG                    VARCHAR2(1)  , 
INSERT_UPDATE_FLAG              VARCHAR2(1)  , 
LOCATION                        VARCHAR2(150),
SET_CODE                        VARCHAR2(30) , 
START_DATE                      VARCHAR2(20)         , 
END_DATE                        VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY              VARCHAR2(30) , 
ATTRIBUTE1                      VARCHAR2(150), 
ATTRIBUTE2                      VARCHAR2(150), 
ATTRIBUTE3                      VARCHAR2(150), 
ATTRIBUTE4                      VARCHAR2(150), 
ATTRIBUTE5                      VARCHAR2(150), 
ATTRIBUTE6                      VARCHAR2(150), 
ATTRIBUTE7                      VARCHAR2(150), 
ATTRIBUTE8                      VARCHAR2(150), 
ATTRIBUTE9                      VARCHAR2(150), 
ATTRIBUTE10                     VARCHAR2(150), 
ATTRIBUTE11                     VARCHAR2(150), 
ATTRIBUTE12                     VARCHAR2(150), 
ATTRIBUTE13                     VARCHAR2(150), 
ATTRIBUTE14                     VARCHAR2(150), 
ATTRIBUTE15                     VARCHAR2(150), 
ATTRIBUTE16                     VARCHAR2(150), 
ATTRIBUTE17                     VARCHAR2(150), 
ATTRIBUTE18                     VARCHAR2(150), 
ATTRIBUTE19                     VARCHAR2(150), 
ATTRIBUTE20                     VARCHAR2(150), 
ATTRIBUTE21                     VARCHAR2(150), 
ATTRIBUTE22                     VARCHAR2(150), 
ATTRIBUTE23                     VARCHAR2(150), 
ATTRIBUTE24                     VARCHAR2(150), 
ATTRIBUTE25                     VARCHAR2(150), 
ATTRIBUTE26                     VARCHAR2(150), 
ATTRIBUTE27                     VARCHAR2(150), 
ATTRIBUTE28                     VARCHAR2(150), 
ATTRIBUTE29                     VARCHAR2(150), 
ATTRIBUTE30                     VARCHAR2(255) 
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_SITE_USES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_SITE_USES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;    
  
EXEC DropTable ('XXMX_HZ_CUST_ACCT_CONTACTS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_ACCT_CONTACTS_EXT"
(
   FILE_SET_ID                       VARCHAR2(30),
   CUST_ORIG_SYSTEM                 VARCHAR2(30),  
   CUST_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
   CUST_SITE_ORIG_SYSTEM            VARCHAR2(30) , 
   CUST_SITE_ORIG_SYS_REF           VARCHAR2(240), 
   CUST_CONTACT_ORIG_SYSTEM         VARCHAR2(30) , 
   CUST_CONTACT_ORIG_SYS_REF        VARCHAR2(240), 
   ROLE_TYPE                        VARCHAR2(30) , 
   PRIMARY_FLAG                     VARCHAR2(1)  , 
   INSERT_UPDATE_FLAG               VARCHAR2(1)  , 
   SOURCE_CODE                      VARCHAR2(150), 
   ATTRIBUTE_CATEGORY               VARCHAR2(30) , 
   ATTRIBUTE1                       VARCHAR2(150), 
   ATTRIBUTE2                       VARCHAR2(150), 
   ATTRIBUTE3                       VARCHAR2(150), 
   ATTRIBUTE4                       VARCHAR2(150), 
   ATTRIBUTE5                       VARCHAR2(150), 
   ATTRIBUTE6                       VARCHAR2(150), 
   ATTRIBUTE7                       VARCHAR2(150), 
   ATTRIBUTE8                       VARCHAR2(150), 
   ATTRIBUTE9                       VARCHAR2(150), 
   ATTRIBUTE10                      VARCHAR2(150), 
   ATTRIBUTE11                      VARCHAR2(150), 
   ATTRIBUTE12                      VARCHAR2(150), 
   ATTRIBUTE13                      VARCHAR2(150), 
   ATTRIBUTE14                      VARCHAR2(150), 
   ATTRIBUTE15                      VARCHAR2(150), 
   ATTRIBUTE16                      VARCHAR2(150), 
   ATTRIBUTE17                      VARCHAR2(150), 
   ATTRIBUTE18                      VARCHAR2(150), 
   ATTRIBUTE19                      VARCHAR2(150), 
   ATTRIBUTE20                      VARCHAR2(150), 
   ATTRIBUTE21                      VARCHAR2(150), 
   ATTRIBUTE22                      VARCHAR2(150), 
   ATTRIBUTE23                      VARCHAR2(150), 
   ATTRIBUTE24                      VARCHAR2(150), 
   ATTRIBUTE25                      VARCHAR2(150), 
   ATTRIBUTE26                      VARCHAR2(150), 
   ATTRIBUTE27                      VARCHAR2(150), 
   ATTRIBUTE28                      VARCHAR2(150), 
   ATTRIBUTE29                      VARCHAR2(150), 
   ATTRIBUTE30                      VARCHAR2(255), 
   ATTRIBUTE_NUMBER1                NUMBER       , 
   ATTRIBUTE_NUMBER2                NUMBER       , 
   ATTRIBUTE_NUMBER3                NUMBER       , 
   ATTRIBUTE_NUMBER4                NUMBER       , 
   ATTRIBUTE_NUMBER5                NUMBER       , 
   ATTRIBUTE_NUMBER6                NUMBER       , 
   ATTRIBUTE_NUMBER7                NUMBER       , 
   ATTRIBUTE_NUMBER8                NUMBER       , 
   ATTRIBUTE_NUMBER9                NUMBER       , 
   ATTRIBUTE_NUMBER10               NUMBER       , 
   ATTRIBUTE_NUMBER11               NUMBER       , 
   ATTRIBUTE_NUMBER12               NUMBER       , 
   ATTRIBUTE_DATE1                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE6                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE7                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE8                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE9                  VARCHAR2(20)         , 
   ATTRIBUTE_DATE10                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE11                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE12                 VARCHAR2(20)         , 
   REL_ORIG_SYSTEM                  VARCHAR2(30) , 
   REL_ORIG_SYSTEM_REFERENCE        VARCHAR2(240)   
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_ACCT_CONTACTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_ACCT_CONTACTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
  
  
  
 EXEC DropTable ('XXMX_HZ_CONTACT_POINTS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CONTACT_POINTS_EXT"
(
   FILE_SET_ID                       VARCHAR2(30),
   CP_ORIG_SYSTEM                    VARCHAR2(30) ,  
   CP_ORIG_SYSTEM_REFERENCE          VARCHAR2(240),  
   PARTY_ORIG_SYSTEM                 VARCHAR2(30) ,  
   PARTY_ORIG_SYSTEM_REFERENCE       VARCHAR2(240),  
   SITE_ORIG_SYSTEM                  VARCHAR2(30) ,  
   SITE_ORIG_SYSTEM_REFERENCE        VARCHAR2(240),  
   PRIMARY_FLAG                      VARCHAR2(1)  ,  
   INSERT_UPDATE_FLAG                VARCHAR2(1)  ,  
   CONTACT_POINT_TYPE                VARCHAR2(30) ,  
   CONTACT_POINT_PURPOSE             VARCHAR2(30) ,  
   EMAIL_ADDRESS                     VARCHAR2(320),  
   EMAIL_FORMAT                      VARCHAR2(30) ,  
   PHONE_AREA_CODE                   VARCHAR2(10) ,  
   PHONE_COUNTRY_CODE                VARCHAR2(10) ,  
   PHONE_EXTENSION                   VARCHAR2(20) ,  
   PHONE_LINE_TYPE                   VARCHAR2(30) ,  
   PHONE_NUMBER                      VARCHAR2(40) ,  
   URL                               VARCHAR2(2000),
   PHONE_CALLING_CALENDAR            VARCHAR2(30)  , 
   START_DATE                        VARCHAR2(20)          , 
   END_DATE                          VARCHAR2(20)          , 
   ATTRIBUTE_CATEGORY                VARCHAR2(30)  , 
   ATTRIBUTE1                        VARCHAR2(150) , 
   ATTRIBUTE2                        VARCHAR2(150) , 
   ATTRIBUTE3                        VARCHAR2(150) , 
   ATTRIBUTE4                        VARCHAR2(150) , 
   ATTRIBUTE5                        VARCHAR2(150) , 
   ATTRIBUTE6                        VARCHAR2(150) , 
   ATTRIBUTE7                        VARCHAR2(150) , 
   ATTRIBUTE8                        VARCHAR2(150) , 
   ATTRIBUTE9                        VARCHAR2(150) , 
   ATTRIBUTE10                       VARCHAR2(150) , 
   ATTRIBUTE11                       VARCHAR2(150) , 
   ATTRIBUTE12                       VARCHAR2(150) , 
   ATTRIBUTE13                       VARCHAR2(150) , 
   ATTRIBUTE14                       VARCHAR2(150) , 
   ATTRIBUTE15                       VARCHAR2(150) , 
   ATTRIBUTE16                       VARCHAR2(150) , 
   ATTRIBUTE17                       VARCHAR2(150) , 
   ATTRIBUTE18                       VARCHAR2(150) ,
   ATTRIBUTE19                       VARCHAR2(150) , 
   ATTRIBUTE20                       VARCHAR2(150) , 
   ATTRIBUTE21                       VARCHAR2(150) , 
   ATTRIBUTE22                       VARCHAR2(150) , 
   ATTRIBUTE23                       VARCHAR2(150) , 
   ATTRIBUTE24                       VARCHAR2(150) , 
   ATTRIBUTE25                       VARCHAR2(150) , 
   ATTRIBUTE26                       VARCHAR2(150) , 
   ATTRIBUTE27                       VARCHAR2(150) , 
   ATTRIBUTE28                       VARCHAR2(150) , 
   ATTRIBUTE29                       VARCHAR2(150) , 
   ATTRIBUTE30                       VARCHAR2(255) , 
   ATTRIBUTE_NUMBER1                 NUMBER        , 
   ATTRIBUTE_NUMBER2                 NUMBER        , 
   ATTRIBUTE_NUMBER3                 NUMBER        , 
   ATTRIBUTE_NUMBER4                 NUMBER        , 
   ATTRIBUTE_NUMBER5                 NUMBER        , 
   ATTRIBUTE_NUMBER6                 NUMBER        , 
   ATTRIBUTE_NUMBER7                 NUMBER        , 
   ATTRIBUTE_NUMBER8                 NUMBER        , 
   ATTRIBUTE_NUMBER9                 NUMBER        , 
   ATTRIBUTE_NUMBER10                NUMBER        , 
   ATTRIBUTE_NUMBER11                NUMBER        , 
   ATTRIBUTE_NUMBER12                NUMBER        , 
   ATTRIBUTE_DATE1                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE2                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE3                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE4                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE5                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE6                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE7                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE8                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE9                   VARCHAR2(20)          , 
   ATTRIBUTE_DATE10                  VARCHAR2(20)          , 
   ATTRIBUTE_DATE11                  VARCHAR2(20)          , 
   ATTRIBUTE_DATE12                  VARCHAR2(20)          , 
   REL_ORIG_SYSTEM                   VARCHAR2(30)  , 
   REL_ORIG_SYSTEM_REFERENCE         VARCHAR2(240)  
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CONTACT_POINTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CONTACT_POINTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
  
  
EXEC DropTable ('XXMX_HZ_ORG_CONTACT_ROLES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_ORG_CONTACT_ROLES_EXT"
(
   FILE_SET_ID                       VARCHAR2(30),
   INSERT_UPDATE_CODE                  VARCHAR2(30), 
   INSERT_UPDATE_FLAG                  VARCHAR2(1) ,  
   CONTACT_ROLE_ORIG_SYSTEM            VARCHAR2(30),  
   CONTACT_ROLE_ORIG_SYS_REF           VARCHAR2(240), 
   REL_ORIG_SYSTEM                     VARCHAR2(30) , 
   REL_ORIG_SYSTEM_REFERENCE           VARCHAR2(240), 
   ROLE_TYPE                           VARCHAR2(30),  
   ROLE_LEVEL                          VARCHAR2(1) ,  
   PRIMARY_FLAG                        VARCHAR2(1) ,  
   PRIMARY_CONTACT_PER_ROLE_TYPE       VARCHAR2(1) ,  
   ATTRIBUTE_CATEGORY                  VARCHAR2(30),  
   ATTRIBUTE1                          VARCHAR2(150), 
   ATTRIBUTE2                          VARCHAR2(150), 
   ATTRIBUTE3                          VARCHAR2(150), 
   ATTRIBUTE4                          VARCHAR2(150), 
   ATTRIBUTE5                          VARCHAR2(150), 
   ATTRIBUTE6                          VARCHAR2(150), 
   ATTRIBUTE7                          VARCHAR2(150), 
   ATTRIBUTE8                          VARCHAR2(150), 
   ATTRIBUTE9                          VARCHAR2(150), 
   ATTRIBUTE10                         VARCHAR2(150), 
   ATTRIBUTE11                         VARCHAR2(150), 
   ATTRIBUTE12                         VARCHAR2(150), 
   ATTRIBUTE13                         VARCHAR2(150), 
   ATTRIBUTE14                         VARCHAR2(150), 
   ATTRIBUTE15                         VARCHAR2(150), 
   ATTRIBUTE16                         VARCHAR2(150), 
   ATTRIBUTE17                         VARCHAR2(150), 
   ATTRIBUTE18                         VARCHAR2(150), 
   ATTRIBUTE19                         VARCHAR2(150), 
   ATTRIBUTE20                         VARCHAR2(150), 
   ATTRIBUTE21                         VARCHAR2(150), 
   ATTRIBUTE22                         VARCHAR2(150), 
   ATTRIBUTE23                         VARCHAR2(150), 
   ATTRIBUTE24                         VARCHAR2(150), 
   ATTRIBUTE25                         VARCHAR2(150), 
   ATTRIBUTE26                         VARCHAR2(150), 
   ATTRIBUTE27                         VARCHAR2(150), 
   ATTRIBUTE28                         VARCHAR2(150), 
   ATTRIBUTE29                         VARCHAR2(150), 
   ATTRIBUTE30                         VARCHAR2(255), 
   ATTRIBUTE_NUMBER1                   NUMBER       , 
   ATTRIBUTE_NUMBER2                   NUMBER       , 
   ATTRIBUTE_NUMBER3                   NUMBER       , 
   ATTRIBUTE_NUMBER4                   NUMBER       , 
   ATTRIBUTE_NUMBER5                   NUMBER       , 
   ATTRIBUTE_NUMBER6                   NUMBER       , 
   ATTRIBUTE_NUMBER7                   NUMBER       , 
   ATTRIBUTE_NUMBER8                   NUMBER       , 
   ATTRIBUTE_NUMBER9                   NUMBER       , 
   ATTRIBUTE_NUMBER10                  NUMBER       , 
   ATTRIBUTE_NUMBER11                  NUMBER       , 
   ATTRIBUTE_NUMBER12                  NUMBER       , 
   ATTRIBUTE_DATE1                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE6                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE7                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE8                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE9                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE10                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE11                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE12                    VARCHAR2(20)          
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_ORG_CONTACT_ROLES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_ORG_CONTACT_ROLES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  

EXEC DropTable ('XXMX_HZ_ORG_CONTACTS_EXT')

CREATE TABLE "XXMX_CORE"."XXMX_HZ_ORG_CONTACTS_EXT"
(
   FILE_SET_ID                       VARCHAR2(30),
   INSERT_UPDATE_FLAG              VARCHAR2(1) ,  
   CONTACT_NUMBER                  VARCHAR2(30), 
   DEPARTMENT_CODE                 VARCHAR2(30),  
   DEPARTMENT                      VARCHAR2(60),  
   JOB_TITLE                       VARCHAR2(100), 
   JOB_TITLE_CODE                  VARCHAR2(30),  
   ATTRIBUTE_CATEGORY              VARCHAR2(30),  
   ATTRIBUTE1                      VARCHAR2(150), 
   ATTRIBUTE2                      VARCHAR2(150), 
   ATTRIBUTE3                      VARCHAR2(150), 
   ATTRIBUTE4                      VARCHAR2(150), 
   ATTRIBUTE5                      VARCHAR2(150), 
   ATTRIBUTE6                      VARCHAR2(150), 
   ATTRIBUTE7                      VARCHAR2(150), 
   ATTRIBUTE8                      VARCHAR2(150), 
   ATTRIBUTE9                      VARCHAR2(150), 
   ATTRIBUTE10                     VARCHAR2(150), 
   ATTRIBUTE11                     VARCHAR2(150), 
   ATTRIBUTE12                     VARCHAR2(150), 
   ATTRIBUTE13                     VARCHAR2(150), 
   ATTRIBUTE14                     VARCHAR2(150), 
   ATTRIBUTE15                     VARCHAR2(150), 
   ATTRIBUTE16                     VARCHAR2(150), 
   ATTRIBUTE17                     VARCHAR2(150), 
   ATTRIBUTE18                     VARCHAR2(150), 
   ATTRIBUTE19                     VARCHAR2(150), 
   ATTRIBUTE20                     VARCHAR2(150), 
   ATTRIBUTE21                     VARCHAR2(150), 
   ATTRIBUTE22                     VARCHAR2(150), 
   ATTRIBUTE23                     VARCHAR2(150), 
   ATTRIBUTE24                     VARCHAR2(150), 
   ATTRIBUTE25                     VARCHAR2(150), 
   ATTRIBUTE26                     VARCHAR2(150), 
   ATTRIBUTE27                     VARCHAR2(150), 
   ATTRIBUTE28                     VARCHAR2(150), 
   ATTRIBUTE29                     VARCHAR2(150), 
   ATTRIBUTE30                     VARCHAR2(255), 
   ATTRIBUTE_NUMBER1               NUMBER       , 
   ATTRIBUTE_NUMBER2               NUMBER       , 
   ATTRIBUTE_NUMBER3               NUMBER       , 
   ATTRIBUTE_NUMBER4               NUMBER       , 
   ATTRIBUTE_NUMBER5               NUMBER       , 
   ATTRIBUTE_NUMBER6               NUMBER       , 
   ATTRIBUTE_NUMBER7               NUMBER       , 
   ATTRIBUTE_NUMBER8               NUMBER       , 
   ATTRIBUTE_NUMBER9               NUMBER       , 
   ATTRIBUTE_NUMBER10              NUMBER       , 
   ATTRIBUTE_NUMBER11              NUMBER       , 
   ATTRIBUTE_NUMBER12              NUMBER       , 
   ATTRIBUTE_DATE1                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE6                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE7                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE8                 VARCHAR2(20)         , 
   ATTRIBUTE_DATE9                 VARCHAR2(20)         ,
   ATTRIBUTE_DATE10                VARCHAR2(20)         , 
   ATTRIBUTE_DATE11                VARCHAR2(20)         , 
   ATTRIBUTE_DATE12                VARCHAR2(20)         , 
   REL_ORIG_SYSTEM                 VARCHAR2(30) , 
   REL_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
   PS_ORIG_SYSTEM                  VARCHAR2(30) , 
   PS_ORIG_SYSTEM_REFERENCE        VARCHAR2(240)
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_ORG_CONTACTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_ORG_CONTACTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
  

EXEC DropTable ('XXMX_HZ_LOCATIONS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_LOCATIONS_EXT"
(
FILE_SET_ID                       VARCHAR2(30),
LOCATION_ORIG_SYSTEM                 VARCHAR2(30),   
LOCATION_ORIG_SYSTEM_REFERENCE       VARCHAR2(240),  
INSERT_UPDATE_FLAG                   VARCHAR2(1)  ,  
COUNTRY                              VARCHAR2(2)  ,  
ADDRESS1                             VARCHAR2(240),  
ADDRESS2                             VARCHAR2(240),  
ADDRESS3                             VARCHAR2(240),  
ADDRESS4                             VARCHAR2(240),  
CITY                                 VARCHAR2(60) ,  
STATE                                VARCHAR2(60) ,  
PROVINCE                             VARCHAR2(60) ,  
COUNTY                               VARCHAR2(60) ,  
POSTAL_CODE                          VARCHAR2(60) ,  
POSTAL_PLUS4_CODE                    VARCHAR2(10) ,  
LOCATION_LANGUAGE                    VARCHAR2(4)  ,  
DESCRIPTION                          VARCHAR2(2000), 
SHORT_DESCRIPTION                    VARCHAR2(240) , 
SALES_TAX_GEOCODE                    VARCHAR2(30)  , 
SALES_TAX_INSIDE_CITY_LIMITS         VARCHAR2(1)   , 
TIMEZONE_CODE                        VARCHAR2(50)  , 
ADDRESS1_STD                         VARCHAR2(240) , 
ADAPTER_CONTENT_SOURCE               VARCHAR2(30)  , 
ADDR_VALID_STATUS_CODE               VARCHAR2(30)  , 
DATE_VALIDATED                       VARCHAR2(20)          , 
ADDRESS_EFFECTIVE_DATE               VARCHAR2(20)          , 
ADDRESS_EXPIRATION_DATE              VARCHAR2(20)          , 
VALIDATED_FLAG                       VARCHAR2(1)   , 
DO_NOT_VALIDATE_FLAG                 VARCHAR2(1)   , 
INTERFACE_STATUS                     VARCHAR2(30)  , 
ERROR_ID                             NUMBER        , 
ATTRIBUTE_CATEGORY                   VARCHAR2(30)  , 
ATTRIBUTE1                           VARCHAR2(150) , 
ATTRIBUTE2                           VARCHAR2(150) , 
ATTRIBUTE3                           VARCHAR2(150) , 
ATTRIBUTE4                           VARCHAR2(150) , 
ATTRIBUTE5                           VARCHAR2(150) , 
ATTRIBUTE6                           VARCHAR2(150) , 
ATTRIBUTE7                           VARCHAR2(150) , 
ATTRIBUTE8                           VARCHAR2(150) , 
ATTRIBUTE9                           VARCHAR2(150) , 
ATTRIBUTE10                          VARCHAR2(150) , 
ATTRIBUTE11                          VARCHAR2(150) , 
ATTRIBUTE12                          VARCHAR2(150) , 
ATTRIBUTE13                          VARCHAR2(150) , 
ATTRIBUTE14                          VARCHAR2(150) , 
ATTRIBUTE15                          VARCHAR2(150) , 
ATTRIBUTE16                          VARCHAR2(150) , 
ATTRIBUTE17                          VARCHAR2(150) , 
ATTRIBUTE18                          VARCHAR2(150) , 
ATTRIBUTE19                          VARCHAR2(150) , 
ATTRIBUTE20                          VARCHAR2(150) , 
ATTRIBUTE21                          VARCHAR2(150) , 
ATTRIBUTE22                          VARCHAR2(150) , 
ATTRIBUTE23                          VARCHAR2(150) , 
ATTRIBUTE24                          VARCHAR2(150) , 
ATTRIBUTE25                          VARCHAR2(150) , 
ATTRIBUTE26                          VARCHAR2(150) , 
ATTRIBUTE27                          VARCHAR2(150) , 
ATTRIBUTE28                          VARCHAR2(150) , 
ATTRIBUTE29                          VARCHAR2(150) , 
ATTRIBUTE30                          VARCHAR2(255) ,
ATTRIBUTE_NUMBER1                    NUMBER        , 
ATTRIBUTE_NUMBER2                    NUMBER        , 
ATTRIBUTE_NUMBER3                    NUMBER        , 
ATTRIBUTE_NUMBER4                    NUMBER        , 
ATTRIBUTE_NUMBER5                    NUMBER        , 
ATTRIBUTE_NUMBER6                    NUMBER        , 
ATTRIBUTE_NUMBER7                    NUMBER        , 
ATTRIBUTE_NUMBER8                    NUMBER        , 
ATTRIBUTE_NUMBER9                    NUMBER        ,
ATTRIBUTE_NUMBER10                   NUMBER        , 
ATTRIBUTE_NUMBER11                   NUMBER        , 
ATTRIBUTE_NUMBER12                   NUMBER        , 
ATTRIBUTE_DATE1                      VARCHAR2(20)          , 
ATTRIBUTE_DATE2                      VARCHAR2(20)          , 
ATTRIBUTE_DATE3                      VARCHAR2(20)          , 
ATTRIBUTE_DATE4                      VARCHAR2(20)          , 
ATTRIBUTE_DATE5                      VARCHAR2(20)          , 
ATTRIBUTE_DATE6                      VARCHAR2(20)          , 
ATTRIBUTE_DATE7                      VARCHAR2(20)          , 
ATTRIBUTE_DATE8                      VARCHAR2(20)          , 
ATTRIBUTE_DATE9                      VARCHAR2(20)          , 
ATTRIBUTE_DATE10                     VARCHAR2(20)          , 
ATTRIBUTE_DATE11                     VARCHAR2(20)          , 
ATTRIBUTE_DATE12                     VARCHAR2(20)          , 
GNR_STATUS                           VARCHAR2(4)    
)
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_LOCATIONS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_LOCATIONS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
 EXEC DropTable ('XXMX_HZ_RELATIONSHIPS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_RELATIONSHIPS_EXT"
(
FILE_SET_ID                       VARCHAR2(30),
SUB_ORIG_SYSTEM                 VARCHAR2(30),  
SUB_ORIG_SYSTEM_REFERENCE       VARCHAR2(240) ,
OBJ_ORIG_SYSTEM                 VARCHAR2(30)  ,
OBJ_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
RELATIONSHIP_TYPE               VARCHAR2(30) , 
RELATIONSHIP_CODE               VARCHAR2(30) , 
START_DATE                      VARCHAR2(20)         , 
INSERT_UPDATE_FLAG              VARCHAR2(1)  , 
END_DATE                        VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY              VARCHAR2(30) , 
ATTRIBUTE1                      VARCHAR2(150), 
ATTRIBUTE2                      VARCHAR2(150), 
ATTRIBUTE3                      VARCHAR2(150), 
ATTRIBUTE4                      VARCHAR2(150), 
ATTRIBUTE5                      VARCHAR2(150), 
ATTRIBUTE6                      VARCHAR2(150), 
ATTRIBUTE7                      VARCHAR2(150), 
ATTRIBUTE8                      VARCHAR2(150), 
ATTRIBUTE9                      VARCHAR2(150), 
ATTRIBUTE10                     VARCHAR2(150), 
ATTRIBUTE11                     VARCHAR2(150), 
ATTRIBUTE12                     VARCHAR2(150), 
ATTRIBUTE13                     VARCHAR2(150), 
ATTRIBUTE14                     VARCHAR2(150), 
ATTRIBUTE15                     VARCHAR2(150), 
ATTRIBUTE16                     VARCHAR2(150), 
ATTRIBUTE17                     VARCHAR2(150), 
ATTRIBUTE18                     VARCHAR2(150), 
ATTRIBUTE19                     VARCHAR2(150), 
ATTRIBUTE20                     VARCHAR2(150), 
ATTRIBUTE21                     VARCHAR2(150), 
ATTRIBUTE22                     VARCHAR2(150), 
ATTRIBUTE23                     VARCHAR2(150), 
ATTRIBUTE24                     VARCHAR2(150), 
ATTRIBUTE25                     VARCHAR2(150), 
ATTRIBUTE26                     VARCHAR2(150), 
ATTRIBUTE27                     VARCHAR2(150), 
ATTRIBUTE28                     VARCHAR2(150), 
ATTRIBUTE29                     VARCHAR2(150), 
ATTRIBUTE30                     VARCHAR2(255), 
ATTRIBUTE_NUMBER1               NUMBER       , 
ATTRIBUTE_NUMBER2               NUMBER       , 
ATTRIBUTE_NUMBER3               NUMBER       , 
ATTRIBUTE_NUMBER4               NUMBER       , 
ATTRIBUTE_NUMBER5               NUMBER       , 
ATTRIBUTE_NUMBER6               NUMBER       , 
ATTRIBUTE_NUMBER7               NUMBER       , 
ATTRIBUTE_NUMBER8               NUMBER       , 
ATTRIBUTE_NUMBER9               NUMBER       , 
ATTRIBUTE_NUMBER10              NUMBER       , 
ATTRIBUTE_NUMBER11              NUMBER       , 
ATTRIBUTE_NUMBER12              NUMBER       , 
ATTRIBUTE_DATE1                 VARCHAR2(20)         , 
ATTRIBUTE_DATE2                 VARCHAR2(20)         , 
ATTRIBUTE_DATE3                 VARCHAR2(20)         , 
ATTRIBUTE_DATE4                 VARCHAR2(20)         , 
ATTRIBUTE_DATE5                 VARCHAR2(20)         , 
ATTRIBUTE_DATE6                 VARCHAR2(20)         , 
ATTRIBUTE_DATE7                 VARCHAR2(20)         ,
ATTRIBUTE_DATE8                 VARCHAR2(20)         , 
ATTRIBUTE_DATE9                 VARCHAR2(20)         , 
ATTRIBUTE_DATE10                VARCHAR2(20)         , 
ATTRIBUTE_DATE11                VARCHAR2(20)         , 
ATTRIBUTE_DATE12                VARCHAR2(20)         , 
SUBJECT_TYPE                    VARCHAR2(30) , 
OBJECT_TYPE                     VARCHAR2(30) , 
REL_ORIG_SYSTEM                 VARCHAR2(30) , 
REL_ORIG_SYSTEM_REFERENCE       VARCHAR2(240) 
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_RELATIONSHIPS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_RELATIONSHIPS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
  

EXEC DropTable ('XXMX_HZ_CUST_PROFILES_EXT')
  
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_PROFILES_EXT"
(
FILE_SET_ID                       VARCHAR2(30),
INSERT_UPDATE_FLAG                  VARCHAR2(1),   
PARTY_ORIG_SYSTEM                   VARCHAR2(240) ,
PARTY_ORIG_SYSTEM_REFERENCE         VARCHAR2(240), 
CUST_ORIG_SYSTEM                    VARCHAR2(240), 
CUST_ORIG_SYSTEM_REFERENCE          VARCHAR2(240), 
CUST_SITE_ORIG_SYSTEM               VARCHAR2(240), 
CUST_SITE_ORIG_SYS_REF              VARCHAR2(240), 
CUSTOMER_PROFILE_CLASS_NAME         VARCHAR2(30),  
COLLECTOR_NAME                      VARCHAR2(30),  
CREDIT_ANALYST_NAME                 VARCHAR2(240), 
CREDIT_REVIEW_CYCLE                 VARCHAR2(20),  
LAST_CREDIT_REVIEW_DATE             VARCHAR2(20)        ,  
NEXT_CREDIT_REVIEW_DATE             VARCHAR2(20)        ,  
CREDIT_BALANCE_STATEMENTS           VARCHAR2(1) ,  
CREDIT_CHECKING                     VARCHAR2(1) ,  
CREDIT_HOLD                         VARCHAR2(1) ,  
DISCOUNT_TERMS                      VARCHAR2(1) ,  
DUNNING_LETTERS                     VARCHAR2(1) ,  
INTEREST_CHARGES                    VARCHAR2(1) ,  
STATEMENTS                          VARCHAR2(1) ,  
TOLERANCE                           NUMBER      ,  
TAX_PRINTING_OPTION                 VARCHAR2(30),  
ACCOUNT_STATUS                      VARCHAR2(30),  
AUTOCASH_HIERARCHY_NAME             VARCHAR2(30) , 
CREDIT_RATING                       VARCHAR2(30) , 
DISCOUNT_GRACE_DAYS                 NUMBER       , 
INTEREST_PERIOD_DAYS                NUMBER       , 
OVERRIDE_TERMS                      VARCHAR2(1)  , 
PAYMENT_GRACE_DAYS                  NUMBER       , 
PERCENT_COLLECTABLE                 NUMBER       , 
RISK_CODE                           VARCHAR2(30) , 
STANDARD_TERM_NAME                  VARCHAR2(15) , 
STATEMENT_CYCLE_NAME                VARCHAR2(15) , 
CHARGE_ON_FINANCE_CHARGE_FLAG       VARCHAR2(1)  , 
GROUPING_RULE_NAME                  VARCHAR2(40) , 
CURRENCY_CODE                       VARCHAR2(15) , 
AUTO_REC_MIN_RECEIPT_AMOUNT         NUMBER       , 
INTEREST_RATE                       NUMBER       , 
MAX_INTEREST_CHARGE                 NUMBER       , 
MIN_DUNNING_AMOUNT                  NUMBER       , 
MIN_DUNNING_INVOICE_AMOUNT          NUMBER       , 
MIN_FC_BALANCE_AMOUNT               NUMBER       , 
MIN_FC_INVOICE_AMOUNT               NUMBER       , 
MIN_STATEMENT_AMOUNT                NUMBER       , 
OVERALL_CREDIT_LIMIT                NUMBER       , 
TRX_CREDIT_LIMIT                    NUMBER       , 
ATTRIBUTE_CATEGORY                  VARCHAR2(30) , 
ATTRIBUTE1                          VARCHAR2(150), 
ATTRIBUTE10                         VARCHAR2(150), 
ATTRIBUTE11                         VARCHAR2(150), 
ATTRIBUTE12                         VARCHAR2(150), 
ATTRIBUTE13                         VARCHAR2(150), 
ATTRIBUTE14                         VARCHAR2(150), 
ATTRIBUTE15                         VARCHAR2(150), 
ATTRIBUTE2                          VARCHAR2(150), 
ATTRIBUTE3                          VARCHAR2(150), 
ATTRIBUTE4                          VARCHAR2(150), 
ATTRIBUTE5                          VARCHAR2(150), 
ATTRIBUTE6                          VARCHAR2(150), 
ATTRIBUTE7                          VARCHAR2(150), 
ATTRIBUTE8                          VARCHAR2(150), 
ATTRIBUTE9                          VARCHAR2(150), 
AMOUNT_ATTRIBUTE_CATEGORY           VARCHAR2(30) , 
AMOUNT_ATTRIBUTE1                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE10                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE11                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE12                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE13                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE14                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE15                  VARCHAR2(150), 
AMOUNT_ATTRIBUTE2                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE3                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE4                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE5                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE6                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE7                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE8                   VARCHAR2(150), 
AMOUNT_ATTRIBUTE9                   VARCHAR2(150), 
AUTO_REC_INCL_DISPUTED_FLAG         VARCHAR2(1)  , 
CLEARING_DAYS                       NUMBER       , 
ORG_ID                              NUMBER       , 
CONS_INV_FLAG                       VARCHAR2(1)  , 
CONS_INV_TYPE                       VARCHAR2(30) , 
LOCKBOX_MATCHING_OPTION             VARCHAR2(30) ,
AUTOCASH_HIERARCHY_NAME_ADR         VARCHAR2(30) , 
CREDIT_CLASSIFICATION               VARCHAR2(30) , 
CONS_BILL_LEVEL                     VARCHAR2(30) , 
LATE_CHARGE_CALCULATION_TRX         VARCHAR2(30) , 
CREDIT_ITEMS_FLAG                   VARCHAR2(1)  , 
DISPUTED_TRANSACTIONS_FLAG          VARCHAR2(1)  , 
LATE_CHARGE_TYPE                    VARCHAR2(30) , 
INTEREST_CALCULATION_PERIOD         VARCHAR2(30) , 
HOLD_CHARGED_INVOICES_FLAG          VARCHAR2(1)  , 
MULTIPLE_INTEREST_RATES_FLAG        VARCHAR2(1)  , 
CHARGE_BEGIN_DATE                   VARCHAR2(20)         , 
EXCHANGE_RATE_TYPE                  VARCHAR2(30) , 
MIN_FC_INVOICE_OVERDUE_TYPE         VARCHAR2(30) , 
MIN_FC_INVOICE_PERCENT              NUMBER       , 
MIN_FC_BALANCE_OVERDUE_TYPE         VARCHAR2(30) , 
MIN_FC_BALANCE_PERCENT              NUMBER       , 
INTEREST_TYPE                       VARCHAR2(30) , 
INTEREST_FIXED_AMOUNT               NUMBER       , 
PENALTY_TYPE                        VARCHAR2(30) ,
PENALTY_RATE                        NUMBER       ,
MIN_INTEREST_CHARGE                 NUMBER       , 
PENALTY_FIXED_AMOUNT                NUMBER       , 
AUTOMATCH_RULE_NAME                 VARCHAR2(30) , 
MATCH_BY_AUTOUPDATE_FLAG            VARCHAR2(1)  , 
PRINTING_OPTION_CODE                VARCHAR2(30) , 
TXN_DELIVERY_METHOD                 VARCHAR2(30) , 
STMT_DELIVERY_METHOD                VARCHAR2(30) , 
XML_INV_FLAG                        VARCHAR2(1)  , 
XML_DM_FLAG                         VARCHAR2(1)  , 
XML_CB_FLAG                         VARCHAR2(1)  , 
XML_CM_FLAG                         VARCHAR2(1)  , 
CMK_CONFIG_FLAG                     VARCHAR2(1)  , 
SERVICE_PROVIDER_NAME               VARCHAR2(256), 
PARTNER_ID                          VARCHAR2(100), 
PARTNER_ID_TYPE_CODE                VARCHAR2(100), 
AR_OUTBOUND_TRANSACTION_FLAG        VARCHAR2(1)  , 
AR_INBOUND_CONFIRM_BOD_FLAG         VARCHAR2(1)  , 
ACCOUNT_NUMBER                      VARCHAR2(30) , 
PARTY_NUMBER                        VARCHAR2(30) , 
PREF_CONTACT_METHOD                 VARCHAR2(30)  
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_PROFILES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_PROFILES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  

EXEC DropTable ('XXMX_RA_CUST_RCPT_METHODS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_RA_CUST_RCPT_METHODS_EXT"
(
FILE_SET_ID                       VARCHAR2(30),
CUST_ORIG_SYSTEM                 VARCHAR2(30) , 
CUST_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
PAYMENT_METHOD_NAME              VARCHAR2(30) , 
PRIMARY_FLAG                     VARCHAR2(1)  , 
CUST_SITE_ORIG_SYSTEM            VARCHAR2(30) , 
CUST_SITE_ORIG_SYS_REF           VARCHAR2(240), 
START_DATE                       VARCHAR2(20)         , 
END_DATE                         VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY               VARCHAR2(30) , 
ATTRIBUTE1                       VARCHAR2(150), 
ATTRIBUTE2                       VARCHAR2(150), 
ATTRIBUTE3                       VARCHAR2(150), 
ATTRIBUTE4                       VARCHAR2(150), 
ATTRIBUTE5                       VARCHAR2(150), 
ATTRIBUTE6                       VARCHAR2(150), 
ATTRIBUTE7                       VARCHAR2(150), 
ATTRIBUTE8                       VARCHAR2(150), 
ATTRIBUTE9                       VARCHAR2(150), 
ATTRIBUTE10                      VARCHAR2(150), 
ATTRIBUTE11                      VARCHAR2(150), 
ATTRIBUTE12                      VARCHAR2(150), 
ATTRIBUTE13                      VARCHAR2(150), 
ATTRIBUTE14                      VARCHAR2(150), 
ATTRIBUTE15                      VARCHAR2(150), 
ORG_ID                           NUMBER        
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_RA_CUST_RCPT_METHODS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_RA_CUST_RCPT_METHODS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  

EXEC DropTable ('XXMX_AR_CUST_BANKS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_AR_CUST_BANKS_EXT"
(
CUST_ORIG_SYSTEM                   VARCHAR2(30) , 
CUST_ORIG_SYSTEM_REFERENCE         VARCHAR2(240) ,
CUST_SITE_ORIG_SYSTEM              VARCHAR2(30) , 
CUST_SITE_ORIG_SYS_REF             VARCHAR2(240), 
FILE_SET_ID                       VARCHAR2(30),
BANK_ACCOUNT_NAME                  VARCHAR2(80) , 
PRIMARY_FLAG                       VARCHAR2(1)  , 
START_DATE                         VARCHAR2(20)         , 
END_DATE                           VARCHAR2(20)         , 
ATTRIBUTE_CATEGORY                 VARCHAR2(30) , 
ATTRIBUTE1                         VARCHAR2(150), 
ATTRIBUTE2                         VARCHAR2(150), 
ATTRIBUTE3                         VARCHAR2(150), 
ATTRIBUTE4                         VARCHAR2(150), 
ATTRIBUTE5                         VARCHAR2(150), 
ATTRIBUTE6                         VARCHAR2(150), 
ATTRIBUTE7                         VARCHAR2(150), 
ATTRIBUTE8                         VARCHAR2(150), 
ATTRIBUTE9                         VARCHAR2(150), 
ATTRIBUTE10                        VARCHAR2(150), 
ATTRIBUTE11                        VARCHAR2(150), 
ATTRIBUTE12                        VARCHAR2(150), 
ATTRIBUTE13                        VARCHAR2(150), 
ATTRIBUTE14                        VARCHAR2(150), 
ATTRIBUTE15                        VARCHAR2(150), 
BANK_ACCOUNT_NUM                   VARCHAR2(30) , 
BANK_ACCOUNT_CURRENCY_CODE         VARCHAR2(15) , 
BANK_ACCOUNT_INACTIVE_DATE         VARCHAR2(20)         , 
BANK_ACCOUNT_DESCRIPTION           VARCHAR2(240),
BANK_NAME                          VARCHAR2(60) , 
BANK_BRANCH_NAME                   VARCHAR2(60) , 
BANK_NUM                           VARCHAR2(25) , 
BANK_BRANCH_DESCRIPTION            VARCHAR2(240), 
BANK_BRANCH_ADDRESS1               VARCHAR2(35) , 
BANK_BRANCH_ADDRESS2               VARCHAR2(35) , 
BANK_BRANCH_ADDRESS3               VARCHAR2(35) , 
BANK_BRANCH_CITY                   VARCHAR2(25) , 
BANK_BRANCH_STATE                  VARCHAR2(25) , 
BANK_BRANCH_ZIP                    VARCHAR2(20) , 
BANK_BRANCH_PROVINCE               VARCHAR2(25) , 
BANK_BRANCH_COUNTRY                VARCHAR2(25) , 
BANK_BRANCH_AREA_CODE              VARCHAR2(10) , 
BANK_BRANCH_PHONE                  VARCHAR2(15) , 
BANK_ACCOUNT_ATT_CATEGORY          VARCHAR2(30) , 
BANK_ACCOUNT_ATTRIBUTE1            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE10           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE11           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE12           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE13           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE14           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE15           VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE2            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE3            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE4            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE5            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE6            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE7            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE8            VARCHAR2(150), 
BANK_ACCOUNT_ATTRIBUTE9            VARCHAR2(150), 
BANK_BRANCH_ATT_CATEGORY           VARCHAR2(30) , 
BANK_BRANCH_ATTRIBUTE1             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE10            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE11            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE12            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE13            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE14            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE15            VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE2             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE3             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE4             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE5             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE6             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE7             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE8             VARCHAR2(150), 
BANK_BRANCH_ATTRIBUTE9             VARCHAR2(150), 
BANK_NUMBER                        VARCHAR2(30) , 
BANK_BRANCH_ADDRESS4               VARCHAR2(35) , 
BANK_BRANCH_COUNTY                 VARCHAR2(25) , 
BANK_BRANCH_EFT_USER_NUMBER        VARCHAR2(30) , 
BANK_ACCOUNT_CHECK_DIGITS          VARCHAR2(30) , 
GLOBAL_ATTRIBUTE_CATEGORY          VARCHAR2(30) , 
GLOBAL_ATTRIBUTE1                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE2                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE3                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE4                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE5                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE6                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE7                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE8                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE9                  VARCHAR2(150), 
GLOBAL_ATTRIBUTE10                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE11                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE12                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE13                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE14                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE15                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE16                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE17                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE18                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE19                 VARCHAR2(150), 
GLOBAL_ATTRIBUTE20                 VARCHAR2(150), 
ORG_ID                             NUMBER       , 
BANK_HOME_COUNTRY                  VARCHAR2(2)  , 
LOCALINSTR                         VARCHAR2(35) , 
SERVICE_LEVEL                      VARCHAR2(35) , 
PURPOSE_CODE                       VARCHAR2(30) , 
BANK_CHARGE_BEARER_CODE            VARCHAR2(30) , 
DEBIT_ADVICE_DELIVERY_METHOD       VARCHAR2(30) , 
DEBIT_ADVICE_EMAIL                 VARCHAR2(155), 
DEBIT_ADVICE_FAX                   VARCHAR2(100), 
EFT_SWIFT_CODE                     VARCHAR2(30) , 
COUNTRY_CODE                       VARCHAR2(2)  , 
FOREIGN_PAYMENT_USE_FLAG           VARCHAR2(1)  , 
PRIMARY_ACCT_OWNER_FLAG            VARCHAR2(1)  , 
BANK_ACCOUNT_NAME_ALT              VARCHAR2(320), 
BANK_ACCOUNT_TYPE                  VARCHAR2(25) , 
ACCOUNT_SUFFIX                     VARCHAR2(30) , 
AGENCY_LOCATION_CODE               VARCHAR2(30) , 
IBAN                               VARCHAR2(50)  
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AR_CUST_BANKS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AR_CUST_BANKS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
EXEC DropTable ('XXMX_HZ_ROLE_RESPS_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_ROLE_RESPS_EXT"
(
FILE_SET_ID                     VARCHAR2(30),
INSERT_UPDATE_CODE              VARCHAR2(30),  
INSERT_UPDATE_FLAG              VARCHAR2(1),   
CUST_CONTACT_ORIG_SYSTEM        VARCHAR2(30),  
CUST_CONTACT_ORIG_SYS_REF       VARCHAR2(240), 
ROLE_RESP_ORIG_SYSTEM           VARCHAR2(30),  
ROLE_RESP_ORIG_SYS_REF          VARCHAR2(240), 
RESPONSIBILITY_TYPE             VARCHAR2(30),  
PRIMARY_FLAG                    VARCHAR2(1) ,  
ATTRIBUTE_CATEGORY              VARCHAR2(30),  
ATTRIBUTE1                      VARCHAR2(150), 
ATTRIBUTE2                      VARCHAR2(150), 
ATTRIBUTE3                      VARCHAR2(150), 
ATTRIBUTE4                      VARCHAR2(150), 
ATTRIBUTE5                      VARCHAR2(150), 
ATTRIBUTE6                      VARCHAR2(150), 
ATTRIBUTE7                      VARCHAR2(150), 
ATTRIBUTE8                      VARCHAR2(150), 
ATTRIBUTE9                      VARCHAR2(150), 
ATTRIBUTE10                     VARCHAR2(150), 
ATTRIBUTE11                     VARCHAR2(150), 
ATTRIBUTE12                     VARCHAR2(150), 
ATTRIBUTE13                     VARCHAR2(150), 
ATTRIBUTE14                     VARCHAR2(150), 
ATTRIBUTE15                     VARCHAR2(150), 
ATTRIBUTE16                     VARCHAR2(150), 
ATTRIBUTE17                     VARCHAR2(150), 
ATTRIBUTE18                     VARCHAR2(150), 
ATTRIBUTE19                     VARCHAR2(150), 
ATTRIBUTE20                     VARCHAR2(150), 
ATTRIBUTE21                     VARCHAR2(150), 
ATTRIBUTE22                     VARCHAR2(150), 
ATTRIBUTE23                     VARCHAR2(150), 
ATTRIBUTE24                     VARCHAR2(150), 
ATTRIBUTE25                     VARCHAR2(150), 
ATTRIBUTE26                     VARCHAR2(150), 
ATTRIBUTE27                     VARCHAR2(150), 
ATTRIBUTE28                     VARCHAR2(150), 
ATTRIBUTE29                     VARCHAR2(150), 
ATTRIBUTE30                     VARCHAR2(255), 
ATTRIBUTE_NUMBER1               NUMBER      , 
ATTRIBUTE_NUMBER2               NUMBER      ,  
ATTRIBUTE_NUMBER3               NUMBER      ,  
ATTRIBUTE_NUMBER4               NUMBER      ,  
ATTRIBUTE_NUMBER5               NUMBER      ,  
ATTRIBUTE_NUMBER6               NUMBER      ,  
ATTRIBUTE_NUMBER7               NUMBER      ,  
ATTRIBUTE_NUMBER8               NUMBER      ,  
ATTRIBUTE_NUMBER9               NUMBER      ,  
ATTRIBUTE_NUMBER10              NUMBER      ,  
ATTRIBUTE_NUMBER11              NUMBER      ,  
ATTRIBUTE_NUMBER12              NUMBER      ,  
ATTRIBUTE_DATE1                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE2                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE3                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE4                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE5                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE6                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE7                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE8                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE9                 VARCHAR2(20)        ,  
ATTRIBUTE_DATE10                VARCHAR2(20)        ,  
ATTRIBUTE_DATE11                VARCHAR2(20)        ,  
ATTRIBUTE_DATE12                VARCHAR2(20)          
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_ROLE_RESPS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_ROLE_RESPS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  

EXEC DropTable ('XXMX_HZ_CUST_ACCT_RELATE_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_ACCT_RELATE_EXT"
(
FILE_SET_ID                     VARCHAR2(30),
INSERT_UPDATE_CODE               VARCHAR2(30),  
CUST_ACCT_REL_ORIG_SYSTEM        VARCHAR2(30),  
CUST_ACCT_REL_ORIG_SYS_REF       VARCHAR2(240), 
CUST_ORIG_SYSTEM                 VARCHAR2(30),  
CUST_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
RELATED_CUST_ORIG_SYSTEM         VARCHAR2(30),  
RELATED_CUST_ORIG_SYS_REF        VARCHAR2(240), 
RELATIONSHIP_TYPE                VARCHAR2(30),  
CUSTOMER_RECIPROCAL_FLAG         VARCHAR2(1),   
BILL_TO_FLAG                     VARCHAR2(1),   
SHIP_TO_FLAG                     VARCHAR2(1), 
SET_CODE                         VARCHAR2(30),    
START_DATE                       VARCHAR2(20)       ,   
END_DATE                         VARCHAR2(20)       ,   
ATTRIBUTE_CATEGORY               VARCHAR2(30),  
ATTRIBUTE1                       VARCHAR2(150), 
ATTRIBUTE2                       VARCHAR2(150), 
ATTRIBUTE3                       VARCHAR2(150), 
ATTRIBUTE4                       VARCHAR2(150), 
ATTRIBUTE5                       VARCHAR2(150), 
ATTRIBUTE6                       VARCHAR2(150), 
ATTRIBUTE7                       VARCHAR2(150), 
ATTRIBUTE8                       VARCHAR2(150), 
ATTRIBUTE9                       VARCHAR2(150), 
ATTRIBUTE10                      VARCHAR2(150), 
ATTRIBUTE11                      VARCHAR2(150), 
ATTRIBUTE12                      VARCHAR2(150), 
ATTRIBUTE13                      VARCHAR2(150), 
ATTRIBUTE14                      VARCHAR2(150), 
ATTRIBUTE15                      VARCHAR2(150), 
ATTRIBUTE16                      VARCHAR2(150), 
ATTRIBUTE17                      VARCHAR2(150), 
ATTRIBUTE18                      VARCHAR2(150), 
ATTRIBUTE19                      VARCHAR2(150), 
ATTRIBUTE20                      VARCHAR2(150), 
ATTRIBUTE21                      VARCHAR2(150), 
ATTRIBUTE22                      VARCHAR2(150), 
ATTRIBUTE23                      VARCHAR2(150), 
ATTRIBUTE24                      VARCHAR2(150), 
ATTRIBUTE25                      VARCHAR2(150), 
ATTRIBUTE26                      VARCHAR2(150), 
ATTRIBUTE27                      VARCHAR2(150), 
ATTRIBUTE28                      VARCHAR2(150), 
ATTRIBUTE29                      VARCHAR2(150), 
ATTRIBUTE30                      VARCHAR2(255) 
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_CUST_ACCT_RELATE_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_CUST_ACCT_RELATE_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  
  
  
EXEC DropTable ('XXMX_HZ_PERSON_LANGUAGE_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_HZ_PERSON_LANGUAGE_EXT"
(
FILE_SET_ID                     VARCHAR2(30),
PARTY_ORIG_SYSTEM                 VARCHAR2(30) , 
PARTY_ORIG_SYSTEM_REFERENCE       VARCHAR2(240), 
LANGUAGE_NAME                     VARCHAR2(30) , 
NATIVE_LANGUAGE_FLAG              VARCHAR2(1)  , 
PRIMARY_LANGUAGE_INDICATOR        VARCHAR2(1)  
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HZ_PERSON_LANGUAGE_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HZ_PERSON_LANGUAGE_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
  