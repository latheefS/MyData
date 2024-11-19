--------------------------------------------------------
--  DDL for View XXMX_PPM_ALLCOST_BATCH_ORG_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_ALLCOST_BATCH_ORG_V" ("BU_NAME", "BATCHNAME", "BU_ID") AS 
  select distinct  b."BU_NAME",b."BATCHNAME",f.bu_id
        from (
            select distinct  b.business_unit bu_name, b.exp_batch_name batchname
            from  XXMX_PPM_prj_LBRCOST_xfm  b 
                    where 1=1 --b.attribute3 is not null
                 --   and b.project_number =  a.project_number
            union 
             select distinct   b.business_unit bu_name, b.exp_batch_name batchname
            from  XXMX_PPM_prj_miscCOST_xfm  b 
                    where 1=1 --b.attribute3 is not null
                   -- and b.project_number =  a.project_number
    /*        union
              select distinct organization_name, attribute10 from XXMX_PPM_prj_BILLEVENT_xfm where attribute6 is not null
    union
    select distinct organization_name, attribute10 from XXMX_PPM_prj_BILLEVENT_xfm where attribute6 is not null*/
    ) b, xxmx_dm_fusion_das f
    where b.bu_name =  f.bu_name
;
