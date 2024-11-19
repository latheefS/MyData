--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
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
--** FILENAME  :  xxmx_hcm_person_scope_mv.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Pallavi Kanajar
--**
--** PURPOSE   :  This script installs the Scope View for the Maximise HCM
--**              Data Migration.
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
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-AUG-2022  Pallavi Kanajar    Created for Maximise.
--**
--****************************************************************************** 

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
    DropView ('XXMX_HCM_PERSON_SCOPE_MV') ;
END;
/



CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_HCM_PERSON_SCOPE_MV" (
    "PERSON_ID",
    "EFFECTIVE_START_DATE",
    "EFFECTIVE_END_DATE",
    "BUSINESS_GROUP_ID",
    "PERSON_TYPE_ID",
    "LAST_NAME",
    "START_DATE",
    "APPLICANT_NUMBER",
    "COMMENT_ID",
    "CURRENT_APPLICANT_FLAG",
    "CURRENT_EMP_OR_APL_FLAG",
    "CURRENT_EMPLOYEE_FLAG",
    "DATE_EMPLOYEE_DATA_VERIFIED",
    "DATE_OF_BIRTH",
    "EMAIL_ADDRESS",
    "EMPLOYEE_NUMBER",
    "EXPENSE_CHECK_SEND_TO_ADDRESS",
    "FIRST_NAME",
    "FULL_NAME",
    "KNOWN_AS",
    "MARITAL_STATUS",
    "MIDDLE_NAMES",
    "NATIONALITY",
    "NATIONAL_IDENTIFIER",
    "PREVIOUS_LAST_NAME",
    "REGISTERED_DISABLED_FLAG",
    "SEX",
    "TITLE",
    "VENDOR_ID",
    "WORK_TELEPHONE",
    "REQUEST_ID",
    "PROGRAM_APPLICATION_ID",
    "PROGRAM_ID",
    "PROGRAM_UPDATE_DATE",
    "ATTRIBUTE_CATEGORY",
    "ATTRIBUTE1",
    "ATTRIBUTE2",
    "ATTRIBUTE3",
    "ATTRIBUTE4",
    "ATTRIBUTE5",
    "ATTRIBUTE6",
    "ATTRIBUTE7",
    "ATTRIBUTE8",
    "ATTRIBUTE9",
    "ATTRIBUTE10",
    "ATTRIBUTE11",
    "ATTRIBUTE12",
    "ATTRIBUTE13",
    "ATTRIBUTE14",
    "ATTRIBUTE15",
    "ATTRIBUTE16",
    "ATTRIBUTE17",
    "ATTRIBUTE18",
    "ATTRIBUTE19",
    "ATTRIBUTE20",
    "ATTRIBUTE21",
    "ATTRIBUTE22",
    "ATTRIBUTE23",
    "ATTRIBUTE24",
    "ATTRIBUTE25",
    "ATTRIBUTE26",
    "ATTRIBUTE27",
    "ATTRIBUTE28",
    "ATTRIBUTE29",
    "ATTRIBUTE30",
    "LAST_UPDATE_DATE",
    "LAST_UPDATED_BY",
    "LAST_UPDATE_LOGIN",
    "CREATED_BY",
    "CREATION_DATE",
    "PER_INFORMATION_CATEGORY",
    "PER_INFORMATION1",
    "PER_INFORMATION2",
    "PER_INFORMATION3",
    "PER_INFORMATION4",
    "PER_INFORMATION5",
    "PER_INFORMATION6",
    "PER_INFORMATION7",
    "PER_INFORMATION8",
    "PER_INFORMATION9",
    "PER_INFORMATION10",
    "PER_INFORMATION11",
    "PER_INFORMATION12",
    "PER_INFORMATION13",
    "PER_INFORMATION14",
    "PER_INFORMATION15",
    "PER_INFORMATION16",
    "PER_INFORMATION17",
    "PER_INFORMATION18",
    "PER_INFORMATION19",
    "PER_INFORMATION20",
    "BACKGROUND_CHECK_STATUS",
    "BACKGROUND_DATE_CHECK",
    "BLOOD_TYPE",
    "CORRESPONDENCE_LANGUAGE",
    "FAST_PATH_EMPLOYEE",
    "FTE_CAPACITY",
    "HOLD_APPLICANT_DATE_UNTIL",
    "HONORS",
    "INTERNAL_LOCATION",
    "LAST_MEDICAL_TEST_BY",
    "LAST_MEDICAL_TEST_DATE",
    "MAILSTOP",
    "OFFICE_NUMBER",
    "ON_MILITARY_SERVICE",
    "ORDER_NAME",
    "PRE_NAME_ADJUNCT",
    "PROJECTED_START_DATE",
    "REHIRE_AUTHORIZOR",
    "REHIRE_RECOMMENDATION",
    "RESUME_EXISTS",
    "RESUME_LAST_UPDATED",
    "SECOND_PASSPORT_EXISTS",
    "STUDENT_STATUS",
    "SUFFIX",
    "WORK_SCHEDULE",
    "PER_INFORMATION21",
    "PER_INFORMATION22",
    "PER_INFORMATION23",
    "PER_INFORMATION24",
    "PER_INFORMATION25",
    "PER_INFORMATION26",
    "PER_INFORMATION27",
    "PER_INFORMATION28",
    "PER_INFORMATION29",
    "PER_INFORMATION30",
    "OBJECT_VERSION_NUMBER",
    "DATE_OF_DEATH",
    "REHIRE_REASON",
    "COORD_BEN_MED_PLN_NO",
    "COORD_BEN_NO_CVG_FLAG",
    "DPDNT_ADOPTION_DATE",
    "DPDNT_VLNTRY_SVCE_FLAG",
    "RECEIPT_OF_DEATH_CERT_DATE",
    "USES_TOBACCO_FLAG",
    "BENEFIT_GROUP_ID",
    "ORIGINAL_DATE_OF_HIRE",
    "TOWN_OF_BIRTH",
    "REGION_OF_BIRTH",
    "COUNTRY_OF_BIRTH",
    "GLOBAL_PERSON_ID",
    "COORD_BEN_MED_PL_NAME",
    "COORD_BEN_MED_INSR_CRR_NAME",
    "COORD_BEN_MED_INSR_CRR_IDENT",
    "COORD_BEN_MED_EXT_ER",
    "COORD_BEN_MED_CVG_STRT_DT",
    "COORD_BEN_MED_CVG_END_DT",
    "PARTY_ID",
    "NPW_NUMBER",
    "CURRENT_NPW_FLAG",
    "GLOBAL_NAME",
    "LOCAL_NAME",
    "SYSTEM_PERSON_TYPE",
    "USER_PERSON_TYPE",
    "NAME_TYPE"
)
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
  USING TRUSTED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
