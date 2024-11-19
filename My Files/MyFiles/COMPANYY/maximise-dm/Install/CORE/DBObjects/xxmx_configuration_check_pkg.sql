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
--** FILENAME  :  xxmx_configuration_check_pkg.sql
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
--** PURPOSE   :  This package does the configuration check for all objects in Maximise.
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
--**   1.0  01-FEB-2024  Sinchana Ramesh      Created for Cloudbridge.
--**
--**   1.0  01-FEB-2024  Sinchana Ramesh      Created configuration check package for Cloudbridge.
--**
--******************************************************************************
--
create or replace PACKAGE xxmx_configuration_check_pkg AS
    PROCEDURE check_tables;
    PROCEDURE check_arch_exists;
    PROCEDURE check_populate_exists;
    PROCEDURE check_metadata_entry;
    PROCEDURE check_column_entry;
    PROCEDURE check_file_location_entries;
    PROCEDURE check_directory_entries;
    PROCEDURE check_outbound_file_entries;
END xxmx_configuration_check_pkg;
/

create or replace PACKAGE BODY xxmx_configuration_check_pkg AS
    PROCEDURE check_tables IS
        lv_stg_exists VARCHAR2(200);
        lv_xfm_exists VARCHAR2(200);

    cursor stg_cursor( p_stg_table VARCHAR2) IS
        SELECT CASE WHEN COUNT(*) > 0 THEN 'STG TABLES ARE PRESENT' ELSE 'STG TABLES ARE NOT PRESENT' END
        FROM all_tables
        WHERE owner = 'XXMX_STG'
        AND TABLE_NAME = P_STG_TABLE;


    cursor xfm_cursor( p_xfm_table VARCHAR2)IS
        SELECT CASE WHEN COUNT(*) > 0 THEN 'XFM TABLES ARE PRESENT' ELSE 'XFM TABLES ARE NOT PRESENT' END
        FROM all_tables
        WHERE owner = 'XXMX_XFM'
        AND TABLE_NAME = P_XFM_TABLE;

  CURSOR METADATA_CURSOR IS 
  SELECT  APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,STG_TABLE,XFM_TABLE
  FROM XXMX_MIGRATION_METADATA WHERE ENABLED_FLAG = 'Y' 
  AND STG_TABLE IS NOT NULL
  AND XFM_TABLE IS NOT NULL;

  BEGIN
    FOR REC IN METADATA_CURSOR LOOP
    lv_stg_exists := 'N';
    lv_xfm_exists := 'N';
    OPEN stg_cursor(REC.STG_TABLE);
    FETCH stg_cursor INTO lv_stg_exists;
    CLOSE stg_cursor;
    DBMS_OUTPUT.PUT_LINE('1' || REC.STG_TABLE);

    OPEN xfm_cursor(REC.XFM_TABLE);
    FETCH xfm_cursor INTO lv_xfm_exists;
    CLOSE xfm_cursor;
    DBMS_OUTPUT.PUT_LINE('2' || REC.XFM_TABLE);

            INSERT INTO XXMX_CONFIGURATION_ISSUES (
                APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,  
                stg_table_exists, xfm_table_exists)
                VALUES (
                rec.APPLICATION_SUITE, rec.APPLICATION,
                rec.BUSINESS_ENTITY, rec.SUB_ENTITY,
                lv_stg_exists, lv_xfm_exists
            );
        END LOOP;
        END check_tables;

 PROCEDURE check_arch_exists IS
    lv_stg_arch_exists VARCHAR2(200);
    lv_xfm_arch_exists VARCHAR2(200);

    cursor stg_arch_cursor( p_stg_table VARCHAR2) IS
        SELECT CASE WHEN COUNT(*) > 0 THEN 'STG ARCHIVE TABLES ARE PRESENT' ELSE 'STG ARCHIVE TABLES ARE NOT PRESENT' END
        FROM all_tables
        WHERE owner = 'XXMX_STG'
        AND TABLE_NAME = P_STG_TABLE || '_ARCH';


    cursor xfm_arch_cursor( p_xfm_table VARCHAR2)IS
        SELECT CASE WHEN COUNT(*) > 0 THEN 'XFM ARCHIVE TABLES AREPRESENT' ELSE 'XFM ARCHIVE TABLES ARE NOT PRESENT' END
        FROM all_tables
        WHERE owner = 'XXMX_XFM'
        AND TABLE_NAME = P_XFM_TABLE || '_ARCH';

  CURSOR METADATA_CURSOR IS 
  SELECT BUSINESS_ENTITY,SUB_ENTITY,STG_TABLE,XFM_TABLE
  FROM XXMX_MIGRATION_METADATA WHERE ENABLED_FLAG = 'Y' 
  AND STG_TABLE IS NOT NULL
  AND XFM_TABLE IS NOT NULL;

