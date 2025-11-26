/*Aggregate window functions calculate running totals, moving averages, and cumulative statistics without collapsing rows.

**Common Window Aggregates:**

```sql
SUM(column) OVER (...)      -- Running totalAVG(column) OVER (...)      -- Moving averageCOUNT(*) OVER (...)         -- Running countMIN(column) OVER (...)      -- Running minimumMAX(column) OVER (...)      -- Running maximum
```

**Window Frame Clauses:**

```sql
ROWS BETWEEN start AND end-- start/end can be:-- UNBOUNDED PRECEDING: From first row-- N PRECEDING: N rows before current-- CURRENT ROW: Current row-- N FOLLOWING: N rows after current-- UNBOUNDED FOLLOWING: To last row
```
### 💡 Tips & Tricks

✅ **Frame clause defaults** when using ORDER BY:

```sql
-- This (with ORDER BY):SUM(col) OVER (ORDER BY date)
-- Is actually:SUM(col) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
```

✅ **Without ORDER BY, frame is entire partition**:

```sql
-- Running total (ORDER BY included)SUM(col) OVER (PARTITION BY service ORDER BY week)
-- Overall service total (no ORDER BY)SUM(col) OVER (PARTITION BY service)
```

✅ **Moving averages** use ROWS BETWEEN:

```sql
-- 3-period moving average (current + 2 before)AVG(col) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
-- Centered 5-period (2 before, current, 2 after)AVG(col) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)
```

✅ **Calculate differences from aggregates**:

```sql
-- Deviation from averagecol - AVG(col) OVER (PARTITION BY group)
-- Percentage of total100.0 * col / SUM(col) OVER (PARTITION BY group)
```
*/


use sqlchallenge;

--1)Calculate running total of patients admitted by week for each service.
SELECT SERVICE, WEEK, patients_admitted,
        SUM(PATIENTS_ADMITTED)
        OVER (PARTITION BY SERVICE ORDER BY WEEK) RUNNING_TOTAL
FROM services_weekly;
  
--2)Find the moving average of patient satisfaction over 4-week periods.
  SELECT WEEK, SERVICE,patient_satisfaction,
        AVG(PATIENT_SATISFACTION)
        OVER(PARTITION BY SERVICE 
        ORDER BY WEEK ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ) MOVING_AVG_4WEEKS
  FROM services_weekly;

  --3)Show cumulative patient refusals by week across all services.
  SELECT SERVICE, WEEK, patients_refused,
        SUM(patients_refused)
        OVER (PARTITION BY SERVICE ORDER BY WEEK) CUMULATIVE_TOTAL
FROM services_weekly
ORDER BY service,week;


  /*Create a trend analysis showing for each service and week: week number, 
  patients_admitted, running total of patients admitted (cumulative), 3-week 
  moving average of patient satisfaction (current week and 2 prior weeks), and 
  the difference between current week admissions and the service average. Filter for weeks 10-20 only.*/

SELECT SERVICE,WEEK,PATIENTS_ADMITTED,
       SUM(PATIENTS_ADMITTED) 
       OVER(ORDER BY WEEK) CUM_TOTAL,
       AVG(patient_satisfaction) OVER (PARTITION BY SERVICE 
               ORDER BY WEEK ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)MOV_AVG,
       AVG(PATIENTS_ADMITTED) 
       OVER (PARTITION BY SERVICE) AVG_PATIENTS_ADMITTED,
       patients_admitted - AVG(patients_admitted) 
       OVER(PARTITION BY SERVICE) DIFF_FROM_AVG
FROM services_weekly
WHERE WEEK BETWEEN 10 AND 20;

