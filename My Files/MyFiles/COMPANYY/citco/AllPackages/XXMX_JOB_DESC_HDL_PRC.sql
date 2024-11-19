--------------------------------------------------------
--  DDL for Procedure XXMX_JOB_DESC_HDL_PRC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_JOB_DESC_HDL_PRC" 
AS
    JV_TP_HEADER   VARCHAR2(10000) := 'METADATA|TalentProfile|ProfileCode|Summary|Description|ProfileTypeCode|ProfileStatusCode|ProfileUsageCode|SourceSystemOwner|SourceSystemId';
	JV_PR_HEADER   VARCHAR2(10000) := 'METADATA|ProfileRelation|ProfileCode|RelationCode|BusinessUnitName|PositionCode|ObjectEffectiveStartDate|SourceSystemOwner|SourceSystemId';
    JV_MP_HEADER   VARCHAR2(10000) := 'METADATA|ModelProfileExtraInfo|ProfileCode|Description|Responsibilities|Qualifications|SourceSystemOwner|SourceSystemId';
    pv_i_file_name VARCHAR2(100) := 'JobDesc_TalentProfile.dat';
BEGIN
   DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

      -- TalentProfile
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', JV_TP_HEADER);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'JobVite_JobDescriptions'
			   , 'MERGE|TalentProfile|'||STG.PROFILE_CODE||'|About the Team & Business Line: Fund Administration is Citco’s core business, and our alternative asset and accounting service is one of the industry’s most respected. Our continuous investment in learning and technology solutions means our people are equipped to deliver a seamless client experience. As a core member of our Fund Accounting team, you will be working with some of the industry’s most accomplished professionals to deliver award-winning services for complex fund structures that our clients can depend upon.|'||STG.DESCRIPTION||'|POSITION|A|M|EBS|TP-'||PROFILE_CODE
FROM XXMX_JOBVITE_JOB_DESC_STG STG;

      -- ProfileRelation
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', JV_PR_HEADER);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'JobVite_JobDescriptions'
			   , 'MERGE|ProfileRelation|'||STG.PROFILE_CODE||'|POSITION|'||SUBSTR(STG.PROFILE_CODE,1,6)||'|'||STG.PROFILE_CODE||'|2020/01/01|EBS|PR-'||STG.PROFILE_CODE
FROM XXMX_JOBVITE_JOB_DESC_STG STG;

      -- ModelProfileExtraInfo
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', JV_MP_HEADER);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'JobVite_JobDescriptions'
			   , 'MERGE|ModelProfileExtraInfo|'||STG.PROFILE_CODE||'|'||STG.POSITION_DESCRIPTION||'.html|'||STG.POSITION_RESPONSIBILITY||'.html|'||POSITION_QUALIFICATION||'.html|EBS|MP-'||STG.PROFILE_CODE
FROM XXMX_JOBVITE_JOB_DESC_STG STG;
commit;
end;

/
