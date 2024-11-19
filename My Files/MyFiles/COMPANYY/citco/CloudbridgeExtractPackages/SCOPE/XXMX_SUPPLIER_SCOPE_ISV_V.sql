--------------------------------------------------------
--  File created - Thursday-January-11-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View XXMX_SUPPLIER_SCOPE_ISV_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_SUPPLIER_SCOPE_ISV_V" ("VENDOR_ID", "VENDOR_NUMBER", "VENDOR_NAME", "PARTY_ID", "ORG_ID", "OPERATING_UNIT_NAME", "VENDOR_SITE_ID", "VENDOR_SITE_CODE", "PARTY_SITE_ID") AS 
  WITH
     xxmx_parameters
     AS
          /*
          ** The Inclusion/Exclusion Rule counts are used to enable/diable the various Inclusion/Exclusion
          ** sub-queries enabling them if there are rules and disabling them if there aren't.
          */
          (
           SELECT  xxmx_core.xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'AP'
                             ,'SUPPLIERS'
                             ,'ALL'
                             ,'MONTHS_TO_MIGRATE'
                             )      AS supplier_months_to_migrate
                  ,xxmx_core.xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'PO'
                             ,'PURCHASE_ORDERS'
                             ,'ALL'
                             ,'MONTHS_TO_MIGRATE'
                             )      AS po_months_to_migrate
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier1
                    WHERE  1 = 1
                    AND    xier1.application_suite      = 'FIN'
                    AND    xier1.application            = 'AP'
                    AND    xier1.business_entity        = 'SUPPLIERS'
                    AND    xier1.include_or_exclude     = 'INCLUDE'
                    AND    xier1.data_element           = 'SUPPLIER_NUMBER'
                    AND    NVL(xier1.enabled_flag, 'N') = 'Y'
                   )                AS supplier_number_inc_count
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier2
                    WHERE  1 = 1
                    AND    xier2.application_suite      = 'FIN'
                    AND    xier2.application            = 'AP'
                    AND    xier2.business_entity        = 'SUPPLIERS'
                    AND    xier2.include_or_exclude     = 'EXCLUDE'
                    AND    xier2.data_element           = 'SUPPLIER_NUMBER'
                    AND    NVL(xier2.enabled_flag, 'N') = 'Y'
                   )                AS supplier_number_exc_count
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier3
                    WHERE  1 = 1
                    AND    xier3.application_suite      = 'FIN'
                    AND    xier3.application            = 'AP'
                    AND    xier3.business_entity        = 'SUPPLIERS'
                    AND    xier3.include_or_exclude     = 'INCLUDE'
                    AND    xier3.data_element           = 'SUPPLIER_NAME'
                    AND    NVL(xier3.enabled_flag, 'N') = 'Y'
                   )                AS supplier_name_inc_count
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier4
                    WHERE  1 = 1
                    AND    xier4.application_suite      = 'FIN'
                    AND    xier4.application            = 'AP'
                    AND    xier4.business_entity        = 'SUPPLIERS'
                    AND    xier4.include_or_exclude     = 'EXCLUDE'
                    AND    xier4.data_element           = 'SUPPLIER_NAME'
                    AND    NVL(xier4.enabled_flag, 'N') = 'Y'
                   )                AS supplier_name_exc_count
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier5
                    WHERE  1 = 1
                    AND    xier5.application_suite      = 'FIN'
                    AND    xier5.application            = 'AP'
                    AND    xier5.business_entity        = 'SUPPLIERS'
                    AND    xier5.include_or_exclude     = 'INCLUDE'
                    AND    xier5.data_element           = 'VENDOR_TYPE'
                    AND    NVL(xier5.enabled_flag, 'N') = 'Y'
                   )                AS vendor_type_inc_count
                  ,(
                    SELECT COUNT(*)
                    FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier6
                    WHERE  1 = 1
                    AND    xier6.application_suite      = 'FIN'
                    AND    xier6.application            = 'AP'
                    AND    xier6.business_entity        = 'SUPPLIERS'
                    AND    xier6.include_or_exclude     = 'EXCLUDE'
                    AND    xier6.data_element           = 'VENDOR_TYPE'
                    AND    NVL(xier6.enabled_flag, 'N') = 'Y'
                   )                AS vendor_type_exc_count
           FROM    dual
          )
     --
    ,xxmx_parameter_conversions
     AS
          /*
          ** ABS function is used in the calls to the ADD_MONTHS function to remove any existing
          ** negative signs from the values retrieved for the MONTHS_TO_MIGRATE parameters.  The
          ** ABSolute value is then multiplied by -1 to get a past date.  This is to allow for
          ** users assigning a positive or negative value to the parameter.
          */
          (
           SELECT CASE
                       WHEN ABS(xp.supplier_months_to_migrate) > ABS(xp.po_months_to_migrate)
                            THEN ADD_MONTHS(
                                            SYSDATE
                                           ,(ABS(xp.supplier_months_to_migrate) * -1)
                                           )
                       WHEN ABS(xp.po_months_to_migrate) > ABS(xp.supplier_months_to_migrate)
                            THEN ADD_MONTHS(
                                            SYSDATE
                                           ,(ABS(xp.po_months_to_migrate) * -1)
                                           )
                       ELSE ADD_MONTHS(
                                       SYSDATE
                                      ,(ABS(xp.supplier_months_to_migrate) * -1)
                                      )
                  END       AS supplier_scope_start_date
           FROM   xxmx_parameters xp
          )
    ,eligible_org_id_list
     AS
          /*
          ** This query builds a list of ORGANIZATION_IDs to restrict
          ** the Suppliers and Sites to be extracted.
          */
          (
           SELECT  DISTINCT
                   haou.organization_id                                AS org_id
                  ,haou.name                                           AS operating_unit_name
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM   xxmx_core.xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.migration_enabled_flag, 'N') = 'Y'
                                           )
          )
    ,supplier_inclusion_list
     AS
          /*
          ** This query builds a list of VENDOR_IDs for Suppliers to be
          ** specifically INCLUDED in the extract process.  Suppliers  
          ** can be included by specifying Supplier Number, Supplier   
          ** Name and/or Supplier Type (hence three sub-queries).      
          **                                                           
          ** This is utilised as a scope restriction to facilitate     
          ** data throttling in Client Testing (e.g. migration of      
          ** specific occurances of a Business Entity) i.e. if         
          ** Inclusion Rules are specified then only the Suppliers for 
          ** those rules should be extracted.
          */        
          (
           /* Supplier Number Type Inclusions */
           SELECT  aps1.vendor_id
           FROM    xxmx_parameters                               xp1
                  ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps1
           WHERE   1 = 1
           AND     xp1.supplier_number_inc_count > 0  /* Only enable this part of the UNION if there are Inclusion Rules for SUPPLIER_NUMBER */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier1
                           WHERE  1 = 1
                           AND    xier1.application_suite      = 'FIN'
                           AND    xier1.application            = 'AP'
                           AND    xier1.business_entity        = 'SUPPLIERS'
                           AND    xier1.include_or_exclude     = 'INCLUDE'
                           AND    xier1.data_element           = 'SUPPLIER_NUMBER'
                           AND    NVL(xier1.enabled_flag, 'N') = 'Y'
                           AND    xier1.data_value             = aps1.segment1
                          )
           UNION /* Supplier Name Inclusions */
           SELECT  aps2.vendor_id
           FROM    xxmx_parameters                               xp2
                  ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps2
           WHERE   1 = 1
           AND     xp2.supplier_name_inc_count > 0  /* Only enable this part of the UNION if there are Inclusion Rules for SUPPLIER_NAME */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier2
                           WHERE  1 = 1
                           AND    xier2.application_suite      = 'FIN'
                           AND    xier2.application            = 'AP'
                           AND    xier2.business_entity        = 'SUPPLIERS'
                           AND    xier2.include_or_exclude     = 'INCLUDE'
                           AND    xier2.data_element           = 'SUPPLIER_NAME'
                           AND    NVL(xier2.enabled_flag, 'N') = 'Y'
                           AND    xier2.data_value             = aps2.vendor_name
                          )
           UNION /* Vendor Type Inclusions */
           SELECT  aps3.vendor_id
           FROM    xxmx_parameters                               xp3
                  ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps3
           WHERE   1 = 1
           AND     xp3.vendor_type_inc_count > 0  /* Only enable this part of the UNION if there are Inclusion Rules for VENDOR_TYPE */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier3
                           WHERE  1 = 1
                           AND    xier3.application_suite      = 'FIN'
                           AND    xier3.application            = 'AP'
                           AND    xier3.business_entity        = 'SUPPLIERS'
                           AND    xier3.include_or_exclude     = 'INCLUDE'
                           AND    xier3.data_element           = 'VENDOR_TYPE'
                           AND    NVL(xier3.enabled_flag, 'N') = 'Y'
                           AND    xier3.data_value             = NVL(aps3.vendor_type_lookup_code, '#NULL')
                          )
          )
    ,supplier_exclusion_list
     AS
          /*
          ** This query builds a list of VENDOR_IDs for Suppliers to be
          ** specifically EXCLUDED from the extract process.  Suppliers
          ** can be excluded by specifying Supplier Number, Supplier   
          ** Name and/or Supplier Type (hence three sub-queries).
          */          
          (
           /* Supplier Number Type Exclusions */
           SELECT  aps1.vendor_id
           FROM    apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps1
                  ,xxmx_parameters                               xp1
           WHERE   1 = 1
           AND     xp1.supplier_number_exc_count > 0  /* Only enable this part of the UNION if there are Exclusion Rules for SUPPLIER_NUMBER */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier1
                           WHERE  1 = 1
                           AND    xier1.application_suite      = 'FIN'
                           AND    xier1.application            = 'AP'
                           AND    xier1.business_entity        = 'SUPPLIERS'
                           AND    xier1.include_or_exclude     = 'EXCLUDE'
                           AND    xier1.data_element           = 'SUPPLIER_NUMBER'
                           AND    NVL(xier1.enabled_flag, 'N') = 'Y'
                           AND    xier1.data_value             = aps1.segment1
                          )
           UNION /* Supplier Name Exclusions */
           SELECT  aps2.vendor_id
           FROM    apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps2
                  ,xxmx_parameters                               xp2
           WHERE   1 = 1
           AND     xp2.supplier_name_exc_count > 0  /* Only enable this part of the UNION if there are Exclusion Rules for SUPPLIER_NAME */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier2
                           WHERE  1 = 1
                           AND    xier2.application_suite      = 'FIN'
                           AND    xier2.application            = 'AP'
                           AND    xier2.business_entity        = 'SUPPLIERS'
                           AND    xier2.include_or_exclude     = 'EXCLUDE'
                           AND    xier2.data_element           = 'SUPPLIER_NAME'
                           AND    NVL(xier2.enabled_flag, 'N') = 'Y'
                           AND    xier2.data_value             = aps2.vendor_name
                          )
           UNION /* Vendor Type Exclusions */
           SELECT  aps3.vendor_id
           FROM    apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps3
                  ,xxmx_parameters                               xp3
           WHERE   1 = 1
           AND     xp3.vendor_type_exc_count > 0  /* Only enable this part of the UNION if there are Exclusion Rules for VENDOR_TYPE */
           AND     EXISTS (
                           SELECT 'X'
                           FROM   xxmx_core.xxmx_inclusion_exclusion_rules  xier3
                           WHERE  1 = 1
                           AND    xier3.application_suite      = 'FIN'
                           AND    xier3.application            = 'AP'
                           AND    xier3.business_entity        = 'SUPPLIERS'
                           AND    xier3.include_or_exclude     = 'EXCLUDE'
                           AND    xier3.data_element           = 'VENDOR_TYPE'
                           AND    NVL(xier3.enabled_flag, 'N') = 'Y'
                           AND    xier3.data_value             = aps3.vendor_type_lookup_code
                          )
          )
     ,suppliers_list
      AS
          /* This constructs a list of Vendor IDs starting with the  */
          /* base Supplier Selection Rules :                         */
          /*                                                         */
          /* 1) Supplier is Enabled.                                 */
          /* 2) Supplier is not End Dated.                           */
          /* 3) Supplier is not a One Time Supplier.                 */
          /*                                                         */
          /* On top of the above rules, if any Inclusion Rules have  */
          /* been defined, the list of Vendor IDs is further         */
          /* restricted to those identified by the inclusion Rules.  */
          /*                                                         */
          /* Finally, if any Exclusion rules have been defined, the  */
          /* Vendor IDs to be exclused are then removed from the     */
          /* list.                                                   */
          (
           SELECT  aps.vendor_id
           FROM    xxmx_parameters                               xp1
                  ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps
                  ,eligible_org_id_list                          eoil
                  ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa
           WHERE   1 = 1
           AND     assa.org_id   = eoil.org_id
           AND     aps.vendor_id = assa.vendor_id
           AND     (
                        aps.enabled_flag                          = 'Y'            /* Enabled Suppliers */
                    AND NVL(aps.end_date_active, SYSDATE + 1)     > TRUNC(SYSDATE) /* Supplier IS NOT end dated */
                   )
           AND     NVL(aps.one_time_flag,'N')                    <> 'Y'            /* Omit One Time Suppliers */
           AND     (
                       (
                            (
                                xp1.supplier_number_inc_count > 0
                             OR xp1.supplier_name_inc_count   > 0
                             OR xp1.vendor_type_inc_count     > 0
                            )
                        AND EXISTS (
                                    SELECT  'X'
                                    FROM    supplier_inclusion_list  sil
                                    WHERE   1 = 1
                                    AND     sil.vendor_id = aps.vendor_id
                                   )
                       )
                   )
           MINUS
           SELECT  sel.vendor_id
           FROM    xxmx_parameters          xp2
                  ,supplier_exclusion_list  sel
           WHERE   1 = 1
           AND     (
                       xp2.supplier_number_exc_count > 0
                    OR xp2.supplier_name_exc_count   > 0
                    OR xp2.vendor_type_exc_count     > 0
                   )
          )
     ,suppliers_and_sites_list
      AS
          /*
          ** This is the main Suppliers and Site selection query and drives off
          ** the "supplier_list" and "eligible_org_id" queries.
          **
          ** The former is used to ensure that only Suppliers which are active
          ** and which are not one-off Suppliers are extracted.  The supplier
          ** list can be further restricted via the specification of
          ** inclusion/exclusion rules functionality (descibed in the queries
          ** above).
          **
          ** The latter is used to ensure that only Suppliers Sites (and their
          ** parent Suppliers) for the Organisations in scope are extracted.
          */
          (
           SELECT  assa.vendor_id                             AS vendor_id
                  ,assa.org_id                                AS org_id
                  ,eoil.operating_unit_name                   AS operating_unit_name
                  ,assa.vendor_site_id                        AS vendor_site_id
           FROM    suppliers_list                                sl
                  ,eligible_org_id_list                          eoil
                  ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa
           WHERE  1 = 1
           AND    assa.vendor_id                                 = sl.vendor_id                                /* Sites to Suppliers List Join */
           AND    assa.org_id                                    = eoil.org_id                                 /* Organisations in scope */
           AND    SYSDATE                                        < NVL(TRUNC(assa.inactive_date),SYSDATE + 1)  /* Supplier Site IS NOT end dated */
           AND    (
                      assa.rfq_only_site_flag                    = 'Y'
                   OR assa.purchasing_site_flag                  = 'Y'
                   OR assa.pay_site_flag                         = 'Y'
                  )
           AND     (
                       EXISTS (
                               /* AP Invoices created for active Suppliers and Sites within last X months */
                               SELECT 'X'
                               FROM   xxmx_parameter_conversions               xpc
                                     ,apps.ap_invoices_all@MXDM_NVIS_EXTRACT   aia
                               WHERE  1 = 1
                               AND    aia.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    aia.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    aia.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(aia.creation_date) >= xpc.supplier_scope_start_date        /* Invoice created within last X months */
                              )
                    OR EXISTS (
                               /* POs created for active Suppliers and Sites within last X months */
                               SELECT 'X'
                               FROM   xxmx_parameter_conversions             xpc
                                     ,apps.po_headers_all@MXDM_NVIS_EXTRACT  pha
                               WHERE  1 = 1
                               AND    pha.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    pha.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    pha.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(pha.creation_date) >= xpc.supplier_scope_start_date        /* PO created within last X months */
                              )
                   )
          )
          SELECT  distinct_vendor_and_sites_list.vendor_id            AS vendor_id
                 ,aps.segment1                                        AS vendor_number
                 ,aps.vendor_name                                     AS vendor_name
                 ,aps.party_id                                        AS party_id
                 ,distinct_vendor_and_sites_list.org_id               AS org_id
                 ,distinct_vendor_and_sites_list.operating_unit_name  AS operating_unit_name
                 ,distinct_vendor_and_sites_list.vendor_site_id       AS vendor_site_id
                 ,assa.vendor_site_code                               AS vendor_site_code
                 ,assa.party_site_id                                  AS party_site_id
          FROM   (
                  SELECT  DISTINCT
                          vendor_and_sites_list.vendor_id
                         ,vendor_and_sites_list.org_id
                         ,vendor_and_sites_list.operating_unit_name
                         ,vendor_and_sites_list.vendor_site_id
                  FROM   (
                          SELECT  vendor_id
                                 ,org_id
                                 ,operating_unit_name
                                 ,vendor_site_id
                          FROM    suppliers_and_sites_list
                         ) vendor_and_sites_list
                 ) distinct_vendor_and_sites_list
                ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps  /* Only required to lookup additional details for Suppliers      */
                ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa /* Only required to lookup additional details for Supplier Sites */
          WHERE  1 = 1
          AND    aps.vendor_id       = distinct_vendor_and_sites_list.vendor_id
          AND    assa.vendor_id      = aps.vendor_id
          AND    assa.org_id         = distinct_vendor_and_sites_list.org_id
          AND    assa.vendor_site_id = distinct_vendor_and_sites_list.vendor_site_id
;
REM INSERTING into XXMX_CORE.XXMX_SUPPLIER_SCOPE_ISV_V
SET DEFINE OFF;
