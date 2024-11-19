create or replace PACKAGE xxmx_hdl_utilities_pkg
IS
     --
     --
     --***************
     --** GLOBAL TYPES
     --***************
     --
     TYPE g_ParamValueList_tt               IS TABLE OF xxmx_migration_parameters.parameter_value%TYPE;
     --
     --*******************
     --** GLOBAL CONSTANTS
     --*******************
     --
     --
     --*******************
     --** GLOBAL VARIABLES
     --*******************
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     gvv_UserName                                       VARCHAR2(100)   := UPPER(sys_context('userenv','OS_USER'));
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     gcn_BulkCollectLimit                      CONSTANT NUMBER := 1000;    
     --
     --**************************************
     --** PROCEDURE AND FUNCTION DECLARATIONS
     --**************************************
     --
     --**************************************************************
     --** The following PROCEDURE returns all the filenames and 
	 --** directories required for migrating the data associated
	 --** associated with the related business/sub entity.
     --*************************************************************
     --
     --** END PROCEDURE get_file_and_directory_details

-- ----------------------------------------------------------------------------
-- |------------------------------< DIR_PATH >--------------------------------|
-- ----------------------------------------------------------------------------
  FUNCTION get_directory_path
            (pv_i_application_suite IN VARCHAR2
            ,pv_i_application IN VARCHAR2
            ,pv_i_business_entity IN VARCHAR2
            ,pv_i_file_location_type IN VARCHAR2
            ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N'
            ) RETURN VARCHAR2;


-- ----------------------------------------------------------------------------
-- |------------------------------< GET_FILENAME >--------------------------------|
-- ----------------------------------------------------------------------------
  FUNCTION get_filename
            (pv_i_application_suite IN VARCHAR2
            ,pv_i_application       IN VARCHAR2
            ,pv_i_business_entity   IN VARCHAR2
            ,pv_i_sub_entity        IN VARCHAR2
            ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N'
            ) RETURN VARCHAR2; 
-- ----------------------------------------------------------------------------
-- |------------------------------< OPEN_HDL >--------------------------------|
-- ----------------------------------------------------------------------------
  PROCEDURE open_hdl
                   (pv_i_client_code     IN VARCHAR2
                   ,pv_i_business_entity IN VARCHAR2
                   ,pv_i_file_name       IN VARCHAR2
                   ,pv_i_directory_name  IN VARCHAR2
                   ,pv_i_file_type       IN VARCHAR2 DEFAULT 'M'
                   ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N');


-- ----------------------------------------------------------------------------
-- |-----------------------------< WRITE_HDR_HEADER >-------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE write_hdr (pv_i_client           IN VARCHAR2
                    ,pv_i_business_entity  IN VARCHAR2
                    ,pv_i_file_name        IN VARCHAR2
                    ,pv_i_file_type        IN VARCHAR2 DEFAULT 'M'
                    ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N');
-- ----------------------------------------------------------------------------
-- |-----------------------------< WRITE_HDL_LINE >---------------------------|
-- ----------------------------------------------------------------------------
--
     PROCEDURE write_hdl_line (pv_i_file_name      IN VARCHAR2  
                    ,pv_i_line_type      IN VARCHAR2  
                    ,pv_line_name        IN VARCHAR2  
                    ,pv_i_line_content   IN VARCHAR2
                    ,pv_i_file_type      IN VARCHAR2 DEFAULT 'M'
                    ,pv_mode             IN VARCHAR2 DEFAULT 'N'
                    ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N');

-- ----------------------------------------------------------------------------
-- |-----------------------------< CLOSE_HDL >--------------------------------|
-- ----------------------------------------------------------------------------
--
     PROCEDURE close_hdl (p_file_type in varchar2 default 'M'
                          ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N');     
     --
     --
END xxmx_hdl_utilities_pkg;
/
