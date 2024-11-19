-- Backup below tables first --


-- DROP TABLE ----

drop table gl_ledgers_extract;
/
drop table gl_balances_extract;
/
drop table gl_code_combinations_extract;
/
drop table XXMX_GL_BALANCE_SUMMARY_V;
/
drop table XXMX_GL_OPENING_BALANCE_V;
/
drop table gl_je_categories_tl_ext;
/
drop table gl_je_sources_tl_ext;
/
drop table gl_je_headers_extract;
/
drop table gl_je_lines_extract;--
/
drop table gl_je_batches_extract;
/
drop table gl_daily_conversion_types_ext;
/
drop table gl_code_combinations_gcc_ext;
/
drop table gl_periods_extract;
/


----- TABLE CREATION ---
create table gl_ledgers_extract as
select * from gl_ledgers@xxmx_extract gl,
xxmx_migration_parameters xx
where gl.name = xx.parameter_value
and xx.enabled_flag = 'Y'
and xx.parameter_code = 'LEDGER_NAME'
and xx.business_entity = 'BALANCES';
/
create table gl_balances_extract
as
select bal.* from gl.gl_balances@xxmx_extract bal,gl_ledgers_extract gl
where bal.ledger_id = gl.ledger_id;
/
create table gl_code_combinations_extract
as
select * from apps.gl_code_combinations_kfv@xxmx_extract;
/
create table XXMX_GL_BALANCE_SUMMARY_V as
SELECT bal.ledger_id LEDGER_ID,
            bal.period_name period_name,
            bal.currency_code currency_code,
            gcc.code_combination_id code_combination_id,
            decode(
              sign(
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )
              ),
              1,
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                ),
              null
            )  entered_dr,
            decode(
              sign(
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )
              ),
              -1,
                abs(sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )),
              null
            ) entered_cr,
            decode(
              sign(
                sum
                (
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )
              ),
              1,
                sum
                (
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                ),
              null
            ) accounted_dr,
            decode(
              sign(
                sum
                (
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )
              ),
              -1,
                abs(sum
                (
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )),
              null
            ) accounted_cr
       FROM
            gl_balances_extract                     bal,
            GL_CODE_COMBINATIONS_EXTRACT      gcc,
            gl_ledgers_extract                      gll,
            xxmx_migration_parameters    xmp
      WHERE     bal.ledger_id  = gll.ledger_id
            AND bal.code_combination_id = gcc.code_combination_id
            AND bal.actual_flag = 'A'
            AND nvl(bal.translated_flag,'X') not in ('Y','N')
            AND bal.template_id IS NULL
            AND bal.period_name = xmp.parameter_value
            AND xmp.business_entity = 'BALANCES' 
            and xmp.sub_entity = 'SUMMARY BALANCES'
            and xmp.enabled_flag = 'Y'
            and xmp.parameter_code = 'PERIOD'
GROUP BY bal.ledger_id ,
            bal.period_name,
            bal.currency_code,
            gcc.code_combination_id;
/
create table XXMX_GL_OPENING_BALANCE_V as
SELECT bal.ledger_id LEDGER_ID,
            bal.period_name period_name,
            bal.currency_code currency_code,
            gcc.code_combination_id code_combination_id,
            decode(
              sign(
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      (NVL(bal.BEGIN_BALANCE_DR_BEQ,0) - NVL(bal.BEGIN_BALANCE_CR_BEQ,0)) + ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL(bal.BEGIN_BALANCE_DR,0) - NVL( bal.BEGIN_BALANCE_CR,0)) + (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )
              ),
              1,
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      (NVL(bal.BEGIN_BALANCE_DR_BEQ,0) - NVL(bal.BEGIN_BALANCE_CR_BEQ,0)) + ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL(bal.BEGIN_BALANCE_DR,0) - NVL( bal.BEGIN_BALANCE_CR,0)) + (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                ),
              null
            )  entered_dr,
            decode(
              sign(
                sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      (NVL(bal.BEGIN_BALANCE_DR_BEQ,0) - NVL(bal.BEGIN_BALANCE_CR_BEQ,0)) + ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL(bal.BEGIN_BALANCE_DR,0) - NVL( bal.BEGIN_BALANCE_CR,0)) + (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )
              ),
              -1,
                abs(sum
                (
                  case
                    when bal.CURRENCY_CODE = gll.CURRENCY_CODE then
                      (NVL(bal.BEGIN_BALANCE_DR_BEQ,0) - NVL(bal.BEGIN_BALANCE_CR_BEQ,0)) + ( NVL(bal.PERIOD_NET_DR_BEQ,0) - NVL(bal.PERIOD_NET_CR_BEQ,0))
                    else
                      (NVL(bal.BEGIN_BALANCE_DR,0) - NVL( bal.BEGIN_BALANCE_CR,0)) + (NVL( bal.PERIOD_NET_DR,0) - NVL( bal.PERIOD_NET_CR,0))
                  end
                )),
              null
            ) entered_cr,
            decode(
              sign(
                sum
                (
                  (nvl(bal.BEGIN_BALANCE_DR_BEQ,0) - nvl(bal.BEGIN_BALANCE_CR_BEQ,0)) +
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )
              ),
              1,
                sum
                (
                  (nvl(bal.BEGIN_BALANCE_DR_BEQ,0) - nvl(bal.BEGIN_BALANCE_CR_BEQ,0)) +
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                ),
              null
            ) accounted_dr,
            decode(
              sign(
                sum
                (
                  (nvl(bal.BEGIN_BALANCE_DR_BEQ,0) - nvl(bal.BEGIN_BALANCE_CR_BEQ,0)) +
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )
              ),
              -1,
                abs(sum
                (
                  (nvl(bal.BEGIN_BALANCE_DR_BEQ,0) - nvl(bal.BEGIN_BALANCE_CR_BEQ,0)) +
                  (nvl(bal.PERIOD_NET_DR_BEQ,0) - nvl(bal.PERIOD_NET_CR_BEQ,0))
                )),
              null
            ) accounted_cr
      FROM
            gl_balances_extract                     bal,
            GL_CODE_COMBINATIONS_EXTRACT      gcc,
            gl_ledgers_extract                      gll,
            xxmx_migration_parameters    xmp
      WHERE     bal.ledger_id  = gll.ledger_id
            AND bal.code_combination_id = gcc.code_combination_id
            AND bal.actual_flag = 'A'
            AND nvl(bal.translated_flag,'X') not in ('Y','N')
            AND bal.template_id IS NULL
            AND bal.period_name = xmp.parameter_value
            AND xmp.business_entity = 'BALANCES' 
            and xmp.sub_entity = 'OPENING BALANCES'
            and xmp.enabled_flag = 'Y'
            and xmp.parameter_code = 'PERIOD'
   GROUP BY bal.ledger_id ,
            bal.period_name,
            bal.currency_code,
            gcc.code_combination_id;
