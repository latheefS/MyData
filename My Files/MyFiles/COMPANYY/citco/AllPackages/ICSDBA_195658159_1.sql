--------------------------------------------------------
--  DDL for Package Body ICSDBA_195658159
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."ICSDBA_195658159" IS
FUNCTION xxmx_utilities_pkg$call_fusio (PV_I_APPLICATION_SUITE VARCHAR2,
PT_I_BUSINESSENTITY VARCHAR2,
PT_I_SUB_ENTITY VARCHAR2
) RETURN INTEGER IS
RETURN_ INTEGER;
BEGIN
RETURN_ := SYS.SQLJUTL.BOOL2INT(XXMX_CORE.XXMX_UTILITIES_PKG.CALL_FUSION_LOAD_GEN(PV_I_APPLICATION_SUITE,
PT_I_BUSINESSENTITY,
PT_I_SUB_ENTITY
));
return RETURN_;
END xxmx_utilities_pkg$call_fusio;
END ICSDBA_195658159;

/
