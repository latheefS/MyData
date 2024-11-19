--------------------------------------------------------
--  DDL for View XXMX_PPM_BILLING_EVENTS_CSV_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_BILLING_EVENTS_CSV_V" ("OUTPUT") AS 
  SELECT
              '"'||sourcename                               ||'"'||','                              --sourcename               
            ||'"'||sourceref                                ||'"'||','                              --sourceref                
            ||'"'||(select max(p.organization_name) from xxmx_ppm_projects_xfm p where e.project_number = p.project_number) ||'"'||','   --organization_name        
            ||'"'||contract_type_name                       ||'"'||','                              --contract_type_name       
            ||'"'||contract_number                          ||'"'||','                              --contract_number          
            ||'"'||contract_line_number                     ||'"'||','                              --contract_line_number     
            ||'"'||event_type_name                          ||'"'||','                              --event_type_name          
            ||'"'||event_desc                               ||'"'||','                              --event_desc               
            ||'"'|| to_char(to_date(e.completion_date, 'DD-MON-YY'), 'MM/DD/YYYY')     ||'"'||','                              --completion_date          
            ||'"'||bill_trns_currency_code                  ||'"'||','                              --bill_trns_currency_code  
            ||'"'||bill_trns_amount                         ||'"'||','                              --bill_trns_amount         
            ||'"'||project_number                           ||'"'||','                              --project_number           
            ||'"'||task_number                              ||'"'||','                              --task_number              
            ||'"'||bill_hold_flag                           ||'"'||','                              --bill_hold_flag           
            ||'"'||revenue_hold_flag                        ||'"'||','                              --revenue_hold_flag        
            ||'"'||''                       ||'"'||','                              --attribute_category       
            ||'"'||attribute1                               ||'"'||','                              --attribute1               
            ||'"'||attribute2                               ||'"'||','                              --attribute2               
            ||'"'||attribute3                               ||'"'||','                              --attribute3               
            ||'"'||attribute4                               ||'"'||','                              --attribute4               
            ||'"'||attribute5                               ||'"'||','                              --attribute5               
            ||'"'||attribute6                               ||'"'||','                              --attribute6               
            ||'"'||attribute7                               ||'"'||','                              --attribute7               
            ||'"'||attribute8                               ||'"'||','                              --attribute8               
            ||'"'||attribute9                               ||'"'||','                              --attribute9               
            ||'"'||attribute10                                ||'"'||','  
            ||'"'||ATTRIBUTE_CHAR11||'"'||','