/
create table gl_je_categories_tl_ext
as
select * from gl.gl_je_categories_tl@xxmx_extract;
/
create table gl_je_sources_tl_ext
as
select * from gl.gl_je_sources_tl@xxmx_extract;
/
create table gl_je_headers_extract
as
select gjh.* from gl.gl_je_headers@xxmx_extract gjh,gl_ledgers_extract gl
where gjh.ledger_id = gl.ledger_id;
/
create table gl_je_lines_extract
as
select gjl.* from gl.gl_je_lines@xxmx_extract gjl,gl_ledgers_extract gl
where gjl.ledger_id = gl.ledger_id;
/
create table gl_je_batches_extract
as
select gjb.* from gl.gl_je_batches@xxmx_extract gjb;
/
create table gl_daily_conversion_types_ext
as
select * from gl.gl_daily_conversion_types@xxmx_extract;
/
create table gl_code_combinations_gcc_ext
as
select * from apps.gl_code_combinations@xxmx_extract;
/
create table GL_PERIODS_EXTRACT
as
select * from gl_periods@xxmx_extract;
/
--Index Creation Scripts
CREATE UNIQUE INDEX GL_JE_HEADERS_U1 ON GL_JE_HEADERS_EXTRACT(JE_HEADER_ID)
/
CREATE UNIQUE INDEX GL_JE_HEADERS_U2 ON GL_JE_HEADERS_EXTRACT(NAME,JE_BATCH_ID)
/
CREATE UNIQUE INDEX GL_JE_LINES_U1 ON GL_JE_LINES_EXTRACT(JE_HEADER_ID,JE_LINE_NUM)
/
CREATE UNIQUE INDEX GL_JE_BATCHES_U1 ON GL_JE_BATCHES_EXTRACT(JE_BATCH_ID)
/
CREATE UNIQUE INDEX GL_JE_BATCHES_U2 ON GL_JE_BATCHES_EXTRACT(NAME,DEFAULT_PERIOD_NAME,CHART_OF_ACCOUNTS_ID,PERIOD_SET_NAME,ACCOUNTED_PERIOD_TYPE)
/
CREATE UNIQUE INDEX GL_CODE_COMBINATIONS_U1 ON GL_CODE_COMBINATIONS_GCC_EXT(CODE_COMBINATION_ID)
/

CREATE INDEX GL_BALANCES_N1 ON gl_balances_extract(CODE_COMBINATION_ID,PERIOD_NAME)
/
CREATE INDEX GL_BALANCES_N2 ON gl_balances_extract(PERIOD_NAME)
/
CREATE INDEX GL_BALANCES_N3 ON gl_balances_extract(PERIOD_NUM, PERIOD_YEAR)
/
CREATE INDEX GL_JE_HEADERS_N1 ON gl_je_headers_extract(JE_BATCH_ID)
/
CREATE INDEX GL_JE_HEADERS_N2 ON gl_je_headers_extract(PERIOD_NAME,JE_CATEGORY)
/
CREATE INDEX GL_JE_LINES_N1 ON gl_je_lines_extract(PERIOD_NAME,CODE_COMBINATION_ID)
/
CREATE INDEX GL_LEDGERS_N1 ON gl_ledgers_extract(CHART_OF_ACCOUNTS_ID,PERIOD_SET_NAME,ACCOUNTED_PERIOD_TYPE)
/
CREATE UNIQUE INDEX GL_LEDGERS_U1 ON gl_ledgers_extract(NAME)
/
CREATE UNIQUE INDEX GL_LEDGERS_U2 ON gl_ledgers_extract(LEDGER_ID)
/
CREATE INDEX GL_JE_BATCHES_N1 ON gl_je_batches_extract(STATUS)
/

CREATE INDEX GL_CODE_COMBINATIONS_N1 ON gl_code_combinations_gcc_ext(SEGMENT1)
/
CREATE INDEX GL_CODE_COMBINATIONS_N2 ON gl_code_combinations_gcc_ext(SEGMENT2)
/
CREATE INDEX GL_CODE_COMBINATIONS_N3 ON gl_code_combinations_gcc_ext(SEGMENT3)
/
CREATE INDEX GL_CODE_COMBINATIONS_N4 ON gl_code_combinations_gcc_ext(SEGMENT4)
/
CREATE INDEX GL_CODE_COMBINATIONS_N5 ON gl_code_combinations_gcc_ext(SEGMENT5)
/
CREATE INDEX GL_CODE_COMBINATIONS_N6 ON gl_code_combinations_gcc_ext(SEGMENT6)
/