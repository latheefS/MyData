
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PO_DISTRIBUTIONS_QTY_V" ("PO_HEADER_ID", "PO_LINE_ID", "SEGMENT1", "LINE_NUM", "LINE_LOCATION_ID", "PO_DISTRIBUTION_ID", "MIN(PLL.SHIPMENT_NUM)", "MIN(PD.DISTRIBUTION_NUM)", "UNIT_PRICE", "QTY_CANCELLED", "QTY_BILLED", "ORIG_QTY_ORDERED", "NEW_QTY_ORDERED", "ORIG_QTY_DELIVERED", "NEW_QTY_DELIVERED") AS 
  select "PO_HEADER_ID","PO_LINE_ID","SEGMENT1","LINE_NUM","LINE_LOCATION_ID","PO_DISTRIBUTION_ID","MIN(PLL.SHIPMENT_NUM)","MIN(PD.DISTRIBUTION_NUM)","UNIT_PRICE","QTY_CANCELLED","QTY_BILLED","ORIG_QTY_ORDERED","NEW_QTY_ORDERED","ORIG_QTY_DELIVERED","NEW_QTY_DELIVERED" from (select pl.po_header_id
        ,pl.po_line_id
        ,ph.segment1
        ,pl.line_num
        ,pll.line_location_id
        ,pd.po_distribution_id
        ,min(pll.shipment_num)
        ,min(pd.distribution_num)
        ,min(pl.unit_price)                                                  unit_price
        ,sum(pd.quantity_cancelled)                                          qty_cancelled
        ,sum(pd.quantity_billed)                                             qty_billed
        ,sum(pd.quantity_ordered)                                            orig_qty_ordered
        ,sum(decode(nvl(pd.quantity_billed,0),0,
              pd.quantity_ordered-pd.quantity_cancelled,
              pd.quantity_ordered-pd.quantity_cancelled-pd.quantity_billed)) new_qty_ordered
        ,sum(pd.quantity_delivered)                                          orig_qty_delivered
        ,sum(decode(nvl(pd.quantity_billed,0),0,
              pd.quantity_delivered,
              pd.quantity_delivered-pd.quantity_billed))                     new_qty_delivered
  from   po.po_distributions_all@XXMX_EXTRACT  pd
        ,po.po_line_locations_all@XXMX_EXTRACT pll
        ,po.po_lines_all@XXMX_EXTRACT          pl
        ,po.po_headers_all@XXMX_EXTRACT        ph
  where ph.po_header_id      = pl.po_header_id
  and   pl.po_line_id        = pll.po_line_id
  and   pll.line_location_id = pd.line_location_id
    and     nvl(pl.cancel_flag, 'N')                   = 'N'
   and     nvl(pl.closed_code, 'OPEN')                NOT IN ('CLOSED','FINALLY CLOSED')
    and     nvl(ph.cancel_flag, 'N')                   = 'N'
        and     nvl(ph.closed_code, 'OPEN')                NOT IN ('CLOSED','FINALLY CLOSED')
        and     nvl(pll.closed_flag, 'OPEN')                NOT IN ('CLOSED','FINALLY CLOSED')
  and     nvl(pll.cancel_flag, 'N')                   = 'N'
  and ph.type_lookup_code='STANDARD'
  AND ph.AUTHORIZATION_STATUS IN ('APPROVED','PRE-APPROVED')
  group by pl.po_header_id
          ,pl.po_line_id
          ,ph.segment1
          ,pl.line_num
          ,pll.line_location_id
          ,pd.po_distribution_id) where NEW_QTY_ORDERED>0;


  GRANT SELECT ON "XXMX_CORE"."XXMX_PO_DISTRIBUTIONS_QTY_V" TO "XXMX_READONLY";
