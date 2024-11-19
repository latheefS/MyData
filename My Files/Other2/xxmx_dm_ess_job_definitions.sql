INSERT
INTO    xxmx_dm_ess_job_definitions
         (
          ITERATION
         ,IMPORTPROCESSNAME
         ,LOAD_NAME
         ,JOB_PACKAGE
         ,JOB_DEFINITION
         ,PARAM_COUNT
         ,PARAMETER1
		 ,PARAMETER2
         )
VALUES
         (
          'SIT'
         ,'Import Historical Rates'
         ,'HISTORICAL_RATES'
         ,'/oracle/apps/ess/financials/generalLedger/programs/common/'
         ,'AssignHistoricalRates'
         ,2
         ,'All'
		 ,'All'
         );