||'"'||ATTRIBUTE_CHAR12       ||'"'||','
||'"'||ATTRIBUTE_CHAR13       ||'"'||','
||'"'||ATTRIBUTE_CHAR14       ||'"'||','
||'"'||ATTRIBUTE_CHAR15       ||'"'||','
||'"'||ATTRIBUTE_CHAR16       ||'"'||','
||'"'||ATTRIBUTE_CHAR17       ||'"'||','
||'"'||ATTRIBUTE_CHAR18       ||'"'||','
||'"'||ATTRIBUTE_CHAR19       ||'"'||','
||'"'||ATTRIBUTE_CHAR20       ||'"'||','
||'"'||ATTRIBUTE_CHAR21  ||'"'||','
||'"'||ATTRIBUTE_CHAR22      ||'"'||','
||'"'||ATTRIBUTE_CHAR23      ||'"'||','
||'"'||ATTRIBUTE_CHAR24      ||'"'||','
||'"'||ATTRIBUTE_CHAR25      ||'"'||','
||'"'||ATTRIBUTE_CHAR26      ||'"'||','
||'"'||ATTRIBUTE_CHAR27      ||'"'||','
||'"'||ATTRIBUTE_CHAR28      ||'"'||','
||'"'||ATTRIBUTE_CHAR29      ||'"'||','
||'"'||ATTRIBUTE_CHAR30      ||'"'||','
||'"'||ATTRIBUTE_NUMBER1      ||'"'||','
||'"'||ATTRIBUTE_NUMBER2      ||'"'||','
||'"'||ATTRIBUTE_NUMBER3      ||'"'||','
||'"'||ATTRIBUTE_NUMBER4      ||'"'||','
||'"'||ATTRIBUTE_NUMBER5      ||'"'||','
||'"'||ATTRIBUTE_NUMBER6      ||'"'||','
||'"'||ATTRIBUTE_NUMBER7      ||'"'||','
||'"'||ATTRIBUTE_NUMBER8      ||'"'||','
||'"'||ATTRIBUTE_NUMBER9      ||'"'||','
||'"'||ATTRIBUTE_NUMBER10     ||'"'||','
||'"'||ATTRIBUTE_DATE1       ||'"'||','
||'"'||  to_char(e.ATTRIBUTE_DATE2, 'MM/DD/YYYY')   ||'"'||','
||'"'||ATTRIBUTE_DATE3      ||'"'||','
||'"'||ATTRIBUTE_DATE4         ||'"'||','
||'"'||ATTRIBUTE_DATE5    ||'"'||','
||'"'||ATTRIBUTE_DATE6    ||'"'||','
||'"'||ATTRIBUTE_DATE7    ||'"'||','
||'"'||ATTRIBUTE_DATE8    ||'"'||','
||'"'||ATTRIBUTE_DATE9    ||'"'||','
||'"'||ATTRIBUTE_DATE10   ||'"'||','
||'"'||ATTRIBUTE_TIMESTAMP1  ||'"'||','
||'"'||ATTRIBUTE_TIMESTAMP2  ||'"'||','
||'"'||ATTRIBUTE_TIMESTAMP3  ||'"'||','
||'"'||ATTRIBUTE_TIMESTAMP4  ||'"'||','
||'"'||ATTRIBUTE_TIMESTAMP5  ||'"'||','
||'"'||REVERSE_ACCRUAL_FLAG    ||'"'||','
||'"'||ITEM_EVENT_FLAG         ||'"'||','
||'"'||QUANTITY                ||'"'||','
||'"'||ITEM_NUMBER  ||'"'||','
||'"'||UNIT_OF_MEASURE 	    ||'"'||','
||'"'||UNIT_PRICE||'"' 			    
        output
    FROM
        xxmx_PPM_prj_billevent_xfm e
    where attribute10 = 'OPEN_AR_1'
    and sourceref in (
    'TAX-CONV_TAX-62302300219',
'TAX-CONV_TAX-62302300221',
'TAX-CONV_TAX-62302300213',
'TAX-CONV_TAX-62302300245',
'TAX-CONV_TAX-62302300231',
'TAX-CONV_TAX-62302300232',
'TAX-CONV_TAX-62302300230',
'TAX-CONV_TAX-62302300239',
'TAX-CONV_TAX-62302300246',
'TAX-CONV_TAX-62302300238',
'TAX-CONV_TAX-62302300240',
'TAX-CONV_TAX-27502300763',
'TAX-CONV_TAX-62302300258',
'TAX-CONV_TAX-62302300260',
'TAX-CONV_TAX-62302300259',
'TAX-CONV_TAX-27502300795',
'TAX-CONV_TAX-27502300829',
'TAX-CONV_TAX-27502300828',
'TAX-CONV_TAX-27502300836',
'TAX-CONV_TAX-27502300833',
'TAX-CONV_TAX-27502300834',
'TAX-CONV_TAX-27502300835',
'TAX-CONV_TAX-62302200153',
'TAX-CONV_TAX-62302200264',
'TAX-CONV_TAX-62302300037',
'TAX-CONV_TAX-62302300101',
'TAX-CONV_TAX-62302300114',
'TAX-CONV_TAX-62302300130',
'TAX-CONV_TAX-62302300173',
'TAX-CONV_TAX-62302300175',
'TAX-CONV_TAX-62302300176',
'TAX-CONV_TAX-62302300157',
'TAX-CONV_TAX-62302300161',
'TAX-CONV_TAX-24002300066',
'TAX-CONV_TAX-31602200153',
'TAX-CONV_TAX-31602300130',
'TAX-CONV_TAX-31602300144',
'TAX-CONV_TAX-31602300168',
'TAX-CONV_TAX-31602300167',
'TAX-CONV_TAX-62302300155',
'TAX-CONV_TAX-62302300197',
'TAX-CONV_TAX-62302300189',
'TAX-CONV_TAX-62302300217',
'TAX-CONV_TAX-62302300214',
'TAX-CONV_TAX-62302300220',
'TAX-CONV_TAX-24002300056',
'TAX-CONV_TAX-24002300059',
'TAX-CONV_TAX-24002300057',
'TAX-CONV_TAX-24002300072',
'TAX-CONV_TAX-24002300073',
'TAX-CONV_TAX-24002300076',
'TAX-CONV_TAX-24002300077',
'TAX-CONV_TAX-44212202784',
'TAX-CONV_TAX-44212202783',
'TAX-CONV_TAX-44212202781',
'TAX-CONV_TAX-44212202782',
'TAX-CONV_TAX-44212203056',
'TAX-CONV_TAX-62302300183',
'TAX-CONV_TAX-22502300042',
'TAX-CONV_TAX-22502300577',
'TAX-CONV_TAX-22502300578',
'TAX-CONV_TAX-22502300582',
'TAX-CONV_TAX-22502300566',
'TAX-CONV_TAX-22502300569',
'TAX-CONV_TAX-22502300647',
'TAX-CONV_TAX-22502300654',
'TAX-CONV_TAX-22502300644',
'TAX-CONV_TAX-27502300608',
'TAX-CONV_TAX-62302300172',
'TAX-CONV_TAX-31602300118',
'TAX-CONV_TAX-24002300058',
'TAX-CONV_TAX-24002300064',
'TAX-CONV_TAX-24002300062',
'TAX-CONV_TAX-24002300063',
'TAX-CONV_TAX-24002300065',
'TAX-CONV_TAX-24002300067',
'TAX-CONV_TAX-24002300068',
'TAX-CONV_TAX-24002300069',
'TAX-CONV_TAX-24002300071',
'TAX-CONV_TAX-24002300074',
'TAX-CONV_TAX-24002300075',
'TAX-CONV_TAX-24002300070',
'TAX-CONV_TAX-29002300008',
'TAX-CONV_TAX-62302200158',
'16059902-INV',
'16000709-INV'
)
    --and e.reverse_accrual_flag = 'Y'
    --and rownum < 2
    --and sourceref != '13433079-REVACC'
;
