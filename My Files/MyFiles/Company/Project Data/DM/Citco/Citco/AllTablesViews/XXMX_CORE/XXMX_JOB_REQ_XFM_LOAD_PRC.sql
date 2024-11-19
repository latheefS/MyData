--------------------------------------------------------
--  DDL for Procedure XXMX_JOB_REQ_XFM_LOAD_PRC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_JOB_REQ_XFM_LOAD_PRC" 
AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_ppm_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Worker Hire and Worker Assignment History HDL file
--**              for PPM Workers List.
--*******************************************************************************
  CURSOR JOB_VITE_DATA_CUR IS
    SELECT UNIQUE JOB_FAMILY,REQUISITIONID,JOBID,TITLE
	     , STARTDATE,ENDDATE,DEPARTMENT
         , STATUS
         , city
         , DECODE(CITY,'Hyderabad','Hyderabad, Telangana, India'                   
		              ,'Mumbai','Mumbai, Maharashtra, India'                       
                      ,'Makati City','Makati City, Manila, Philippines'            
					  ,'Pune','Pune, Maharashtra, India'                           
                      ,'Muntinlupa City','Muntinlupa City, Manila, Philippines'    
					  ,'Luxembourg','Luxembourg'                                   
                      ,'Toronto','Toronto, ON, Canada'                             
					  ,'Manila','Ayala Center'                                
					  ,'Changi','Changi, Tanah Merah, Singapore'--'Changi, Singapore'                                           
					  ,'Halifax','Halifax, NS, Canada'                             
					  ,'San Francisco','San Francisco, CA, United States'          
					  ,'Jersey City','Jersey City, NJ, United States'              
					  ,'New York','New York, NY, United States'                    
					  ,'Charlotte','Charlotte, NC, United States'                                
					  ,'Fort Lauderdale','Fort Lauderdale, FL, United States'                       
					  ,'Hong Kong','Hong Kong'
					  ,'St Peter Port','St. Peter Port, Guernsey, Guernsey'
					  ,'Willemstad - De RuyterKade','Willemstad'
					  ,'Madrid','Madrid, Spain, Spain'
					  ,'St. Julian''s','St. Julian''s, Malta'
					  ,'Frankfurt','Frankfurt am Main'
                      ,'Jiangan District','Taizhou, Jiangsu, China') LOCATION_NAME
         , DECODE(CITY,'Vilnius',300000052863662
		              ,'Dublin',300000040338444
					  ,'Malvern',300000004284626
					  ,'Tortola',300000061057578
					  ,'Ebene',300000061057566
					  ,'Cork',300000040338424
					  ,'Sydney',300000037480793
					  ,'Amsterdam',300000053476680
					  ,'Willemstad',300000061057597
					  ,'London',300000017093011
					  ,'Paris',300000039303411
					  ,'Montevideo',300000052823920
					  ,'Pampanga',300000061057557
					  ,'Grand Cayman',300000052819307
					  ,'St Helier',300000061057585
					  ,'Jersey City',300000004284558
					  ,'Frankfurt am Main',300000038385740
					  ,'Singapore',300000059347025,
                      'Jiangan District', 300000037954721,
                      'Abu Dhabi',300000037413226,
                      'Dubai',300000037413233,null
                      ) LOCATION_ID,
            decode(city, 'Hyderabad',300000004278571,'Mumbai',300000004278415,'Pune',300000004278457,
            'Manila',300000061007099,'Muntinlupa City', 300000004278499,'Makati City',300000004278547,
            'Changi',300000061007118,
            NULL) primary_work_location_id
         ,(SELECT UNIQUE RESPONSIBILITY 
             FROM XXMX_POSITION_PROFILES_STG 
            WHERE POSITION_CODE=QR.POSITION_CODE) POSITION_RESPONSIBILITY
		 ,(SELECT UNIQUE QUALIFICATION 
             FROM XXMX_POSITION_PROFILES_STG 
            WHERE POSITION_CODE=QR.POSITION_CODE) POSITION_QUALIFICATION
		 , CASE
            WHEN LENGTH(POSITION_CODE)>6 
            THEN POSITION_CODE 
            ELSE NULL 
           END POSITION_CODE
         ,GRADE_CODE
		 , SUBSTR(POSITION_CODE,1,6) BU_CODE
	     , STATUS CURRENT_PHASE_CODE
	     , CASE 
	         WHEN STATUS ='Draft'
	         THEN 'In Progress'
	         WHEN STATUS = 'Open'
	         then 'Unposted'
	         ELSE NULL	       END CURRENT_STATE_CODE
         , CASE 
		     WHEN EMP LIKE 'Employee%'
             THEN TO_CHAR(SUBSTR(EMP,INSTR(EMP,'=',1,1)+1,INSTR(EMP,';',1,1)-INSTR(EMP,'=',1,1)-1)) 
             ELSE NULL
           END EMP
         , CASE 
		     WHEN REC LIKE 'Employee%'
             THEN TO_CHAR(SUBSTR(REC,INSTR(REC,'=',1,1)+1,INSTR(REC,';',1,1)-INSTR(REC,'=',1,1)-1))
             ELSE NULL
           END rec
         , requisition_type
         , companyname
		 , workflow
         , business_case
         , jobtype
         , budgeted_salary
         , internalonly
         , if_replacement_name
         , vacancy_type
		 ,(SELECT UNIQUE DESCRIPTION 
             FROM XXMX_POSITION_PROFILES_STG 
            WHERE POSITION_CODE=QR.POSITION_CODE) POSITION_DESCRIPTION
		 /*, DECODE(SUBSTR(POSITION_CODE,1,6),'PH1350',300000004188858,'CA2110',300000004188871,'US2190',300000004188884,'US2230',300000004188897
                                           ,'LU2600',300000004188910,'IE2690',300000004188936,'IN2830',300000004188949,'MT3200',300000004188962
                                           ,'CW4270',300000004188975,'CA4420',300000004188988,'LT5400',300000004214027,'SG6770',300000004214053
                                           ,'VG7620',300000004214066,'KY7970',300000004214079,'GB1170',300000004214105,'PH1330',300000004214118
                                           ,'CA1480',300000004214131,'IE1520',300000004214144,'US1530',300000004214157,'AU2250',300000004214183
                                           ,'KY2370',300000004214196,'GG2520',300000004214209,'LT2540',300000004214222,'IN2810',300000004214248
                                           ,'IN2840',300000004214261,'US2870',300000004214274,'NL4320',300000004214287,'IE4350',300000004214300
                                           ,'LT5380',300000004214326,'DE5770',300000004214365,'FR5850',300000004214378,'LU6350',300000004214404
                                           ,'JE6500',300000004214430,'HK6850',300000004214443,'MU6870',300000004214456,'LU5570',300000061521296
                                           ,'CA3050',300000061521335,'UY7990',300000061521400,'NL6230',300000061521597,'CW7050',300000063394167
                                           ,'ES5470',300000063394180,'GB4120',300000063394193,'IE3220',300000063394206,'LU4370',300000063394219
                                           ,'LU5200',300000063394232,'NL2100',300000063394245,'NL6220',300000063394258,'SG2750',300000063394271,NULL) ORGANIZATION_ID */
         , (select fusion_dept_id 
              from xxmx_jobvite_dept_org_codes 
             where jobvite_dept_name = qr.oracle_code_department ) department_id
		 , (select fusion_org_code 
              from xxmx_jobvite_dept_org_codes
             where jobvite_dept_name = qr.oracle_code_department ) organization_code,
             qr.job_code, qr.legal_employer
