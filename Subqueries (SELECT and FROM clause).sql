/*Topics: Subqueries in SELECT, derived tables, inline views

Subqueries can also appear in SELECT (as calculated columns) and FROM (as derived tables).

**Syntax:**

```sql
-- Subquery in SELECTSELECT
    column1,
    (SELECT aggregate FROM table2 WHERE condition) AS calculated_column
FROM table1;
-- Subquery in FROM (derived table)SELECT *FROM (
    SELECT column1, column2
    FROM table    WHERE condition
) AS subquery_alias;
```
### 💡 Tips & Tricks

✅ **Always alias derived tables**:

```sql
-- ❌ Missing alias: FROM (SELECT ...)-- ✅ Correct: FROM (SELECT ...) AS alias
```

✅ **Subquery in SELECT must return single value**:

```sql
-- This works (single value):SELECT name, (SELECT COUNT(*) FROM staff) AS total_staff
-- This fails (multiple values):SELECT name, (SELECT staff_name FROM staff)  -- ERROR
```

✅ **Use derived tables to organize complex logic**:

```sql
-- Instead of one massive query, break into logical stepsFROM (
    -- Step 1: Calculate metrics    SELECT service, COUNT(*) as count FROM patients GROUP BY service
) AS step1
JOIN (
    -- Step 2: Calculate different metrics    SELECT service, AVG(satisfaction) as avg_sat FROM patients GROUP BY service
) AS step2 ON step1.service = step2.service
```

✅ **CTEs (Day 21) are often cleaner** than derived tables for complex queries

✅ **Correlated subqueries in SELECT** execute once per row (can be slow):

```python
SELECT
    p.name,
    (SELECT AVG(satisfaction)
     FROM patients p2
     WHERE p2.service = p.service) AS service_avg  -- Runs for each patientFROM patients p;
```*/



use sqlchallenge;

--1)Show each patient with their service's average satisfaction as an additional column.
SELECT PATIENT_ID, NAME,
(SELECT AVG(SATISFACTION)
FROM patients P2
WHERE P1.SERVICE=P2.SERVICE)
AS SERVICE_AVG_SATISFACTION
FROM patients P1;

--2)Create a derived table of service statistics and query from it.
SELECT P.PATIENT_ID,P.NAME,P.SERVICE,
(SELECT AVG(P2.SATISFACTION)
FROM patients P2
WHERE P2.SERVICE =P.SERVICE)AS AVG_SATIFACTION,
(SELECT COUNT(*)
FROM patients P3
WHERE P3.service= P.SERVICE) AS TOTAL_PATIENTS
FROM patients P;

--3)Display staff with their service's total patient count as a calculated field.
SELECT S.STAFF_ID, S.STAFF_NAME, S.ROLE, S.SERVICE,
(SELECT COUNT(*)
FROM patients P
WHERE P.SERVICE = S.SERVICE) AS SERVICE_PATIENT_COUNT
FROM STAFF S;

/*Create a report showing each service with: service name, total patients admitted, 
the difference between their total admissions and the average admissions across all services,
and a rank indicator ('Above Average', 'Average', 'Below Average').
Order by total patients admitted descending. */
SELECT S.SERVICE, S.TOTAL_ADMITTED, (S.TOTAL_ADMITTED - A.AVG_PATIENT_ADMITTED) AS DIFF_FROM_AVG,
CASE 
    WHEN S.TOTAL_ADMITTED > A.AVG_PATIENT_ADMITTED THEN 'ABOVE AVERAGE'
    WHEN S.TOTAL_ADMITTED < A.AVG_PATIENT_ADMITTED THEN 'BELOW AVERAGE'
ELSE 'AVERAGE'
END AS RANKING_CATEGORY
FROM (SELECT SERVICE, SUM(patients_admitted) AS TOTAL_ADMITTED
       FROM services_weekly
       GROUP BY SERVICE) AS S
CROSS JOIN
(SELECT AVG(TOTAL_PATIENTS_ADMITTED) AS AVG_PATIENT_ADMITTED
FROM (SELECT SERVICE, SUM(PATIENTS_ADMITTED) AS TOTAL_PATIENTS_ADMITTED
      FROM services_weekly
      GROUP BY service) AS DERIVED_TABLE) AS A
      ORDER BY S.TOTAL_ADMITTED DESC;

