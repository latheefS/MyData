
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_JOBREQ_UNPOST_HDL_V" ("COL1_HEADER") AS 
  SELECT 'METADATA|JobRequisition|RequisitionNumber|CurrentPhaseCode|CurrentStateCode|BaseLanguageCode' METADATA from dual;
UNION ALL
SELECT UNIQUE 'MERGE|JobRequisition|'||REQUISITION_NUMBER||'|REQUISITION_OPEN|REQUISITION_UNPOSTED|US'
FROM XXMX_HCM_IREC_JOB_REQ_XFM;


  GRANT SELECT ON "XXMX_CORE"."XXMX_JOBREQ_UNPOST_HDL_V" TO "XXMX_READONLY";