BEGIN
    FOR REC IN METADATA_CURSOR LOOP
    lv_stg_arch_exists := 'N';
    lv_xfm_arch_exists := 'N';
    OPEN stg_arch_cursor(REC.STG_TABLE);
    FETCH stg_arch_cursor INTO lv_stg_arch_exists;
    CLOSE stg_arch_cursor;
    DBMS_OUTPUT.PUT_LINE('1' || REC.STG_TABLE);

    OPEN xfm_arch_cursor(REC.XFM_TABLE);
    FETCH xfm_arch_cursor INTO lv_xfm_arch_exists;
    CLOSE xfm_arch_cursor;
    DBMS_OUTPUT.PUT_LINE('2' || REC.XFM_TABLE);

    UPDATE xxmx_configuration_issues 
    SET stg_arch_exists = lv_stg_arch_exists,xfm_arch_exists = lv_xfm_arch_exists
    where BUSINESS_ENTITY =  REC.BUSINESS_ENTITY
    AND SUB_ENTITY = REC.SUB_ENTITY;

    COMMIT;
    end loop;
END check_arch_exists;

PROCEDURE check_populate_exists IS
    lv_stg_populate_exists VARCHAR2(200);
    lv_xfm_populate_exists VARCHAR2(200);

    cursor stg_populate_cursor( p_stg_table VARCHAR2) IS
    SELECT CASE WHEN COUNT(*) > 0 THEN 'PRESENT' ELSE 'NOT PRESENT' END
    FROM XXMX_STG_TABLES
    WHERE TABLE_NAME = P_STG_TABLE
    AND STG_TABLE_ID is not null;


    cursor xfm_populate_cursor( p_xfm_table VARCHAR2)IS
    SELECT CASE WHEN COUNT(*) > 0 THEN 'PRESENT' ELSE 'NOT PRESENT' END
    FROM XXMX_XFM_TABLES
    WHERE TABLE_NAME =P_XFM_TABLE
    AND XFM_TABLE_ID is not null;

  CURSOR POPULATE_CURSOR IS 
  SELECT BUSINESS_ENTITY,SUB_ENTITY,STG_TABLE,XFM_TABLE
  FROM XXMX_MIGRATION_METADATA WHERE ENABLED_FLAG = 'Y' 
  AND STG_TABLE IS NOT NULL
  AND XFM_TABLE IS NOT NULL;

BEGIN
    FOR REC IN POPULATE_CURSOR LOOP
    lv_stg_populate_exists := 'N';
    lv_xfm_populate_exists := 'N';
    OPEN stg_populate_cursor(REC.STG_TABLE);
    FETCH stg_populate_cursor INTO lv_stg_populate_exists;
    CLOSE stg_populate_cursor;
    DBMS_OUTPUT.PUT_LINE('1' || REC.STG_TABLE);

    OPEN xfm_populate_cursor(REC.XFM_TABLE);
    FETCH xfm_populate_cursor INTO lv_xfm_populate_exists;
    CLOSE xfm_populate_cursor;
    DBMS_OUTPUT.PUT_LINE('2' || REC.XFM_TABLE);

    UPDATE xxmx_configuration_issues 
    SET stg_populate_exists = lv_stg_populate_exists,xfm_populate_exists = lv_xfm_populate_exists
    where BUSINESS_ENTITY =  REC.BUSINESS_ENTITY
    AND SUB_ENTITY = REC.SUB_ENTITY;
    COMMIT;
    end loop;
END check_populate_exists;

PROCEDURE check_metadata_entry IS
    lv_metadata_entry_exists VARCHAR2(200);

    CURSOR stg_xfm_cursor(p_metadata_id NUMBER) IS
        SELECT
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM all_tables at
                    JOIN XXMX_MIGRATION_METADATA mm ON at.TABLE_NAME = mm.STG_TABLE
                    WHERE at.owner = 'XXMX_STG'
                    AND mm.METADATA_ID = p_metadata_id
                )
                AND EXISTS (
                    SELECT 1
                    FROM all_tables at
                    JOIN XXMX_MIGRATION_METADATA mm ON at.TABLE_NAME = mm.XFM_TABLE
                    WHERE at.owner = 'XXMX_XFM'
                    AND mm.METADATA_ID = p_metadata_id
                )
                THEN 'METADATA ENTRY, STG AND XFM TABLES ARE PRESENT'
                ELSE 'METADATA ENTRY IS PRESENT BUT STG AND XFM TABLES ARE NOT PRESENT'
            END AS STATUS
        FROM DUAL;

    CURSOR METADATA_CURSOR IS
        SELECT
            METADATA_ID,
            APPLICATION_SUITE,
            APPLICATION,
            BUSINESS_ENTITY,
            SUB_ENTITY,
            STG_TABLE,
            XFM_TABLE
        FROM
            XXMX_MIGRATION_METADATA
        WHERE
            ENABLED_FLAG = 'Y'
            AND STG_TABLE IS NOT NULL
            AND XFM_TABLE IS NOT NULL;

