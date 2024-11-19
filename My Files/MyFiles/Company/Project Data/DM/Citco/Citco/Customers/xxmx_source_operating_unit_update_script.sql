--xxmx_source_operating_units - fusion_business_unit check
select sou.source_operating_unit_name
,sou.fusion_business_unit_name
,fdas.bu_name,fdas.bu_id,sou.fusion_business_unit_id
from xxmx_source_operating_units sou,xxmx_dm_fusion_das fdas
where 1=1
and fdas.bu_name(+)=sou.fusion_business_unit_name;

--update xxmx_source_operating_units from xxmx_dm_fusion_das table
update xxmx_source_operating_units set fusion_business_unit_id = ( select fdas.bu_id from xxmx_dm_fusion_das fdas where fdas.bu_name(+)=sou.fusion_business_unit_name)