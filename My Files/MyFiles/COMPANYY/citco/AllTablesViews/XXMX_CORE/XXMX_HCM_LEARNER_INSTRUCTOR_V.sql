--------------------------------------------------------
--  DDL for View XXMX_HCM_LEARNER_INSTRUCTOR_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_LEARNER_INSTRUCTOR_V" ("METADATA") AS 
  select 'METADATA|InstructorResource|OwnedByPersonNumber|InstructorResourceNumber|PersonNumber' METADATA from dual
 union
 Select distinct 'MERGE|InstructorResource|50|'||instructor_number||'|'||instructor_number from xxmx_olm_class_stg
;
