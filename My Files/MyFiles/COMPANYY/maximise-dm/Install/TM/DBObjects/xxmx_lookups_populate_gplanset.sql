INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GOAL PLAN SET'
         ,'GOAL PLAN SET'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--*********************************************************************************/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_SET'
         ,'GOAL PLAN SET'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_SET_PLAN'
         ,'GOAL PLAN SET PLAN'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST'
         ,'GPSET MASS REQUEST'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_ELIGIBILITY_PRO_OBJ'
         ,'GPSET ELIGIBILITY PRO OBJ'
         ,NULL
         ,'Y'
         ,'Y'
         );

--                   
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST_HIERARCHY'
         ,'GPSET MASS REQUEST HIERARCHY'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                   
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST_EXEMPTION'
         ,'GPSET MASS REQUEST EXEMPTION'
         ,NULL
         ,'Y'
         ,'Y'
         );