--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2021 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_create_directories_grants.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Sinchana Ramesh
--**
--** PURPOSE   :  This script creates the directories and permits grants.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    None
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Created Date  Created By          Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Created Date  Created By             Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  20-OCT-2023  Sinchana Ramesh      Created for Cloudbridge.
--**
--**   1.0  20-OCT-2023  Sinchana Ramesh      Created directory and grant scripts.
--**
--******************************************************************************
--
set verify off
set termout off
set echo on

spool &3/crtdbdir.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

-----******DIRECTORY SCRIPTS*******---------
---**********FIN MODULES************--------
--AP
CREATE OR REPLACE DIRECTORY SUPPLIERS AS '/home/oracle/fin/ap/suppliers1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_ADDRESSES AS '/home/oracle/fin/ap/supplier_addresses1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_BANK_ACCOUNTS AS '/home/oracle/fin/ap/supplier_bank_accounts1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_CONTACT AS '/home/oracle/fin/ap/supplier_contact1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_SITES AS '/home/oracle/fin/ap/supplier_sites1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_SITE_ASSIGNS AS '/home/oracle/fin/ap/supplier_site_assigns1/output/';
CREATE OR REPLACE DIRECTORY INVOICES AS '/home/oracle/fin/ap/invoices1/output/';
CREATE OR REPLACE DIRECTORY SUPPLIER_TAX AS '/home/oracle/fin/ap/supplier_tax1/output/';

--AR
CREATE OR REPLACE DIRECTORY CASH_RECEIPTS AS '/home/oracle/fin/ar/cash_receipts1/output/';
CREATE OR REPLACE DIRECTORY CUSTOMERS AS '/home/oracle/fin/ar/customers1/output/';
CREATE OR REPLACE DIRECTORY TRANSACTIONS AS '/home/oracle/fin/ar/transactions1/output/';

--FA
CREATE OR REPLACE DIRECTORY FIXED_ASSETS AS '/home/oracle/fin/fa/fixed_assets1/output/';

--GL
CREATE OR REPLACE DIRECTORY BALANCES AS '/home/oracle/fin/gl/balances1/output/';
CREATE OR REPLACE DIRECTORY OPEN_BAL AS '/home/oracle/fin/gl/open_bal1/output/';
CREATE OR REPLACE DIRECTORY SUMM_BAL AS '/home/oracle/fin/gl/summ_bal1/output/';
CREATE OR REPLACE DIRECTORY DETAIL_BAL AS '/home/oracle/fin/gl/detail_bal1/output/';
CREATE OR REPLACE DIRECTORY DAILY_RATES AS '/home/oracle/fin/gl/daily_rates1/output/';
CREATE OR REPLACE DIRECTORY HISTORICAL_RATES AS '/home/oracle/fin/gl/historical_rates1/output/';
CREATE OR REPLACE DIRECTORY JOURNAL AS '/home/oracle/fin/gl/journal1/output/';

--ZX
CREATE OR REPLACE DIRECTORY CUSTOMER_TAX AS '/home/oracle/fin/zx/customer_tax1/output/';

---**********SCM MODULES************--------
--PO
CREATE OR REPLACE DIRECTORY PURCHASE_ORDERS AS '/home/oracle/scm/po/purchase_orders1/output/';
CREATE OR REPLACE DIRECTORY PURCHASE_ORDERS_BPA AS '/home/oracle/scm/po/purchase_orders_bpa1/output/';
CREATE OR REPLACE DIRECTORY PURCHASE_ORDERS_CPA AS '/home/oracle/scm/po/purchase_orders_cpa1/output/';
CREATE OR REPLACE DIRECTORY PURCHASE_ORDER_RECEIPT AS '/home/oracle/scm/po/purchase_order_receipt1/output/';

---**********PPM MODULES************--------
--PRJ
CREATE OR REPLACE DIRECTORY PRJ_FOUNDATION AS '/home/oracle/ppm/prj/prj_foundation1/output/';
CREATE OR REPLACE DIRECTORY PRJ_RBS AS '/home/oracle/ppm/prj/prj_rbs1/output/';
CREATE OR REPLACE DIRECTORY PRJ_EVENTS AS '/home/oracle/ppm/prj/prj_events1/output/';
CREATE OR REPLACE DIRECTORY PRJ_COST AS '/home/oracle/ppm/prj/prj_cost1/output/';