AS
    WITH emp_bt_mgr_dt_frm AS (
        SELECT
            papf.*,
            ppt.system_person_type,
            ppt.user_person_type,
            'GLOBAL' name_type
        FROM
            per_all_people_f@mxdm_nvis_extract         papf,
            per_person_type_usages_f@mxdm_nvis_extract pptu,
            per_person_types@mxdm_nvis_extract         ppt,
            (
                SELECT DISTINCT
                    haou.organization_id bg_id,
                    haou.name            bg_name
                FROM
                    apps.hr_all_organization_units@mxdm_nvis_extract   haou,
                    apps.hr_organization_information@mxdm_nvis_extract hoi
                WHERE
                        1 = 1
                    AND hoi.organization_id = haou.organization_id
                    AND hoi.org_information1 = 'HR_BG'
                    AND haou.name IN (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                                application = 'HR'
                            AND parameter_code = 'BUSINESS_GROUP_NAME'
                                           --and enabled_flag = 'Y'
                    )
            )                                          bg
        WHERE
                papf.person_id = pptu.person_id
            AND ppt.person_type_id = pptu.person_type_id
            AND papf.business_group_id = bg_id
            AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
            AND papf.effective_start_date >= (
                SELECT
                    to_date(parameter_value, 'RRRR-MM-DD')
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'MIGRATE_DATE_FROM'
                    AND enabled_flag = 'Y'
            )
            AND papf.effective_end_date <= (
                SELECT
                    to_date(parameter_value, 'RRRR-MM-DD')
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'MIGRATE_DATE_TO'
                    AND enabled_flag = 'Y'
            )
            AND upper(ppt.user_person_type) IN (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'PERSON_TYPE'
                    AND enabled_flag = 'Y'
            )
    )
        -- Employess after migration date from
    , emp_a_mgr_dt_frm AS (
        SELECT
            papf.*,
            ppt.system_person_type,
            ppt.user_person_type,
            'GLOBAL' name_type
        FROM
            per_all_people_f@mxdm_nvis_extract         papf,
            per_person_type_usages_f@mxdm_nvis_extract pptu,
            per_person_types@mxdm_nvis_extract         ppt,
            (
                SELECT DISTINCT
                    haou.organization_id bg_id,
                    haou.name            bg_name
                FROM
                    apps.hr_all_organization_units@mxdm_nvis_extract   haou,
                    apps.hr_organization_information@mxdm_nvis_extract hoi
                WHERE
                        1 = 1
                    AND hoi.organization_id = haou.organization_id
                    AND hoi.org_information1 = 'HR_BG'
                    AND haou.name IN (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                                application = 'HR'
                            AND parameter_code = 'BUSINESS_GROUP_NAME'
                                           --and enabled_flag = 'Y'
                    )
            )                                          bg
        WHERE
                papf.person_id = pptu.person_id
            AND ppt.person_type_id = pptu.person_type_id
            AND papf.business_group_id = bg_id
            AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
            AND upper(ppt.user_person_type) IN (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'PERSON_TYPE'
                    AND enabled_flag = 'Y'
            )
                    --employees started before Migration_Date_From
            AND papf.effective_start_date >= (
                SELECT
                    to_date(parameter_value, 'RRRR-MM-DD')
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'MIGRATE_DATE_FROM'
                    AND enabled_flag = 'Y'
            )
    )
                -- Employess before migration date from
    , emp_b_mgr_dt_frm AS (
        SELECT
            papf.*,
            ppt.system_person_type,
            ppt.user_person_type,
            'GLOBAL' name_type
        FROM
            per_all_people_f@mxdm_nvis_extract         papf,
            per_person_type_usages_f@mxdm_nvis_extract pptu,
            per_person_types@mxdm_nvis_extract         ppt,
            (
                SELECT DISTINCT
                    haou.organization_id bg_id,
                    haou.name            bg_name
                FROM
                    apps.hr_all_organization_units@mxdm_nvis_extract   haou,
                    apps.hr_organization_information@mxdm_nvis_extract hoi
                WHERE
                        1 = 1
                    AND hoi.organization_id = haou.organization_id
                    AND hoi.org_information1 = 'HR_BG'
                    AND haou.name IN (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                                application = 'HR'
                            AND parameter_code = 'BUSINESS_GROUP_NAME'
                                           --and enabled_flag = 'Y'
                    )
            )                                          bg
        WHERE
                papf.person_id = pptu.person_id
            AND ppt.person_type_id = pptu.person_type_id
            AND papf.business_group_id = bg_id
            AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
            AND upper(ppt.user_person_type) IN (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'PERSON_TYPE'
                    AND enabled_flag = 'Y'
            )
                    --employees started before Migration_Date_From
            AND papf.effective_start_date <= (
                SELECT
                    to_date(parameter_value, 'RRRR-MM-DD')
                FROM
                    xxmx_migration_parameters
                WHERE
                        application = 'HR'
                    AND parameter_code = 'MIGRATE_DATE_FROM'
                    AND enabled_flag = 'Y'
            )
    )
    SELECT
        "PERSON_ID",
        "EFFECTIVE_START_DATE",
        "EFFECTIVE_END_DATE",
        "BUSINESS_GROUP_ID",
        "PERSON_TYPE_ID",
        "LAST_NAME",
        "START_DATE",
        "APPLICANT_NUMBER",
        "COMMENT_ID",
        "CURRENT_APPLICANT_FLAG",
        "CURRENT_EMP_OR_APL_FLAG",
        "CURRENT_EMPLOYEE_FLAG",
        "DATE_EMPLOYEE_DATA_VERIFIED",
        "DATE_OF_BIRTH",
        "EMAIL_ADDRESS",
        "EMPLOYEE_NUMBER",
        "EXPENSE_CHECK_SEND_TO_ADDRESS",
        "FIRST_NAME",
        "FULL_NAME",
        "KNOWN_AS",
        "MARITAL_STATUS",
        "MIDDLE_NAMES",
        "NATIONALITY",
        "NATIONAL_IDENTIFIER",
        "PREVIOUS_LAST_NAME",
        "REGISTERED_DISABLED_FLAG",
        "SEX",
        "TITLE",
        "VENDOR_ID",
        "WORK_TELEPHONE",
        "REQUEST_ID",
        "PROGRAM_APPLICATION_ID",
        "PROGRAM_ID",
        "PROGRAM_UPDATE_DATE",
        "ATTRIBUTE_CATEGORY",
        "ATTRIBUTE1",
        "ATTRIBUTE2",
        "ATTRIBUTE3",
        "ATTRIBUTE4",
        "ATTRIBUTE5",
        "ATTRIBUTE6",
        "ATTRIBUTE7",
        "ATTRIBUTE8",
        "ATTRIBUTE9",
        "ATTRIBUTE10",
        "ATTRIBUTE11",
        "ATTRIBUTE12",
        "ATTRIBUTE13",
        "ATTRIBUTE14",
        "ATTRIBUTE15",
        "ATTRIBUTE16",
        "ATTRIBUTE17",
        "ATTRIBUTE18",
        "ATTRIBUTE19",
        "ATTRIBUTE20",
        "ATTRIBUTE21",
        "ATTRIBUTE22",
        "ATTRIBUTE23",
        "ATTRIBUTE24",
        "ATTRIBUTE25",
        "ATTRIBUTE26",
        "ATTRIBUTE27",
        "ATTRIBUTE28",
        "ATTRIBUTE29",
        "ATTRIBUTE30",
        "LAST_UPDATE_DATE",
        "LAST_UPDATED_BY",
        "LAST_UPDATE_LOGIN",
        "CREATED_BY",
        "CREATION_DATE",
        "PER_INFORMATION_CATEGORY",
        "PER_INFORMATION1",
        "PER_INFORMATION2",
        "PER_INFORMATION3",
        "PER_INFORMATION4",
        "PER_INFORMATION5",
        "PER_INFORMATION6",
        "PER_INFORMATION7",
        "PER_INFORMATION8",
        "PER_INFORMATION9",
        "PER_INFORMATION10",
        "PER_INFORMATION11",
        "PER_INFORMATION12",
        "PER_INFORMATION13",
        "PER_INFORMATION14",
        "PER_INFORMATION15",
        "PER_INFORMATION16",
        "PER_INFORMATION17",
        "PER_INFORMATION18",
        "PER_INFORMATION19",
        "PER_INFORMATION20",
        "BACKGROUND_CHECK_STATUS",
        "BACKGROUND_DATE_CHECK",
        "BLOOD_TYPE",
        "CORRESPONDENCE_LANGUAGE",
        "FAST_PATH_EMPLOYEE",
        "FTE_CAPACITY",
        "HOLD_APPLICANT_DATE_UNTIL",
        "HONORS",
        "INTERNAL_LOCATION",
        "LAST_MEDICAL_TEST_BY",
        "LAST_MEDICAL_TEST_DATE",
        "MAILSTOP",
        "OFFICE_NUMBER",
        "ON_MILITARY_SERVICE",
        "ORDER_NAME",
        "PRE_NAME_ADJUNCT",
        "PROJECTED_START_DATE",
        "REHIRE_AUTHORIZOR",
        "REHIRE_RECOMMENDATION",
        "RESUME_EXISTS",
        "RESUME_LAST_UPDATED",
        "SECOND_PASSPORT_EXISTS",
        "STUDENT_STATUS",
        "SUFFIX",
        "WORK_SCHEDULE",
        "PER_INFORMATION21",
        "PER_INFORMATION22",
        "PER_INFORMATION23",
        "PER_INFORMATION24",
        "PER_INFORMATION25",
        "PER_INFORMATION26",
        "PER_INFORMATION27",
        "PER_INFORMATION28",
        "PER_INFORMATION29",
        "PER_INFORMATION30",
        "OBJECT_VERSION_NUMBER",
        "DATE_OF_DEATH",
        "REHIRE_REASON",
        "COORD_BEN_MED_PLN_NO",
        "COORD_BEN_NO_CVG_FLAG",
        "DPDNT_ADOPTION_DATE",
        "DPDNT_VLNTRY_SVCE_FLAG",
        "RECEIPT_OF_DEATH_CERT_DATE",
        "USES_TOBACCO_FLAG",
        "BENEFIT_GROUP_ID",
        "ORIGINAL_DATE_OF_HIRE",
        "TOWN_OF_BIRTH",
        "REGION_OF_BIRTH",
        "COUNTRY_OF_BIRTH",
        "GLOBAL_PERSON_ID",
        "COORD_BEN_MED_PL_NAME",
        "COORD_BEN_MED_INSR_CRR_NAME",
        "COORD_BEN_MED_INSR_CRR_IDENT",
        "COORD_BEN_MED_EXT_ER",
        "COORD_BEN_MED_CVG_STRT_DT",
        "COORD_BEN_MED_CVG_END_DT",
        "PARTY_ID",
        "NPW_NUMBER",
        "CURRENT_NPW_FLAG",
        "GLOBAL_NAME",
        "LOCAL_NAME",
        "SYSTEM_PERSON_TYPE",
        "USER_PERSON_TYPE",
        "NAME_TYPE"
    FROM
        emp_bt_mgr_dt_frm
    UNION ALL
    SELECT
        "PERSON_ID",
        "EFFECTIVE_START_DATE",
        "EFFECTIVE_END_DATE",
        "BUSINESS_GROUP_ID",
        "PERSON_TYPE_ID",
        "LAST_NAME",
        "START_DATE",
        "APPLICANT_NUMBER",
        "COMMENT_ID",
        "CURRENT_APPLICANT_FLAG",
        "CURRENT_EMP_OR_APL_FLAG",
        "CURRENT_EMPLOYEE_FLAG",
        "DATE_EMPLOYEE_DATA_VERIFIED",
        "DATE_OF_BIRTH",
        "EMAIL_ADDRESS",
        "EMPLOYEE_NUMBER",
        "EXPENSE_CHECK_SEND_TO_ADDRESS",
        "FIRST_NAME",
        "FULL_NAME",
        "KNOWN_AS",
        "MARITAL_STATUS",
        "MIDDLE_NAMES",
        "NATIONALITY",
        "NATIONAL_IDENTIFIER",
        "PREVIOUS_LAST_NAME",
        "REGISTERED_DISABLED_FLAG",
        "SEX",
        "TITLE",
        "VENDOR_ID",
        "WORK_TELEPHONE",
        "REQUEST_ID",
        "PROGRAM_APPLICATION_ID",
        "PROGRAM_ID",
        "PROGRAM_UPDATE_DATE",
        "ATTRIBUTE_CATEGORY",
        "ATTRIBUTE1",
        "ATTRIBUTE2",
        "ATTRIBUTE3",
        "ATTRIBUTE4",
        "ATTRIBUTE5",
        "ATTRIBUTE6",
        "ATTRIBUTE7",
        "ATTRIBUTE8",
        "ATTRIBUTE9",
        "ATTRIBUTE10",
        "ATTRIBUTE11",
        "ATTRIBUTE12",
        "ATTRIBUTE13",
        "ATTRIBUTE14",
        "ATTRIBUTE15",
        "ATTRIBUTE16",
        "ATTRIBUTE17",
        "ATTRIBUTE18",
        "ATTRIBUTE19",
        "ATTRIBUTE20",
        "ATTRIBUTE21",
        "ATTRIBUTE22",
        "ATTRIBUTE23",
        "ATTRIBUTE24",
        "ATTRIBUTE25",
        "ATTRIBUTE26",
        "ATTRIBUTE27",
        "ATTRIBUTE28",
        "ATTRIBUTE29",
        "ATTRIBUTE30",
        "LAST_UPDATE_DATE",
        "LAST_UPDATED_BY",
        "LAST_UPDATE_LOGIN",
        "CREATED_BY",
        "CREATION_DATE",
        "PER_INFORMATION_CATEGORY",
        "PER_INFORMATION1",
        "PER_INFORMATION2",
        "PER_INFORMATION3",
        "PER_INFORMATION4",
        "PER_INFORMATION5",
        "PER_INFORMATION6",
        "PER_INFORMATION7",
        "PER_INFORMATION8",
        "PER_INFORMATION9",
        "PER_INFORMATION10",
        "PER_INFORMATION11",
        "PER_INFORMATION12",
        "PER_INFORMATION13",
        "PER_INFORMATION14",
        "PER_INFORMATION15",
        "PER_INFORMATION16",
        "PER_INFORMATION17",
        "PER_INFORMATION18",
        "PER_INFORMATION19",
        "PER_INFORMATION20",
        "BACKGROUND_CHECK_STATUS",
        "BACKGROUND_DATE_CHECK",
        "BLOOD_TYPE",
        "CORRESPONDENCE_LANGUAGE",
        "FAST_PATH_EMPLOYEE",
        "FTE_CAPACITY",
        "HOLD_APPLICANT_DATE_UNTIL",
        "HONORS",
        "INTERNAL_LOCATION",
        "LAST_MEDICAL_TEST_BY",
        "LAST_MEDICAL_TEST_DATE",
        "MAILSTOP",
        "OFFICE_NUMBER",
        "ON_MILITARY_SERVICE",
        "ORDER_NAME",
        "PRE_NAME_ADJUNCT",
        "PROJECTED_START_DATE",
        "REHIRE_AUTHORIZOR",
        "REHIRE_RECOMMENDATION",
        "RESUME_EXISTS",
        "RESUME_LAST_UPDATED",
        "SECOND_PASSPORT_EXISTS",
        "STUDENT_STATUS",
        "SUFFIX",
        "WORK_SCHEDULE",
        "PER_INFORMATION21",
        "PER_INFORMATION22",
        "PER_INFORMATION23",
        "PER_INFORMATION24",
        "PER_INFORMATION25",
        "PER_INFORMATION26",
        "PER_INFORMATION27",
        "PER_INFORMATION28",
        "PER_INFORMATION29",
        "PER_INFORMATION30",
        "OBJECT_VERSION_NUMBER",
        "DATE_OF_DEATH",
        "REHIRE_REASON",
        "COORD_BEN_MED_PLN_NO",
        "COORD_BEN_NO_CVG_FLAG",
        "DPDNT_ADOPTION_DATE",
        "DPDNT_VLNTRY_SVCE_FLAG",
        "RECEIPT_OF_DEATH_CERT_DATE",
        "USES_TOBACCO_FLAG",
        "BENEFIT_GROUP_ID",
        "ORIGINAL_DATE_OF_HIRE",
        "TOWN_OF_BIRTH",
        "REGION_OF_BIRTH",
        "COUNTRY_OF_BIRTH",
        "GLOBAL_PERSON_ID",
        "COORD_BEN_MED_PL_NAME",
        "COORD_BEN_MED_INSR_CRR_NAME",
        "COORD_BEN_MED_INSR_CRR_IDENT",
        "COORD_BEN_MED_EXT_ER",
        "COORD_BEN_MED_CVG_STRT_DT",
        "COORD_BEN_MED_CVG_END_DT",
        "PARTY_ID",
        "NPW_NUMBER",
        "CURRENT_NPW_FLAG",
        "GLOBAL_NAME",
        "LOCAL_NAME",
        "SYSTEM_PERSON_TYPE",
        "USER_PERSON_TYPE",
        "NAME_TYPE"
    FROM
        emp_b_mgr_dt_frm
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                emp_bt_mgr_dt_frm
            WHERE
                emp_bt_mgr_dt_frm.person_id = emp_b_mgr_dt_frm.person_id
        )
    UNION ALL
    SELECT
        "PERSON_ID",
        "EFFECTIVE_START_DATE",
        "EFFECTIVE_END_DATE",
        "BUSINESS_GROUP_ID",
        "PERSON_TYPE_ID",
        "LAST_NAME",
        "START_DATE",
        "APPLICANT_NUMBER",
        "COMMENT_ID",
        "CURRENT_APPLICANT_FLAG",
        "CURRENT_EMP_OR_APL_FLAG",
        "CURRENT_EMPLOYEE_FLAG",
        "DATE_EMPLOYEE_DATA_VERIFIED",
        "DATE_OF_BIRTH",
        "EMAIL_ADDRESS",
        "EMPLOYEE_NUMBER",
        "EXPENSE_CHECK_SEND_TO_ADDRESS",
        "FIRST_NAME",
        "FULL_NAME",
        "KNOWN_AS",
        "MARITAL_STATUS",
        "MIDDLE_NAMES",
        "NATIONALITY",
        "NATIONAL_IDENTIFIER",
        "PREVIOUS_LAST_NAME",
        "REGISTERED_DISABLED_FLAG",
        "SEX",
        "TITLE",
        "VENDOR_ID",
        "WORK_TELEPHONE",
        "REQUEST_ID",
        "PROGRAM_APPLICATION_ID",
        "PROGRAM_ID",
        "PROGRAM_UPDATE_DATE",
        "ATTRIBUTE_CATEGORY",
        "ATTRIBUTE1",
        "ATTRIBUTE2",
        "ATTRIBUTE3",
        "ATTRIBUTE4",
        "ATTRIBUTE5",
        "ATTRIBUTE6",
        "ATTRIBUTE7",
        "ATTRIBUTE8",
        "ATTRIBUTE9",
        "ATTRIBUTE10",
        "ATTRIBUTE11",
        "ATTRIBUTE12",
        "ATTRIBUTE13",
        "ATTRIBUTE14",
        "ATTRIBUTE15",
        "ATTRIBUTE16",
        "ATTRIBUTE17",
        "ATTRIBUTE18",
        "ATTRIBUTE19",
        "ATTRIBUTE20",
        "ATTRIBUTE21",
        "ATTRIBUTE22",
        "ATTRIBUTE23",
        "ATTRIBUTE24",
        "ATTRIBUTE25",
        "ATTRIBUTE26",
        "ATTRIBUTE27",
        "ATTRIBUTE28",
        "ATTRIBUTE29",
        "ATTRIBUTE30",
        "LAST_UPDATE_DATE",
        "LAST_UPDATED_BY",
        "LAST_UPDATE_LOGIN",
        "CREATED_BY",
        "CREATION_DATE",
        "PER_INFORMATION_CATEGORY",
        "PER_INFORMATION1",
        "PER_INFORMATION2",
        "PER_INFORMATION3",
        "PER_INFORMATION4",
        "PER_INFORMATION5",
        "PER_INFORMATION6",
        "PER_INFORMATION7",
        "PER_INFORMATION8",
        "PER_INFORMATION9",
        "PER_INFORMATION10",
        "PER_INFORMATION11",
        "PER_INFORMATION12",
        "PER_INFORMATION13",
        "PER_INFORMATION14",
        "PER_INFORMATION15",
        "PER_INFORMATION16",
        "PER_INFORMATION17",
        "PER_INFORMATION18",
        "PER_INFORMATION19",
        "PER_INFORMATION20",
        "BACKGROUND_CHECK_STATUS",
        "BACKGROUND_DATE_CHECK",
        "BLOOD_TYPE",
        "CORRESPONDENCE_LANGUAGE",
        "FAST_PATH_EMPLOYEE",
        "FTE_CAPACITY",
        "HOLD_APPLICANT_DATE_UNTIL",
        "HONORS",
        "INTERNAL_LOCATION",
        "LAST_MEDICAL_TEST_BY",
        "LAST_MEDICAL_TEST_DATE",
        "MAILSTOP",
        "OFFICE_NUMBER",
        "ON_MILITARY_SERVICE",
        "ORDER_NAME",
        "PRE_NAME_ADJUNCT",
        "PROJECTED_START_DATE",
        "REHIRE_AUTHORIZOR",
        "REHIRE_RECOMMENDATION",
        "RESUME_EXISTS",
        "RESUME_LAST_UPDATED",
        "SECOND_PASSPORT_EXISTS",
        "STUDENT_STATUS",
        "SUFFIX",
        "WORK_SCHEDULE",
        "PER_INFORMATION21",
        "PER_INFORMATION22",
        "PER_INFORMATION23",
        "PER_INFORMATION24",
        "PER_INFORMATION25",
        "PER_INFORMATION26",
        "PER_INFORMATION27",
        "PER_INFORMATION28",
        "PER_INFORMATION29",
        "PER_INFORMATION30",
        "OBJECT_VERSION_NUMBER",
        "DATE_OF_DEATH",
        "REHIRE_REASON",
        "COORD_BEN_MED_PLN_NO",
        "COORD_BEN_NO_CVG_FLAG",
        "DPDNT_ADOPTION_DATE",
        "DPDNT_VLNTRY_SVCE_FLAG",
        "RECEIPT_OF_DEATH_CERT_DATE",
        "USES_TOBACCO_FLAG",
        "BENEFIT_GROUP_ID",
        "ORIGINAL_DATE_OF_HIRE",
        "TOWN_OF_BIRTH",
        "REGION_OF_BIRTH",
        "COUNTRY_OF_BIRTH",
        "GLOBAL_PERSON_ID",
        "COORD_BEN_MED_PL_NAME",
        "COORD_BEN_MED_INSR_CRR_NAME",
        "COORD_BEN_MED_INSR_CRR_IDENT",
        "COORD_BEN_MED_EXT_ER",
        "COORD_BEN_MED_CVG_STRT_DT",
        "COORD_BEN_MED_CVG_END_DT",
        "PARTY_ID",
        "NPW_NUMBER",
        "CURRENT_NPW_FLAG",
        "GLOBAL_NAME",
        "LOCAL_NAME",
        "SYSTEM_PERSON_TYPE",
        "USER_PERSON_TYPE",
        "NAME_TYPE"
    FROM
        emp_a_mgr_dt_frm
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                emp_bt_mgr_dt_frm
            WHERE
                emp_bt_mgr_dt_frm.person_id = emp_a_mgr_dt_frm.person_id
        )
            AND NOT EXISTS (
            SELECT
                1
            FROM
                emp_b_mgr_dt_frm
            WHERE
                emp_b_mgr_dt_frm.person_id = emp_a_mgr_dt_frm.person_id
        );
COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_HCM_PERSON_SCOPE_MV" IS
    'snapshot table for snapshot XXMX_CORE.XXMX_HCM_PERSON_SCOPE_MV';
/