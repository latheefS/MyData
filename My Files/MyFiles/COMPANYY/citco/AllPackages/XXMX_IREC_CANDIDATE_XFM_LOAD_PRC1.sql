--------------------------------------------------------
--  DDL for Procedure XXMX_IREC_CANDIDATE_XFM_LOAD_PRC1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_IREC_CANDIDATE_XFM_LOAD_PRC1" 
AS
  CURSOR CANDIDATE_DATA_CUR 
     IS  /*SELECT case when length(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),1,instr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
	          , SUBMITTED, EMAIL, nvl((select distinct Cand_First_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),firstname) firstname,
             NVL((select distinct Cand_last_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),lastname) LASTNAME, ADDRESS,
             case when length(city)>30
             then substr(city,1,instr(city,',',1,1)-1)
             else city
             end city
			  ,/*DECODE(COUNTRY,'Ireland','IE'
                             ,'United States','US'
                             ,'Lithuania','LT'
                             ,'Bangladesh','BD'
                             ,'British Indian Ocean Territory','IO'
                             ,'Luxembourg','LU'
                             ,'Singapore','SG'
                             ,'Pakistan','PK'
                             ,'India','IN'
                             ,'United Kingdom','GB'
                             ,'Canada','CA','Philippines','PH','Cayman Islands','KY','Guernsey','GG'
                             ,'United Arab Emirates','UE'
                             ,'France','FR'
                             ,'Spain','ES','Mauritius','MU'
                             ,'Germany','DE'
                             ,'Hong Kong','HK'
                             ,'Australia','AU'
                             ,'Netherlands','NL'
                             ,'Poland','PL'
                             ,NULL)*/
                             /*(select country_code from XXMX_HCM_GEO_MAP g where g.country = can.country)COUNTRY
              , CASE WHEN  UPPER(country) IN ('IN','INDIA') OR UPPER(country) IN ( 'SG','SINGAPORE')
              THEN
            LPAD(REPLACE(postalcode,' '),6,0)
            WHEN  UPPER(country) IN ('IE','IRELAND')
            then 
            'T12 VN2V'
                 /*case when length(postalcode)>7 
                  then postalcode 
                   else substr(postalcode,1,3)||' '||substr(postalcode,4)
                  end*/
            /*ELSE POSTALCODE 
            END POSTALCODE, REQUISITIONID
	    ,      (SELECT COUNTRY_CODE FROM XXMX_CANDIDATE_LOAD CL WHERE CL.COUNTRY = CAN.COUNTRY)  COUNTRY_CODE 
        /*CASE
			    WHEN UPPER(COUNTRY) IN('FRANCE')
				THEN 33
				WHEN UPPER(COUNTRY) IN('SPAIN')
				THEN 34
				WHEN UPPER(COUNTRY) IN('IN','INDIA')
				THEN 91
				WHEN UPPER(COUNTRY) IN('CANADA','TRINIDAD AND TOBAGO','UNITED STATES','UNITED_STATES','BERMUDA','CAYMAN ISLANDS'
				                      ,'CAYMAN_ISLANDS','BAHAMAS','SAINT LUCIA','DOMINICA','JAMAICA','BARBADOS')
				THEN 1
				WHEN UPPER(COUNTRY) IN('PHILIPPINES')
				THEN 63
				WHEN UPPER(COUNTRY) IN('MALAWI')
				THEN 265
				WHEN UPPER(COUNTRY) IN('SINGAPORE')
				THEN 65
				WHEN UPPER(COUNTRY) IN('ITALY')	
				THEN 39
				WHEN UPPER(COUNTRY) IN('BELIZE')
				THEN 501
				WHEN UPPER(COUNTRY) IN('SOUTH AFRICA','SOUTH_AFRICA')
				THEN 27
				WHEN UPPER(COUNTRY) IN('OMAN')
				THEN 968
				WHEN UPPER(COUNTRY) IN('TAIWAN')
				THEN 886
				WHEN UPPER(COUNTRY) IN('HONDURAS')
				THEN 504
				WHEN UPPER(COUNTRY) IN('ALBANIA')
				THEN 355
				WHEN UPPER(COUNTRY) IN('LUXEMBOURG')
				THEN 352
				WHEN UPPER(COUNTRY) IN('TUNISIA')
				THEN 216
				WHEN UPPER(COUNTRY) IN('PAKISTAN')
				THEN 92
				WHEN UPPER(COUNTRY) IN('ZIMBABWE')
				THEN 263
				WHEN UPPER(COUNTRY) IN('CHINA')
				THEN 86
				WHEN UPPER(COUNTRY) IN('PH')
				THEN 63
				WHEN UPPER(COUNTRY) IN('RUSSIAN FEDERATION')
				THEN 7
				WHEN UPPER(COUNTRY) IN('NEW ZEALAND')
				THEN 64
				WHEN UPPER(COUNTRY) IN('BRITISH INDIAN OCEAN TERRITORY')
				THEN 246
				WHEN UPPER(COUNTRY) IN('UNITED ARAB EMIRATES')
				THEN 971
				WHEN UPPER(COUNTRY) IN('GAMBIA')
				THEN 220
				WHEN UPPER(COUNTRY) IN('URUGUAY')
				THEN 598
				WHEN UPPER(COUNTRY) IN('UKRAINE')
				THEN 380
				WHEN UPPER(COUNTRY) IN('AZERBAIJAN')
				THEN 994
				WHEN UPPER(COUNTRY) IN('GERMANY')
				THEN 49
				WHEN UPPER(COUNTRY) IN('LEBANON')
				THEN 961
				WHEN UPPER(COUNTRY) IN('SAUDI ARABIA','SAUDI_ARABIA')
				THEN 966
				WHEN UPPER(COUNTRY) IN('COSTA_RICA')
				THEN 506
				WHEN UPPER(COUNTRY) IN('MEXICO')
				THEN 52
				WHEN UPPER(COUNTRY) IN('EGYPT')
				THEN 20
				WHEN UPPER(COUNTRY) IN('SERBIA')
				THEN 381
				WHEN UPPER(COUNTRY) IN('IE')
				THEN 353
				WHEN UPPER(COUNTRY) IN('LITHUANIA')
				THEN 370
				WHEN UPPER(COUNTRY) IN('UNITED KINGDOM','UNITED_KINGDOM')
				THEN 44
				WHEN UPPER(COUNTRY) IN('GREECE')
				THEN 30
				WHEN UPPER(COUNTRY) IN('BELGIUM')
				THEN 32
				WHEN UPPER(COUNTRY) IN('DENMARK')
				THEN 45
				WHEN UPPER(COUNTRY) IN('POLAND')
				THEN 48
				WHEN UPPER(COUNTRY) IN('SWITZERLAND')
				THEN 41
				WHEN UPPER(COUNTRY) IN('KUWAIT')
				THEN 965
				WHEN UPPER(COUNTRY) IN('SLOVAKIA')
				THEN 421
				WHEN UPPER(COUNTRY) IN('MOROCCO')
				THEN 212
				WHEN UPPER(COUNTRY) IN('LATVIA')
				THEN 371
				WHEN UPPER(COUNTRY) IN('BAHRAIN')
				THEN 973
				WHEN UPPER(COUNTRY) IN('SRI LANKA')
				THEN 94
				WHEN UPPER(COUNTRY) IN('TURKEY')
				THEN 90
				WHEN UPPER(COUNTRY) IN('IRELAND')
				THEN 353
				WHEN UPPER(COUNTRY) IN('BRAZIL')
				THEN 55
				WHEN UPPER(COUNTRY) IN('HONG KONG')
				THEN 852
				WHEN UPPER(COUNTRY) IN('QATAR')
				THEN 974
				WHEN UPPER(COUNTRY) IN('BULGARIA')
				THEN 359
				WHEN UPPER(COUNTRY) IN('JAPAN')
				THEN 81
				WHEN UPPER(COUNTRY) IN('PORTUGAL')
				THEN 351
				WHEN UPPER(COUNTRY) IN('VIETNAM')
				THEN 84
				WHEN UPPER(COUNTRY) IN('ROMANIA')
				THEN 40
				WHEN UPPER(COUNTRY) IN('THAILAND')
				THEN 66
				WHEN UPPER(COUNTRY) IN('TANZANIA')
				THEN 255
				WHEN UPPER(COUNTRY) IN('NORWAY')
				THEN 47
				WHEN UPPER(COUNTRY) IN('HUNGARY')
				THEN 36
				WHEN UPPER(COUNTRY) IN('FINLAND')
				THEN 358
				WHEN UPPER(COUNTRY) IN('NETHERLANDS')
				THEN 31
				WHEN UPPER(COUNTRY) IN('BANGLADESH')
				THEN 880
				WHEN UPPER(COUNTRY) IN('SWEDEN')
				THEN 46
				WHEN UPPER(COUNTRY) IN('ZAMBIA')
				THEN 260
				WHEN UPPER(COUNTRY) IN('BOSNIA AND HERZEGOVINA')
				THEN 387
				WHEN UPPER(COUNTRY) IN('SOMALIA')
				THEN 252
				WHEN UPPER(COUNTRY) IN('MALAYSIA')
				THEN 60
				WHEN UPPER(COUNTRY) IN('MAURITIUS')
				THEN 230
				WHEN UPPER(COUNTRY) IN('NIGERIA')
				THEN 234
				WHEN UPPER(COUNTRY) IN('MALTA')
				THEN 356
				WHEN UPPER(COUNTRY) IN('CYPRUS')
				THEN 357
				WHEN UPPER(COUNTRY) IN('ARGENTINA')
				THEN 54
				WHEN UPPER(COUNTRY) IN('COSTA RICA')
				THEN 506
				WHEN UPPER(COUNTRY) IN('AUSTRALIA')
				THEN 61
				ELSE NULL
				END COUNTRY_CODE*/
             /* , (SELECT AREA_CODE FROM XXMX_CANDIDATE_LOAD CL WHERE CL.AREA_CODE = AREA_CODE) AREA_CODE
              /*CASE 
			    WHEN UPPER(COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),1,3)
				WHEN UPPER(COUNTRY) IN('BERMUDA')
				THEN '441'
				WHEN UPPER(COUNTRY) IN('BAHAMAS')
				THEN '242'
				WHEN UPPER(COUNTRY) IN('CAYMAN_ISLANDS','CAYMAN ISLANDS')
				THEN '345'
				WHEN UPPER(COUNTRY) IN('SAINT LUCIA')
				THEN '758'
				WHEN UPPER(COUNTRY) IN('JAMAICA')
				THEN '876'
				ELSE NULL
                END AREA_CODE*/
              /*, CASE 
                WHEN UPPER(COUNTRY) ='CANADA'
                THEN 'CA'
                WHEN UPPER(COUNTRY) = 'TRINIDAD AND TOBAGO'
                THEN 'TT'
                WHEN UPPER(COUNTRY) = 'UNITED STATES'
                THEN 'US'
                WHEN UPPER(COUNTRY) = 'UNITED_STATES'
                THEN 'US'
                WHEN UPPER(COUNTRY) = 'BERMUDA'
                THEN 'BM'
                WHEN UPPER(COUNTRY) = 'CAYMAN ISLANDS'
                THEN 'KY'
				WHEN UPPER(COUNTRY) = 'CAYMAN_ISLANDS'
                THEN 'KY'
                WHEN UPPER(COUNTRY) = 'BAHAMAS'
                THEN 'BS'
                WHEN UPPER(COUNTRY) = 'SAINT LUCIA'
                THEN 'LC'
                WHEN UPPER(COUNTRY) = 'DOMINICA'
                THEN 'DM'
                WHEN UPPER(COUNTRY) = 'JAMAICA'
                THEN 'JM'
                WHEN UPPER(COUNTRY) = 'BARBADOS'
				THEN 'BB'
                WHEN UPPER(COUNTRY) = 'UNITED KINGDOM' THEN 'GB'
                WHEN UPPER(COUNTRY) = 'ITALY' THEN 'IT'
                WHEN UPPER(COUNTRY) = 'AUSTRALIA' THEN 'AU'
                WHEN UPPER(COUNTRY) = 'RUSSIAN FEDERATION' THEN 'RU'
                ELSE NULL END */
               /* (select country_code from XXMX_HCM_GEO_MAP g where g.country = can.country) legislation_CODE
              ,null PHONE_NUMBER-- (SELECT PHONE_NUMBER FROM XXMX_CANDIDATE_LOAD CL WHERE CL.PHONE_NUMBER = PHONE_NUMBER) PHONE_NUMBER
              /*CASE 
                WHEN UPPER(COUNTRY) IN('FRANCE','FR')
				THEN
                   '176742549'
                WHEN Upper(country) IN ('SPAIN','ES')
                THEN
                '914148667'
			    WHEN UPPER(COUNTRY) IN ('PHILIPPINES','TRINIDAD AND TOBAGO','ITALY','PAKISTAN','CHINA','PH','TURKEY'
				                       ,'BRITISH INDIAN OCEAN TERRITORY','MEXICO','EGYPT','UNITED KINGDOM','UNITED_KINGDOM','GREECE'
									   ,'JAPAN','NIGERIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10)
                WHEN UPPER(COUNTRY) IN ('IN','INDIA')
                THEN nvl(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),'2066380800')
				WHEN UPPER(COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),4)
				WHEN UPPER(COUNTRY) IN('BELIZE','GAMBIA','AZERBAIJAN','BERMUDA','BAHAMAS','DENMARK','CAYMAN_ISLANDS'
				                      ,'CAYMAN ISLANDS','SAINT LUCIA','JAMAICA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-7)
				WHEN UPPER(COUNTRY) IN ('MALAWI','SOUTH AFRICA','SOUTH_AFRICA','TAIWAN','ALBANIA','LUXEMBOURG','ZIMBABWE','NEW ZEALAND'
				                       ,'UNITED ARAB EMIRATES','UKRAINE','SAUDI ARABIA','SAUDI_ARABIA','SERBIA','IE','BELGIUM','POLAND','SWITZERLAND'
									   ,'SLOVAKIA','MOROCCO','SRI LANKA','IRELAND','BRAZIL','BULGARIA','PORTUGAL','VIETNAM','ROMANIA','THAILAND'
									   ,'TANZANIA','HUNGARY','NETHERLANDS','SWEDEN','ZAMBIA','SOMALIA','MALAYSIA','AUSTRALIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-9)
				WHEN UPPER(COUNTRY) IN ('SINGAPORE','OMAN','HONDURAS','TUNISIA','URUGUAY','GERMANY','LEBANON','COSTA_RICA','LITHUANIA'
				                       ,'KUWAIT','LATVIA','BAHRAIN','HONG KONG','QATAR','NORWAY','FINLAND','BOSNIA AND HERZEGOVINA','MALTA'
									   ,'MAURITIUS','CYPRUS','COSTA RICA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-8)
				WHEN UPPER(COUNTRY) IN('RUSSIAN FEDERATION','BANGLADESH','ARGENTINA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-11)
                ELSE NULL
                END PHONE_NUMBER*/
			/*  ,NULL CURRENT_PHASE_CODE--(SELECT FUSION_CURRENT_PHASE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.FUSION_CURRENT_PHASE_CODE = STATUS) CURRENT_PHASE_CODE
             --Commented BY POOJA on 03/03/2023 for Generic code
              /*CASE
                  WHEN STATUS = 'New'   THEN  'NEW'
                  WHEN STATUS = 'Application Reviewed'   THEN  'NEW'
                  WHEN STATUS = 'Internal Screen Requested'   THEN  'SCREENING'
                  WHEN STATUS = 'Phone Screen Requested'   THEN  'SCREENING'
                  WHEN STATUS = 'Screened by TA'   THEN  'SCREENING'
                  WHEN STATUS = 'Submitted to Hiring Manager'   THEN  'SCREENING'
                  WHEN STATUS = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Rejected by Hiring Manager'   THEN  'SCREENING'
                  WHEN STATUS = 'Schedule Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'First Interveiw'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Second Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Additional Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Offer Pending Approval'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Verbal Offer Extended'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Verbal Offer Accepted'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN STATUS = 'Offer Approved' THEN 'OFFER'
                  WHEN STATUS = 'Offer Rejected' THEN 'OFFER'

                END CURRENT_PHASE_CODE*/
               /* ,NULL CURRENT_STATE_CODE--(SELECT FUSION_CURRENT_STATE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.FUSION_CURRENT_STATE_CODE = STATUS) CURRENT_STATE_CODE
                /*CASE
                  WHEN STATUS = 'New'   THEN  'TO_BE_REVIEWED'
                  WHEN STATUS = 'Application Reviewed'   THEN  'REVIEWED'
                  WHEN STATUS = 'Internal Screen Requested'   THEN  'PHONE_SCREEN_TO_BE_SCHEDULED'
                  WHEN STATUS = 'Phone Screen Requested'   THEN  'PHONE_SCREEN_SCHEDULED'
                  WHEN STATUS = 'Screened by TA'   THEN  'PHONE_SCREEN_COMPLETED'
                  WHEN STATUS = 'Submitted to Hiring Manager'   THEN  '300000017023892'
                  WHEN STATUS = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN STATUS = 'Rejected by Hiring Manager'   THEN  'REJECTED_BY_EMPLOYER'
                  WHEN STATUS = 'Schedule Interview'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN STATUS = 'First Interveiw'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN STATUS = 'Second Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN STATUS = 'Additional Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN STATUS = 'Offer Pending Approval'   THEN  'SELECTED_FOR_OFFER'
                  WHEN STATUS = 'Verbal Offer Extended'   THEN  'SELECTED_FOR_OFFER'
                  WHEN STATUS = 'Verbal Offer Accepted'   THEN  'SELECTED_FOR_OFFER'
                  WHEN STATUS = 'Offer Approved' THEN 'APPROVED'
                  WHEN STATUS = 'Offer Rejected' THEN 'REJECTED_BY_EMPLOYER'
                END CURRENT_STATE_CODE*/
               /*,decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency Name','Employee Referral',
               'Employee Referral',
               (SELECT FUSION_SOURCE FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency','Employee Referral',
               'Jobvite Referral',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,OFFERLETTER
                ,ORIGINALDOCUMENT
	       FROM XXMX_JOBVITE_CANDIDATES_STG CAN
		  WHERE 1=1--REQUISITIONID IN('IRC90432')
            AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG c where c.email = can.email )
            AND TRUNC(TO_DATE(submitted,'MM/DD/RRRR HH24:MI')) 
            BETWEEN  TRUNC(TO_DATE('03/31/2021','MM/DD/RRRR')) 
            AND TRUNC(TO_DATE('04/01/2022','MM/DD/RRRR'))
            AND (upper(source) like '%AGENCY%' OR (upper(status) in ('NEW'
				,'APPLICATION REVIEWED' 
				,'INTERNAL SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'SCREENED BY TA' 
				,'SUBMITTED TO HIRING MANAGER'
				,'ACCEPTED BY HIRING MANAGER' 
				,'REJECTED BY HIRING MANAGER' 
				,'SCHEDULE INTERVIEW' 
				,'FIRST INTERVEIW' 
				,'SECOND INTERVIEW' 
				,'ADDITIONAL INTERVIEW' 
				,'OFFER PENDING APPROVAL' 
				,'VERBAL OFFER EXTENDED' 
				,'VERBAL OFFER ACCEPTED')
            AND REQUISITIONID IN(SELECT DISTINCT REQUISITION_ID FROM XXMX_JOB_SAMPLE_REQ)));*/
            
               SELECT case when length(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),1,instr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
	          , SUBMITTED, EMAIL, nvl((select distinct Cand_First_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),firstname) firstname,
             NVL((select distinct Cand_last_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),lastname) LASTNAME, ADDRESS,
             case when length(city)>30
             then substr(city,1,instr(city,',',1,1)-1)
             else city
             end city
             ,(select country from XXMX_CANDIDATE_LOAD CL where CL.country = CAN.country) COUNTRY
              ,(select territory_code from XXMX_CANDIDATE_LOAD cl where cl.country = can.country) TERRITORY_CODE
              , CASE WHEN  UPPER(country) IN ('IN','INDIA') OR UPPER(country) IN ( 'SG','SINGAPORE')
              THEN
            LPAD(REPLACE(postalcode,' '),6,0)
            WHEN  UPPER(country) IN ('IE','IRELAND')
            then 
            'T12 VN2V'
                
            ELSE POSTALCODE 
            END POSTALCODE, REQUISITIONID
	    ,      (SELECT COUNTRY_CODE FROM XXMX_CANDIDATE_LOAD CL WHERE CL.COUNTRY = CAN.COUNTRY)  COUNTRY_CODE
                     , (SELECT AREA_CODE FROM xxmx_candidate_load cl WHERE cl.country = CAN.country) AREA_CODE
             
              ,
                (select country_code from XXMX_HCM_GEO_MAP g where g.country = can.country) legislation_CODE
            , (nvl(trim(mobile),(SELECT PHONE_NUMBER FROM XXMX_CANDIDATE_LOAD CL WHERE CL.country = CAN.country))) PHONE_NUMBER
             
			  ,(SELECT CURRENT_PHASE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.JOBVITE_STATUS = CAN.STATUS) CURRENT_PHASE_CODE
            
             ,(SELECT CURRENT_STATE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.JOBVITE_STATUS = CAN.STATUS) CURRENT_STATE_CODE
                
               ,decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency Name','Employee Referral',
               'Employee Referral',
               (SELECT FUSION_SOURCE FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency','Employee Referral',
               'Jobvite Referral',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,OFFERLETTER
                ,ORIGINALDOCUMENT, CAN.STATUS
	       FROM XXMX_JOBVITE_CANDIDATES_STG CAN
		  WHERE 1=1--REQUISITIONID IN('IRC90432')
            AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG c where c.email = can.email )
            AND TRUNC(TO_DATE(submitted,'MM/DD/RRRR HH24:MI')) 
            BETWEEN  TRUNC(TO_DATE('03/31/2021','MM/DD/RRRR')) 
            AND TRUNC(TO_DATE('04/01/2022','MM/DD/RRRR'))
            AND (upper(source) like '%AGENCY%' OR (upper(status) in ('NEW'
				,'APPLICATION REVIEWED' 
				,'INTERNAL SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'SCREENED BY TA' 
				,'SUBMITTED TO HIRING MANAGER'
				,'ACCEPTED BY HIRING MANAGER' 
				,'REJECTED BY HIRING MANAGER' 
				,'SCHEDULE INTERVIEW' 
				,'FIRST INTERVEIW' 
				,'SECOND INTERVIEW' 
				,'ADDITIONAL INTERVIEW' 
				,'OFFER PENDING APPROVAL' 
				,'VERBAL OFFER EXTENDED' 
				,'VERBAL OFFER ACCEPTED')
            AND REQUISITIONID IN(SELECT DISTINCT REQUISITION_ID FROM XXMX_JOB_SAMPLE_REQ)));

  TYPE CANDIDATE_DATA_REC IS TABLE OF CANDIDATE_DATA_CUR%ROWTYPE INDEX BY PLS_INTEGER;
  CANDIDATE_TBL    CANDIDATE_DATA_REC;

  --JOB_VITE_DATA_LIMIT NUMBER := 5000;
  l_migration_set_id       NUMBER;
  l_migration_set_name     VARCHAR2(80);
  l_migration_status       VARCHAR2(20) := 'PRE-TRANSFORM';
  l_metadata               VARCHAR2(20) := 'MERGE';

