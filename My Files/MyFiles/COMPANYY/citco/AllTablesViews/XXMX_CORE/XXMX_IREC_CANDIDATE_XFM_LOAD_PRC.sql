--------------------------------------------------------
--  DDL for Procedure XXMX_IREC_CANDIDATE_XFM_LOAD_PRC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_IREC_CANDIDATE_XFM_LOAD_PRC" 
AS
  CURSOR CANDIDATE_DATA_CUR 
     IS SELECT UNIQUE case when length(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),1,
                instr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
              , candidateid candid
	          , SUBMITTED
              , can.EMAIL
              , nvl((select distinct Cand_First_Name 
                    from xxmx_Candidate_name_map cn
                    where can.email= cn.cand_email),firstname) firstname
               , nvl((select distinct Cand_last_Name 
                        from xxmx_Candidate_name_map cn 
                        where can.email= cn.cand_email),lastname) lastname, 
             can.ADDRESS address,
             nvl(case when length(can.city)>30
             then substr(can.city,1,instr(can.city,',',1,1)-1)
             else can.city
             end, can.city) city ,
              nvl((select g.country_code from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) COUNTRY
            , nvl(CASE WHEN  UPPER(can.country) IN ('IN','INDIA') 
                     OR UPPER(can.country) IN ( 'SG','SINGAPORE')
                  THEN
                LPAD(REPLACE(can.postalcode,' '),6,0)
                WHEN  UPPER(can.country) IN ('IE','IRELAND')
                then 
                'T12 VN2V'                     
                ELSE can.POSTALCODE 
                END ,can.POSTALCODE) POSTALCODE
              , can.REQUISITIONID
	          , CASE
			    WHEN UPPER(can.COUNTRY) IN('FRANCE')
				THEN 33
				WHEN UPPER(can.COUNTRY) IN('SPAIN')
				THEN 34
				WHEN UPPER(can.COUNTRY) IN('IN','INDIA')
				THEN 91
				WHEN UPPER(can.COUNTRY) IN('CANADA','TRINIDAD AND TOBAGO','UNITED STATES','UNITED_STATES','BERMUDA','CAYMAN ISLANDS'
				                      ,'CAYMAN_ISLANDS','BAHAMAS','SAINT LUCIA','DOMINICA','JAMAICA','BARBADOS')
				THEN 1
				WHEN UPPER(can.COUNTRY) IN('PHILIPPINES')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('MALAWI')
				THEN 265
				WHEN UPPER(can.COUNTRY) IN('SINGAPORE')
				THEN 65
				WHEN UPPER(can.COUNTRY) IN('ITALY')	
				THEN 39
				WHEN UPPER(can.COUNTRY) IN('BELIZE')
				THEN 501
				WHEN UPPER(can.COUNTRY) IN('SOUTH AFRICA','SOUTH_AFRICA')
				THEN 27
				WHEN UPPER(can.COUNTRY) IN('OMAN')
				THEN 968
				WHEN UPPER(can.COUNTRY) IN('TAIWAN')
				THEN 886
				WHEN UPPER(can.COUNTRY) IN('HONDURAS')
				THEN 504
				WHEN UPPER(can.COUNTRY) IN('ALBANIA')
				THEN 355
				WHEN UPPER(can.COUNTRY) IN('LUXEMBOURG')
				THEN 352
				WHEN UPPER(can.COUNTRY) IN('TUNISIA')
				THEN 216
				WHEN UPPER(can.COUNTRY) IN('PAKISTAN')
				THEN 92
				WHEN UPPER(can.COUNTRY) IN('ZIMBABWE')
				THEN 263
				WHEN UPPER(can.COUNTRY) IN('CHINA')
				THEN 86
				WHEN UPPER(can.COUNTRY) IN('PH')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION')
				THEN 7
				WHEN UPPER(can.COUNTRY) IN('NEW ZEALAND')
				THEN 64
				WHEN UPPER(can.COUNTRY) IN('BRITISH INDIAN OCEAN TERRITORY')
				THEN 246
				WHEN UPPER(can.COUNTRY) IN('UNITED ARAB EMIRATES')
				THEN 971
				WHEN UPPER(can.COUNTRY) IN('GAMBIA')
				THEN 220
				WHEN UPPER(can.COUNTRY) IN('URUGUAY')
				THEN 598
				WHEN UPPER(can.COUNTRY) IN('UKRAINE')
				THEN 380
				WHEN UPPER(can.COUNTRY) IN('AZERBAIJAN')
				THEN 994
				WHEN UPPER(can.COUNTRY) IN('GERMANY')
				THEN 49
				WHEN UPPER(can.COUNTRY) IN('LEBANON')
				THEN 961
				WHEN UPPER(can.COUNTRY) IN('SAUDI ARABIA','SAUDI_ARABIA')
				THEN 966
				WHEN UPPER(can.COUNTRY) IN('COSTA_RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('MEXICO')
				THEN 52
				WHEN UPPER(can.COUNTRY) IN('EGYPT')
				THEN 20
				WHEN UPPER(can.COUNTRY) IN('SERBIA')
				THEN 381
				WHEN UPPER(can.COUNTRY) IN('IE')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('LITHUANIA')
				THEN 370
				WHEN UPPER(can.COUNTRY) IN('UNITED KINGDOM','UNITED_KINGDOM')
				THEN 44
				WHEN UPPER(can.COUNTRY) IN('GREECE')
				THEN 30
				WHEN UPPER(can.COUNTRY) IN('BELGIUM')
				THEN 32
				WHEN UPPER(can.COUNTRY) IN('DENMARK')
				THEN 45
				WHEN UPPER(can.COUNTRY) IN('POLAND')
				THEN 48
				WHEN UPPER(can.COUNTRY) IN('SWITZERLAND')
				THEN 41
				WHEN UPPER(can.COUNTRY) IN('KUWAIT')
				THEN 965
				WHEN UPPER(can.COUNTRY) IN('SLOVAKIA')
				THEN 421
				WHEN UPPER(can.COUNTRY) IN('MOROCCO')
				THEN 212
				WHEN UPPER(can.COUNTRY) IN('LATVIA')
				THEN 371
				WHEN UPPER(can.COUNTRY) IN('BAHRAIN')
				THEN 973
				WHEN UPPER(can.COUNTRY) IN('SRI LANKA')
				THEN 94
				WHEN UPPER(can.COUNTRY) IN('TURKEY')
				THEN 90
				WHEN UPPER(can.COUNTRY) IN('IRELAND')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('BRAZIL')
				THEN 55
				WHEN UPPER(can.COUNTRY) IN('HONG KONG')
				THEN 852
				WHEN UPPER(can.COUNTRY) IN('QATAR')
				THEN 974
				WHEN UPPER(can.COUNTRY) IN('BULGARIA')
				THEN 359
				WHEN UPPER(can.COUNTRY) IN('JAPAN')
				THEN 81
				WHEN UPPER(can.COUNTRY) IN('PORTUGAL')
				THEN 351
				WHEN UPPER(can.COUNTRY) IN('VIETNAM')
				THEN 84
				WHEN UPPER(can.COUNTRY) IN('ROMANIA')
				THEN 40
				WHEN UPPER(can.COUNTRY) IN('THAILAND')
				THEN 66
				WHEN UPPER(can.COUNTRY) IN('TANZANIA')
				THEN 255
				WHEN UPPER(can.COUNTRY) IN('NORWAY')
				THEN 47
				WHEN UPPER(can.COUNTRY) IN('HUNGARY')
				THEN 36
				WHEN UPPER(can.COUNTRY) IN('FINLAND')
				THEN 358
				WHEN UPPER(can.COUNTRY) IN('NETHERLANDS')
				THEN 31
				WHEN UPPER(can.COUNTRY) IN('BANGLADESH')
				THEN 880
				WHEN UPPER(can.COUNTRY) IN('SWEDEN')
				THEN 46
				WHEN UPPER(can.COUNTRY) IN('ZAMBIA')
				THEN 260
				WHEN UPPER(can.COUNTRY) IN('BOSNIA AND HERZEGOVINA')
				THEN 387
				WHEN UPPER(can.COUNTRY) IN('SOMALIA')
				THEN 252
				WHEN UPPER(can.COUNTRY) IN('MALAYSIA')
				THEN 60
				WHEN UPPER(can.COUNTRY) IN('MAURITIUS')
				THEN 230
				WHEN UPPER(can.COUNTRY) IN('NIGERIA')
				THEN 234
				WHEN UPPER(can.COUNTRY) IN('MALTA')
				THEN 356
				WHEN UPPER(can.COUNTRY) IN('CYPRUS')
				THEN 357
				WHEN UPPER(can.COUNTRY) IN('ARGENTINA')
				THEN 54
				WHEN UPPER(can.COUNTRY) IN('COSTA RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('AUSTRALIA')
				THEN 61
				ELSE NULL
				END COUNTRY_CODE
              , CASE 
			    WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(can.MOBILE,can.HOMEPHONE),'[^0-9]',''),-10),1,3)
				WHEN UPPER(can.COUNTRY) IN('BERMUDA')
				THEN '441'
				WHEN UPPER(can.COUNTRY) IN('BAHAMAS')
				THEN '242'
				WHEN UPPER(can.COUNTRY) IN('CAYMAN_ISLANDS','CAYMAN ISLANDS')
				THEN '345'
				WHEN UPPER(can.COUNTRY) IN('SAINT LUCIA')
				THEN '758'
				WHEN UPPER(can.COUNTRY) IN('JAMAICA')
				THEN '876'
				ELSE NULL
                END AREA_CODE
              , nvl( (select g.country_code 
                  from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) legislation_CODE
              , NVL(CASE 
                WHEN UPPER(can.COUNTRY) IN('FRANCE','FR')
				THEN
                   '176742549'
                WHEN Upper(can.COUNTRY) IN ('SPAIN','ES')
                THEN
                '914148667'
			    WHEN UPPER(can.COUNTRY) IN ('PHILIPPINES','TRINIDAD AND TOBAGO','ITALY','PAKISTAN','CHINA','PH','TURKEY'
				                       ,'BRITISH INDIAN OCEAN TERRITORY','MEXICO','EGYPT','UNITED KINGDOM','UNITED_KINGDOM','GREECE'
									   ,'JAPAN','NIGERIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10)
                WHEN UPPER(can.COUNTRY) IN ('IN','INDIA')
                THEN nvl(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),'2066380800')
				WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),4)
				WHEN UPPER(can.COUNTRY) IN('BELIZE','GAMBIA','AZERBAIJAN','BERMUDA','BAHAMAS','DENMARK','CAYMAN_ISLANDS'
				                      ,'CAYMAN ISLANDS','SAINT LUCIA','JAMAICA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-7)
				WHEN UPPER(can.COUNTRY) IN ('MALAWI','SOUTH AFRICA','SOUTH_AFRICA','TAIWAN','ALBANIA','LUXEMBOURG','ZIMBABWE','NEW ZEALAND'
				                       ,'UNITED ARAB EMIRATES','UKRAINE','SAUDI ARABIA','SAUDI_ARABIA','SERBIA','IE','BELGIUM','POLAND','SWITZERLAND'
									   ,'SLOVAKIA','MOROCCO','SRI LANKA','IRELAND','BRAZIL','BULGARIA','PORTUGAL','VIETNAM','ROMANIA','THAILAND'
									   ,'TANZANIA','HUNGARY','NETHERLANDS','SWEDEN','ZAMBIA','SOMALIA','MALAYSIA','AUSTRALIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-9)
				WHEN UPPER(can.COUNTRY) IN ('SINGAPORE','OMAN','HONDURAS','TUNISIA','URUGUAY','GERMANY','LEBANON','COSTA_RICA','LITHUANIA'
				                       ,'KUWAIT','LATVIA','BAHRAIN','HONG KONG','QATAR','NORWAY','FINLAND','BOSNIA AND HERZEGOVINA','MALTA'
									   ,'MAURITIUS','CYPRUS','COSTA RICA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-8)
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION','BANGLADESH','ARGENTINA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-11)
                ELSE  nvl(mobile,homephone)
                END, nvl(mobile,homephone)) PHONE_NUMBER,
                CASE
                  WHEN can.status = 'New'   THEN  'NEW'
                  WHEN can.status = 'Application Reviewed'   THEN  'NEW'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'SCREENING'
                  WHEN can.status = 'Internal Screening Form'   THEN  'SCREENING'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'SCREENING'
                  WHEN can.status = 'Phone Screen'   THEN  'SCREENING'
                  WHEN can.status = 'Screened by TA'   THEN  'SCREENING'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  'SCREENING'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'SCREENING'
                  WHEN can.status = 'Schedule Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'First Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Second Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Additional Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Offer Approved' THEN 'OFFER'
                  WHEN can.status = 'Offer Rejected' THEN 'OFFER'
                  WHEN can.status = 'Rejected' THEN 'REJECTED'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_PHASE_CODE,
                CASE
                  WHEN can.status = 'New'   THEN  'TO_BE_REVIEWED'
                  WHEN can.status = 'Application Reviewed'   THEN  'REVIEWED'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'PHONE_SCREEN_TO_BE_SCHEDULED'
                  WHEN can.status = 'Internal Screening Form'   THEN  'PHONE_SCREEN_TO_BE_SCHEDULED'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'PHONE_SCREEN_SCHEDULED'
                  WHEN can.status = 'Phone Screen'   THEN  'PHONE_SCREEN_SCHEDULED'
                  WHEN can.status = 'Screened by TA'   THEN  'PHONE_SCREEN_COMPLETED'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  '300000017023892'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Schedule Interview'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN can.status = 'First Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Second Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Additional Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Offer Approved' THEN 'APPROVED'
                  WHEN can.status = 'Offer Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_STATE_CODE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency Name',
               'Employee Referral','Employee Referral',
               'Recruiter','Jobvite Career Site',
               (SELECT FUSION_SOURCE 
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                 WHERE JOBVITE_SOURCE = CAN.SOURCE))         SOURCE,             
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM,
                decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Referred by Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT decode(FUSION_SOURCE_MEDIUM, 
                              'Agency','Referred by Agency',
                              'Employee Referral','Jobvite Referral',FUSION_SOURCE_MEDIUM)
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_medium_canextra
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,can.OFFERLETTER
                ,can.ORIGINALDOCUMENT ,can.coverletterfile,can.status
	       FROM xxmx_jobvite_candidates_stg can,
                xxmx_jobvite_requisition_stg req
            --    hr_locations_all@xxmx_extract hrl
         where can.requisitionid = req.requisitionid(+) 
        --   and hrl.country = substr(location,1,2)
        --   and inactive_date is null
        --   and trunc(hrl.last_update_date) = (select trunc(max(last_update_date))
        --                                   from hr_locations_all@xxmx_extract mhrl 
        --                                    where mhrl.country=hrl.country 
        --                                    and inactive_date is null)
      --      AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG
        --                     c where c.email = can.email )
        AND ((TRUNC(TO_DATE(submitted,'MM/DD/RRRR HH24:MI')) 
            BETWEEN  TRUNC(TO_DATE('03/31/2022','MM/DD/RRRR')) 
            AND TRUNC(TO_DATE('04/01/2023','MM/DD/RRRR'))
            AND (upper(source) like '%AGENCY%' OR upper(source) like '%REFERRAL%'
               ) ));



        cursor get_all_open_requisitions_data
        is SELECT UNIQUE case when length(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),1,
                instr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
              , candidateid candid
	          , SUBMITTED
              , can.EMAIL
              , nvl((select distinct Cand_First_Name 
                    from xxmx_Candidate_name_map cn
                    where can.email= cn.cand_email),firstname) firstname
               , nvl((select distinct Cand_last_Name 
                        from xxmx_Candidate_name_map cn 
                        where can.email= cn.cand_email),lastname) lastname, 
             can.ADDRESS address,
             nvl(case when length(can.city)>30
             then substr(can.city,1,instr(can.city,',',1,1)-1)
             else can.city
             end, can.city) city ,
              nvl((select g.country_code from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) COUNTRY
            , nvl(CASE WHEN  UPPER(can.country) IN ('IN','INDIA') 
                     OR UPPER(can.country) IN ( 'SG','SINGAPORE')
                  THEN
                LPAD(REPLACE(can.postalcode,' '),6,0)
                WHEN  UPPER(can.country) IN ('IE','IRELAND')
                then 
                'T12 VN2V'                     
                ELSE can.POSTALCODE 
                END ,can.POSTALCODE) POSTALCODE
              , can.REQUISITIONID
	          , CASE
			    WHEN UPPER(can.COUNTRY) IN('FRANCE')
				THEN 33
				WHEN UPPER(can.COUNTRY) IN('SPAIN')
				THEN 34
				WHEN UPPER(can.COUNTRY) IN('IN','INDIA')
				THEN 91
				WHEN UPPER(can.COUNTRY) IN('CANADA','TRINIDAD AND TOBAGO','UNITED STATES','UNITED_STATES','BERMUDA','CAYMAN ISLANDS'
				                      ,'CAYMAN_ISLANDS','BAHAMAS','SAINT LUCIA','DOMINICA','JAMAICA','BARBADOS')
				THEN 1
				WHEN UPPER(can.COUNTRY) IN('PHILIPPINES')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('MALAWI')
				THEN 265
				WHEN UPPER(can.COUNTRY) IN('SINGAPORE')
				THEN 65
				WHEN UPPER(can.COUNTRY) IN('ITALY')	
				THEN 39
				WHEN UPPER(can.COUNTRY) IN('BELIZE')
				THEN 501
				WHEN UPPER(can.COUNTRY) IN('SOUTH AFRICA','SOUTH_AFRICA')
				THEN 27
				WHEN UPPER(can.COUNTRY) IN('OMAN')
				THEN 968
				WHEN UPPER(can.COUNTRY) IN('TAIWAN')
				THEN 886
				WHEN UPPER(can.COUNTRY) IN('HONDURAS')
				THEN 504
				WHEN UPPER(can.COUNTRY) IN('ALBANIA')
				THEN 355
				WHEN UPPER(can.COUNTRY) IN('LUXEMBOURG')
				THEN 352
				WHEN UPPER(can.COUNTRY) IN('TUNISIA')
				THEN 216
				WHEN UPPER(can.COUNTRY) IN('PAKISTAN')
				THEN 92
				WHEN UPPER(can.COUNTRY) IN('ZIMBABWE')
				THEN 263
				WHEN UPPER(can.COUNTRY) IN('CHINA')
				THEN 86
				WHEN UPPER(can.COUNTRY) IN('PH')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION')
				THEN 7
				WHEN UPPER(can.COUNTRY) IN('NEW ZEALAND')
				THEN 64
				WHEN UPPER(can.COUNTRY) IN('BRITISH INDIAN OCEAN TERRITORY')
				THEN 246
				WHEN UPPER(can.COUNTRY) IN('UNITED ARAB EMIRATES')
				THEN 971
				WHEN UPPER(can.COUNTRY) IN('GAMBIA')
				THEN 220
				WHEN UPPER(can.COUNTRY) IN('URUGUAY')
				THEN 598
				WHEN UPPER(can.COUNTRY) IN('UKRAINE')
				THEN 380
				WHEN UPPER(can.COUNTRY) IN('AZERBAIJAN')
				THEN 994
				WHEN UPPER(can.COUNTRY) IN('GERMANY')
				THEN 49
				WHEN UPPER(can.COUNTRY) IN('LEBANON')
				THEN 961
				WHEN UPPER(can.COUNTRY) IN('SAUDI ARABIA','SAUDI_ARABIA')
				THEN 966
				WHEN UPPER(can.COUNTRY) IN('COSTA_RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('MEXICO')
				THEN 52
				WHEN UPPER(can.COUNTRY) IN('EGYPT')
				THEN 20
				WHEN UPPER(can.COUNTRY) IN('SERBIA')
				THEN 381
				WHEN UPPER(can.COUNTRY) IN('IE')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('LITHUANIA')
				THEN 370
				WHEN UPPER(can.COUNTRY) IN('UNITED KINGDOM','UNITED_KINGDOM')
				THEN 44
				WHEN UPPER(can.COUNTRY) IN('GREECE')
				THEN 30
				WHEN UPPER(can.COUNTRY) IN('BELGIUM')
				THEN 32
				WHEN UPPER(can.COUNTRY) IN('DENMARK')
				THEN 45
				WHEN UPPER(can.COUNTRY) IN('POLAND')
				THEN 48
				WHEN UPPER(can.COUNTRY) IN('SWITZERLAND')
				THEN 41
				WHEN UPPER(can.COUNTRY) IN('KUWAIT')
				THEN 965
				WHEN UPPER(can.COUNTRY) IN('SLOVAKIA')
				THEN 421
				WHEN UPPER(can.COUNTRY) IN('MOROCCO')
				THEN 212
				WHEN UPPER(can.COUNTRY) IN('LATVIA')
				THEN 371
				WHEN UPPER(can.COUNTRY) IN('BAHRAIN')
				THEN 973
				WHEN UPPER(can.COUNTRY) IN('SRI LANKA')
				THEN 94
				WHEN UPPER(can.COUNTRY) IN('TURKEY')
				THEN 90
				WHEN UPPER(can.COUNTRY) IN('IRELAND')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('BRAZIL')
				THEN 55
				WHEN UPPER(can.COUNTRY) IN('HONG KONG')
				THEN 852
				WHEN UPPER(can.COUNTRY) IN('QATAR')
				THEN 974
				WHEN UPPER(can.COUNTRY) IN('BULGARIA')
				THEN 359
				WHEN UPPER(can.COUNTRY) IN('JAPAN')
				THEN 81
				WHEN UPPER(can.COUNTRY) IN('PORTUGAL')
				THEN 351
				WHEN UPPER(can.COUNTRY) IN('VIETNAM')
				THEN 84
				WHEN UPPER(can.COUNTRY) IN('ROMANIA')
				THEN 40
				WHEN UPPER(can.COUNTRY) IN('THAILAND')
				THEN 66
				WHEN UPPER(can.COUNTRY) IN('TANZANIA')
				THEN 255
				WHEN UPPER(can.COUNTRY) IN('NORWAY')
				THEN 47
				WHEN UPPER(can.COUNTRY) IN('HUNGARY')
				THEN 36
				WHEN UPPER(can.COUNTRY) IN('FINLAND')
				THEN 358
				WHEN UPPER(can.COUNTRY) IN('NETHERLANDS')
				THEN 31
				WHEN UPPER(can.COUNTRY) IN('BANGLADESH')
				THEN 880
				WHEN UPPER(can.COUNTRY) IN('SWEDEN')
				THEN 46
				WHEN UPPER(can.COUNTRY) IN('ZAMBIA')
				THEN 260
				WHEN UPPER(can.COUNTRY) IN('BOSNIA AND HERZEGOVINA')
				THEN 387
				WHEN UPPER(can.COUNTRY) IN('SOMALIA')
				THEN 252
				WHEN UPPER(can.COUNTRY) IN('MALAYSIA')
				THEN 60
				WHEN UPPER(can.COUNTRY) IN('MAURITIUS')
				THEN 230
				WHEN UPPER(can.COUNTRY) IN('NIGERIA')
				THEN 234
				WHEN UPPER(can.COUNTRY) IN('MALTA')
				THEN 356
				WHEN UPPER(can.COUNTRY) IN('CYPRUS')
				THEN 357
				WHEN UPPER(can.COUNTRY) IN('ARGENTINA')
				THEN 54
				WHEN UPPER(can.COUNTRY) IN('COSTA RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('AUSTRALIA')
				THEN 61
				ELSE NULL
				END COUNTRY_CODE
              , CASE 
			    WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(can.MOBILE,can.HOMEPHONE),'[^0-9]',''),-10),1,3)
				WHEN UPPER(can.COUNTRY) IN('BERMUDA')
				THEN '441'
				WHEN UPPER(can.COUNTRY) IN('BAHAMAS')
				THEN '242'
				WHEN UPPER(can.COUNTRY) IN('CAYMAN_ISLANDS','CAYMAN ISLANDS')
				THEN '345'
				WHEN UPPER(can.COUNTRY) IN('SAINT LUCIA')
				THEN '758'
				WHEN UPPER(can.COUNTRY) IN('JAMAICA')
				THEN '876'
				ELSE NULL
                END AREA_CODE
              ,  nvl( (select g.country_code 
                  from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) legislation_CODE
              , NVL(CASE 
                WHEN UPPER(can.COUNTRY) IN('FRANCE','FR')
				THEN
                   '176742549'
                WHEN Upper(can.COUNTRY) IN ('SPAIN','ES')
                THEN
                '914148667'
			    WHEN UPPER(can.COUNTRY) IN ('PHILIPPINES','TRINIDAD AND TOBAGO','ITALY','PAKISTAN','CHINA','PH','TURKEY'
				                       ,'BRITISH INDIAN OCEAN TERRITORY','MEXICO','EGYPT','UNITED KINGDOM','UNITED_KINGDOM','GREECE'
									   ,'JAPAN','NIGERIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10)
                WHEN UPPER(can.COUNTRY) IN ('IN','INDIA')
                THEN nvl(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),'2066380800')
				WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),4)
				WHEN UPPER(can.COUNTRY) IN('BELIZE','GAMBIA','AZERBAIJAN','BERMUDA','BAHAMAS','DENMARK','CAYMAN_ISLANDS'
				                      ,'CAYMAN ISLANDS','SAINT LUCIA','JAMAICA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-7)
				WHEN UPPER(can.COUNTRY) IN ('MALAWI','SOUTH AFRICA','SOUTH_AFRICA','TAIWAN','ALBANIA','LUXEMBOURG','ZIMBABWE','NEW ZEALAND'
				                       ,'UNITED ARAB EMIRATES','UKRAINE','SAUDI ARABIA','SAUDI_ARABIA','SERBIA','IE','BELGIUM','POLAND','SWITZERLAND'
									   ,'SLOVAKIA','MOROCCO','SRI LANKA','IRELAND','BRAZIL','BULGARIA','PORTUGAL','VIETNAM','ROMANIA','THAILAND'
									   ,'TANZANIA','HUNGARY','NETHERLANDS','SWEDEN','ZAMBIA','SOMALIA','MALAYSIA','AUSTRALIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-9)
				WHEN UPPER(can.COUNTRY) IN ('SINGAPORE','OMAN','HONDURAS','TUNISIA','URUGUAY','GERMANY','LEBANON','COSTA_RICA','LITHUANIA'
				                       ,'KUWAIT','LATVIA','BAHRAIN','HONG KONG','QATAR','NORWAY','FINLAND','BOSNIA AND HERZEGOVINA','MALTA'
									   ,'MAURITIUS','CYPRUS','COSTA RICA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-8)
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION','BANGLADESH','ARGENTINA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-11)
                ELSE  nvl(mobile,homephone)
                END, nvl(mobile,homephone)) PHONE_NUMBER,
                CASE
                  WHEN can.status = 'New'   THEN  'NEW'
                  WHEN can.status = 'Application Reviewed'   THEN  'NEW'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'SCREENING'
                  WHEN can.status = 'Internal Screening Form'   THEN  'SCREENING'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'SCREENING'
                  WHEN can.status = 'Phone Screen'   THEN  'SCREENING'
                  WHEN can.status = 'Screened by TA'   THEN  'SCREENING'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  'SCREENING'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'SCREENING'
                  WHEN can.status = 'Schedule Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'First Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Second Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Additional Interview'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Offer Approved' THEN 'OFFER'
                  WHEN can.status = 'Offer Rejected' THEN 'OFFER'
                  WHEN can.status = 'Rejected' THEN 'REJECTED'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_PHASE_CODE,
                CASE
                  WHEN can.status = 'New'   THEN  'TO_BE_REVIEWED'
                  WHEN can.status = 'Application Reviewed'   THEN  'REVIEWED'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'PHONE_SCREEN_TO_BE_SCHEDULED'
                  WHEN can.status = 'Internal Screening Form'   THEN  'PHONE_SCREEN_TO_BE_SCHEDULED'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'PHONE_SCREEN_SCHEDULED'
                  WHEN can.status = 'Phone Screen'   THEN  'PHONE_SCREEN_SCHEDULED'
                  WHEN can.status = 'Screened by TA'   THEN  'PHONE_SCREEN_COMPLETED'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  '300000017023892'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Schedule Interview'   THEN  'INTERVIEW_TO_BE_SCHEDULED'
                  WHEN can.status = 'First Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Second Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Additional Interview'   THEN  'INTERVIEW_SCHEDULED'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Offer Approved' THEN 'APPROVED'
                  WHEN can.status = 'Offer Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_STATE_CODE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency Name',
               'Employee Referral','Employee Referral',
               'Recruiter','Jobvite Career Site',
               (SELECT FUSION_SOURCE 
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                 WHERE JOBVITE_SOURCE = CAN.SOURCE))         SOURCE,             
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM,
                decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Referred by Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT decode(FUSION_SOURCE_MEDIUM, 
                              'Agency','Referred by Agency',
                              'Employee Referral','Jobvite Referral',FUSION_SOURCE_MEDIUM)
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_medium_canextra
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,can.OFFERLETTER
                ,can.ORIGINALDOCUMENT ,can.coverletterfile,can.status
	       FROM xxmx_jobvite_candidates_stg can,
                xxmx_jobvite_requisition_stg req
            --    hr_locations_all@xxmx_extract hrl
         where can.requisitionid = req.requisitionid(+) 
        --   and hrl.country = substr(location,1,2)
        --   and inactive_date is null
        --   and trunc(hrl.last_update_date) = (select trunc(max(last_update_date))
        --                                   from hr_locations_all@xxmx_extract mhrl 
        --                                    where mhrl.country=hrl.country 
        --                                    and inactive_date is null)
         --   AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG
           --                  c where c.email = can.email )
            and  (upper(can.status) in ('NEW'
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
            AND can.REQUISITIONID IN (select distinct rs.REQUISITIONID 
                             from XXMX_JOBVITE_REQUISITION_STG rs
                            where status IN ('Draft','Open', 'On Hold')
                              and REQUISITIONID like 'IRC%'));

      cursor get_all_candidate_pool_recs
      is SELECT UNIQUE case when length(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'))>30 
                then substr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),1,
                instr(REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_'),'_',1,1)-1)||rownum 
                else REPLACE(SUBSTR(can.EMAIL,1,INSTR(can.EMAIL,'@',1,1)-1),'.','_')
                end CANDIDATEID
              , candidateid candid
	          , SUBMITTED
              , can.EMAIL
              , nvl((select distinct Cand_First_Name 
                    from xxmx_Candidate_name_map cn
                    where can.email= cn.cand_email),firstname) firstname
               , nvl((select distinct Cand_last_Name 
                        from xxmx_Candidate_name_map cn 
                        where can.email= cn.cand_email),lastname) lastname, 
             can.ADDRESS address,
             nvl(case when length(can.city)>30
             then substr(can.city,1,instr(can.city,',',1,1)-1)
             else can.city
             end, can.city) city ,
              nvl((select g.country_code from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) COUNTRY
            , nvl(CASE WHEN  UPPER(can.country) IN ('IN','INDIA') 
                     OR UPPER(can.country) IN ( 'SG','SINGAPORE')
                  THEN
                LPAD(REPLACE(can.postalcode,' '),6,0)
                WHEN  UPPER(can.country) IN ('IE','IRELAND')
                then 
                'T12 VN2V'                     
                ELSE can.POSTALCODE 
                END ,can.POSTALCODE) POSTALCODE
              , can.REQUISITIONID
	          , CASE
			    WHEN UPPER(can.COUNTRY) IN('FRANCE')
				THEN 33
				WHEN UPPER(can.COUNTRY) IN('SPAIN')
				THEN 34
				WHEN UPPER(can.COUNTRY) IN('IN','INDIA')
				THEN 91
				WHEN UPPER(can.COUNTRY) IN('CANADA','TRINIDAD AND TOBAGO','UNITED STATES','UNITED_STATES','BERMUDA','CAYMAN ISLANDS'
				                      ,'CAYMAN_ISLANDS','BAHAMAS','SAINT LUCIA','DOMINICA','JAMAICA','BARBADOS')
				THEN 1
				WHEN UPPER(can.COUNTRY) IN('PHILIPPINES')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('MALAWI')
				THEN 265
				WHEN UPPER(can.COUNTRY) IN('SINGAPORE')
				THEN 65
				WHEN UPPER(can.COUNTRY) IN('ITALY')	
				THEN 39
				WHEN UPPER(can.COUNTRY) IN('BELIZE')
				THEN 501
				WHEN UPPER(can.COUNTRY) IN('SOUTH AFRICA','SOUTH_AFRICA')
				THEN 27
				WHEN UPPER(can.COUNTRY) IN('OMAN')
				THEN 968
				WHEN UPPER(can.COUNTRY) IN('TAIWAN')
				THEN 886
				WHEN UPPER(can.COUNTRY) IN('HONDURAS')
				THEN 504
				WHEN UPPER(can.COUNTRY) IN('ALBANIA')
				THEN 355
				WHEN UPPER(can.COUNTRY) IN('LUXEMBOURG')
				THEN 352
				WHEN UPPER(can.COUNTRY) IN('TUNISIA')
				THEN 216
				WHEN UPPER(can.COUNTRY) IN('PAKISTAN')
				THEN 92
				WHEN UPPER(can.COUNTRY) IN('ZIMBABWE')
				THEN 263
				WHEN UPPER(can.COUNTRY) IN('CHINA')
				THEN 86
				WHEN UPPER(can.COUNTRY) IN('PH')
				THEN 63
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION')
				THEN 7
				WHEN UPPER(can.COUNTRY) IN('NEW ZEALAND')
				THEN 64
				WHEN UPPER(can.COUNTRY) IN('BRITISH INDIAN OCEAN TERRITORY')
				THEN 246
				WHEN UPPER(can.COUNTRY) IN('UNITED ARAB EMIRATES')
				THEN 971
				WHEN UPPER(can.COUNTRY) IN('GAMBIA')
				THEN 220
				WHEN UPPER(can.COUNTRY) IN('URUGUAY')
				THEN 598
				WHEN UPPER(can.COUNTRY) IN('UKRAINE')
				THEN 380
				WHEN UPPER(can.COUNTRY) IN('AZERBAIJAN')
				THEN 994
				WHEN UPPER(can.COUNTRY) IN('GERMANY')
				THEN 49
				WHEN UPPER(can.COUNTRY) IN('LEBANON')
				THEN 961
				WHEN UPPER(can.COUNTRY) IN('SAUDI ARABIA','SAUDI_ARABIA')
				THEN 966
				WHEN UPPER(can.COUNTRY) IN('COSTA_RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('MEXICO')
				THEN 52
				WHEN UPPER(can.COUNTRY) IN('EGYPT')
				THEN 20
				WHEN UPPER(can.COUNTRY) IN('SERBIA')
				THEN 381
				WHEN UPPER(can.COUNTRY) IN('IE')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('LITHUANIA')
				THEN 370
				WHEN UPPER(can.COUNTRY) IN('UNITED KINGDOM','UNITED_KINGDOM')
				THEN 44
				WHEN UPPER(can.COUNTRY) IN('GREECE')
				THEN 30
				WHEN UPPER(can.COUNTRY) IN('BELGIUM')
				THEN 32
				WHEN UPPER(can.COUNTRY) IN('DENMARK')
				THEN 45
				WHEN UPPER(can.COUNTRY) IN('POLAND')
				THEN 48
				WHEN UPPER(can.COUNTRY) IN('SWITZERLAND')
				THEN 41
				WHEN UPPER(can.COUNTRY) IN('KUWAIT')
				THEN 965
				WHEN UPPER(can.COUNTRY) IN('SLOVAKIA')
				THEN 421
				WHEN UPPER(can.COUNTRY) IN('MOROCCO')
				THEN 212
				WHEN UPPER(can.COUNTRY) IN('LATVIA')
				THEN 371
				WHEN UPPER(can.COUNTRY) IN('BAHRAIN')
				THEN 973
				WHEN UPPER(can.COUNTRY) IN('SRI LANKA')
				THEN 94
				WHEN UPPER(can.COUNTRY) IN('TURKEY')
				THEN 90
				WHEN UPPER(can.COUNTRY) IN('IRELAND')
				THEN 353
				WHEN UPPER(can.COUNTRY) IN('BRAZIL')
				THEN 55
				WHEN UPPER(can.COUNTRY) IN('HONG KONG')
				THEN 852
				WHEN UPPER(can.COUNTRY) IN('QATAR')
				THEN 974
				WHEN UPPER(can.COUNTRY) IN('BULGARIA')
				THEN 359
				WHEN UPPER(can.COUNTRY) IN('JAPAN')
				THEN 81
				WHEN UPPER(can.COUNTRY) IN('PORTUGAL')
				THEN 351
				WHEN UPPER(can.COUNTRY) IN('VIETNAM')
				THEN 84
				WHEN UPPER(can.COUNTRY) IN('ROMANIA')
				THEN 40
				WHEN UPPER(can.COUNTRY) IN('THAILAND')
				THEN 66
				WHEN UPPER(can.COUNTRY) IN('TANZANIA')
				THEN 255
				WHEN UPPER(can.COUNTRY) IN('NORWAY')
				THEN 47
				WHEN UPPER(can.COUNTRY) IN('HUNGARY')
				THEN 36
				WHEN UPPER(can.COUNTRY) IN('FINLAND')
				THEN 358
				WHEN UPPER(can.COUNTRY) IN('NETHERLANDS')
				THEN 31
				WHEN UPPER(can.COUNTRY) IN('BANGLADESH')
				THEN 880
				WHEN UPPER(can.COUNTRY) IN('SWEDEN')
				THEN 46
				WHEN UPPER(can.COUNTRY) IN('ZAMBIA')
				THEN 260
				WHEN UPPER(can.COUNTRY) IN('BOSNIA AND HERZEGOVINA')
				THEN 387
				WHEN UPPER(can.COUNTRY) IN('SOMALIA')
				THEN 252
				WHEN UPPER(can.COUNTRY) IN('MALAYSIA')
				THEN 60
				WHEN UPPER(can.COUNTRY) IN('MAURITIUS')
				THEN 230
				WHEN UPPER(can.COUNTRY) IN('NIGERIA')
				THEN 234
				WHEN UPPER(can.COUNTRY) IN('MALTA')
				THEN 356
				WHEN UPPER(can.COUNTRY) IN('CYPRUS')
				THEN 357
				WHEN UPPER(can.COUNTRY) IN('ARGENTINA')
				THEN 54
				WHEN UPPER(can.COUNTRY) IN('COSTA RICA')
				THEN 506
				WHEN UPPER(can.COUNTRY) IN('AUSTRALIA')
				THEN 61
				ELSE NULL
				END COUNTRY_CODE
              , CASE 
			    WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(can.MOBILE,can.HOMEPHONE),'[^0-9]',''),-10),1,3)
				WHEN UPPER(can.COUNTRY) IN('BERMUDA')
				THEN '441'
				WHEN UPPER(can.COUNTRY) IN('BAHAMAS')
				THEN '242'
				WHEN UPPER(can.COUNTRY) IN('CAYMAN_ISLANDS','CAYMAN ISLANDS')
				THEN '345'
				WHEN UPPER(can.COUNTRY) IN('SAINT LUCIA')
				THEN '758'
				WHEN UPPER(can.COUNTRY) IN('JAMAICA')
				THEN '876'
				ELSE NULL
                END AREA_CODE
              ,  nvl( (select g.country_code 
                  from XXMX_HCM_GEO_MAP g 
                  where upper(g.country) = upper(can.country)),can.country) legislation_CODE
              , NVL(CASE 
                WHEN UPPER(can.COUNTRY) IN('FRANCE','FR')
				THEN
                   '176742549'
                WHEN Upper(can.COUNTRY) IN ('SPAIN','ES')
                THEN
                '914148667'
			    WHEN UPPER(can.COUNTRY) IN ('PHILIPPINES','TRINIDAD AND TOBAGO','ITALY','PAKISTAN','CHINA','PH','TURKEY'
				                       ,'BRITISH INDIAN OCEAN TERRITORY','MEXICO','EGYPT','UNITED KINGDOM','UNITED_KINGDOM','GREECE'
									   ,'JAPAN','NIGERIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10)
                WHEN UPPER(can.COUNTRY) IN ('IN','INDIA')
                THEN nvl(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),'2066380800')
				WHEN UPPER(can.COUNTRY) IN('CANADA','UNITED STATES','UNITED_STATES','DOMINICA','BARBADOS')
				THEN SUBSTR(SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-10),4)
				WHEN UPPER(can.COUNTRY) IN('BELIZE','GAMBIA','AZERBAIJAN','BERMUDA','BAHAMAS','DENMARK','CAYMAN_ISLANDS'
				                      ,'CAYMAN ISLANDS','SAINT LUCIA','JAMAICA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-7)
				WHEN UPPER(can.COUNTRY) IN ('MALAWI','SOUTH AFRICA','SOUTH_AFRICA','TAIWAN','ALBANIA','LUXEMBOURG','ZIMBABWE','NEW ZEALAND'
				                       ,'UNITED ARAB EMIRATES','UKRAINE','SAUDI ARABIA','SAUDI_ARABIA','SERBIA','IE','BELGIUM','POLAND','SWITZERLAND'
									   ,'SLOVAKIA','MOROCCO','SRI LANKA','IRELAND','BRAZIL','BULGARIA','PORTUGAL','VIETNAM','ROMANIA','THAILAND'
									   ,'TANZANIA','HUNGARY','NETHERLANDS','SWEDEN','ZAMBIA','SOMALIA','MALAYSIA','AUSTRALIA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-9)
				WHEN UPPER(can.COUNTRY) IN ('SINGAPORE','OMAN','HONDURAS','TUNISIA','URUGUAY','GERMANY','LEBANON','COSTA_RICA','LITHUANIA'
				                       ,'KUWAIT','LATVIA','BAHRAIN','HONG KONG','QATAR','NORWAY','FINLAND','BOSNIA AND HERZEGOVINA','MALTA'
									   ,'MAURITIUS','CYPRUS','COSTA RICA')
                THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-8)
				WHEN UPPER(can.COUNTRY) IN('RUSSIAN FEDERATION','BANGLADESH','ARGENTINA')
				THEN SUBSTR(REGEXP_REPLACE(NVL(MOBILE,HOMEPHONE),'[^0-9]',''),-11)
                ELSE  nvl(mobile,homephone)
                END, nvl(mobile,homephone)) PHONE_NUMBER,
                CASE
                  WHEN can.status = 'New'   THEN  'NOT_CONTACTED'
                  WHEN can.status = 'Application Reviewed'   THEN  'REVIEWED'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'ENGAGED'
                  WHEN can.status = 'Internal Screening Form'   THEN  'ENGAGED'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'ENGAGED'
                  WHEN can.status = 'Phone Screen'   THEN  'ENGAGED'
                  WHEN can.status = 'Screened by TA'   THEN  'REVIEWED'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  'REVIEWED'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'ENGAGED'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'ENGAGED'
                  WHEN can.status = 'Schedule Interview'   THEN  'ENGAGED'
                  WHEN can.status = 'First Interview'   THEN  'ENGAGED'
                  WHEN can.status = 'Second Interview'   THEN  'ENGAGED'
                  WHEN can.status = 'Additional Interview'   THEN  'ENGAGED'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'INTERVIEW_AND_SELECTION'
                  WHEN can.status = 'Offer Approved' THEN 'OFFER'
                  WHEN can.status = 'Offer Rejected' THEN 'OFFER'
                  WHEN can.status = 'Rejected' THEN 'ENGAGED'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_PHASE_CODE,
                CASE
                  WHEN can.status = 'New'   THEN  'NEW'
                  WHEN can.status = 'Application Reviewed'   THEN  'NEEDS_ATTENTION'
                  WHEN can.status = 'Internal Screen Requested'   THEN  'NEEDS_ATTENTION'
                  WHEN can.status = 'Internal Screening Form'   THEN  'NEEDS_ATTENTION'
                  WHEN can.status = 'Phone Screen Requested'   THEN  'CONTACTED'
                  WHEN can.status = 'Phone Screen'   THEN  'CONTACTED'
                  WHEN can.status = 'Screened by TA'   THEN  'MEETS_QUALIFICATIONS'
                  WHEN trim(can.status) = 'Submitted to Hiring Manager'   THEN  'NEEDS_ATTENTION'
                  WHEN can.status = 'Accepted by Hiring Manager'   THEN  'INTERESTED'
                  WHEN can.status = 'Rejected by Hiring Manager'   THEN  'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Schedule Interview'   THEN  'INTERESTED'
                  WHEN can.status = 'First Interview'   THEN  'CONTACTED'
                  WHEN can.status = 'Second Interview'   THEN  'CONTACTED'
                  WHEN can.status = 'Additional Interview'   THEN  'CONTACTED'
                  WHEN can.status = 'Offer Pending Approval'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Extended'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Verbal Offer Accepted'   THEN  'SELECTED_FOR_OFFER'
                  WHEN can.status = 'Offer Approved' THEN 'APPROVED'
                  WHEN can.status = 'Offer Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'Rejected' THEN 'REJECTED_BY_EMPLOYER'
                  WHEN can.status = 'HRIS Sync Completed' THEN 'HRIS_SYNC_COMPLETED'
                END CURRENT_STATE_CODE,
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency Name',
               'Employee Referral','Employee Referral',
               'Recruiter','Jobvite Career Site',
               (SELECT FUSION_SOURCE 
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                 WHERE JOBVITE_SOURCE = CAN.SOURCE))         SOURCE,             
               decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT FUSION_SOURCE_MEDIUM FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_MEDIUM,
                decode(INITCAP(nvl(SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1),source)),
               'Agency','Referred by Agency',
               'Employee Referral','Jobvite Referral',
                'Recruiter','Jobvite Career Site',
                (SELECT decode(FUSION_SOURCE_MEDIUM, 
                              'Agency','Referred by Agency',
                              'Employee Referral','Jobvite Referral',FUSION_SOURCE_MEDIUM)
                  FROM XXMX_JOBVITE_SOURCE_MEDIUM_STG 
                  WHERE JOBVITE_SOURCE = CAN.SOURCE)) SOURCE_medium_canextra
                --SUBSTR(SOURCE,1,INSTR(SOURCE,':',1,1)-1)
               -- 'Agency' SOURCE_MEDIUM
                ,TRIM(SUBSTR(SOURCE,INSTR(SOURCE,':',1,1)+1)) notes
                ,can.OFFERLETTER
                ,can.ORIGINALDOCUMENT ,can.coverletterfile,can.status
	       FROM xxmx_jobvite_candidates_stg can,
                xxmx_jobvite_requisition_stg req
            --    hr_locations_all@xxmx_extract hrl
         where can.requisitionid = req.requisitionid(+) 
        --   and hrl.country = substr(location,1,2)
        --   and inactive_date is null
        --   and trunc(hrl.last_update_date) = (select trunc(max(last_update_date))
        --                                   from hr_locations_all@xxmx_extract mhrl 
        --                                    where mhrl.country=hrl.country 
        --                                    and inactive_date is null)
      --      AND submitted = (select max(submitted) from XXMX_JOBVITE_CANDIDATES_STG
      --                       c where c.email = can.email )
        AND TRUNC(TO_DATE(submitted,'MM/DD/RRRR HH24:MI')) 
            BETWEEN  TRUNC(TO_DATE('03/31/2022','MM/DD/RRRR')) 
            AND TRUNC(TO_DATE('04/01/2023','MM/DD/RRRR'))
         AND CAN.requisitionid not like 'IRC%';


  TYPE CANDIDATE_DATA_REC IS TABLE OF CANDIDATE_DATA_CUR%ROWTYPE INDEX BY PLS_INTEGER;
  CANDIDATE_TBL    CANDIDATE_DATA_REC;

  TYPE CANDIDATE_DATA_REC1 IS TABLE OF get_all_open_requisitions_data%ROWTYPE INDEX BY PLS_INTEGER;
  CANDIDATE_TBL1    CANDIDATE_DATA_REC1;

    TYPE CANDIDATE_DATA_REC2 IS TABLE OF get_all_candidate_pool_recs%ROWTYPE INDEX BY PLS_INTEGER;
  CANDIDATE_TBL2    CANDIDATE_DATA_REC2;

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
                                          , MIGRATION_status
                                          , METADATA
                                          , OBJECTNAME
                                          , CANDIDATE_NUMBER
										  , REQUISITION_NUMBER
                                          , OBJECT_status
										  , AVAILABILITY_DATE
										  , START_DATE
										  , CONFIRMED_FLAG
										  , CAND_PREF_LANGUAGE_CODE
                                          , CURRENT_PHASE_CODE
                                          , CURRENT_STATE_CODE 
                                          , SOURCE
                                          , SOURCE_MEDIUM ,notes 
                                          , OFFERLETTER
                                          , ORIGINALDOCUMENT,coverletterfile,attribute1 )
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
                                          , CANDIDATE_TBL(CAND).SOURCE_medium_canextra
                                          ,CANDIDATE_TBL(CAND).NOTES
                                          ,CANDIDATE_TBL(CAND).OFFERLETTER
                                          ,CANDIDATE_TBL(CAND).ORIGINALDOCUMENT
                                          ,CANDIDATE_TBL(CAND).coverletterfile
                                          ,CANDIDATE_TBL(CAND).candid
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


    OPEN get_all_open_requisitions_data;
     FETCH get_all_open_requisitions_data BULK COLLECT INTO CANDIDATE_TBL1;-- LIMIT JOB_VITE_DATA_LIMIT;

     --EXIT WHEN CANDIDATE_TBL.COUNT = 0;
       FORALL CAND1 IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_XFM( MIGRATION_SET_ID
                                          , MIGRATION_SET_NAME
                                          , MIGRATION_status
                                          , METADATA
                                          , OBJECTNAME
                                          , CANDIDATE_NUMBER
										  , REQUISITION_NUMBER
                                          , OBJECT_status
										  , AVAILABILITY_DATE
										  , START_DATE
										  , CONFIRMED_FLAG
										  , CAND_PREF_LANGUAGE_CODE
                                          , CURRENT_PHASE_CODE
                                          , CURRENT_STATE_CODE 
                                          , SOURCE
                                          , SOURCE_MEDIUM ,notes 
                                          , OFFERLETTER
                                          , ORIGINALDOCUMENT,coverletterfile,attribute1 )
                                     VALUES ( l_migration_set_id
									      , l_migration_set_name
										  , l_migration_status
										  , l_metadata
										  , 'CANDIDATE'
									      , CANDIDATE_TBL1(CAND1).CANDIDATEID
										  , CANDIDATE_TBL1(CAND1).REQUISITIONID
                                          , 'ACTIVE'
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CAND1).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD HH24:MI:SS')
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CAND1).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                          , 'Y'
                                          , 'US'
										  , CANDIDATE_TBL1(CAND1).CURRENT_PHASE_CODE
										  , CANDIDATE_TBL1(CAND1).CURRENT_STATE_CODE
                                          , CANDIDATE_TBL1(CAND1).SOURCE
                                          , CANDIDATE_TBL1(CAND1).SOURCE_medium_canextra
                                          ,CANDIDATE_TBL1(CAND1).NOTES
                                          ,CANDIDATE_TBL1(CAND1).OFFERLETTER
                                          ,CANDIDATE_TBL1(CAND1).ORIGINALDOCUMENT
                                          ,CANDIDATE_TBL1(CAND1).coverletterfile
                                          ,CANDIDATE_TBL1(CAND1).candid
                                          );

       FORALL CMAIL IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_EMAIL_XFM( CANDIDATE_NUMBER
                                                , DATE_FROM 
												, EMAIL_ADDRESS
												, EMAIL_TYPE)
                                         VALUES ( CANDIDATE_TBL1(CMAIL).CANDIDATEID
                                                , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CMAIL).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
												, CANDIDATE_TBL1(CMAIL).EMAIL
												, 'H1' );

	   FORALL CNAME IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_NAME_XFM( CANDIDATE_NUMBER 
                                               , EFFECTIVE_START_DATE
                                               , FIRST_NAME
                                               , LAST_NAME )
                                          VALUES ( CANDIDATE_TBL1(CNAME).CANDIDATEID
                                               , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CNAME).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               , CANDIDATE_TBL1(CNAME).FIRSTNAME
                                               , CANDIDATE_TBL1(CNAME).LASTNAME	 ); 

       FORALL CADD IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ADDRESS_XFM( CANDIDATE_NUMBER 
                                               , ADDRESS_LINE_1
											   , TOWN_OR_CITY
											   , COUNTRY
                                               , POSTAL_CODE
                                               , EFFECTIVE_START_DATE )
                                          VALUES ( CANDIDATE_TBL1(CADD).CANDIDATEID
                                               , CANDIDATE_TBL1(CADD).ADDRESS
											   , CANDIDATE_TBL1(CADD).CITY
											   , CANDIDATE_TBL1(CADD).COUNTRY
                                               , CANDIDATE_TBL1(CADD).POSTALCODE 
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CADD).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
											   ); 

       FORALL CPHN IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_PHONE_XFM( CANDIDATE_NUMBER 
                                                  , COUNTRY_CODE_NUMBER
												  , AREA_CODE
                                                  , PHONE_NUMBER
												  , PHONE_TYPE
												  , DATE_FROM,legislation_CODE  )
                                          VALUES ( CANDIDATE_TBL1(CPHN).CANDIDATEID
										       , CANDIDATE_TBL1(CPHN).COUNTRY_CODE
											   , CANDIDATE_TBL1(CPHN).AREA_CODE
                                               , CANDIDATE_TBL1(CPHN).PHONE_NUMBER
											   , 'H1'
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL1(CPHN).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               ,CANDIDATE_TBL1(CPHN).legislation_CODE
											   ); 

      FORALL CATT IN 1..CANDIDATE_TBL1.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ATTMT_XFM( CANDIDATE_NUMBER 
                                                , TITLE
                                                , URL_OR_FILENAME)
                                          VALUES ( CANDIDATE_TBL1(CATT).CANDIDATEID
                                               , CANDIDATE_TBL1(CATT).ORIGINALDOCUMENT
											   , NULL); 
    COMMIT;

   CLOSE get_all_open_requisitions_data;

    OPEN get_all_candidate_pool_recs;
     FETCH get_all_candidate_pool_recs BULK COLLECT INTO CANDIDATE_TBL2;-- LIMIT JOB_VITE_DATA_LIMIT;

     --EXIT WHEN CANDIDATE_TBL2.COUNT = 0;
       FORALL CAND2 IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_XFM( MIGRATION_SET_ID
                                          , MIGRATION_SET_NAME
                                          , MIGRATION_status
                                          , METADATA
                                          , OBJECTNAME
                                          , CANDIDATE_NUMBER
										  , REQUISITION_NUMBER
                                          , OBJECT_status
										  , AVAILABILITY_DATE
										  , START_DATE
										  , CONFIRMED_FLAG
										  , CAND_PREF_LANGUAGE_CODE
                                          , CURRENT_PHASE_CODE
                                          , CURRENT_STATE_CODE 
                                          , SOURCE
                                          , SOURCE_MEDIUM ,notes 
                                          , OFFERLETTER
                                          , ORIGINALDOCUMENT,coverletterfile,attribute1 )
                                     VALUES ( l_migration_set_id
									      , l_migration_set_name
										  , l_migration_status
										  , l_metadata
										  , 'CANDIDATE'
									      , CANDIDATE_TBL2(CAND2).CANDIDATEID
										  , CANDIDATE_TBL2(CAND2).REQUISITIONID
                                          , 'ACTIVE'
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CAND2).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD HH24:MI:SS')
                                          , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CAND2).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                          , 'Y'
                                          , 'US'
										  , CANDIDATE_TBL2(CAND2).CURRENT_PHASE_CODE
										  , CANDIDATE_TBL2(CAND2).CURRENT_STATE_CODE
                                          , CANDIDATE_TBL2(CAND2).SOURCE
                                          , CANDIDATE_TBL2(CAND2).SOURCE_medium_canextra
                                          ,CANDIDATE_TBL2(CAND2).NOTES
                                          ,CANDIDATE_TBL2(CAND2).OFFERLETTER
                                          ,CANDIDATE_TBL2(CAND2).ORIGINALDOCUMENT
                                          ,CANDIDATE_TBL2(CAND2).coverletterfile
                                          ,CANDIDATE_TBL2(CAND2).candid
                                          );

       FORALL CMAIL IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_EMAIL_XFM( CANDIDATE_NUMBER
                                                , DATE_FROM 
												, EMAIL_ADDRESS
												, EMAIL_TYPE)
                                         VALUES ( CANDIDATE_TBL2(CMAIL).CANDIDATEID
                                                , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CMAIL).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
												, CANDIDATE_TBL2(CMAIL).EMAIL
												, 'H1' );

	   FORALL CNAME IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_NAME_XFM( CANDIDATE_NUMBER 
                                               , EFFECTIVE_START_DATE
                                               , FIRST_NAME
                                               , LAST_NAME )
                                          VALUES ( CANDIDATE_TBL2(CNAME).CANDIDATEID
                                               , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CNAME).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               , CANDIDATE_TBL2(CNAME).FIRSTNAME
                                               , CANDIDATE_TBL2(CNAME).LASTNAME	 ); 

       FORALL CADD IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ADDRESS_XFM( CANDIDATE_NUMBER 
                                               , ADDRESS_LINE_1
											   , TOWN_OR_CITY
											   , COUNTRY
                                               , POSTAL_CODE
                                               , EFFECTIVE_START_DATE )
                                          VALUES ( CANDIDATE_TBL2(CADD).CANDIDATEID
                                               , CANDIDATE_TBL2(CADD).ADDRESS
											   , CANDIDATE_TBL2(CADD).CITY
											   , CANDIDATE_TBL2(CADD).COUNTRY
                                               , CANDIDATE_TBL2(CADD).POSTALCODE 
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CADD).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
											   ); 

       FORALL CPHN IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_PHONE_XFM( CANDIDATE_NUMBER 
                                                  , COUNTRY_CODE_NUMBER
												  , AREA_CODE
                                                  , PHONE_NUMBER
												  , PHONE_TYPE
												  , DATE_FROM,legislation_CODE  )
                                          VALUES ( CANDIDATE_TBL2(CPHN).CANDIDATEID
										       , CANDIDATE_TBL2(CPHN).COUNTRY_CODE
											   , CANDIDATE_TBL2(CPHN).AREA_CODE
                                               , CANDIDATE_TBL2(CPHN).PHONE_NUMBER
											   , 'H1'
											   , TO_CHAR(TO_DATE(CANDIDATE_TBL2(CPHN).SUBMITTED,'MM/DD/YYYY HH24:MI'),'YYYY/MM/DD')
                                               ,CANDIDATE_TBL2(CPHN).legislation_CODE
											   ); 

      FORALL CATT IN 1..CANDIDATE_TBL2.COUNT
         INSERT INTO XXMX_HCM_IREC_CAN_ATTMT_XFM( CANDIDATE_NUMBER 
                                                , TITLE
                                                , URL_OR_FILENAME)
                                          VALUES ( CANDIDATE_TBL2(CATT).CANDIDATEID
                                               , CANDIDATE_TBL2(CATT).ORIGINALDOCUMENT
											   , NULL); 
    COMMIT;

   CLOSE get_all_candidate_pool_recs;
END XXMX_IREC_CANDIDATE_XFM_LOAD_PRC;

/
