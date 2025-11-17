/*INNER JOIN, joining two tables, relationship understanding */

/*INNER JOIN combines rows from two tables based on a related column, returning only matching rows.

**Basic Syntax:**

```sql
SELECT columnsFROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

**How INNER JOIN Works:**
1. Takes each row from table1
2. Looks for matching rows in table2
3. Returns only rows that have matches in BOTH tables
4. Non-matching rows are excluded */

/*Examples:
-- Join patients with staff (same service)SELECT
    p.patient_id,
    p.name AS patient_name,
    p.service,
    s.staff_name,
    s.roleFROM patients p
INNER JOIN staff s ON p.service = s.service
ORDER BY p.service, p.name;
-- Count staff per patient serviceSELECT
    p.patient_id,
    p.name,
    p.service,
    COUNT(s.staff_id) AS staff_count
FROM patients p
INNER JOIN staff s ON p.service = s.service
GROUP BY p.patient_id, p.name, p.service;
-- Multiple join conditionsSELECT *FROM services_weekly sw
INNER JOIN staff_schedule ss
    ON sw.service = ss.service
    AND sw.week = ss.week;
​
💡 Tips & Tricks
✅ Use table aliases for cleaner code:
FROM patients p      -- 'p' is aliasINNER JOIN staff s   -- 's' is alias
​
✅ Always qualify columns in joins to avoid ambiguity:
-- ❌ Ambiguous: SELECT service FROM patients p JOIN staff s...-- ✅ Clear: SELECT p.service FROM patients p JOIN staff s...
​
✅ JOIN is optional - these are the same:
INNER JOIN staff ON...
JOIN staff ON...        -- INNER is default
​
✅ Chain multiple joins:
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.idJOIN table3 t3 ON t2.id = t3.id
​
✅ Use WHERE after ON for additional filtering:
FROM patients p
JOIN staff s ON p.service = s.service
WHERE p.age > 65 */


USE sqlchallenge;

--1)Join patients and staff based on their common service field (show patient and staff who work in same service).
SELECT P.NAME AS PATIENT_NAME, P.SERVICE, S.STAFF_NAME, S.ROLE 
FROM patients P
INNER JOIN staff S
ON P.SERVICE = S.SERVICE
ORDER BY P.SERVICE,P.NAME;

--2)Join services_weekly with staff to show weekly service data with staff information.
SELECT S.SERVICE, W.WEEK , S.STAFF_ID, S.STAFF_NAME, S.ROLE
FROM services_weekly W
INNER JOIN staff S
ON W.SERVICE =S.SERVICE ;

--3)Create a report showing patient information along with staff assigned to their service.
SELECT P.PATIENT_ID,P.NAME PATIENT_NAME, P.AGE, P.ARRIVAL_DATE,P.DEPARTURE_DATE,P.SERVICE,S.STAFF_NAME
FROM patients P
JOIN staff S
ON P.service =S.service

/*Create a comprehensive report showing patient_id, patient name, age, service, 
and the total number of staff members available in their service. 
Only include patients from services that have more than 5 staff members. 
Order by number of staff descending, then by patient name. */

SELECT P.PATIENT_ID, P.NAME PATIENT_NAME, P.AGE, P.SERVICE,
COUNT (S.STAFF_ID) STAFF_COUNT
FROM patients P
JOIN STAFF S
ON P.SERVICE = S.SERVICE
GROUP BY P.PATIENT_ID,P.NAME,P.AGE,P.SERVICE
HAVING COUNT(S.STAFF_ID)>5
ORDER BY COUNT(S.STAFF_ID) DESC;