FROM(
      SELECT CATEGORY job_family,requisitionid,jobid,title
	       ,to_char(TO_DATE(startdate,'DD/MM/YYYY HH:MI AM'),'YYYY/MM/DD HH24:MI:SS') startdate
           ,to_char(TO_DATE(enddate,'DD/MM/YYYY HH:MI AM'),'YYYY/MM/DD HH24:MI:SS') enddate
		   , department
           , status
           , hiringmanagers
           , substr(hiringmanagers,instr(hiringmanagers,'EmployeeId',1,1)) emp
           , recruiters
           , substr(recruiters,instr(recruiters,'EmployeeId',1,1)) rec
           , city
		   , country
		   , companyname
		   , confidential_vacancy requisition_type
      	   , workflow
		   , oracle_code_department
           , business_case
           , jobtype
           , budgeted_salary
           , internalonly
           , if_replacement_name
           , vacancy_type
      	   , (select distinct position_code 
               from xxmx_job_req_position_codes
               where requisition_number = requisitionid) position_code           
           , (select distinct substr(position_code,
                 instr(position_code,'-',1,2)+1)
                 ||'-'||substr(position_code,1,6) grade
               from xxmx_job_req_position_codes 
               where requisition_number=requisitionid) grade_code
             ,(select distinct j.job_code
                from xxmx_jobreq_position_job_map j, 
                     xxmx_job_req_position_codes pc
                where pc.requisition_number=s.requisitionid 
                and j.position_code= pc.position_code)
                 job_code 
        
            , (select distinct  legal_employer
              from xxmx_hcm_position_le_bu_tab le
              where substr(s.oracle_code_department,instr(s.oracle_code_department,'|',1)+2)= le.bu)legal_employer
        from xxmx_jobvite_requisition_stg s
        WHERE 1=1
       AND STATUS IN ('Draft','Open', 'On Hold') 
       and REQUISITIONID like 'IRC%'
       
) QR;


  TYPE JOB_VITE_DATA IS TABLE OF JOB_VITE_DATA_CUR%ROWTYPE INDEX BY PLS_INTEGER;
  JOB_VITE_TBL    JOB_VITE_DATA;

  --JOB_VITE_DATA_LIMIT NUMBER := 5000;

