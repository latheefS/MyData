INSERT INTO XXMX_OLC_COURSE_PRICE_COMP_STG(
MIGRATION_SET_ID,
MIGRATION_SET_NAME,
MIGRATION_STATUS,
BG_NAME,
METADATA,
OBJECTNAME,
EFFECTIVE_START_DATE,
PRICING_COMPONENT_NUMBER,
PRICING_COMPONENT_TYPE,
PRICE,
INCLUDE_IN_SELF_SERVICE_PRICING,
REQUIRED,
PRICING_RULE_NUMBER,
SOURCE_SYSTEM_OWNER,
SOURCE_SYSTEM_ID)

VALUES(
2022,
'TEST_MIGRATION_COURSE_PRICE_COMP',
'EXTRACTED',
'TEST_BG',
'MERGE',
'CourseOfferingPricingComponent',
DATE '2021-08-15',
'PC393939',
'List Price Adjustment',
50,
'Y',
'Y',
'PR939393',
'DATAMIGRATION',
'COPC3939391')
/

VALUES(
2022,
'TEST_MIGRATION_COURSE_PRICE_COMP',
'EXTRACTED',
'TEST_BG',
'MERGE',
'CourseOfferingPricingComponent',
DATE '2021-08-15',
'PC393940',
'List Price',
75,
'Y',
'Y',
'PR939394',
'DATAMIGRATION',
'COPC3939401')
/

VALUES(
2022,
'TEST_MIGRATION_COURSE_PRICE_COMP',
'EXTRACTED',
'TEST_BG',
'MERGE',
'CourseOfferingPricingComponent',
DATE '2021-08-15',
'PC393941',
'List Price',
100,
'Y',
'Y',
'PR939395',
'DATAMIGRATION',
'COPC3939411')
/