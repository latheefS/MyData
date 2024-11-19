--****************************************--
---TRANSFORMATION---
----------------------------
-- NOTE --  Make sure to Execute below updates before below Procedures Execute.
--****************************************--
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'’','''');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'–','-');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'?','?');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'“','"');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'”','"');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'o   ','o ');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'o   ','o ');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'·','•');
UPDATE xxmx_per_goal_stg SET DETAIL = REPLACE(DETAIL,'…','...');


UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(success_criteria,'’','''');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(success_criteria,'–','-');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(success_criteria,'?','?');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'“','"');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'”','"');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'o   ','o ');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'o   ','o ');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'·','•');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'…','...');
UPDATE xxmx_per_goal_stg SET SUCCESS_CRITERIA = REPLACE(SUCCESS_CRITERIA,'       ',' ');

UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'’','''');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'–','-');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'?','?');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'“','"');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'”','"');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'o   ','o ');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'o   ','o ');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'·','•');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'…','...');
UPDATE xxmx_per_goal_stg SET COMMENTS = REPLACE(COMMENTS,'       ',' ');

--=========================================================================================

-- DETAIL (DESCRIPTION)
DECLARE
  CURSOR C1 IS 
     SELECT PERSONNUMBER,name_1,NAME_1||'_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,name_1) FILE_NAME
          , REPLACE(NAME,'''','''''') NAME,REPLACE(DETAIL,'''','''''') DETAIL
       FROM (SELECT UNIQUE personnumber,name,SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25) name_1,DETAIL
               FROM xxmx_per_goal_xfm where personnumber='10007'
			   );
			   
		v_spool VARCHAR2(500) := 'spool P:\VDI_profile\VaKrishna\Desktop\prod\Goals\ClobFiles\';
		--V_VAL1 VARCHAR2(2000);
		
BEGIN
     DBMS_OUTPUT.PUT_LINE('SET DEFINE OFF;');
     DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
     DBMS_OUTPUT.PUT_LINE('SET HEADING OFF;');
     FOR I IN C1
	 LOOP
       dbms_output.enable(NULL);
	   DBMS_OUTPUT.PUT_LINE(v_spool||I.PERSONNUMBER||'_'||I.FILE_NAME||'.html');
	   DBMS_OUTPUT.PUT_LINE('SELECT ''<HTML>''||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(regexp_replace(DETAIL, ''[^[:print:]]'', ''<br>''),''•'',''&bull;''),''Æ'',''&AElig;''),''®'',''&reg;''),''£'',''&pound;'')
	                                       ,''Ø'',''&empty;''),''©'',''&copy;''),''>'',''&gt;''),''<br&gt;'',''<br>'')||''</HTML>''
               FROM xxmx_per_goal_xfm where personnumber='''||I.PERSONNUMBER||''' AND NAME ='''||I.NAME||''';');
       DBMS_OUTPUT.PUT_LINE('spool off;');
	 END LOOP;
END;
/
--======================================================================================================
--SUCCESS_CRITERIA
DECLARE
  CURSOR C1 IS 
     SELECT PERSONNUMBER,name_1,NAME_1||'_SC_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,name_1) FILE_NAME
          , REPLACE(NAME,'''','''''') NAME,REPLACE(SUCCESS_CRITERIA,'''','''''') SUCCESS_CRITERIA
       FROM (SELECT personnumber,name,SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25) name_1,SUCCESS_CRITERIA
               FROM xxmx_per_goal_xfm 
			   where SUCCESS_CRITERIA IS NOT NULL
			   AND ROWNUM=1
			   );
			   
		v_spool VARCHAR2(50) := 'spool P:\VDI_profile\VaKrishna\Desktop\prod\Goals\ClobFiles\';
		--V_VAL1 VARCHAR2(2000);
		
BEGIN
     DBMS_OUTPUT.PUT_LINE('SET DEFINE OFF;');
     DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
     DBMS_OUTPUT.PUT_LINE('SET HEADING OFF;');
     FOR I IN C1
	 LOOP
       dbms_output.enable(NULL);
	   DBMS_OUTPUT.PUT_LINE(v_spool||I.PERSONNUMBER||'_'||I.FILE_NAME||'.html');
	   DBMS_OUTPUT.PUT_LINE('SELECT ''<HTML>''||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(regexp_replace(SUCCESS_CRITERIA, ''[^[:print:]]'', ''<br>''),''•'',''&bull;''),''Æ'',''&AElig;''),''®'',''&reg;''),''£'',''&pound;'')
	                                       ,''Ø'',''&empty;''),''©'',''&copy;''),''>'',''&gt;''),''<br&gt;'',''<br>'')||''</HTML>''
               FROM xxmx_per_goal_xfm where personnumber='''||I.PERSONNUMBER||''' AND NAME ='''||I.NAME||''';');
       DBMS_OUTPUT.PUT_LINE('spool off;');
	 END LOOP;
END;
/
--======================================================================================================
--COMMENTS
DECLARE
  CURSOR C1 IS 
     SELECT PERSONNUMBER,name_1,NAME_1||'_CMT_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,name_1) FILE_NAME
          , REPLACE(NAME,'''','''''') NAME,REPLACE(COMMENTS,'''','''''') COMMENTS
       FROM (SELECT personnumber,name,SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25) name_1,COMMENTS
               FROM xxmx_per_goal_xfm 
			   where COMMENTS IS NOT NULL
			   AND ROWNUM=1
			   );
			   
		v_spool VARCHAR2(50) := 'spool P:\VDI_profile\VaKrishna\Desktop\DRYRUN_Spools\';
		--V_VAL1 VARCHAR2(2000);
		
BEGIN
     DBMS_OUTPUT.PUT_LINE('SET DEFINE OFF;');
     DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
     DBMS_OUTPUT.PUT_LINE('SET HEADING OFF;');
     FOR I IN C1
	 LOOP
       dbms_output.enable(NULL);
	   DBMS_OUTPUT.PUT_LINE(v_spool||I.PERSONNUMBER||'_'||I.FILE_NAME||'.html');
	   DBMS_OUTPUT.PUT_LINE('SELECT ''<HTML>''||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(regexp_replace(COMMENTS, ''[^[:print:]]'', ''<br>''),''•'',''&bull;''),''Æ'',''&AElig;''),''®'',''&reg;''),''£'',''&pound;'')
	                                       ,''Ø'',''&empty;''),''©'',''&copy;''),''>'',''&gt;''),''<br&gt;'',''<br>'')||''</HTML>''
               FROM xxmx_per_goal_xfm where personnumber='''||I.PERSONNUMBER||''' AND NAME ='''||I.NAME||''';');
       DBMS_OUTPUT.PUT_LINE('spool off;');
	 END LOOP;
END;
/