BEGIN
   DELETE FROM XXMX_HCM_IREC_JOB_REQ_XFM;
   DELETE FROM XXMX_HCM_IREC_JR_HIRE_TEAM_XFM;
   DELETE FROM XXMX_HCM_IREC_JR_POST_DET_XFM;

   COMMIT;

   OPEN JOB_VITE_DATA_CUR;
     FETCH JOB_VITE_DATA_CUR BULK COLLECT INTO JOB_VITE_TBL;-- LIMIT JOB_VITE_DATA_LIMIT;

       --EXIT WHEN JOB_VITE_TBL.COUNT = 0;
       FORALL i IN 1..JOB_VITE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_JOB_REQ_XFM( JOB_FAMILY_NAME   
                                               , DEPARTMENT_NAME
                                               , CURRENT_PHASE_CODE
                                               , CURRENT_STATE_CODE
                                               , HIRING_MANAGER_PERSON_NUMBER
                                               --, HIRING_MANAGER_ASSIGNMENT_NUMBER
                                               , RECRUITER_PERSON_NUMBER
                                               --, RECRUITER_ASSIGNMENT_NUMBER
                                               , PRIMARY_LOCATION_NAME  
											   , PRIMARY_LOCATION_ID
                                               , primary_work_location_code
                                               , primary_work_location_id
											   , REQUISITION_NUMBER
											   , REQUISITION_TITLE
											   , RECRUITING_TYPE
											   , ORGANIZATION_NAME
											   , CANDIDATE_SELECTION_PROCESS_CODE
                                               , POSITION_CODE
											   , BUSINESS_UNIT_SHORT_CODE
											   --, ORGANIZATION_ID
											   , POSITION_DESCRIPTION
											   , POSITION_QUALIFICATION
											   , POSITION_RESPONSIBILITY
											   , DEPARTMENT_ID
											   , ORGANIZATION_CODE
                                               , GRADE_CODE
                                              ,  business_case
                                              ,  fulltime_or_parttime
                                              ,  budgeted_salary
                                              ,  internalonly
                                              ,  IF_REPLACEMENT_NAME
                                              ,  vacancy_type
                                              ,  job_code
                                              , legal_employer_name
                                              , attribute2
                                              )
                                       VALUES (JOB_VITE_TBL(i).JOB_FAMILY
                                              , JOB_VITE_TBL(i).DEPARTMENT
                                              , JOB_VITE_TBL(i).CURRENT_PHASE_CODE
                                              , JOB_VITE_TBL(i).CURRENT_STATE_CODE
                                              , JOB_VITE_TBL(i).EMP
                                              , JOB_VITE_TBL(i).REC
                                              , JOB_VITE_TBL(i).LOCATION_NAME
											  , JOB_VITE_TBL(i).LOCATION_ID
                                              , JOB_VITE_TBL(i).LOCATION_NAME
											  , nvl(JOB_VITE_TBL(i).LOCATION_ID,JOB_VITE_TBL(i).primary_work_location_id)
											  , JOB_VITE_TBL(i).REQUISITIONID
											  , JOB_VITE_TBL(i).TITLE
											  , JOB_VITE_TBL(i).requisition_type
											  , JOB_VITE_TBL(i).COMPANYNAME
											  , JOB_VITE_TBL(i).WORKFLOW 
											  , JOB_VITE_TBL(i).POSITION_CODE
											  , JOB_VITE_TBL(i).BU_CODE
											  --, JOB_VITE_TBL(i).ORGANIZATION_ID
											  , JOB_VITE_TBL(i).POSITION_DESCRIPTION
											  , JOB_VITE_TBL(i).POSITION_QUALIFICATION
											  , JOB_VITE_TBL(i).POSITION_RESPONSIBILITY
											  , JOB_VITE_TBL(i).DEPARTMENT_ID
											  , JOB_VITE_TBL(i).ORGANIZATION_CODE
                                              , JOB_VITE_TBL(i).GRADE_CODE
                                              , JOB_VITE_TBL(i).business_case
                                              , JOB_VITE_TBL(i).jobtype
                                              , JOB_VITE_TBL(i).budgeted_salary
                                              , JOB_VITE_TBL(i).internalonly
                                              , JOB_VITE_TBL(i).IF_REPLACEMENT_NAME
                                              , JOB_VITE_TBL(i).vacancy_type
                                              , JOB_VITE_TBL(i).job_code
                                              , JOB_VITE_TBL(i).legal_employer
                                              , JOB_VITE_TBL(i).city
                                              );

       FORALL j IN 1..JOB_VITE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_JR_HIRE_TEAM_XFM( REQUISITION_NUMBER )
                                               VALUES ( JOB_VITE_TBL(j).REQUISITIONID );

	   FORALL k IN 1..JOB_VITE_TBL.COUNT
         INSERT INTO XXMX_HCM_IREC_JR_POST_DET_XFM( PUBLISHED_JOB_ID 
                                                  , REQUISITION_NUMBER
                                                  , START_DATE
                                                  , END_DATE )
                                           VALUES ( JOB_VITE_TBL(k).JOBID
                                                   ,JOB_VITE_TBL(k).REQUISITIONID		
                                                   ,NVL(JOB_VITE_TBL(k).STARTDATE,'0001/01/01 00:00:00')
                                                   ,JOB_VITE_TBL(k).ENDDATE	 ); 
    update XXMX_HCM_IREC_JOB_REQ_XFM x
set attribute1=primary_work_location_id,
primary_work_location_id =  (select location_id from xxmx_irec_hcm_city_location_id
   where city = x.attribute2);
    COMMIT;

   CLOSE JOB_VITE_DATA_CUR;
END XXMX_JOB_REQ_XFM_LOAD_PRC;

/
