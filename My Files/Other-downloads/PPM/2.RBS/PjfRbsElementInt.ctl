--  This control file loads project resource breakdown structures data from a CSV file into a staging/interface table PJF_RBS_ELEMENTS_INT.
     --  The csv can be generated using the ResourceBreakdownStructureImportTemplate.xlsm file. The sequence of columns in CSV is
     --  defined as per following order. Please do not modify the column order.
     --  For local testing, you need to comment out some of the columns. Please refer below for more info.
     --  MODIFIED BY   (MM/DD/YY)
     --  srnallam       10/16/18   Bug 28798774 - Mentioned CHAR(300) for LEVEL1_RES_NAME, LEVEL2_RES_NAME,
     --                                           LEVEL3_RES_NAME. If not mentioned the defaut value is taken as 255.
     --	 srnallam       1/18/18    ER 25113070 - Created.
     --  skvadama       06/22/20   Bug 31390429 - Added PROJECT_NUMBER as part of PRBS FBDI resource addition for Projects.
	 
      LOAD DATA
      INFILE *
      APPEND
      INTO TABLE PJF_RBS_ELEMENTS_INT    
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '"'
      TRAILING NULLCOLS 
      (
		CURRENT_RUN_ID				CONSTANT    '-100',
		TEMP_RBS_ELEMENT_ID			EXPRESSION  "PJF_RBS_ELEMENTS_INT_S1.nextval",
		RBS_HEADER_NAME,
		RES_FORMAT_NAME,
		ALIAS,
		LEVEL1_RES_NAME                         CHAR(300),
		LEVEL2_RES_NAME                         CHAR(300),
		LEVEL3_RES_NAME                         CHAR(300),
		RESOURCE_CLASS_NAME,
		SPREAD_CURVE_NAME,
		PROJECT_NUMBER,
		CREATION_DATE 				EXPRESSION 	"systimestamp",
		LAST_UPDATE_DATE 			EXPRESSION 	"systimestamp",
		LOAD_REQUEST_ID 			CONSTANT  	'#LOADREQUESTID#',
		LAST_UPDATE_LOGIN 			CONSTANT  	'#LASTUPDATELOGIN#',
		CREATED_BY 				CONSTANT  	'#CREATEDBY#',
		LAST_UPDATED_BY 			CONSTANT  	'#LASTUPDATEDBY#'

		-- You can have the below block commented out when you merge. 
		-- Uncomment and use for local testing as the string /replacement will not happen without the parent job code in your local deployment
		-- CREATED_BY			CONSTANT 1,
		-- LAST_UPDATED_BY		CONSTANT 1,
		-- LAST_UPDATE_LOGIN		CONSTANT 1,
		-- LOAD_REQUEST_ID		CONSTANT 1		
	)
