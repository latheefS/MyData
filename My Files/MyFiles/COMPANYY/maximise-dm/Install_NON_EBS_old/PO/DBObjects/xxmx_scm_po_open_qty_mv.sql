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
    DropView ('XXMX_SCM_PO_OPEN_QTY_MV') ;
END;
/

  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_SCM_PO_OPEN_QTY_MV" ("ORG_ID", "DOCUMENT_NUM", "VENDOR_SITE_ID", "LINE_NUM", "SHIPMENT_NUM", "DISTRIBUTION_NUM", "PO_HEADER_ID", "PO_LINE_ID", "LINE_LOCATION_ID", "PO_DISTRIBUTION_ID", "LINE_TYPE", "MATCHING_BASIS", "UNIT_PRICE", "ORDERED", "RECEIVED", "BILLED", "CANCELLED", "OPEN_PO", "CLOSE_PO")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT  pha.org_id org_id,
          pha.segment1 document_num,
          pha.vendor_site_id,
          pla.line_num line_num,
          pll.shipment_num shipment_num,
          pda.distribution_num distribution_num,
          pda.po_header_id po_header_id,
          pda.po_line_id po_line_id,
          pda.line_location_id line_location_id,
          pda.po_distribution_id po_distribution_id,
          plt.line_type line_type,
          plt.matching_basis matching_basis,
          pla.unit_price unit_price,
          NVL(pda.quantity_ordered,0) ordered,
          NVL(pda.quantity_delivered,0) received,
          NVL(pda.quantity_billed,0) billed,
          NVL(pda.quantity_cancelled,0) cancelled,
          (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) open_po,
          (NVL(pda.quantity_cancelled, 0) + NVL(pda.quantity_billed, 0)) close_po
     FROM apps.po_headers_all@MXDM_NVIS_EXTRACT pha,
          apps.po_lines_all@MXDM_NVIS_EXTRACT pla,
          apps.po_line_types@MXDM_NVIS_EXTRACT plt,
          apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll,
          apps.po_distributions_all@MXDM_NVIS_EXTRACT pda,
          XXMX_PURCHASE_ORDER_SCOPE_V xpos
    WHERE     1 = 1
          --
          AND pha.po_header_id = pda.po_header_id
          --
          AND pla.po_header_id = pha.po_header_id
          AND pla.po_line_id = pda.po_line_id
          --
          AND pla.line_type_id = plt.line_type_id
          AND plt.matching_basis = 'QUANTITY'
          --
          AND pla.unit_price != 0
          AND pll.line_location_id = pda.line_location_id
          AND pll.po_line_id = pla.po_line_id
          --
          AND pha.org_id                            = xpos.org_id	
      --    and pha.po_header_id = 61
          AND pha.po_header_id				       = xpos.po_header_id	
UNION 
  SELECT  pha.org_id org_id,
          pha.segment1 document_num,
          pha.vendor_site_id,
          pla.line_num line_num,
          pll.shipment_num shipment_num,
          pda.distribution_num distribution_num,
          pda.po_header_id po_header_id,
          pda.po_line_id po_line_id,
          pda.line_location_id line_location_id,
          pda.po_distribution_id po_distribution_id,
          plt.line_type line_type,
          plt.matching_basis matching_basis,
          pla.unit_price unit_price,
          NVL(pda.quantity_ordered,0) ordered,
          NVL(pda.quantity_delivered,0) received,
          NVL(pda.quantity_billed,0) billed,
          NVL(pda.quantity_cancelled,0) cancelled,
          (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) open_po,
          (NVL(pda.quantity_cancelled, 0) + NVL(pda.quantity_billed, 0)) close_po
     FROM apps.po_headers_all@MXDM_NVIS_EXTRACT pha,
          apps.po_lines_all@MXDM_NVIS_EXTRACT pla,
          apps.po_line_types@MXDM_NVIS_EXTRACT plt,
          apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll,
          apps.po_distributions_all@MXDM_NVIS_EXTRACT pda,
          XXMX_PURCHASE_ORDER_SCOPE_V xpos
    WHERE     1 = 1
          --
          AND pha.po_header_id = pda.po_header_id
          --
          AND pla.po_header_id = pha.po_header_id
          AND pla.po_line_id = pda.po_line_id
          --
          AND pla.line_type_id = plt.line_type_id
          AND plt.matching_basis = 'AMOUNT'
          --
          AND pla.unit_price != 0
          AND pll.line_location_id = pda.line_location_id
          AND pll.po_line_id = pla.po_line_id
          --
          AND pha.org_id                            = xpos.org_id	
          --and pha.po_header_id = 61
          AND pha.po_header_id				       = xpos.po_header_id;

   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_SCM_PO_OPEN_QTY_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_SCM_PO_OPEN_QTY_MV';

/