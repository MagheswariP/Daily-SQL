/*Multiple joins combine data from three or more tables in a single query.
Basic Syntax:
SELECT columnsFROM table1
JOIN table2 ON table1.key = table2.keyJOIN table3 ON table2.key = table3.keyLEFT JOIN table4 ON table3.key = table4.key; */

/*Join Order:
- Joins are evaluated left to right
- Results are cumulative (each join adds to the result set)
- Mix INNER and LEFT joins as needed*/

/*### 💡 Tips & Tricks

✅ **Start with the main table** (the one you want all rows from)

✅ **Use LEFT JOIN when you want all rows** from the left table, INNER JOIN when you only want matches

✅ **Join order matters** with mixed join types:

```sql
-- These can produce different results:FROM table1
LEFT JOIN table2 ON ...
INNER JOIN table3 ON ...
FROM table1
INNER JOIN table3 ON ...
LEFT JOIN table2 ON ...
```

✅ **Watch for join conditions** across multiple tables:

```sql
-- Join condition can reference earlier tablesFROM t1
JOIN t2 ON t1.id = t2.idJOIN t3 ON t1.id = t3.id AND t2.status = 'active'
```

✅ **Use DISTINCT or GROUP BY** if joins create duplicates

✅ **Test joins incrementally** - add one join at a time to verify results*/


use sqlchallenge;

--1)Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT P.PATIENT_ID,P.NAME PATIENT_NAME, S.STAFF_NAME,SS.SERVICE, SS.PRESENT STAFF_AVAILABILITY
 FROM PATIENTS P
 LEFT JOIN STAFF S ON P.SERVICE= S.SERVICE 
 LEFT JOIN STAFF_SCHEDULE SS ON S.SERVICE =SS.SERVICE;

 --2)Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
 SELECT SW.week,SW.MONTH, S.STAFF_NAME,S.role, SS.SERVICE,SS.present
 FROM services_weekly SW
 LEFT JOIN STAFF S ON SW.SERVICE =S.SERVICE
 LEFT JOIN STAFF_SCHEDULE SS ON S.SERVICE =SS.SERVICE;

 --3)Create a multi-table report showing patient admissions with staff information.
 SELECT P.NAME PATIENT_NAME,SW.PATIENTS_ADMITTED,S.*
 FROM patients P
 LEFT JOIN services_weekly SW ON P.SERVICE =SW.SERVICE
 LEFT JOIN staff S ON SW.SERVICE =S.SERVICE;

 /* Create a comprehensive service analysis report for week 20 showing: service name, total patients admitted 
 that week, total patients refused, average patient satisfaction, count of staff assigned to service, 
 and count of staff present that week. Order by patients admitted descending.*/

SELECT SW.WEEK, SW.SERVICE SERVICE_NAME, 
       SUM(SW.PATIENTS_ADMITTED) PATIENTS_ADMITTED, 
       SUM(SW.PATIENTS_REFUSED) PATIENTS_REFUSED,
       AVG(SW.PATIENT_SATISFACTION) PATIENTS_SATISFACTION, 
       COUNT(DISTINCT s.staff_id) AS assigned_staff,
       SUM(CASE WHEN ss.present = 1 THEN 1 ELSE 0 END) AS staff_present
FROM services_weekly SW
LEFT JOIN STAFF S ON SW.SERVICE =S.SERVICE
LEFT JOIN staff_schedule SS ON S.SERVICE =SS.SERVICE
GROUP BY SW.WEEK, SW.SERVICE ,SW.PATIENTS_ADMITTED,SW.PATIENTS_REFUSED, SW.PATIENT_SATISFACTION
ORDER BY patients_admitted DESC;

