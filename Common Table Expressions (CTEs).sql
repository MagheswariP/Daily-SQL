/*CTEs (WITH clauses) create temporary named result sets that exist only during query execution. They make complex queries more readable and maintainable.

**Basic Syntax:**

```sql
WITH cte_name AS (
    SELECT columns    FROM table    WHERE condition
)
SELECT *FROM cte_name;
```

**Multiple CTEs:**

```sql
WITH
cte1 AS (
    SELECT ...
),
cte2 AS (
    SELECT ...
)
SELECT *FROM cte1
JOIN cte2 ON ...;
```
### 💡 Tips & Tricks

✅ **Use CTEs to break down complex queries**:

```sql
-- Instead of nested subqueries, use step-by-step CTEsWITH
step1 AS (SELECT ...),
step2 AS (SELECT ... FROM step1),
step3 AS (SELECT ... FROM step2)
SELECT * FROM step3;
```

✅ **CTEs vs Subqueries**:
- CTEs: More readable, can be referenced multiple times
- Subqueries: More concise for simple cases

```sql
-- CTE (readable, reusable)WITH avg_age AS (SELECT AVG(age) FROM patients)
SELECT * FROM patients, avg_age WHERE age > avg_age;
-- Subquery (more concise)SELECT * FROM patients WHERE age > (SELECT AVG(age) FROM patients);
```

✅ **CTEs are evaluated once** and can be referenced multiple times:

```sql
WITH service_avg AS (
    SELECT service, AVG(satisfaction) AS avg_sat
    FROM patients
    GROUP BY service
)
SELECT *FROM patients p
JOIN service_avg sa ON p.service = sa.service
WHERE p.satisfaction > sa.avg_sat;  -- Reference CTE twice
```

✅ **Use descriptive CTE names** that explain what they contain:

```sql
-- ❌ WITH x AS, y AS, z AS-- ✅ WITH patient_stats AS, staff_summary AS, weekly_trends AS
```

✅ **CTEs improve debugging** - test each CTE independently:

```sql
-- Test first CTEWITH cte1 AS (SELECT ...)
SELECT * FROM cte1;
-- Then add second CTEWITH cte1 AS (...), cte2 AS (...)
SELECT * FROM cte2;
```

✅ **Not materialized by default** - some databases recalculate CTEs each time they’re referenced. Use temp tables for expensive calculations used multiple times.
*/



use sqlchallenge;

--1)Create a CTE to calculate service statistics, then query from it.
with service_stats as
(SELECT
  service,
    SUM(PATIENTS_REQUEST) TOTAL_PATIENTS_REQUEST,
    SUM(PATIENTS_ADMITTED) TOTAL_PATIENTS_ADMITTED,
    SUM(PATIENTS_REFUSED) TOTAL_PATIENTS_REFUSED,
    AVG(PATIENT_SATISFACTION) AVG_SATISFACTION
  FROM services_weekly
  GROUP BY service
)
SELECT *FROM service_stats
WHERE avg_satisfaction > 75
ORDER BY service DESC;

--2)Use multiple CTEs to break down a complex query into logical steps.
WITH PATIENT_STATS AS
(SELECT SERVICE,
  COUNT(PATIENT_ID) TOTAL_PATIENTS,
  AVG(AGE) AVG_PATIENT_AGE,
  AVG(SATISFACTION) AVG_SATISFACTION
FROM patients
GROUP BY SERVICE
),
STAFF_STATS AS
( SELECT SERVICE,
   COUNT(*) TOTAL_STAFF
FROM staff
GROUP BY SERVICE),
WEEKLY_SERVICE AS
(SELECT service,
    SUM(PATIENTS_ADMITTED) TOTAL_PATIENTS_ADMITTED,
    SUM(PATIENTS_REFUSED) TOTAL_PATIENTS_REFUSED
  FROM services_weekly
  GROUP BY service)
SELECT
    PS.SERVICE,PS.TOTAL_PATIENTS,PS.AVG_PATIENT_AGE,PS.AVG_SATISFACTION,
    SS.TOTAL_STAFF,
    WS.TOTAL_PATIENTS_ADMITTED,WS.TOTAL_PATIENTS_REFUSED
FROM PATIENT_STATS PS
LEFT JOIN STAFF_STATS SS ON PS.SERVICE =SS.SERVICE
LEFT JOIN WEEKLY_SERVICE WS ON PS.SERVICE =WS.SERVICE
ORDER BY PS.AVG_SATISFACTION DESC;

--3)Build a CTE for staff utilization and join it with patient data.
WITH STAFF_DETAIL AS
(SELECT
     STAFF_NAME, SERVICE, ROLE
FROM staff),
PATIENT_METRICS AS
(SELECT
     NAME, SERVICE
FROM patients)
SELECT SD.*,PM.name
FROM STAFF_DETAIL SD
LEFT JOIN PATIENT_METRICS PM ON SD.SERVICE =PM.SERVICE;

/* Create a comprehensive hospital performance dashboard using CTEs. Calculate: 
1) Service-level metrics (total admissions, refusals, avg satisfaction), 
2) Staff metrics per service (total staff, avg weeks present), 
3) Patient demographics per service (avg age, count). 
Then combine all three CTEs to create a final report showing service name, 
all calculated metrics, and an overall performance score (weighted average of admission rate and satisfaction). 
Order by performance score descending.*/

WITH SERVICE_METRIC AS
(SELECT SERVICE,
    SUM(PATIENTS_REQUEST) TOTAL_PATIENTS_REQUEST,
    SUM(PATIENTS_ADMITTED) TOTAL_PATIENTS_ADMITTED,
    SUM(PATIENTS_REFUSED) TOTAL_PATIENTS_REFUSED,
    AVG(PATIENT_SATISFACTION) AVG_SATISFACTION
FROM services_weekly
GROUP BY service),
STAFF_METRICS AS
(SELECT SERVICE,
     COUNT(STAFF_ID) TOTAL_STAFF,
     AVG (WEEK) AVG_WEEK_PRESENT
FROM staff_schedule
GROUP BY service),
PATIENTS_METRICS AS
(SELECT SERVICE,
     COUNT(PATIENT_ID) TOTAL_PATIENTS,
     AVG(AGE) AVG_PATIENT_AGE
FROM patients
GROUP BY service)
SELECT SM.*,ST.AVG_WEEK_PRESENT,ST.TOTAL_STAFF,
       PM.AVG_PATIENT_AGE,PM.TOTAL_PATIENTS,
         ROUND(100.0 * SM.TOTAL_PATIENTS_ADMITTED /
          (SM.TOTAL_PATIENTS_ADMITTED + SM.TOTAL_PATIENTS_REFUSED ),2) AS admission_rate,
          ROUND(((0.0* SM.AVG_SATISFACTION)+
          (0.4* SM.TOTAL_PATIENTS_ADMITTED/SM.TOTAL_PATIENTS_REQUEST)*100),2) OVERALL_PERFORMANCE
FROM SERVICE_METRIC SM
LEFT JOIN STAFF_METRICS ST ON SM.SERVICE =ST.SERVICE
LEFT JOIN PATIENTS_METRICS PM ON SM.SERVICE =PM.SERVICE
ORDER BY OVERALL_PERFORMANCE DESC;





