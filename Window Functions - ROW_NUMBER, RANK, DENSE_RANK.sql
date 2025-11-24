/*Window functions perform calculations across rows related to the current row, without collapsing results like GROUP BY.

**Basic Syntax:**

```sql
window_function() OVER (
    [PARTITION BY column]
    [ORDER BY column]
)
```

**Ranking Functions:**
- **ROW_NUMBER()**: Sequential numbering (1, 2, 3, 4…)
- **RANK()**: Same values get same rank, gaps after ties (1, 2, 2, 4…)
- **DENSE_RANK()**: Same values get same rank, no gaps (1, 2, 2, 3…)
*/
/*### 💡 Tips & Tricks

✅ **PARTITION BY is optional** - without it, window applies to entire result set:

```sql
-- Rank across all patientsRANK() OVER (ORDER BY satisfaction DESC)
-- Rank within each serviceRANK() OVER (PARTITION BY service ORDER BY satisfaction DESC)
```

✅ **Choose the right ranking function**:
- ROW_NUMBER() when you need unique numbers
- RANK() when ties should skip numbers (1, 2, 2, 4)
- DENSE_RANK() when ties shouldn’t skip (1, 2, 2, 3)

✅ **Filter ranked results with subquery**:

```sql
-- Can't use WHERE with window functions directly-- Use subquery:SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY age DESC) AS rn
    FROM patients
) WHERE rn <= 10  -- Top 10 oldest patients
```

✅ **ORDER BY in OVER is different from query ORDER BY**:

```sql
SELECT
    name,
    ROW_NUMBER() OVER (ORDER BY age DESC) AS rn  -- For numberingFROM patients
ORDER BY name;  -- For final result display
```*/



use sqlchallenge;

--1)Rank patients by satisfaction score within each service.
 SELECT patient_id, name, service,satisfaction,
    DENSE_RANK() OVER (
            PARTITION BY service 
            ORDER BY satisfaction DESC) AS row_num
FROM patients;

--2)Assign row numbers to staff ordered by their name.
SELECT STAFF_ID,STAFF_NAME,
      ROW_NUMBER() OVER(ORDER BY STAFF_NAME) AS ROLL_NUM
FROM staff;

--3)Rank services by total patients admitted.
SELECT
   service,
    SUM(patients_admitted) AS total_admitted,
    RANK() OVER (ORDER BY SUM(patients_admitted) DESC) AS admission_rank
FROM services_weekly
GROUP BY service;


/*For each service, rank the weeks by patient satisfaction score (highest first). 
Show service, week, patient_satisfaction, patients_admitted, and the rank. 
Include only the top 3 weeks per service. */

WITH RANKED AS
(SELECT SERVICE, 
       WEEK, 
       PATIENT_SATISFACTION, 
       PATIENTS_ADMITTED,
       RANK() OVER(
               PARTITION BY SERVICE 
               ORDER BY PATIENT_SATISFACTION DESC) AS SATISFACTION_RATE
FROM services_weekly
)
SELECT* FROM RANKED
WHERE SATISFACTION_RATE <=3;



