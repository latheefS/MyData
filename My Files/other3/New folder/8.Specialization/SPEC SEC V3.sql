INSERT INTO XXMX_OLC_SPEC_SXN_STG(
MIGRATION_SET_ID,
MIGRATION_SET_NAME,
MIGRATION_STATUS,
BG_NAME,
METADATA,
OBJECTNAME,
EFFECTIVE_START_DATE,
SPECIALIZATION_SECTION_NUMBER,
TITLE,
COMPLETION_RULE_TYPE,
NUM_OF_ACTIVITIES_TO_COMPLETE,
SEQUENCE_RULE_TYPE,
SEQUENCE_RULE_SECTION_NUMBER,
INIT_ASSIGN_STATUS_ACTIVITIES,
SECTION_POSITION,
SPECIALIZATION_NUMBER,
SOURCE_SYSTEM_OWNER,
SOURCE_SYSTEM_ID)

VALUES(
2026,
'TEST_MIGRATION_SPEC_SXN',
'EXTRACTED',
'TEST_BG',
'MERGE',
'SpecializationSection',
DATE '2021-08-15',
'SSN111114',
'Next Simplest Specialization Section',
'ORA_COMPLETION_SECTION',
0,
'ORA_SECTION_ANYTIME',
'Active',
1,
'SPL111224',
'DATAMIGRATION',
'SSNO1111141')
/

VALUES(
2026,
'TEST_MIGRATION_SPEC_SXN',
'EXTRACTED',
'TEST_BG',
'MERGE',
'SpecializationSection',
DATE '2021-08-15',
'SSN111115',
'Next Atypical Specialization Section One',
'ORA_COMPLETION_SECTION',
0,
'ORA_SECTION_ANYTIME',
'Active',
1,
'SPL111225',
'DATAMIGRATION',
'SSNO1111151')
/

VALUES(
2026,
'TEST_MIGRATION_SPEC_SXN',
'EXTRACTED',
'TEST_BG',
'MERGE',
'SpecializationSection',
DATE '2021-08-15',
'SSN111116',
'Next Atypical Specialization Section Two',
'ORA_COMPLETION_SECTION',
0,
'ORA_SECTION_PREVIOUS',
'SSN111115'
'Active',
2,
'SPL111225',
'DATAMIGRATION',
'SSNO1111161')
/