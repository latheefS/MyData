--------------------------------------------------------
--  DDL for Function XXMX_DM_ESS_SUBENTITY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "XXMX_CORE"."XXMX_DM_ESS_SUBENTITY" (p_businessentity varchar2,p_subentity varchar2)
return varchar2
AS
v_load_name varchar2(100);
BEGIN
    IF (p_businessentity = 'SUPPLIERS' ) THEN 
        v_load_name:= p_subentity;
    ELSE
        v_load_name:=p_businessentity;
    END IF;
    RETURN v_load_name;
END;

--Select * from xxmx_dm_fusion_das a, xxmx_gl_detail_balances_stg b
--where a.das_name = b.ledger_name;

/
