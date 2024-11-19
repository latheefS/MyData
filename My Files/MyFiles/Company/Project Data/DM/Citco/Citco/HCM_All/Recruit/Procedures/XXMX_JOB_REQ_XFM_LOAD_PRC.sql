create or replace PROCEDURE XXMX_JOB_REQ_XFM_LOAD_PRC
AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_ppm_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Worker Hire and Worker Assignment History HDL file
--**              for PPM Workers List.
--*******************************************************************************
  CURSOR JOB_VITE_DATA_CUR IS
    select UNIQUE job_family,requisitionid,jobid,title
,startdate,enddate,department,status,city,LOCATION_NAME,LOCATION_ID,primary_work_location_id,country,companyname,requisition_type
, workflow,oracle_code_department,business_case,jobtype,budgeted_salary,internalonly
,if_replacement_name,vacancy_type,legal_employer,job_code,grade_code,POSITION_QUALIFICATION,position_description,department_id,organization_code
,POSITION_RESPONSIBILITY,POSITION_CODE,BU_CODE, CURRENT_PHASE_CODE,CURRENT_STATE_CODE
,     NVL(CASE 
		     WHEN EMP LIKE 'Employee%'
             THEN TO_CHAR(SUBSTR(EMP,INSTR(EMP,'=',1,1)+1,INSTR(EMP,';',1,1)-INSTR(EMP,'=',1,1)-1)) 
             ELSE NULL
           END,18362) EMP
         , NVL( CASE 
		     WHEN REC LIKE 'Employee%'
             THEN TO_CHAR(SUBSTR(REC,INSTR(REC,'=',1,1)+1,INSTR(REC,';',1,1)-INSTR(REC,'=',1,1)-1))
             ELSE NULL
           END,'18362') REC 