---**********HCM MODULES************--------
--BEN
CREATE OR REPLACE DIRECTORY BENEFITS AS '/home/oracle/hcm/ben/benefits1/output/';

--HR
CREATE OR REPLACE DIRECTORY BANKS_AND_BRANCHES AS '/home/oracle/hcm/hr/banks_and_branches1/output/';
CREATE OR REPLACE DIRECTORY PERSON AS '/home/oracle/hcm/hr/person1/output/';
CREATE OR REPLACE DIRECTORY WORKER AS '/home/oracle/hcm/hr/worker1/output/';
CREATE OR REPLACE DIRECTORY TALENT AS '/home/oracle/hcm/hr/talent1/output/';
CREATE OR REPLACE DIRECTORY ORGANIZATION AS '/home/oracle/hcm/hr/organization1/output/';
CREATE OR REPLACE DIRECTORY LOCATION AS '/home/oracle/hcm/hr/location1/output/';

--IREC
CREATE OR REPLACE DIRECTORY GEOGRAPHY_HIERARCHY AS '/home/oracle/hcm/irec/geography_hierarchy1/output/';
CREATE OR REPLACE DIRECTORY JOB_REQUISITION AS '/home/oracle/hcm/irec/job_requisition1/output/';
CREATE OR REPLACE DIRECTORY CANDIDATE AS '/home/oracle/hcm/irec/candidate1/output/';
CREATE OR REPLACE DIRECTORY CANDIDATE_POOL AS '/home/oracle/hcm/irec/candidate_pool1/output/';
CREATE OR REPLACE DIRECTORY JOB_REFERRAL AS '/home/oracle/hcm/irec/job_referral1/output/';
CREATE OR REPLACE DIRECTORY PROSPECT AS '/home/oracle/hcm/irec/prospect1/output/';

--PAY
CREATE OR REPLACE DIRECTORY CALC_CARDS_PAE AS '/home/oracle/hcm/pay/calc_cards_pae1/output/';
CREATE OR REPLACE DIRECTORY CALC_CARDS_SD AS '/home/oracle/hcm/pay/calc_cards_sd1/output/';
CREATE OR REPLACE DIRECTORY CALC_CARDS_SL AS '/home/oracle/hcm/pay/calc_cards_sl1/output/';
CREATE OR REPLACE DIRECTORY CALC_CARDS_BP AS '/home/oracle/hcm/pay/calc_cards_bp1/output/';
CREATE OR REPLACE DIRECTORY CALC_CARDS_NSD AS '/home/oracle/hcm/pay/calc_cards_nsd1/output/';
CREATE OR REPLACE DIRECTORY CALC_CARDS_PGL AS '/home/oracle/hcm/pay/calc_cards_pgl1/output/';
CREATE OR REPLACE DIRECTORY PAY_BALANCES AS '/home/oracle/hcm/pay/pay_balances1/output/';
CREATE OR REPLACE DIRECTORY ELEMENTS AS '/home/oracle/hcm/pay/elements1/output/';

--TM
CREATE OR REPLACE DIRECTORY PERFORMANCE_DOCUMENT AS '/home/oracle/hcm/tm/performance_document1/output/';
CREATE OR REPLACE DIRECTORY GOAL AS '/home/oracle/hcm/tm/goal1/output/';
CREATE OR REPLACE DIRECTORY GOAL_PLAN AS '/home/oracle/hcm/tm/goal_plan1/output/';
CREATE OR REPLACE DIRECTORY GOAL_PLAN_SET AS '/home/oracle/hcm/tm/goal_plan_set1/output/';

---**********OLC MODULES************--------
--LRN
CREATE OR REPLACE DIRECTORY LEARNING AS '/home/oracle/olc/lrn/learning1/output/';

/

-----********GRANT SCRIPTS*********----------
---**********FIN MODULES************---------
--AP
GRANT ALL ON DIRECTORY SUPPLIERS TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_ADDRESSES TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_BANK_ACCOUNTS TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_CONTACT TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_SITES TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_SITE_ASSIGNS TO xxmx_core;
GRANT ALL ON DIRECTORY INVOICES TO xxmx_core;
GRANT ALL ON DIRECTORY SUPPLIER_TAX TO xxmx_core;

