
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PURCHASE_ORDER_SCOPE" ("PO_HEADER_ID", "ORG_ID", "PO_NUMBER", "SOURCE_OPERATING_UNIT_NAME") AS 
  select pha.po_header_id,pha.org_id,pha.segment1 po_number, xsou.SOURCE_OPERATING_UNIT_NAME
       from
            xxmx_source_operating_units                          xsou,
            hr.hr_all_organization_units@XXMX_EXTRACT            hout,
            po_headers_all@XXMX_EXTRACT                          pha
        where   hout.name                                   = xsou.SOURCE_OPERATING_UNIT_NAME
        and     pha.org_id                                  = hout.organization_id
        and     pha.type_lookup_code                        = 'STANDARD'
        and     pha.authorization_status                    IN ('APPROVED','PRE-APPROVED')
        and     nvl(pha.closed_code, 'OPEN')                NOT IN ('CLOSED','FINALLY CLOSED')
        and     nvl(pha.cancel_flag, 'N')                   = 'N'
        and     nvl(pha.closed_code, 'OPEN')                NOT IN ('CLOSED','FINALLY CLOSED')
        and exists
        (
            select  1 from XXMX_PO_LINES_QTY_V plv
            where   plv.po_header_id = pha.po_header_id
        )
        and nvl(xsou.FIN_MIGRATION_ENABLED_FLAG,'Y')='Y';


  GRANT SELECT ON "XXMX_CORE"."XXMX_PURCHASE_ORDER_SCOPE" TO "XXMX_READONLY";
