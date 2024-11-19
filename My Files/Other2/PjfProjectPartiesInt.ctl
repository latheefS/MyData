--  This control file loads project team members data from a CSV file into staging/interface table PJF_PROJECT_PARTIES_INT.
--  The csv can be generated using the ProjectImportTemplate.xlsm file. The sequence of columns in CSV is
--  defined as per following order. Please do not modify the column order.
--  For local testing, you need to comment out some of the columns. Please refer below for more info.

LOAD DATA
INFILE *
APPEND
INTO TABLE PJF_PROJECT_PARTIES_INT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
	TEAM_MEMBER_XFACE_ID		EXPRESSION "PJF_PROJECT_PARTIES_INT_S.nextval",
	PROJECT_NAME "TRIM(:PROJECT_NAME)",
	TEAM_MEMBER_NUMBER,
	TEAM_MEMBER_NAME,
	TEAM_MEMBER_EMAIL,
	PROJECT_ROLE_NAME,
	START_DATE_ACTIVE		"to_date(:START_DATE_ACTIVE,'YYYY/MM/DD')",
	END_DATE_ACTIVE			"to_date(:END_DATE_ACTIVE,'YYYY/MM/DD')",
	TRACK_TIME_FLAG,
        ALLOCATION,
        EFFORT,
        COST_RATE,
        BILL_RATE,
        ASSIGNMENT_TYPE,
        BILLABLE_PERCENT,
	BILLABLE_PERCENT_REASON_CODE,
	LOAD_STATUS			CONSTANT 'COMPLETE',
	IMPORT_STATUS			CONSTANT 'SUBMITTED',
	CREATION_DATE			EXPRESSION "systimestamp",
	LAST_UPDATE_DATE		EXPRESSION "systimestamp",
	CREATED_BY			CONSTANT  '#CREATEDBY#',
	LAST_UPDATED_BY			CONSTANT  '#LASTUPDATEDBY#',
	LAST_UPDATE_LOGIN		CONSTANT  '#LASTUPDATELOGIN#',
	LOAD_REQUEST_ID			CONSTANT  '#LOADREQUESTID#',
	OBJECT_VERSION_NUMBER		CONSTANT  1
	-- You can have the below block commented out when you merge. 
	-- Uncomment and use for local testing as the string /replacement will not happen without the parent job code in your local deployment
	--,CREATED_BY			CONSTANT 1
	--,LAST_UPDATED_BY		CONSTANT 1
	--,LAST_UPDATE_LOGIN		CONSTANT 1
	--,LOAD_REQUEST_ID		CONSTANT 1
)
