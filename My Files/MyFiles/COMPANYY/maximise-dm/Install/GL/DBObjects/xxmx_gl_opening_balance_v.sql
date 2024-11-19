--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_gl_opening_balance_v.sql
--**
--** FILEPATH  :  $XXVM_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Shireesha  
--**
--** PURPOSE   :  This creates view GL extract
--**
--** NOTES     :
--**
--******************************************************************************
--**

  CREATE OR REPLACE  VIEW "XXMX_CORE"."XXMX_GL_OPENING_BALANCE_V" ("LEDGER_ID", "PERIOD_NAME", "CURRENCY_CODE", "CODE_COMBINATION_ID", "ENTERED_DR", "ENTERED_CR", "ACCOUNTED_DR", "ACCOUNTED_CR") AS 
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
            gl.gl_balances@mxdm_nvis_extract                     bal,
            apps.gl_code_combinations_kfv@mxdm_nvis_extract      gcc,
            gl.gl_ledgers@mxdm_nvis_extract                      gll
      WHERE     bal.ledger_id  = gll.ledger_id
            AND bal.code_combination_id = gcc.code_combination_id
            AND bal.actual_flag = 'A'
            AND nvl(bal.translated_flag,'X') not in ('Y','N')
            AND bal.template_id IS NULL
   GROUP BY bal.ledger_id ,
            bal.period_name,
            bal.currency_code,
            gcc.code_combination_id
;