BEGIN
    FOR REC IN METADATA_CURSOR LOOP
        lv_metadata_entry_exists := 'N';

        BEGIN
            OPEN stg_xfm_cursor(REC.METADATA_ID);
            FETCH stg_xfm_cursor INTO lv_metadata_entry_exists;
            CLOSE stg_xfm_cursor;

            UPDATE XXMX_CONFIGURATION_ISSUES
            SET METADATA_ENTRY = lv_metadata_entry_exists
            WHERE BUSINESS_ENTITY = REC.BUSINESS_ENTITY
            AND SUB_ENTITY = REC.SUB_ENTITY;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END check_metadata_entry;

PROCEDURE check_column_entry AS
    lv_column_entry_exists VARCHAR2(200);

    CURSOR stg_xfm_table_cursor IS
        SELECT
            mm.BUSINESS_ENTITY,
            mm.SUB_ENTITY,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM all_tables STG, all_tables XFM, XXMX_STG_TABLE_COLUMNS STG_COL, XXMX_XFM_TABLE_COLUMNS XFM_COL
                    WHERE STG.owner = 'XXMX_STG'
                    AND STG.table_name = mm.STG_TABLE
                    AND XFM.owner = 'XXMX_XFM'
                    AND XFM.table_name = mm.XFM_TABLE
                    AND STG_COL.STG_TABLE_ID = XFM_COL.XFM_TABLE_ID
                    AND STG_COL.column_name = XFM_COL.column_name
                ) THEN 'MATCHING'
                ELSE 'NOT MATCHING'
            END AS STATUS
        FROM XXMX_MIGRATION_METADATA mm;

BEGIN
    FOR REC IN stg_xfm_table_cursor LOOP
        lv_column_entry_exists := REC.STATUS;

        UPDATE XXMX_CONFIGURATION_ISSUES ci
        SET ci.COLUMN_STATUS = lv_column_entry_exists
        WHERE ci.BUSINESS_ENTITY = REC.BUSINESS_ENTITY
        AND ci.SUB_ENTITY = REC.SUB_ENTITY;

        COMMIT;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        NULL; 
END check_column_entry;

PROCEDURE check_file_location_entries AS

    CURSOR METADATA_CURSOR IS
    SELECT business_entity
    FROM xxmx_migration_metadata
    WHERE enabled_flag = 'Y';

BEGIN
  FOR migration_rec IN METADATA_CURSOR LOOP
    DECLARE
      v_count NUMBER;
    BEGIN
      SELECT COUNT(*)
      INTO v_count
      FROM xxmx_file_locations
      WHERE business_entity = migration_rec.business_entity;


      IF v_count > 0 THEN
        UPDATE xxmx_configuration_issues
        SET FILE_LOCATION_STATUS = 'Present'
        WHERE business_entity = migration_rec.business_entity;

      ELSE

        UPDATE xxmx_configuration_issues
        SET FILE_LOCATION_STATUS = 'Not Present'
        WHERE business_entity = migration_rec.business_entity;
      END IF;
    END;
  END LOOP;
  COMMIT; 
END check_file_location_entries;

PROCEDURE check_directory_entries AS
BEGIN
    FOR metadata_rec IN (SELECT DIRECTORY_NAME FROM ALL_DIRECTORIES) LOOP

        DECLARE
            v_directory_count NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO v_directory_count
            FROM XXMX_MIGRATION_METADATA
            WHERE business_entity = metadata_rec.DIRECTORY_NAME;


            IF v_directory_count > 0 THEN

                UPDATE XXMX_CONFIGURATION_ISSUES
                SET directory_status = 'PRESENT'
                WHERE business_entity = metadata_rec.DIRECTORY_NAME;
            ELSE

                UPDATE XXMX_CONFIGURATION_ISSUES
                SET directory_status = 'NOT PRESENT'
                WHERE business_entity = metadata_rec.DIRECTORY_NAME;
            END IF;
        END;
    END LOOP;
END check_directory_entries; 

PROCEDURE check_outbound_file_entries AS
BEGIN

    FOR rec IN (SELECT COLUMN_NAME, include_in_outbound_file
                FROM xxmx_xfm_table_columns) LOOP
        -- Checking if include_in_outbound_file is 'Y' or not
        IF rec.include_in_outbound_file = 'Y' THEN
            UPDATE xxmx_configuration_issues
            SET INCLUDE_IN_OUTBOUND_FILE_STATUS = 'Y';

        ELSE
            UPDATE xxmx_configuration_issues
            SET INCLUDE_IN_OUTBOUND_FILE_STATUS = 'N';

        END IF;
    END LOOP;
END check_outbound_file_entries;
END xxmx_configuration_check_pkg;
/