FROM (select UNIQUE CATEGORY job_family,requisitionid,jobid,title
	       ,to_char(TO_DATE(startdate,'DD/MM/YYYY HH:MI AM'),'YYYY/MM/DD HH24:MI:SS') startdate
           ,to_char(TO_DATE(enddate,'DD/MM/YYYY HH:MI AM'),'YYYY/MM/DD HH24:MI:SS') enddate
		   , department
           , status
           --, hiringmanagers
           ,ATTRIBUTE149 emp
           --, recruiters
           ,ATTRIBUTE148 rec
           , decode(city,'Jupiter Mills','Mumbai',city) city
           , DECODE(CITY,'Hyderabad','Hyderabad, Telangana, India'                   
		              ,'Mumbai','Mumbai, Maharashtra, India' 

                      ,'Jupiter Mills','Mumbai, Maharashtra, India' 
                      ,'Valletta', 'St. Julian''s, Malta'
                      ,'Ho-Ho-Kus','Jersey City, NJ, United States'
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
                      ,'Jiangan District','Taizhou, Jiangsu, China'
                      ,'Pampanga','Pampanga, Manila, Philippines'
                      ,'Tortola','Tortola, Virgin Islands, British',
                      'Ebene','Ebene Mauritius',
                      'Nyon','Nyon, Vaud, Switzerland',NULL
                      ) LOCATION_NAME
         , DECODE(CITY,'Vilnius',100000051986497
		              ,'Dublin',100000053306236
					  ,'Malvern',100000022001699
					  ,'Tortola',300000009117128
                      ,'Toronto',100000013158763
                      ,'New York',100000022039508
					  ,'Ebene',300000009117140
					  ,'Cork',100000053306216.
					  ,'Sydney',300000037480793
					  ,'Amsterdam',100000046714847
					  ,'Willemstad',300000009117116
					  ,'London',100000025113355
					  ,'Paris',100000044017787
					  ,'Montevideo',100000043863646
					  ,'Pampanga',300000009117147
					  ,'Grand Cayman',100000043364363
					  ,'St Helier',300000061057585
					  ,'Jersey City',100000022018805
					  ,'Frankfurt am Main',100000043443758
					  ,'Singapore',100000045015551,
                      'Jiangan District', 300000037954721,
                      'Abu Dhabi',100000042417256,
                      'Dubai',300000037413233,'Changi',300000009120009,
                      'Charlotte',100000022011932,
                      'Nyon','100000042485769',
                      NULL
                      ) LOCATION_ID,
            decode(city, 'Hyderabad',300000004278571,'Mumbai',300000004278415,'Pune',300000004278457,
            'Manila',300000061007099,'Muntinlupa City', 300000004278499,'Makati City',300000004278547,
            'Changi',300000061007118 )  primary_work_location_id
		   , country
		   , companyname
		   , confidential_vacancy requisition_type
      	   , workflow
		   , S.oracle_code_department
           , business_case
           , jobtype
           , budgeted_salary
           , internalonly
           , if_replacement_name
           , decode(vacancy_type,'zDO NOT USE - New','New – New Business','New - NBEC (Add Client)','New – New Business','New - Replacement (System Constraints)','New – New Initiative',vacancy_type) vacancy_type
,j.job_code,PC.legal_employer_name legal_employer,attribute150,J.grade_code
,(SELECT UNIQUE POSITION_QUALIFICATION 
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd
            WHERE jjd.profile_code=PC.POSITION_CODE) POSITION_QUALIFICATION
,(SELECT UNIQUE position_responsibility 
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd
            WHERE jjd.profile_code=PC.POSITION_CODE) POSITION_RESPONSIBILITY
,(SELECT UNIQUE jjd.position_description||'.html'  
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd
            WHERE jjd.profile_code=PC.POSITION_CODE) position_description
            ,(select fusion_dept_id 
              from xxmx_jobvite_dept_org_codes 
             where jobvite_dept_name = s.oracle_code_department ) department_id
		 , (select fusion_org_code 
              from xxmx_jobvite_dept_org_codes
             where jobvite_dept_name = s.oracle_code_department ) organization_code
, CASE
            WHEN LENGTH(PC.POSITION_CODE)>6 
            THEN PC.POSITION_CODE 
            ELSE NULL 
           END POSITION_CODE
		 , SUBSTR(PC.POSITION_CODE,1,6) BU_CODE
	     , STATUS CURRENT_PHASE_CODE
	     , CASE 
	         WHEN STATUS ='Draft'
	         THEN 'In Progress'
	         WHEN STATUS = 'Open'
	         then 'Unposted'
	         ELSE NULL	       END CURRENT_STATE_CODE
from xxmx_jobvite_requisition_XFM s,xxmx_jobreq_position_job_map j, xxmx_job_req_position_codes pc
        WHERE 1=1
        AND pc.requisition_number=s.requisitionid 
     and j.position_code= pc.position_code
       AND STATUS IN ('Draft','Open', 'On Hold') 
       and REQUISITIONID like 'IRC%'
      );

  /*  

     SELECT UNIQUE JOB_FAMILY,REQUISITIONID,JOBID,TITLE
	     , STARTDATE,ENDDATE,DEPARTMENT
         , STATUS
         , city
         , DECODE(CITY,'Hyderabad','Hyderabad, Telangana, India'                   
		              ,'Mumbai','Mumbai, Maharashtra, India'   
                      ,'Jupiter Mills','Mumbai, Maharashtra, India' 
                      ,'Valletta', 'St. Julian''s, Malta'
                      ,'Ho-Ho-Kus','Jersey City, NJ, United States'
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
         , DECODE(CITY,'Vilnius',100000051986497
		              ,'Dublin',100000053306236
					  ,'Malvern',100000022001699
					  ,'Tortola',300000009117128
					  ,'Ebene',300000009117140
					  ,'Cork',100000053306216
					  ,'Sydney',300000037480793
					  ,'Amsterdam',100000046714847
					  ,'Willemstad',300000009117116
					  ,'London',100000025113355
					  ,'Paris',100000044017787
					  ,'Montevideo',100000043863646
					  ,'Pampanga',300000009117147
					  ,'Grand Cayman',100000043364363
					  ,'St Helier',300000061057585
					  ,'Jersey City',100000022018805
					  ,'Frankfurt am Main',100000043443758
					  ,'Singapore',100000045015551,
                      'Jiangan District', 300000037954721,
                      'Abu Dhabi',100000042417256,
                      'Dubai',300000037413233,'Changi',300000009120009,
                      'Charlotte',100000022011932,NULL
                      ) LOCATION_ID,
            decode(city, 'Hyderabad',300000004278571,'Mumbai',300000004278415,'Pune',300000004278457,
            'Manila',300000061007099,'Muntinlupa City', 300000004278499,'Makati City',300000004278547,
            'Changi',300000061007118,
            NULL)  primary_work_location_id
         ,(SELECT UNIQUE position_responsibility 
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd
            WHERE jjd.profile_code=QR.POSITION_CODE) POSITION_RESPONSIBILITY
		 ,(SELECT UNIQUE POSITION_QUALIFICATION 
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd
            WHERE jjd.profile_code=QR.POSITION_CODE) POSITION_QUALIFICATION
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
		 ,(SELECT UNIQUE POSITION_DESCRIPTION||'.html' 
             FROM XXMX_JOBVITE_JOB_DESC_STG jjd 
            WHERE jjd.profile_code=QR.POSITION_CODE) POSITION_DESCRIPTION

         , (select fusion_dept_id 
              from xxmx_jobvite_dept_org_codes 
             where FUSION_DEPT_NAME = qr.attribute150 ) department_id
		 , (select fusion_org_code 
              from xxmx_jobvite_dept_org_codes
             where FUSION_DEPT_NAME = qr.attribute150 ) organization_code,
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
           , 
               (select distinct j.grade_code
                from xxmx_jobreq_position_job_map j, 
                     xxmx_job_req_position_codes pc
                where pc.requisition_number=s.requisitionid 
                and j.position_code= pc.position_code)
               grade_code
             ,(select distinct j.job_code
                from xxmx_jobreq_position_job_map j, 
                     xxmx_job_req_position_codes pc
                where pc.requisition_number=s.requisitionid 
                and j.position_code= pc.position_code)
                 job_code 

            ,(select distinct  legal_employer_name
              from xxmx_job_req_position_codes rpc
              where rpc.requisition_number= s.requisitionid)legal_employer, attribute150
        from xxmx_jobvite_requisition_stg s
        WHERE 1=1
       AND STATUS IN ('Draft','Open', 'On Hold') 
       and REQUISITIONID like 'IRC%') QR;*/

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
  /*  update XXMX_HCM_IREC_JOB_REQ_XFM x
set attribute1=primary_work_location_id,
primary_work_location_id =  (select location_id from xxmx_irec_hcm_city_location_id
   where city = x.attribute2);*/
    COMMIT;

   CLOSE JOB_VITE_DATA_CUR;
END XXMX_JOB_REQ_XFM_LOAD_PRC;