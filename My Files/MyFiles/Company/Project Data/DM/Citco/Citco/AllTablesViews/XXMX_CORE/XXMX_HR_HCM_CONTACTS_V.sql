--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_CONTACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_CONTACTS_V" ("C_MIGRATION_STATUS", "C_PERSON_ID", "C_START_DATE", "C_PARTY_ID", "C_CORRESPONDENCE_LANGUAGE", "C_BLOOD_TYPE", "C_DATE_OF_BIRTH", "C_DATE_OF_DEATH", "C_COUNTRY_OF_BIRTH", "C_REGION_OF_BIRTH", "C_TOWN_OF_BIRTH", "C_USER_GUID", "C_NAMETYPE", "C_LAST_NAME", "C_FIRST_NAME", "C_MIDDLE_NAMES", "C_LEGISLATION_CODE", "C_TITLE", "C_PRE_NAME_ADJUNCT", "C_SUFFIX", "C_KNOWN_AS", "C_PREVIOUS_LAST_NAME", "CR_EFFECTIVESTARTDATE", "CR_EFFECTIVEENDDATE", "CR_CONTPERSONID", "CR_RELATEDPERSONID", "CR_RELATEDPERSONNUM", "CR_CONTACTTYPE", "CR_EMERGENCYCONTACTFLAG", "CR_PRIMARYCONTACTFLAG", "CR_EXISTINGPERSON", "CR_PERSONALFLAG", "CR_SEQUENCENUMBER", "CA_MIGRATION_STATUS", "CA_EFFECTIVESTARTDATE", "CA_EFFECTIVEENDDATE", "CA_CONTPERSONID", "CA_ADDRESSTYPE", "CA_ADDRESSLINE1", "CA_ADDRESSLINE2", "CA_ADDRESSLINE3", "CA_TOWNORCITY", "CA_REGION1", "CA_COUNTRY", "CA_POSTALCODE", "CA_PRIMARYFLAG", "CP_MIGRATION_STATUS", "CP_DATEFROM", "CP_DATETO", "CP_CONTPERSONID", "CP_LEGISLATIONCODE", "CP_COUNTRYCODENUMBER", "CP_PHONETYPE", "CP_PHONENUMBER", "CP_PRIMARYFLAG") AS 
  SELECT DISTINCT
         c.migration_status                              c_migration_status
        ,c.person_id                	                 c_person_id
        ,TO_CHAR(c.start_date,'RRRR/MM/DD')              c_start_date
        ,c.party_id                 	                 c_party_id
        ,c.correspondence_language  	                 c_correspondence_language
        ,c.blood_type               	                 c_blood_type
        ,TO_CHAR(c.date_of_birth,'RRRR/MM/DD')           c_date_of_birth
        ,TO_CHAR(c.date_of_death,'RRRR/MM/DD')           c_date_of_death
        ,c.country_of_birth         	                 c_country_of_birth
        ,c.region_of_birth          	                 c_region_of_birth
        ,c.town_of_birth            	                 c_town_of_birth
        ,c.user_guid                	                 c_user_guid
        ,c.nametype                 	                 c_nametype
        ,c.last_name                	                 c_last_name
        ,c.first_name               	                 c_first_name
        ,c.middle_names             	                 c_middle_names
        ,c.legislation_code         	                 c_legislation_code
        ,c.title                    	                 c_title
        ,c.pre_name_adjunct         	                 c_pre_name_adjunct
        ,c.suffix                   	                 c_suffix
        ,c.known_as                 	                 c_known_as
        ,c.previous_last_name       	                 c_previous_last_name
        ,TO_CHAR(cr.effectivestartdate,'RRRR/MM/DD')     cr_effectivestartdate
        ,TO_CHAR(cr.effectiveenddate,'RRRR/MM/DD')       cr_effectiveenddate
        ,cr.contpersonid        	                      cr_contpersonid
        ,cr.relatedpersonid     	                      cr_relatedpersonid
        ,cr.relatedpersonnum    	                      cr_relatedpersonnum
        ,cr.contacttype         	                      cr_contacttype
        ,cr.emergencycontactflag	                      cr_emergencycontactflag
        ,NVL(cr.primarycontactflag,'Y')                   cr_primarycontactflag
        ,cr.existingperson      	                      cr_existingperson
        ,cr.personalflag        	                      cr_personalflag
        ,cr.sequencenumber      	                      cr_sequencenumber
        ,ca.migration_status   	                      ca_migration_status
        ,TO_CHAR(ca.effectivestartdate,'RRRR/MM/DD')     ca_effectivestartdate
        ,TO_CHAR(ca.effectiveenddate,'RRRR/MM/DD')       ca_effectiveenddate
        ,ca.contpersonid       	                      ca_contpersonid
        ,ca.addresstype        	                      ca_addresstype
        ,ca.addressline1       	                      ca_addressline1
        ,ca.addressline2       	                      ca_addressline2
        ,ca.addressline3       	                      ca_addressline3
        ,ca.townorcity         	                      ca_townorcity
        ,ca.region1            	                      ca_region1
        ,ca.country            	                      ca_country
        ,ca.postalcode         	                      ca_postalcode
        ,NVL(ca.primaryflag,'Y')                         ca_primaryflag
        ,cp.migration_status                             cp_migration_status
        ,TO_CHAR(cp.datefrom,'RRRR/MM/DD')               cp_datefrom
        ,TO_CHAR(cp.dateto,'RRRR/MM/DD')                 cp_dateto
        ,cp.contpersonid                                 cp_contpersonid
        ,cp.legislationcode                              cp_legislationcode
        ,cp.countrycodenumber                            cp_countrycodenumber
        ,cp.phonetype           	                      cp_phonetype
        ,cp.phonenumber                                  cp_phonenumber
        ,NVL(cp.primaryflag,'Y')                         cp_primaryflag
    FROM XXMX_PER_CONTACTS_xfm c,
         XXMX_PER_CONTACT_PHONE_xfm cp,
         XXMX_PER_CONTACT_REL_xfm cr,
         XXMX_PER_CONTACT_ADDR_xfm  ca
   WHERE c.person_id   = ca.contpersonid (+)
     AND c.person_id   = cr.contpersonid
     AND c.person_id    = cp.contpersonid   (+)
   order by  cr_relatedpersonnum
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_CONTACTS_V" TO "XXMX_READONLY";
