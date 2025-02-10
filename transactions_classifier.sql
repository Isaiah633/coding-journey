  WITH chase_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN amount < 0 THEN amount -- Debit (negative) 
            ELSE amount -- Credit (positive) 
        END AS normalized_amount,
        'CHASE' AS Source 
    FROM
        big-query1-447223.amex.chase ), amex_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN amount > 0 THEN -amount -- Debit (positive,
            convert to negative) 
            ELSE -amount -- Credit (negative,
            convert to positive) 
        END AS normalized_amount,
        'AMEX' AS Source 
    FROM
        big-query1.amex.amex )

, discover_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN amount > 0 THEN -amount -- Debit (positive,
            convert to negative) 
            ELSE -amount -- Credit (negative,
            convert to positive) 
        END AS normalized_amount,
        'DISCOVER' AS Source 
    FROM
        big-query1.amex.discover )

, delta_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN amount > 0 THEN -amount -- Debit (positive,
            convert to negative) 
            ELSE -amount -- Credit (negative,
            convert to positive) 
        END AS normalized_amount,
        'DELTA' AS Source 
    FROM
        big-query1.amex.delta )

, WF_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN amount < 0 THEN amount -- Debit (negative) 
            ELSE amount -- Credit (positive) 
        END AS normalized_amount,
        'WFchecking' AS Source 
    FROM
        big-query1.amex.WFchecking )

, checking_merge AS ( SELECT
        Date,
        Description,
        amount,
        CASE 
            WHEN Transaction = 'Debit' THEN -amount -- Debit (positive,
            convert to negative) 
            WHEN Transaction = 'Credit' THEN amount -- Credit (leave as positive) 
            ELSE NULL -- Optional: Handle unexpected Transaction 
        values
            
        END AS normalized_amount,
        'CHECKING' AS Source 
    FROM
        big-query1.amex.checking )

, unified_transactions as (
  SELECT *
  FROM chase_merge
  UNION ALL
  SELECT *
  FROM amex_merge
  UNION ALL
  SELECT *
  FROM discover_merge
  UNION ALL
  SELECT *
  FROM delta_merge
  UNION ALL
  SELECT *
  FROM wf_merge
  UNION ALL
  SELECT *
  FROM checking_merge
)

 SELECT
    Date,
    Amount,
    Normalized_amount,
    Source,
    Description,
    CASE
       WHEN
          Description LIKE '%PSEG%' 
          OR Description LIKE '%OPTIMUM%' 
          OR Description LIKE '%SEWER%' 
       THEN
          'UTILITIES' 
       WHEN
          Description LIKE '%MLS%' 
          OR Description LIKE '%SUPRA%' 
          OR Description LIKE '%REALTOR%' 
       THEN
          'REAL ESTATE' 
       WHEN
          Description LIKE '%NEWREZ%' 
       THEN
          'MORTGAGE' 
       WHEN
          Description LIKE '%LIBERTY MUTUAL%' 
       THEN
          'LOGAN INSURANCE' 
       WHEN
          Description LIKE '%LUKOIL%' 
          OR Description LIKE '%WAWA%' 
          OR Description like '%PEPBOYS%' 
          OR Description LIKE '%PLYMOUTH%' 
          OR Description LIKE '%SALIT%' 
       THEN
          'AUTO' 
       WHEN
          Description LIKE '%OHR%' 
          OR Description LIKE '%DOLLAR-A-DAY%' 
          OR Description LIKE '%NER ISRAEL%' 
       THEN
          'CHARITY' 
       WHEN
          Description LIKE '%CVS%' 
          OR Description LIKE '%PHARMACY%' 
          OR Description LIKE '%WALGREENS%' 
       THEN
          'PHARMACY' 
       WHEN
          Description LIKE '%DRESS%' 
          OR Description LIKE '%MARSHALLS%' 
          OR Description LIKE '%DSW%' 
          OR Description LIKE '%CARTERS%' 
          OR Description LIKE '%SHEIN%' 
       THEN
          'CLOTHES' 
       WHEN
          Description LIKE '%PESACH%' 
          OR Description LIKE '%FACTS%' 
       THEN
          'TUITION' 
       WHEN
          Description LIKE '%WAL-MART%' 
          OR Description LIKE '%WALMART%' 
          OR Description LIKE '%STOP & SHOP%' 
          OR Description LIKE '%SHOPRITE%' 
          OR Description LIKE '%TRADER JOE%' 
          OR Description LIKE '%GLATT 27%' 
          OR Description LIKE '%STOP &%' 
          OR Description LIKE '%COSTCO%' 
       THEN
          'GROCERY' 
       WHEN
          Description LIKE '%DUNKIN%' 
          OR Description LIKE '%mediterranean%' 
          OR Description LIKE '%starbu%' 
       THEN
          'RESTAURANTS' 
       WHEN
          Description LIKE '%FRANKLIN%' 
          OR Description LIKE '%HMH%' 
          OR Description LIKE '%BAKER TILLY%' 
       THEN
          'JOB INCOME' 
       WHEN
          Description LIKE '%HOME DEPOT%' 
          OR Description LIKE '%LOWES%' 
          OR Description LIKE '%FREIGHT%' 
       THEN
          'HOME IMPROVEMENT' 
       WHEN
          Description LIKE '%LA FITNESS%' 
       THEN
          'GYM' 
       WHen
          Description like '@AMAZON%' 
          OR Description LIKE '%AMZN%' 
       THEN
          'AMAZON' 
       ELSE
          'UNCATEGORIZED' 
    END
    AS Category 
 FROM
    unified_transactions
