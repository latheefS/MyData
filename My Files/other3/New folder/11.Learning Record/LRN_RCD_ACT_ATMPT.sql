INSERT INTO XXMX_OLC_LEARN_RCD_ACT_ATT_STG(
MIGRATION_SET_ID,
MIGRATION_SET_NAME,
MIGRATION_STATUS,
BG_NAME,
METADATA,
OBJECTNAME,
ACTIVITY_ATTEMPT_ID,
LEARNING_RECORD_NUMBER,
ACTIVITY_NUMBER,
ACTIVITY_ATTEMPT_STATUS,
ACTIVITY_ATTEMPT_DATE,
ACTIVITY_ATTEMPT_REASON_CODE,
ACTIVITY_ATTEMPT_ACTUAL_SCORE,
ACTIVITY_ATTEMPT_ACTUAL_EFFORT,
ACTIVITY_ATTEMPT_NOTE)

VALUES(
2034,
'TEST_MIGRATION_LEARN_RCD_ACT',
'EXTRACTED',
'TEST_BG',
'MERGE',
'LearningRecordActivityAttempt',
,
'LR989861',
'OLC134011',
'ORA_ASSN_TASK_NOT_COMPLETED',
'',
'',
'',
'',
'Activity is done yet')
/