BEGIN

    BEGIN
	   SELECT MIGRATION_SET_ID+1
	     INTO l_migration_set_id
		 FROM XXMX_HCM_IREC_CAN_XFM
		WHERE ROWNUM = 1;
	EXCEPTION
	   WHEN OTHERS THEN
	     l_migration_set_id := 100;
	END;
	l_migration_set_name := 'CANDIDATE_'||l_migration_set_id||'_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MI');

   DELETE FROM XXMX_HCM_IREC_CAN_XFM;
   DELETE FROM XXMX_HCM_IREC_CAN_ADDRESS_XFM;
   DELETE FROM XXMX_HCM_IREC_CAN_EMAIL_XFM;
   DELETE FROM XXMX_HCM_IREC_CAN_NAME_XFM;
   DELETE FROM XXMX_HCM_IREC_CAN_PHONE_XFM;
   DELETE FROM XXMX_HCM_IREC_CAN_ATTMT_XFM;

   COMMIT;

   OPEN CANDIDATE_DATA_CUR;
     FETCH CANDIDATE_DATA_CUR BULK COLLECT INTO CANDIDATE_TBL;-- LIMIT JOB_VITE_DATA_LIMIT;

       --EXIT WHEN CANDIDATE_TBL.COUNT = 0;
       FORALL CAND IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_XFM( MIGRATION_SET_ID
                                          , MIGRATION_SET_NAME
                                          , MIGRATION_STATUS
                                          , METADATA
                                          , OBJECTNAME
                                          , CANDIDATE_NUMBER
										  , REQUISITION_NUMBER
                                          , OBJECT_STATUS
										  , AVAILABILITY_DATE
										  , START_DATE
										  , CONFIRMED_FLAG
										  , CAND_PREF_LANGUAGE_CODE
                                          , CURRENT_PHASE_CODE
                                          , CURRENT_STATE_CODE 
                                          , SOURCE
                                          , SOURCE_MEDIUM ,notes 
                                          , OFFERLETTER
                                          , ORIGINALDOCUMENT )
                                     VALUES ( l_migration_set_id
									      , l_migration_set_name
										  , l_migration_status
										  , l_metadata
										  , 'CANDIDATE'
									      , CANDIDATE_TBL(CAND).CANDIDATEID
										  , CANDIDATE_TBL(CAND).REQUISITIONID
                                          , 'ACTIVE'
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL(CAND).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD HH24:MI:SS')
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL(CAND).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                          , 'Y'
                                          , 'US'
										  , CANDIDATE_TBL(CAND).CURRENT_PHASE_CODE
										  , CANDIDATE_TBL(CAND).CURRENT_STATE_CODE
                                          , CANDIDATE_TBL(CAND).SOURCE
                                          , CANDIDATE_TBL(CAND).SOURCE_MEDIUM
                                          ,CANDIDATE_TBL(CAND).NOTES
                                          ,CANDIDATE_TBL(CAND).OFFERLETTER
                                          ,CANDIDATE_TBL(CAND).ORIGINALDOCUMENT
                                          );

       FORALL CMAIL IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_EMAIL_XFM( CANDIDATE_NUMBER
                                                , DATE_FROM 
												, EMAIL_ADDRESS
												, EMAIL_TYPE)
                                         VALUES ( CANDIDATE_TBL(CMAIL).CANDIDATEID
                                                , TO_CHAR(TO_DATE(CANDIDATE_TBL(CMAIL).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
												, CANDIDATE_TBL(CMAIL).EMAIL
												, 'H1' );

	   FORALL CNAME IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_NAME_XFM( CANDIDATE_NUMBER 
                                               , EFFECTIVE_START_DATE
                                               , FIRST_NAME
                                               , LAST_NAME )
                                          VALUES ( CANDIDATE_TBL(CNAME).CANDIDATEID
                                               , TO_CHAR(TO_DATE(CANDIDATE_TBL(CNAME).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               , CANDIDATE_TBL(CNAME).FIRSTNAME
                                               , CANDIDATE_TBL(CNAME).LASTNAME	 ); 

       FORALL CADD IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ADDRESS_XFM( CANDIDATE_NUMBER 
                                               , ADDRESS_LINE_1
											   , TOWN_OR_CITY
											   , COUNTRY
                                               , POSTAL_CODE
                                               , EFFECTIVE_START_DATE )
                                          VALUES ( CANDIDATE_TBL(CADD).CANDIDATEID
                                               , CANDIDATE_TBL(CADD).ADDRESS
											   , CANDIDATE_TBL(CADD).CITY
											   , CANDIDATE_TBL(CADD).COUNTRY
                                               , CANDIDATE_TBL(CADD).POSTALCODE 
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL(CADD).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
											   ); 

       FORALL CPHN IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_PHONE_XFM( CANDIDATE_NUMBER 
                                                  , COUNTRY_CODE_NUMBER
												  , AREA_CODE
                                                 , PHONE_NUMBER
												  , PHONE_TYPE
												  , DATE_FROM,legislation_CODE  )
                                          VALUES ( CANDIDATE_TBL(CPHN).CANDIDATEID
										       , CANDIDATE_TBL(CPHN).COUNTRY_CODE
											   , CANDIDATE_TBL(CPHN).AREA_CODE
                                               , CANDIDATE_TBL(CPHN).PHONE_NUMBER
											   , 'H1'
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL(CPHN).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               ,CANDIDATE_TBL(CPHN).legislation_CODE
											   ); 

      FORALL CATT IN 1..CANDIDATE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ATTMT_XFM( CANDIDATE_NUMBER 
                                                , TITLE
                                                , URL_OR_FILENAME)
                                          VALUES ( CANDIDATE_TBL(CATT).CANDIDATEID
                                               , CANDIDATE_TBL(CATT).ORIGINALDOCUMENT
											   , NULL); 
    COMMIT;

   CLOSE CANDIDATE_DATA_CUR;
   
   
   
   /*
   SELECT case when length(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),1,instr(REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
	          , SUBMITTED, EMAIL, nvl((select distinct Cand_First_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),firstname) firstname,
             NVL((select distinct Cand_last_Name from xxmx_Candidate_name_map cn where can.email= cn.cand_email),lastname) LASTNAME, ADDRESS,
             case when length(city)>30
             then substr(city,1,instr(city,',',1,1)-1)
             else city
             end city
			  ,  (select country_code from XXMX_HCM_GEO_MAP g where g.country = can.country)COUNTRY
              , CASE WHEN  UPPER(country) IN ('IN','INDIA') OR UPPER(country) IN ( 'SG','SINGAPORE')
              THEN
            LPAD(REPLACE(postalcode,' '),6,0)
            WHEN  UPPER(country) IN ('IE','IRELAND')
            then 
            'T12 VN2V'
                
            ELSE POSTALCODE 
            END POSTALCODE, REQUISITIONID
	    ,      (SELECT COUNTRY_CODE FROM XXMX_CANDIDATE_LOAD CL WHERE CL.COUNTRY = CAN.COUNTRY)  COUNTRY_CODE 
                     , (SELECT AREA_CODE FROM xxmx_candidate_load cl WHERE cl.country = can.country) AREA_CODE
             
              ,
                (select country_code from XXMX_HCM_GEO_MAP g where g.country = can.country) legislation_CODE
              , nvl(trim(mobile),(SELECT PHONE_NUMBER FROM XXMX_CANDIDATE_LOAD CL WHERE CL.country = can.country)) PHONE_NUMBER
             
			  ,(SELECT FUSION_CURRENT_PHASE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.FUSION_CURRENT_PHASE_CODE = STATUS) CURRENT_PHASE_CODE
            
                ,NULL CURRENT_STATE_CODE--(SELECT FUSION_CURRENT_STATE_CODE FROM XXMX_JOB_REQ_STATUS JRS where JRS.FUSION_CURRENT_STATE_CODE = STATUS) CURRENT_STATE_CODE
                ,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency Name','Employee Referral',
               'Employee Referral',
               (SELECT FUSION_SOURCE FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),'Agency','Agency','Employee Referral',
               'Jobvite Referral',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,OFFERLETTER
                ,ORIGINALDOCUMENT
	       FROM XXMX_JOBVITE_CANDIDATES_STG CAN
		  WHERE 1=1--REQUISITIONID IN('IRC90432')
            AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG c where c.email = can.email )
            AND TRUNC(TO_DATE(submitted,'MM/DD/RRRR HH24:MI')) 
            BETWEEN  TRUNC(TO_DATE('03/31/2021','MM/DD/RRRR')) 
            AND TRUNC(TO_DATE('04/01/2022','MM/DD/RRRR'))
            AND (upper(source) like '%AGENCY%' OR (upper(status) in ('NEW'
				,'APPLICATION REVIEWED' 
				,'INTERNAL SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'PHONE SCREEN REQUESTED' 
				,'SCREENED BY TA' 
				,'SUBMITTED TO HIRING MANAGER'
				,'ACCEPTED BY HIRING MANAGER' 
				,'REJECTED BY HIRING MANAGER' 
				,'SCHEDULE INTERVIEW' 
				,'FIRST INTERVEIW' 
				,'SECOND INTERVIEW' 
				,'ADDITIONAL INTERVIEW' 
				,'OFFER PENDING APPROVAL' 
				,'VERBAL OFFER EXTENDED' 
				,'VERBAL OFFER ACCEPTED')
            AND REQUISITIONID IN(SELECT DISTINCT REQUISITION_ID FROM XXMX_JOB_SAMPLE_REQ)));
   */
END XXMX_IREC_CANDIDATE_XFM_LOAD_PRC1;

/
