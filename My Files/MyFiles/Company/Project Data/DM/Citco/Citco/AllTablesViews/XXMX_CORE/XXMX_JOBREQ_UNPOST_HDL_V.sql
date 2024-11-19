--------------------------------------------------------
--  DDL for View XXMX_JOBREQ_UNPOST_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_JOBREQ_UNPOST_HDL_V" ("COL1_HEADER") AS 
  SELECT 'METADATA|JobRequisition|RequisitionNumber|HiringManagerPersonNumber|RecruiterPersonNumber|CurrentPhaseCode|CurrentStateCode|BaseLanguageCode' Col1_Header from dual
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_JOBREQ_UNPOST_HDL_V" TO "XXMX_READONLY";
