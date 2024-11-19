--------------------------------------------------------
--  DDL for Function GETDMESS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "XXMX_CORE"."GETDMESS" (p_businessEntity VARCHAR2, p_subEntity VARCHAR2)
return varchar2
AS 
v_load_name VARCHAR2(500);
BEGIN 

IF( p_businessEntity = 'SUPPLIERS')
THEN 
     v_load_name := p_subEntity;
ELSE 
    v_load_name := p_BusinessEntity;
END IF;

 RETURN v_load_name;
END;

/
