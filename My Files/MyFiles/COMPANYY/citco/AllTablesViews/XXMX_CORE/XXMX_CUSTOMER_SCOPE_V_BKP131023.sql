--------------------------------------------------------
--  DDL for View XXMX_CUSTOMER_SCOPE_V_BKP131023
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CUSTOMER_SCOPE_V_BKP131023" ("ORG_ID", "OPERATING_UNIT_NAME", "CUST_ACCOUNT_ID", "ACCOUNT_NUMBER", "ACCOUNT_PARTY_ID", "CUST_ACCT_SITE_ID", "PARTY_NAME", "PARTY_SITE_ID", "PARTY_SITE_NUMBER", "PARTY_SITE_NAME", "LOCATION_ID") AS 
  select "ORG_ID","OPERATING_UNIT_NAME","CUST_ACCOUNT_ID","ACCOUNT_NUMBER","ACCOUNT_PARTY_ID","CUST_ACCT_SITE_ID","PARTY_NAME","PARTY_SITE_ID","PARTY_SITE_NUMBER","PARTY_SITE_NAME","LOCATION_ID" from xxmx_customer_scope_v
;