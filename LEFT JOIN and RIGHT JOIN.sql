/*LEFT JOIN returns all rows from the left table, with matching rows from the right table (or NULL if no match). 
RIGHT JOIN does the opposite.*/

/***Basic Syntax:**

```sql
-- LEFT JOIN (most common)SELECT columnsFROM table1
LEFT JOIN table2 ON table1.column = table2.column;
-- RIGHT JOIN (less common)SELECT columnsFROM table1
RIGHT JOIN table2 ON table1.column = table2.column;
```

**Key Differences:**
- **INNER JOIN**: Only matching rows from both tables
- **LEFT JOIN**: All rows from left table + matches from right (NULL if no match)
- **RIGHT JOIN**: All rows from right table + matches from left (NULL if no match)*/


/*💡 Tips & Tricks
✅ LEFT JOIN is more common than RIGHT JOIN - you can rewrite RIGHT as LEFT by swapping tables:
-- These are equivalent:FROM table1 RIGHT JOIN table2 ON ...
FROM table2 LEFT JOIN table1 ON ...
​
✅ Use COALESCE with LEFT JOIN to handle NULLs:
SELECT
    s.staff_name,
    COALESCE(SUM(ss.present), 0) AS weeks_present  -- 0 instead of NULLFROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
​
✅ Find non-matching rows using WHERE column IS NULL:
-- Staff with no schedule entriesFROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
WHERE ss.staff_id IS NULL
​
✅ WHERE vs ON in LEFT JOIN:
-- ON: Filters before joining (keeps all left rows)LEFT JOIN table2 ON condition AND table2.column = 'value'-- WHERE: Filters after joining (can exclude left rows)LEFT JOIN table2 ON condition
WHERE table2.column = 'value' */


use sqlchallenge;

--1)Show all staff members and their schedule information (including those with no schedule entries).
SELECT S.*,
COUNT(SS.WEEK) WEEKS,
SUM(COALESCE(SS.PRESENT,0)) PRESENTS
FROM STAFF S
LEFT JOIN STAFF_SCHEDULE SS ON S.STAFF_ID= SS.STAFF_ID
GROUP BY S.STAFF_ID,S.STAFF_NAME,S.ROLE,S.SERVICE;

--2)List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT S.STAFF_ID,S.STAFF_NAME,SW.SERVICE,SW.WEEK
FROM services_weekly SW
LEFT JOIN STAFF S
ON SW. SERVICE= S.SERVICE;

--3)Display all patients and their service's weekly statistics (if available).
SELECT P.PATIENT_ID,P.NAME,P.SERVICE,SW.WEEK
FROM patients P
LEFT JOIN services_weekly SW
ON P.service =SW.service;

/*Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service)
and the count of weeks they were present (from staff_schedule). Include staff members even if 
they have no schedule records. Order by weeks present descending.*/
SELECT S.*, COALESCE(COUNT(SS.WEEK),0) WEEKS_PRESENT
FROM STAFF S
LEFT JOIN STAFF_SCHEDULE SS
ON S.STAFF_ID =SS.STAFF_ID AND SS.PRESENT =1
GROUP BY S.STAFF_ID,S.staff_name,S.role,S.service
ORDER BY WEEKS_PRESENT DESC;