--AR
GRANT ALL ON DIRECTORY CASH_RECEIPTS TO xxmx_core;
GRANT ALL ON DIRECTORY CUSTOMERS TO xxmx_core;
GRANT ALL ON DIRECTORY TRANSACTIONS TO xxmx_core;

--FA
GRANT ALL ON DIRECTORY FIXED_ASSETS TO xxmx_core;

--GL
GRANT ALL ON DIRECTORY BALANCES TO xxmx_core;
GRANT ALL ON DIRECTORY OPEN_BAL TO xxmx_core;
GRANT ALL ON DIRECTORY SUMM_BAL TO xxmx_core;
GRANT ALL ON DIRECTORY DETAIL_BAL TO xxmx_core;
GRANT ALL ON DIRECTORY DAILY_RATES TO xxmx_core;
GRANT ALL ON DIRECTORY HISTORICAL_RATES TO xxmx_core;
GRANT ALL ON DIRECTORY JOURNAL TO xxmx_core;

--ZX
GRANT ALL ON DIRECTORY CUSTOMER_TAX TO xxmx_core;

---**********SCM MODULES************--------
--PO
GRANT ALL ON DIRECTORY PURCHASE_ORDERS TO xxmx_core;
GRANT ALL ON DIRECTORY PURCHASE_ORDERS_BPA TO xxmx_core;
GRANT ALL ON DIRECTORY PURCHASE_ORDERS_CPA TO xxmx_core;
GRANT ALL ON DIRECTORY PURCHASE_ORDER_RECEIPT TO xxmx_core;


---**********PPM MODULES************--------
--PRJ
GRANT ALL ON DIRECTORY PRJ_FOUNDATION TO xxmx_core;
GRANT ALL ON DIRECTORY PRJ_RBS TO xxmx_core;
GRANT ALL ON DIRECTORY PRJ_EVENTS TO xxmx_core;
GRANT ALL ON DIRECTORY PRJ_COST TO xxmx_core;

---**********HCM MODULES************--------
--BEN
GRANT ALL ON DIRECTORY BENEFITS TO xxmx_core;


--HR
GRANT ALL ON DIRECTORY BANKS_AND_BRANCHES TO xxmx_core;
GRANT ALL ON DIRECTORY PERSON TO xxmx_core;
GRANT ALL ON DIRECTORY WORKER TO xxmx_core;
GRANT ALL ON DIRECTORY TALENT TO xxmx_core;
GRANT ALL ON DIRECTORY ORGANIZATION TO xxmx_core;
GRANT ALL ON DIRECTORY LOCATION TO xxmx_core;

--IREC
GRANT ALL ON DIRECTORY GEOGRAPHY_HIERARCHY TO xxmx_core;
GRANT ALL ON DIRECTORY JOB_REQUISITION TO xxmx_core;
GRANT ALL ON DIRECTORY CANDIDATE TO xxmx_core;
GRANT ALL ON DIRECTORY CANDIDATE_POOL TO xxmx_core;
GRANT ALL ON DIRECTORY JOB_REFERRAL TO xxmx_core;
GRANT ALL ON DIRECTORY PROSPECT TO xxmx_core;

--PAY
GRANT ALL ON DIRECTORY CALC_CARDS_PAE TO xxmx_core;
GRANT ALL ON DIRECTORY CALC_CARDS_SD TO xxmx_core;
GRANT ALL ON DIRECTORY CALC_CARDS_SL TO xxmx_core;
GRANT ALL ON DIRECTORY CALC_CARDS_BP TO xxmx_core;
GRANT ALL ON DIRECTORY CALC_CARDS_NSD TO xxmx_core;
GRANT ALL ON DIRECTORY CALC_CARDS_PGL TO xxmx_core;
GRANT ALL ON DIRECTORY PAY_BALANCES TO xxmx_core;
GRANT ALL ON DIRECTORY ELEMENTS TO xxmx_core;


--TM
GRANT ALL ON DIRECTORY PERFORMANCE_DOCUMENT TO xxmx_core;
GRANT ALL ON DIRECTORY GOAL TO xxmx_core;
GRANT ALL ON DIRECTORY GOAL_PLAN TO xxmx_core;
GRANT ALL ON DIRECTORY GOAL_PLAN_SET TO xxmx_core;

---**********OLC MODULES************--------
--LRN
GRANT ALL ON DIRECTORY LEARNING TO xxmx_core;

commit;
/

spool off;

set verify on
set echo off
set termout on

exit





