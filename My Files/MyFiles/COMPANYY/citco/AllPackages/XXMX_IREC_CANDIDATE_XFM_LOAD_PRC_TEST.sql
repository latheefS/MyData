--------------------------------------------------------
--  DDL for Procedure XXMX_IREC_CANDIDATE_XFM_LOAD_PRC_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_IREC_CANDIDATE_XFM_LOAD_PRC_TEST" 
AS
  CURSOR CANDIDATE_DATA_CUR 
     IS  SELECT EMAIL
	       FROM XXMX_JOBVITE_CANDIDATES_STG CAN;
		  --WHERE REQUISITIONID IN('IRC46565','IRC31766');

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
                                          , CANDIDATE_NUMBER )
                                     VALUES ( l_migration_set_id
									      , l_migration_set_name
										  , l_migration_status
										  , l_metadata
										  , 'CANDIDATE'
									      , CANDIDATE_TBL(CAND).CANDIDATEID);


    COMMIT;

   CLOSE CANDIDATE_DATA_CUR;
END XXMX_IREC_CANDIDATE_XFM_LOAD_PRC_TEST;

/
