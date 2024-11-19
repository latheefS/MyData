CREATE OR REPLACE VIEW xxmx_po_open_quantity_v
                          (
                            org_id,
                            procurement_ou,
                            document_num,
                            header_revision_num,
                            line_revision_num,
                            location_revision_num,
                            distribution_revision_num,
                            authorization_status,
                            header_cancel_flag,
                            line_cancel_flag,
                            schedule_cancel_flag,
                            vendor_id,
                            vendor_name,
                            vendor_num,
                            vendor_type,
                            supplier_end_date,
                            req_bu_name,
                            soldto_le_name,
                            billto_bu_name,
                            agent_name,
                            vendor_site_code,
                            po_description,
                            currency_code,
                            po_header_comments,
                            po_line_category,
                            vendor_site_id,
                            line_num,
                            header_close_code,
                            line_close_code,
                            schedule_close_code,
                            shipment_num,
                            distribution_num,
                            po_type,
                            approved_date,
                            approved_year,
                            creation_date,
                            created_year,
                            po_header_id,
                            po_line_id,
                            line_location_id,
                            po_distribution_id,
                            project_id,
                            project_number,
                            project_name,
                            project_description,
                            project_type,
                            project_status,
                            task_id,
                            task_number,
                            task_name,
                            task_description,
                            task_completion_date,
                            expenditure_type,
                            expenditure_organization,
                            expenditure_organization_id,
                            line_type,
                            matching_basis,
                            unit_price,
                            ordered,
                            received,
                            billed,
                            cancelled,
                            open_po,
                            close_po,
                            revised_date,
                            revised_year,
                            change_summary,
                            vendor_enabled_flag,
                            vendor_site_end_date,
                            vendor_site_status,
                            closed_date,
                            po_source
                          )
