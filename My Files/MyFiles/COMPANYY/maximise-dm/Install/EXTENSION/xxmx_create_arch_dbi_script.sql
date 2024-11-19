DECLARE
    CURSOR c_stg_table 
	 IS
	SELECT DISTINCT stg_table
      FROM XXMX_CORE.xxmx_migration_metadata mm
	  WHERE EXISTS (SELECT 1 
					  FROM all_objects ao 
					 WHERE ao.object_type = 'TABLE'
					   AND ao.object_name = UPPER(mm.stg_table)
                       AND ao.owner= 'XXMX_STG'
                    )
	AND NOT  EXISTS (SELECT 1 
					  FROM all_objects ao 
					 WHERE ao.object_type = 'TABLE'
 					   AND ao.object_name = UPPER(mm.STG_table)||'_ARCH'
                       AND ao.owner= 'XXMX_STG'
                    );

    CURSOR c_xfm_table 
	 IS
	SELECT DISTINCT xfm_table
      FROM XXMX_CORE.xxmx_migration_metadata mm
     WHERE  EXISTS (SELECT 1 
					  FROM all_objects ao 
					 WHERE ao.object_type = 'TABLE'
 					   AND ao.object_name = UPPER(mm.xfm_table)
                       AND ao.owner= 'XXMX_XFM'
                    )
	AND NOT  EXISTS (SELECT 1 
					  FROM all_objects ao 
					 WHERE ao.object_type = 'TABLE'
 					   AND ao.object_name = UPPER(mm.xfm_table)||'_ARCH'
                       AND ao.owner= 'XXMX_XFM'
                    );

BEGIN
--STG
    FOR r_table IN c_stg_table LOOP
    
       /*EXECUTE IMMEDIATE 'DROP TABLE xxmx_stg.'
        || r_table.stg_table
        || '_ARCH';*/
        EXECUTE IMMEDIATE 'CREATE TABLE xxmx_stg.'
        || r_table.stg_table
        || '_ARCH AS SELECT * FROM xxmx_stg.'
        || r_table.stg_table
        || ' WHERE 1=2';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM '
        || r_table.stg_table
        || '_ARCH FOR '
        || 'xxmx_stg.'
        || r_table.stg_table
        || '_ARCH';
		
		execute immediate 'GRANT ALL ON XXMX_STG.'|| r_table.stg_table|| '_ARCH TO PUBLIC';
    END LOOP;
--XFM

    FOR r_table IN c_xfm_table LOOP
       /* EXECUTE IMMEDIATE 'DROP TABLE xxmx_XFM.'
        || r_table.xfm_table
        || '_ARCH';*/
        EXECUTE IMMEDIATE 'CREATE TABLE  xxmx_XFM.'
        || r_table.xfm_table
        || '_ARCH AS SELECT * FROM  xxmx_XFM.'
        || r_table.xfm_table
        || ' WHERE 1=2';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM '
        || r_table.xfm_table
        || '_ARCH FOR '
        || 'xxmx_xfm.'
        || r_table.xfm_table
        || '_ARCH';
		execute immediate 'GRANT ALL ON XXMX_XFM.'|| r_table.xfm_table|| '_ARCH TO PUBLIC';
    END LOOP;

END;
/
