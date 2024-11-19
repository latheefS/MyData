--------------------------------------------------------
--  DDL for Package XXMX_KIT_NATIONAL_IDENTIFIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_NATIONAL_IDENTIFIER_PKG" AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_national_identifier_pkg.sql
--**
--** PURPOSE   :  This script uses to Transform National Identifier DATA
--**              and Generates HDL file for Worker National Identifer
--**      Note : Before Executing this Script, Insert the Worker National Identifier Details 
--**             from Excel to XXMX_PER_NID_F_STG Table

procedure update_nid_extract_data;

procedure transform_nid_details;

procedure generate_nid_hdl;

end xxmx_kit_national_identifier_pkg;

/
