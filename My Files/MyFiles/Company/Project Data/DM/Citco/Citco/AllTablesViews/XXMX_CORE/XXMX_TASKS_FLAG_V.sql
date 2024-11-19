--------------------------------------------------------
--  DDL for View XXMX_TASKS_FLAG_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_TASKS_FLAG_V" ("OU", "TEMPLATE_NUMBER", "PROJECT_NUMBER", "Project Task Number", "Project Chargeable Flag", "Project Billable Flag", "Template Task Number", "Template Chargeable Flag", "Template Billable Flag") AS 
  select 
--SUBSTR(ppa.project_type,1,6) "OU",
--(select segment1 from apps.pa_projects_all@xxmx_extract where project_id = pt1.project_id) "Project Template",
--ppa.segment1 "project Number",
ppa.ou,
ppa.template_number,
ppa.project_number,
pt.task_number "Project Task Number",
pt.chargeable_flag "Project Chargeable Flag",
pt.billable_flag "Project Billable Flag",
pt1.task_number "Template Task Number",
pt1.chargeable_flag"Template Chargeable Flag",
pt1.billable_flag "Template Billable Flag"
from
--apps.pa_projects_all@xxmx_extract ppa,
--apps.pa_tasks@xxmx_extract pt,
xxpa_tasks_Stg pt,
xxmx_ppm_template_task_flags pt1,
XXMX_PPM_PROJ_TEMPLATE_NUMBERS ppa
--apps.pa_tasks@xxmx_extract pt1
where 1=1
--and stg.project_id =  ppa.project_id
and ppa.project_id = pt.project_id
and  pt1.project_id = ppa.created_from_project_id
and pt1.task_number = pt.task_number
and (pt1.chargeable_flag != pt.chargeable_flag or pt1.billable_flag != pt.billable_flag)
--and ppa.project_status_code not in('CLOSED')
and pt.task_number not in ('AEOI1042REPORTING'
,'AEOISTATEMENTS'
,'AGENT-TP'
,'AGMAR-FF'
,'AIFMD-RISK-01'
,'AIFMD-RISK-02'
,'AUDITCOM-FF'
,'AUDITCOM-TP'
,'BANKINVEST-TP'
,'CAPINCRDIV-FF'
,'CCO'
,'CCO_SUPPORT'
,'CERTCONTIN-FF'
,'CERTMEMAA-TP'
,'CERTTAXEXM-FF'
,'CFSSUPPORT-09'
,'CFSSUPPORT-10'
,'CFSSUPPORT-11'
,'CFSSUPPORT-14'
,'CFSSUPPORT-18'
,'CFSSUPPORT-22'
,'CHANGECOMSECR-FF'
,'CHANGESHRLD-FF'
,'COMPVAT-FF'
,'CONTFCBC-FF'
,'CUSTODY-TP'
,'DIRADD-TP'
,'DNBVISIT-FF'
,'FADMIN-03'
,'FADMIN-10'
,'FADMIN-12'
,'FADMIN-26'
,'FADMIN-27'
,'FADMIN-28'
,'FADMIN-37'
,'FAR-FF'
,'FISCREPR-FF'
,'GSTTAX-TP'
,'LEGALAUDIT-FF'
,'MARKET DATA'
,'MSCORDIR-FF'
,'MSDIRPERS-FF'
,'MSHCORDIR-FF'
,'NOTFORNA-FF'
,'PEPBR-FF'
,'PO-FF'
,'PREPSHLDREG-FF'
,'PROVREG-FF'
,'REGISTRATION-TP'
,'RENTELECTR-FF'
,'RESPOFF-FF'
,'RESSHLD-FF'
,'SALE-FF'
,'SHIPDEREG-FF'
,'SOCSEC-FF'
,'STATEFILING-FF'
,'SUBSCRFREV-FF'
,'SWMAINTENANCE-FF'
,'TAXRULEAPPL-TP'
,'TAXRULEEXTENT-FF'
,'TAXRULEEXTENT-TP'
,'TFILEMAIN-02')
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_TASKS_FLAG_V" TO "XXMX_READONLY";
