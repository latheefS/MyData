--  This control file loads project resource breakdown structures data from a CSV file into a staging/interface table PJF_RBS_HEADERS_INT. 
     --  The csv can be generated using the ResourceBreakdownStructureImportTemplate.xlsm file. The sequence of columns in CSV is 
     --  defined as per following order. Please do not modify the column order.
     --  For local testing, you need to comment out some of the columns. Please refer below for more info.
     --  MODIFIED BY   (MM/DD/YY) 
     --  srnallam       10/16/18   Bug 28798774 - Mentioned CHAR(2000) for DESCRIPTION.
     --                                           If not mentioned the defaut value is taken as 255.
     --	 srnallam       1/18/18    ER 25113070 - Created.
     --  skvadama       03/15/21   ER 32455886 - Added a new column AUTO_ADD_RES_FLAG
	 
      LOAD DATA
      INFILE *
      APPEND
      INTO TABLE PJF_RBS_HEADERS_INT    
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '"'
      TRAILING NULLCOLS 
      (
		RBS_HEADER_INT_REC_ID 		EXPRESSION 	"PJF_RBS_HEADERS_INT_S1.nextval",	
		RBS_HEADER_NAME,
		DESCRIPTION                     CHAR(2000),
		PROJECT_UNIT_NAME,
		JOB_SET_NAME,
		ALLOW_CHANGE_IN_PROJECT_FLAG    "NVL(:ALLOW_CHANGE_IN_PROJECT_FLAG, 'N')",
		START_DATE_ACTIVE	        "to_date(:START_DATE_ACTIVE,'YYYY/MM/DD')",
		END_DATE_ACTIVE 		"to_date(:END_DATE_ACTIVE,'YYYY/MM/DD')",
		AUTO_ADD_RES_FLAG               "REPLACE(:AUTO_ADD_RES_FLAG,CHR(13),'')",
                CREATION_DATE 			EXPRESSION 	"systimestamp",
		LAST_UPDATE_DATE 		EXPRESSION 	"systimestamp",
		LOAD_REQUEST_ID 		CONSTANT  	'#LOADREQUESTID#',
		LAST_UPDATE_LOGIN 		CONSTANT  	'#LASTUPDATELOGIN#',
		CREATED_BY 			CONSTANT  	'#CREATEDBY#',
		LAST_UPDATED_BY 		CONSTANT  	'#LASTUPDATEDBY#'

		-- You can have the below block commented out when you merge. 
		-- Uncomment and use for local testing as the string /replacement will not happen without the parent job code in your local deployment
		-- CREATED_BY			CONSTANT 1,
		-- LAST_UPDATED_BY		CONSTANT 1,
		-- LAST_UPDATE_LOGIN		CONSTANT 1,
		-- LOAD_REQUEST_ID		CONSTANT 1		
	)