AS
  SELECT  pha.org_id org_id,
          haou.name procurement_ou,
          pha.segment1 document_num,
          pha.revision_num header_revision_num,
          0 line_revision_num,
          0 location_revision_num,
          0 distribution_revision_num,
          pha.authorization_status,
          pha.cancel_flag Header_Cancel_Flag,
          pla.cancel_flag Line_Cancel_Flag,
          pll.cancel_flag Schedule_Cancel_Flag,
          pha.vendor_id,
          avv.vendor_name vendor_name,
          avv.vendor_number vendor_num,
          avv.vendor_type_disp vendor_type,
          avv.end_date_active Supplier_End_Date,
          /*
          NVL((SELECT hou.name
                FROM  apps.po_distributions_all@MXDM_NVIS_EXTRACT         pda
                     ,apps.po_req_distributions_all@MXDM_NVIS_EXTRACT     prda
                     ,apps.po_requisition_lines_all@MXDM_NVIS_EXTRACT     prla
                     ,apps.po_requisition_headers_all@MXDM_NVIS_EXTRACT   prha
                     ,apps.hr_operating_units@MXDM_NVIS_EXTRACT           hou
                WHERE pha.po_header_id = pda.po_header_id
                AND   pda.req_distribution_id = prda.distribution_id
                AND   prda.requisition_line_id = prla.requisition_line_id
                AND   prla.requisition_header_id = prha.requisition_header_id
                AND   hou.organization_id = prha.org_id
                AND   ROWNUM = 1),haou.name) Req_Bu_Name,
          */
          haou.name Req_Bu_Name,
          (SELECT xep.name
           FROM   apps.hr_operating_units@MXDM_NVIS_EXTRACT hou
                 ,apps.xle_entity_profiles@MXDM_NVIS_EXTRACT xep
           WHERE  xep.legal_entity_id = hou.default_legal_context_id
           AND    hou.organization_id = haou.organization_id) Soldto_Le_Name,
           haou.name Billto_Bu_Name,
          (SELECT lower(ppf.email_address)
           FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf
           WHERE  ppf.person_id = pha.agent_id
           AND    ppf.email_address IS NOT NULL
           AND    ppf.effective_start_date = ( SELECT MAX(effective_start_date)
                                               FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf1
                                               WHERE  ppf1.person_id = ppf.person_id) ) Agent_Name,
          pvs.vendor_site_code vendor_site_code,
          pla.item_description po_description,
          pha.currency_code,
          pha.comments po_header_comments,
          (SELECT mct.Description
           FROM   apps.mtl_categories_tl@MXDM_NVIS_EXTRACT  mct
           WHERE  mct.category_id = pla.category_id) po_line_category,
          pha.vendor_site_id,
          pla.line_num line_num,
          pha.closed_code Header_Close_Code,
          pll.closed_code Line_Close_Code,
          pla.closed_code Schedule_Close_Code,
          pll.shipment_num shipment_num,
          pda.distribution_num distribution_num,
          pha.type_lookup_code po_type,
          pha.approved_date approved_date,
          TO_CHAR(pha.approved_date,'YYYY') approved_year,
          pha.creation_date creation_date,
          TO_CHAR(pha.creation_date,'YYYY') created_year,
          pda.po_header_id po_header_id,
          pda.po_line_id po_line_id,
          pda.line_location_id line_location_id,
          pda.po_distribution_id po_distribution_id,
          pda.project_id,
          (SELECT pa.segment1
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           WHERE  pa.project_id = pda.project_id ) Project_Number,
          (SELECT pa.name
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_name,
          (SELECT pa.DESCRIPTION
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_DESCRIPTION,
          (SELECT pa.PROJECT_TYPE
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_type,
          (SELECT pps.project_status_name
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa,
                  apps.pa_project_statuses@MXDM_NVIS_EXTRACT pps
           WHERE  pa.project_id = pda.project_id
           AND    pa.project_status_code = pps.project_status_code) Project_Status,
          pda.task_id,
          (SELECT pt.task_number
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) Task_Number,
          (SELECT pt.task_name
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) task_name,
          (SELECT pt.DESCRIPTION
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) task_description,
          (SELECT pt.completion_date
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) Task_Completion_date,
          pda.expenditure_type Expenditure_Type,
          (SELECT org.name
           FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org
           WHERE  org.organization_id = pda.expenditure_organization_id ) Expenditure_Organization,
          pda.expenditure_organization_id,
          plt.line_type line_type,
          plt.matching_basis matching_basis,
          pla.unit_price unit_price,
          NVL(pda.quantity_ordered,0) ordered,
          NVL(pda.quantity_delivered,0) received,
          NVL(pda.quantity_billed,0) billed,
          NVL(pda.quantity_cancelled,0) cancelled,
          --(pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) open_po,
          --(NVL(pda.quantity_cancelled, 0) + NVL(pda.quantity_billed, 0)) close_po,
          CASE WHEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) > pda.quantity_ordered
               THEN pda.quantity_ordered
               WHEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) < 0
               THEN 0
               ELSE (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0))
          END open_po,
          CASE WHEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) > pda.quantity_ordered
               THEN 0
               WHEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) < 0
               THEN pda.quantity_ordered
               ELSE NVL(pda.quantity_cancelled, 0) + NVL(pda.quantity_billed, 0)
          END close_po,
          pha.revised_date revised_date,
          to_char(pha.revised_date,'YYYY')  revised_year,
          pha.change_summary                change_summary,
          avv.enabled_flag                  vendor_enabled_flag,
          pvs.inactive_date                 vendor_site_end_date,
          1                     vendor_site_status,
          pha.closed_date,
          'PO_HEADERS_ALL' po_source
     FROM apps.po_headers_all@MXDM_NVIS_EXTRACT pha,
          apps.po_lines_all@MXDM_NVIS_EXTRACT pla,
          apps.po_line_types@MXDM_NVIS_EXTRACT plt,
          apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll,
          apps.po_distributions_all@MXDM_NVIS_EXTRACT pda,
          apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou,
          apps.ap_vendors_v@MXDM_NVIS_EXTRACT avv,
          apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
    WHERE     1 = 1
          --
          AND pha.type_lookup_code = 'STANDARD'
          AND NVL(pha.authorization_status, 'NUL') IN ('PRE-APPROVED', 'APPROVED')
          AND NVL(pha.cancel_flag, 'N') = 'N'
          AND NVL(pha.closed_code, 'OPEN') NOT IN ('CLOSED', 'FINALLY CLOSED')
          --
          AND pha.po_header_id = pda.po_header_id
          AND pda.distribution_type = 'STANDARD'
          --
          AND pla.po_header_id = pha.po_header_id
          AND pla.po_line_id = pda.po_line_id
          AND NVL(pla.cancel_flag,'N') = 'N'
          AND NVL(pla.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
          --
          AND pla.line_type_id = plt.line_type_id
          AND plt.matching_basis = 'QUANTITY'
          --
          AND pla.unit_price != 0
          AND pll.line_location_id = pda.line_location_id
          AND pll.po_line_id = pla.po_line_id
          AND NVL(pll.cancel_flag,'N') = 'N'
          AND NVL(pll.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
          --
          AND haou.organization_id = pha.org_id
          --
          AND avv.vendor_id = pha.vendor_id
          AND NVL(avv.vendor_type_lookup_code, 'VENDOR') != 'EMPLOYEE'
          AND pvs.vendor_site_id = pha.vendor_site_id
          AND NVL(pvs.pay_group_lookup_code, 'VENDOR') != 'EMPLOYEE'
          --
          --AND pha.org_id = 83
    UNION
  SELECT  pha.org_id org_id,
          haou.name procurement_ou,
          pha.segment1 document_num,
          pha.revision_num header_revision_num,
          0 line_revision_num,
          0 location_revision_num,
          0 distribution_revision_num,
          pha.authorization_status,
          pha.cancel_flag Header_Cancel_Flag,
          pla.cancel_flag Line_Cancel_Flag,
          pll.cancel_flag Schedule_Cancel_Flag,
          pha.vendor_id,
          avv.vendor_name vendor_name,
          avv.vendor_number vendor_num,
          avv.vendor_type_disp vendor_type,
          avv.end_date_active Supplier_End_Date,
          /*
          NVL((SELECT hou.name
                FROM  apps.po_distributions_all@MXDM_NVIS_EXTRACT         pda
                     ,apps.po_req_distributions_all@MXDM_NVIS_EXTRACT     prda
                     ,apps.po_requisition_lines_all@MXDM_NVIS_EXTRACT     prla
                     ,apps.po_requisition_headers_all@MXDM_NVIS_EXTRACT   prha
                     ,apps.hr_operating_units@MXDM_NVIS_EXTRACT           hou
                WHERE pha.po_header_id = pda.po_header_id
                AND   pda.req_distribution_id = prda.distribution_id
                AND   prda.requisition_line_id = prla.requisition_line_id
                AND   prla.requisition_header_id = prha.requisition_header_id
                AND   hou.organization_id = prha.org_id
                AND   ROWNUM = 1),haou.name) Req_Bu_Name,
          */
          haou.name Req_Bu_Name,
          (SELECT xep.name
           FROM   apps.hr_operating_units@MXDM_NVIS_EXTRACT hou
                 ,apps.xle_entity_profiles@MXDM_NVIS_EXTRACT xep
           WHERE  xep.legal_entity_id = hou.default_legal_context_id
           AND    hou.organization_id = haou.organization_id) Soldto_Le_Name,
          haou.name Billto_Bu_Name,
          (SELECT lower(ppf.email_address)
           FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf
           WHERE  ppf.person_id = pha.agent_id
           AND    ppf.email_address IS NOT NULL
           AND    ppf.effective_start_date = ( SELECT MAX(effective_start_date)
                                               FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf1
                                               WHERE  ppf1.person_id = ppf.person_id) ) Agent_Name,
          pvs.vendor_site_code vendor_site_code,
          pla.item_description po_description,
          pha.currency_code,
          pha.comments po_header_comments,
          (SELECT mct.Description
           FROM   apps.mtl_categories_tl@MXDM_NVIS_EXTRACT  mct
           WHERE  mct.category_id = pla.category_id) po_line_category,
          pha.vendor_site_id,
          pla.line_num line_num,
          pha.closed_code Header_Close_Code,
          pll.closed_code Line_Close_Code,
          pla.closed_code Schedule_Close_Code,
          pll.shipment_num shipment_num,
          pda.distribution_num distribution_num,
          pha.type_lookup_code po_type,
          pha.approved_date approved_date,
          TO_CHAR(pha.approved_date,'YYYY') approved_year,
          pha.creation_date creation_date,
          TO_CHAR(pha.creation_date,'YYYY') created_year,
          pda.po_header_id po_header_id,
          pda.po_line_id po_line_id,
          pda.line_location_id line_location_id,
          pda.po_distribution_id po_distribution_id,
          pda.project_id,
          (SELECT pa.segment1
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           WHERE  pa.project_id = pda.project_id ) Project_Number,
          (SELECT pa.name
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_name,
          (SELECT pa.description
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_DESCRIPTION,
          (SELECT pa.project_type
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa
           where  pa.project_id = pda.project_id)   project_type,
          (SELECT pps.project_status_name
           FROM   apps.pa_projects_all@MXDM_NVIS_EXTRACT pa,
                  apps.pa_project_statuses@MXDM_NVIS_EXTRACT pps
           WHERE  pa.project_id = pda.project_id
           AND    pa.project_status_code = pps.project_status_code) Project_Status,
          pda.task_id,
          (SELECT pt.task_number
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) Task_Number,
          (SELECT pt.TASK_NAME
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) TASK_NAME,
          (SELECT pt.DESCRIPTION
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) TASK_DESCRIPTION,
          (SELECT pt.completion_date
           FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT pt
           WHERE  pt.task_id = pda.task_id ) Task_Completion_date,
          pda.expenditure_type Expenditure_Type,
          (SELECT org.name
           FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org
           WHERE  org.organization_id = pda.expenditure_organization_id ) Expenditure_Organization,
          pda.expenditure_organization_id,
          plt.line_type line_type,
          plt.matching_basis matching_basis,
          pla.unit_price unit_price,
          NVL(pda.amount_ordered, 0) ordered,
          NVL(pda.amount_delivered, 0) received,
          NVL(pda.amount_billed, 0) billed,
          NVL(pda.amount_cancelled, 0) cancelled,
          --(NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0)) open_po,
          --(NVL(pda.amount_cancelled, 0) + NVL(pda.amount_billed, 0)) close_po,
          CASE WHEN (pda.amount_ordered - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0)) > pda.amount_ordered
               THEN pda.amount_ordered
               WHEN (pda.amount_ordered - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0)) < 0
               THEN 0
               ELSE (pda.amount_ordered - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
          END open_po,
          CASE WHEN (pda.amount_ordered - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0)) > pda.amount_ordered
               THEN 0
               WHEN (pda.amount_ordered - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0)) < 0
               THEN pda.amount_ordered
               ELSE NVL(pda.amount_cancelled, 0) + NVL(pda.amount_billed, 0)
          END close_po,
          pha.revised_date revised_date,
          to_char(pha.revised_date,'YYYY')  revised_year,
          pha.change_summary                change_summary,
          avv.enabled_flag                  vendor_enabled_flag,
          pvs.inactive_date                 vendor_site_end_date,
          1                     vendor_site_status,
          pha.closed_date,
         'PO_HEADERS_ALL' po_source
     FROM apps.po_headers_all@MXDM_NVIS_EXTRACT pha,
          apps.po_lines_all@MXDM_NVIS_EXTRACT pla,
          apps.po_line_types@MXDM_NVIS_EXTRACT plt,
          apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll,
          apps.po_distributions_all@MXDM_NVIS_EXTRACT pda,
          apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou,
          apps.ap_vendors_v@MXDM_NVIS_EXTRACT avv,
          apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
    WHERE     1 = 1
          --
          AND pha.type_lookup_code = 'STANDARD'
          AND NVL(pha.authorization_status, 'NUL') IN ('PRE-APPROVED', 'APPROVED')
          AND NVL(pha.cancel_flag, 'N') = 'N'
          AND NVL(pha.closed_code, 'OPEN') NOT IN ('CLOSED', 'FINALLY CLOSED')
          --
          AND pha.po_header_id = pda.po_header_id
          AND pda.distribution_type = 'STANDARD'
          --
          AND pla.po_header_id = pha.po_header_id
          AND pla.po_line_id = pda.po_line_id
          AND NVL(pla.cancel_flag,'N') = 'N'
          AND NVL(pla.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
          --
          AND pla.line_type_id = plt.line_type_id
          AND plt.matching_basis = 'AMOUNT'
          --
          --AND pla.unit_price != 0
          AND pll.line_location_id = pda.line_location_id
          AND pll.po_line_id = pla.po_line_id
          AND NVL(pll.cancel_flag,'N') = 'N'
          AND NVL(pll.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
          --
          AND haou.organization_id = pha.org_id
          --
          AND avv.vendor_id = pha.vendor_id
          AND NVL(avv.vendor_type_lookup_code, 'VENDOR') != 'EMPLOYEE'
          AND pvs.vendor_site_id = pha.vendor_site_id
          AND NVL(pvs.pay_group_lookup_code, 'VENDOR') != 'EMPLOYEE'
          ;
/


EXEC DROPTABLE('XXMX_PO_OPEN_QUANTITY_TEMP')

create table xxmx_po_open_quantity_temp
as select * from xxmx_po_open_quantity_v;
