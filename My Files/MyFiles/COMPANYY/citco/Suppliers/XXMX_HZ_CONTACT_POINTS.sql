CREATE TABLE XXMX_HZ_CONTACT_POINTS
AS SELECT *
                   FROM APPS.HZ_CONTACT_POINTS@XXMX_EXTRACT CP_PHONE
                  WHERE     1 = 1
                        AND CP_PHONE.OWNER_TABLE_NAME = 'HZ_PARTY_SITES'                    
                        AND CP_PHONE.CONTACT_POINT_TYPE  IN ( 'PHONE','EMAIL');