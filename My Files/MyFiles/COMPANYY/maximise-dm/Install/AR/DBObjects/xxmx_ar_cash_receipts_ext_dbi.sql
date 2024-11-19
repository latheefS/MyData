EXEC DropTable ('XXMX_AR_CASH_RECEIPTS_EXT')
--
CREATE TABLE XXMX_CORE.XXMX_AR_CASH_RECEIPTS_EXT
     (
        file_set_id                      VARCHAR2(30)
        ,migration_set_id                NUMBER                
        ,migration_set_name              VARCHAR2(100)  
        ,migration_status 		         VARCHAR2(50)
        ,record_type                     VARCHAR2(2)    
        ,record_seq                      NUMBER         
        ,operating_unit_name             VARCHAR2(240)  
        ,batch_name                      VARCHAR2(25)            
        ,item_number                     NUMBER                  
        ,remittance_amount               NUMBER                  
        ,transit_routing_number          VARCHAR2(25)            
        ,customer_bank_account           VARCHAR2(30)            
        ,receipt_number                  VARCHAR2(30)            
        ,receipt_date                    VARCHAR2(20)
        ,currency_code                   VARCHAR2(15)            
        ,lockbox_number                  VARCHAR2(30)
        ,lockbox_batch_count             NUMBER          
        ,lockbox_record_count            NUMBER          
        ,lockbox_amount                  NUMBER
        ,exchange_rate_type              VARCHAR2(30)            
        ,exchange_rate                   NUMBER                  
        ,customer_number                 VARCHAR2(30)            
        ,bill_to_location                VARCHAR2(40)            
        ,customer_bank_branch_name       VARCHAR2(320)           
        ,customer_bank_name              VARCHAR2(320)           
        ,receipt_method                  VARCHAR2(30)            
        ,remittance_bank_branch_name     VARCHAR2(320)           
        ,remittance_bank_name            VARCHAR2(320)           
        ,deposit_date                    VARCHAR2(20)
        ,deposit_time                    VARCHAR2(8)             
        ,anticipated_clearing_date       VARCHAR2(20)
        ,invoice1                        VARCHAR2(50)            
        ,invoice1_installment            NUMBER                  
        ,matching1_date                  VARCHAR2(20)
        ,invoice_currency_code1          VARCHAR2(15)            
        ,trans_to_receipt_rate1          NUMBER                  
        ,amount_applied1                 NUMBER                  
        ,amount_applied_from1            NUMBER                  
        ,customer_reference1             VARCHAR2(100)           
        ,invoice2                        VARCHAR2(50)            
        ,invoice2_installment            NUMBER                  
        ,matching2_date                  VARCHAR2(20)
        ,invoice_currency_code2          VARCHAR2(15)            
        ,trans_to_receipt_rate2          NUMBER                  
        ,amount_applied2                 NUMBER                  
        ,amount_applied_from2            NUMBER                  
        ,customer_reference2             VARCHAR2(100)           
        ,invoice3                        VARCHAR2(50)            
        ,invoice3_installment            NUMBER                  
        ,matching3_date                  VARCHAR2(20)
        ,invoice_currency_code3          VARCHAR2(15)            
        ,trans_to_receipt_rate3          NUMBER                  
        ,amount_applied3                 NUMBER                  
        ,amount_applied_from3            NUMBER                  
        ,customer_reference3             VARCHAR2(100)           
        ,invoice4                        VARCHAR2(50)            
        ,invoice4_installment            NUMBER                  
        ,matching4_date                  VARCHAR2(20)
        ,invoice_currency_code4          VARCHAR2(15)            
        ,trans_to_receipt_rate4          NUMBER                  
        ,amount_applied4                 NUMBER                  
        ,amount_applied_from4            NUMBER                  
        ,customer_reference4             VARCHAR2(100)           
        ,invoice5                        VARCHAR2(50)            
        ,invoice5_installment            NUMBER                  
        ,matching5_date                  VARCHAR2(20)
        ,invoice_currency_code5          VARCHAR2(15)            
        ,trans_to_receipt_rate5          NUMBER                  
        ,amount_applied5                 NUMBER                  
        ,amount_applied_from5            NUMBER                  
        ,customer_reference5             VARCHAR2(100)           
        ,invoice6                        VARCHAR2(50)            
        ,invoice6_installment            NUMBER                  
        ,matching6_date                  VARCHAR2(20)
        ,invoice_currency_code6          VARCHAR2(15)            
        ,trans_to_receipt_rate6          NUMBER                  
        ,amount_applied6                 NUMBER                  
        ,amount_applied_from6            NUMBER                  
        ,customer_reference6             VARCHAR2(100)           
        ,invoice7                        VARCHAR2(50)            
        ,invoice7_installment            NUMBER                  
        ,matching7_date                  VARCHAR2(20)
        ,invoice_currency_code7          VARCHAR2(15)            
        ,trans_to_receipt_rate7          NUMBER                  
        ,amount_applied7                 NUMBER                  
        ,amount_applied_from7            NUMBER                  
        ,customer_reference7             VARCHAR2(100)           
        ,invoice8                        VARCHAR2(50)            
        ,invoice8_installment            NUMBER                  
        ,matching8_date                  VARCHAR2(20)
        ,invoice_currency_code8          VARCHAR2(15)            
        ,trans_to_receipt_rate8          NUMBER                  
        ,amount_applied8                 NUMBER                  
        ,amount_applied_from8            NUMBER                  
        ,customer_reference8             VARCHAR2(100)           
        ,comments                        VARCHAR2(240)           
        ,attribute1                      VARCHAR2(150)           
        ,attribute2                      VARCHAR2(150)           
        ,attribute3                      VARCHAR2(150)           
        ,attribute4                      VARCHAR2(150)           
        ,attribute5                      VARCHAR2(150)           
        ,attribute6                      VARCHAR2(150)           
        ,attribute7                      VARCHAR2(150)           
        ,attribute8                      VARCHAR2(150)           
        ,attribute9                      VARCHAR2(150)           
        ,attribute10                     VARCHAR2(150)           
        ,attribute11                     VARCHAR2(150)           
        ,attribute12                     VARCHAR2(150)           
        ,attribute13                     VARCHAR2(150)           
        ,attribute14                     VARCHAR2(150)           
        ,attribute15                     VARCHAR2(150)           
        ,attribute_category              VARCHAR2(30)             
  )
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AR_CASH_RECEIPTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AR_CASH_RECEIPTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ; 
 
--
--