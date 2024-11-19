--------------------------------------------------------
--  DDL for View XXMX_PPM_PROJECTS_BATCH_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PROJECTS_BATCH_V" ("MIN_PROJECT_NAME", "MAX_PROJECT_NAME", "BU", "PROJECT_COUNT") AS 
  SELECT
        MIN(project_name)                    min_project_name,
        MAX(project_name)                    max_project_name,
        substr(source_template_number, 5, 6) bu,
        COUNT(*)                             project_count
    FROM
        xxmx_ppm_projects_xfm
    where organization_name in (
    'Citco (Bahamas) Limited - Funds',
'Citco (Bahamas) Limited - Governance',
'Citco Custody (UK) Limited',
'Citco Deutschland GmbH',
'Citco Financial Products (London) Limited',
'Citco Fund Services (Europe) B.V.',
'Citco Fund Services (Guernsey) Limited',
'Citco Fund Services (Singapore) Pte. Ltd.'	
    )
    GROUP BY
        substr(source_template_number, 5, 6)
;
