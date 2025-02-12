#Overview

I created a process to assist individuals and businesses with financial planning and budgeting. My goal was to create an easy to follow, duplicatable process to organize income and expenses in order to help individuals and businesses looking to develop a plan. This project provides a structured, repeatable process for organizing income and expenses, assisting individuals and businesses with financial planning and budgeting. The workflow involves extracting financial data, transforming it using SQL, and visualizing insights in Google Looker Studio.

#Walkthrough

The first step is downloading bank and credit card statements in CSV format. Next the statements are uploaded to BigQuery as new data tables. Using SQL, the Date, Description, and Amount columns of the transactions from the various Data Tables from different banks and credit cards are merged together as one table using UNION ALL, and a new colum is created to identify the source of the data. The data is also standardized and unified where there are discrepancies between different data sets using CTE (common table expressions). Another SQL query is then run on this new table that now contains all of the data from the different bank accounts and credit cards. This new query also uses CTE and a column is added that categorizes all the transactions based on their description or any other applicable metric, and a new updated table is created in BigQuery. Now that the data is complete, it is uploaded to Google Looker Studio as a google sheets or Excel file. Then the data can be incorporated into different graphs and charts on Looker Studio. The data can be organized by income and expenses, and various categories of income and expenses can be organized by cash amounts or volume of transactions. This data now in its final form is easy to understand and visualize, and can be used for financial planning and budgeting.

#Below is the SQL code I used for combining and standardizing the various financial statements, as well as the code for categorizing different transactions. Also attached are some graphs and visuals of the data from Looker Studio.

#Combining and standardizing financial statements:

WITH chase_merge AS ( SELECT Date, Description, amount, CASE WHEN amount < 0 THEN amount -- Debit (negative) ELSE amount -- Credit (positive) END AS normalized_amount, 'CHASE' AS Source FROM big-query1-447223.amex.chase ), amex_merge AS ( SELECT Date, Description, amount, CASE WHEN amount > 0 THEN -amount -- Debit (positive, convert to negative) ELSE -amount -- Credit (negative, convert to positive) END AS normalized_amount, 'AMEX' AS Source FROM big-query1.amex.amex ), discover_merge AS ( SELECT Date, Description, amount, CASE WHEN amount > 0 THEN -amount -- Debit (positive, convert to negative) ELSE -amount -- Credit (negative, convert to positive) END AS normalized_amount, 'DISCOVER' AS Source FROM big-query1.amex.discover ), delta_merge AS ( SELECT Date, Description, amount, CASE WHEN amount > 0 THEN -amount -- Debit (positive, convert to negative) ELSE -amount -- Credit (negative, convert to positive) END AS normalized_amount, 'DELTA' AS Source FROM big-query1.amex.delta ), WF_merge AS ( SELECT Date, Description, amount, CASE WHEN amount < 0 THEN amount -- Debit (negative) ELSE amount -- Credit (positive) END AS normalized_amount, 'WFchecking' AS Source FROM big-query1.amex.WFchecking ), checking_merge AS ( SELECT Date, Description, amount, CASE WHEN Transaction = 'Debit' THEN -amount -- Debit (positive, convert to negative) WHEN Transaction = 'Credit' THEN amount -- Credit (leave as positive) ELSE NULL -- Optional: Handle unexpected Transaction values END AS normalized_amount, 'CHECKING' AS Source FROM big-query1.amex.checking )

-- Combine all transactions SELECT * FROM chase_merge UNION ALL SELECT * FROM amex_merge UNION ALL SELECT * FROM discover_merge UNION ALL SELECT * FROM delta_merge UNION ALL SELECT * FROM WF_merge UNION ALL SELECT * FROM checking_merge;

#Categorizing different transactions:

WITH breakdown AS ( SELECT Date, Amount, Normalized_amount, Source, Description, CASE WHEN Description LIKE '%PSEG%' OR Description LIKE '%OPTIMUM%' OR Description LIKE '%SEWER%' THEN 'UTILITIES' WHEN Description LIKE '%MLS%' OR Description LIKE '%SUPRA%' OR Description LIKE '%REALTOR%' THEN 'REAL ESTATE' WHEN Description LIKE '%NEWREZ%' THEN 'MORTGAGE' WHEN Description LIKE '%LIBERTY MUTUAL%' THEN 'LOGAN INSURANCE' WHEN Description LIKE '%LUKOIL%' OR Description LIKE '%WAWA%' OR Description like '%PEPBOYS%' OR Description LIKE '%PLYMOUTH%' OR Description LIKE '%SALIT%' THEN 'AUTO' WHEN Description LIKE '%OHR%' OR Description LIKE '%DOLLAR-A-DAY%' OR Description LIKE '%NER ISRAEL%' THEN 'CHARITY' WHEN Description LIKE '%CVS%' OR Description LIKE '%PHARMACY%' OR Description LIKE '%WALGREENS%' THEN 'PHARMACY' WHEN Description LIKE '%DRESS%' OR Description LIKE '%MARSHALLS%' OR Description LIKE '%DSW%' OR Description LIKE '%CARTERS%' OR Description LIKE '%SHEIN%' THEN 'CLOTHES' WHEN Description LIKE '%PESACH%' OR Description LIKE '%FACTS%' THEN 'TUITION' WHEN Description LIKE '%WAL-MART%' OR Description LIKE '%WALMART%' OR Description LIKE '%STOP & SHOP%' OR Description LIKE '%SHOPRITE%' OR Description LIKE '%TRADER JOE%' OR Description LIKE '%GLATT 27%' OR Description LIKE '%STOP &%' OR Description LIKE '%COSTCO%' THEN 'GROCERY' WHEN Description LIKE '%DUNKIN%' OR Description LIKE '%mediterranean%' OR Description LIKE '%starbu%' THEN 'RESTAURANTS' WHEN Description LIKE '%FRANKLIN%' OR Description LIKE '%HMH%' OR Description LIKE '%BAKER TILLY%' THEN 'JOB INCOME' WHEN Description LIKE '%HOME DEPOT%' OR Description LIKE '%LOWES%' OR Description LIKE '%FREIGHT%' THEN 'HOME IMPROVEMENT' WHEN Description LIKE '%LA FITNESS%' THEN 'GYM' WHen Description like '@AMAZON%' OR Description LIKE '%AMZN%' THEN 'AMAZON' ELSE 'UNCATEGORIZED'

END AS Category

FROM steam-idiom.amex.NEW combined ) SELECT * FROM breakdown;

#Selected parts of the Graphs and visuals of the data from Looker Studio
![UNADJUSTEDNONRAW_thumb_1c](https://github.com/user-attachments/assets/3d573c22-35f8-46bc-a756-724c857d210e)



![Image 2-11-25 at 7 37 PM](https://github.com/user-attachments/assets/04a9d8d0-e989-411b-9e47-0c4cb84f4bb8)


![UNADJUSTEDNONRAW_thumb_1f](https://github.com/user-attachments/assets/29109a8f-9e70-4ad9-b046-260bb91ee20c)
![UNADJUSTEDNONRAW_thumb_20](https://github.com/user-attachments/assets/43cee6be-4ee6-41ff-a80e-b10690441518)

![UNADJUSTEDNONRAW_thumb_21](https://github.com/user-attachments/assets/25063112-ff0d-48c6-8c2a-44dde0cd2750)
![UNADJUSTEDNONRAW_thumb_23](https://github.com/user-attachments/assets/2a805a82-8bf3-433b-a0da-721ab6bfb39b)
![UNADJUSTEDNONRAW_thumb_22](https://github.com/user-attachments/assets/7deacd46-242f-45c8-a199-9990186c3abc)
