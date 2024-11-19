
DECLARE

   PROCEDURE DropView (pView IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || pView ;
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -12003 THEN
         RAISE;
      END IF;
   END DropVIew ;
   
BEGIN
    DropView ('XXMX_PO_OPEN_QUANTITY_MV') ;
END;
/


CREATE MATERIALIZED VIEW xxmx_po_open_quantity_mv
                          (org_id,
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
                           po_source)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS SELECT *
   FROM   xxmx_po_open_quantity_temp;



