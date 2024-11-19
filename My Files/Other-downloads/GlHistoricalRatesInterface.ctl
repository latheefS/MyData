-- +=========================================================================+
-- | $Header: fusionapps/fin/gl/bin/GlHistoricalRatesInterface.ctl /st_fusionapps_pt-v2mib/2 2021/10/18 10:42:33 jenchen Exp $ |
-- +=========================================================================+
-- | Copyright (c) 2012 Oracle Corporation Redwood City, California, USA |
-- | All rights reserved. |
-- |=========================================================================+
-- | |
-- | |
-- | FILENAME |
-- | |
-- | glhistoricalratesinterface.ctl
-- | |
-- | DESCRIPTION
-- | Uploads CSV file data into GL_HISTORICAL_RATES_INT |
-- | Created by Sundar Ganesan 05/02/2021
-- | 
-- |	CHAR(600) is added to handle multilang characters fields

load data
CHARACTERSET UTF8
append into table gl_historical_rates_int
fields terminated by "," optionally enclosed by '"' trailing nullcols
(   
	group_number      CONSTANT 	    	    '#LOADREQUESTID#', 
    row_number        SEQUENCE(1,1),
    load_request_id  CONSTANT 	    	    '#LOADREQUESTID#',
    ledger_name,
	import_action_code,
    segment1,
    segment2,
    segment3,
    segment4,
    segment5,
    segment6,
    segment7,
    segment8,
    segment9,
    segment10,
    segment11,
    segment12,
    segment13,
    segment14,
    segment15,
    segment16,
    segment17,
    segment18,
    segment19,
    segment20,
    segment21,
    segment22,
    segment23,
    segment24,
    segment25,
    segment26,
    segment27,
    segment28,
    segment29,
    segment30,
    period_name,
    target_currency_code,
    value_type_code,
    credit_amount_rate,
    auto_roll_forward_flag "decode(:auto_roll_forward_flag,'YES','Y','NO','N','I')",
    attribute_category	CHAR(120),
    attribute1	    CHAR(600),
    attribute2	    CHAR(600),
    attribute3	    CHAR(600),
    attribute4	    CHAR(600),
    attribute5	    CHAR(600),
    CREATED_BY                       CONSTANT               '#CREATEDBY#',
    CREATION_DATE                    expression             "systimestamp",
    LAST_UPDATE_DATE                 expression             "systimestamp",
    LAST_UPDATE_LOGIN                CONSTANT               '#LASTUPDATELOGIN#',
    LAST_UPDATED_BY                  CONSTANT               '#LASTUPDATEDBY#',
    usage_code                       CONSTANT               'S',
    status_code                      CONSTANT               'NEW',
    error_message CHAR(1000) "decode(:auto_roll_forward_flag,'YES',null,'NO',null,'::GL_HIST_RATE_INVALID_ROLL_FWD-'|| :auto_roll_forward_flag)",
    code_combination_id    CONSTANT '-1'
)
