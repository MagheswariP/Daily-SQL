/*Subqueries are queries nested inside other queries. In WHERE clauses, they filter based on results from another query.

**Basic Syntax:**

SELECT columnsFROM table1
WHERE column IN (
    SELECT column    FROM table2
    WHERE condition
);

### 💡 Tips & Tricks

✅ **IN vs EXISTS**:
- Use IN for small result sets
- Use EXISTS for better performance with large datasets

✅ **Correlated subqueries** reference outer query:

-- Find patients with above-average satisfaction in their serviceSELECT *FROM patients p1
WHERE satisfaction > (
    SELECT AVG(satisfaction)
    FROM patients p2
    WHERE p2.service = p1.service  -- References outer query);

✅ **Handle NULLs with NOT IN**:

-- NOT IN with NULL returns no rows! Use NOT EXISTS or 
IS NOT NULLWHERE service NOT IN (SELECT service FROM table WHERE service IS NOT NULL)


✅ **Single-value subqueries** must return exactly one row:

WHERE age > (SELECT AVG(age) FROM patients)  -- Must return single value
*/


USE sqlchallenge;

--1)Find patients who are in services with above-average staff count.
SELECT PATIENT_ID,NAME FROM patients
WHERE service IN (
    SELECT SERVICE
    FROM STAFF
    GROUP BY SERVICE
    HAVING COUNT(staff_ID) >(SELECT AVG(STAFF_COUNT)
    FROM(SELECT COUNT(STAFF_ID) STAFF_COUNT
    FROM staff
    GROUP BY service
    )AS S
    ));


--2)List staff who work in services that had any week with patient satisfaction below 70.
SELECT STAFF_NAME FROM STAFF
WHERE SERVICE IN(
      SELECT SERVICE
      FROM SERVICES_WEEKLY
      WHERE PATIENT_SATISFACTION <70
      GROUP  BY SERVICE);
      
--3)Show patients from services where total admitted patients exceed 1000.
SELECT PATIENT_ID, NAME FROM patients
WHERE SERVICE IN (
       SELECT SERVICE
       FROM services_weekly
       GROUP BY service
       HAVING SUM(PATIENTS_ADMITTED)>1000
      );

/* Find all patients who were admitted to services that had at least one 
week where patients were refused AND the average patient satisfaction for that
service was below the overall hospital average satisfaction. 
Show patient_id, name, service, and their personal satisfaction score.*/
SELECT PATIENT_ID, NAME, SERVICE,SATISFACTION
FROM patients
WHERE SERVICE IN(
          SELECT SERVICE 
          FROM services_weekly
          WHERE patients_refused >0
          GROUP BY SERVICE
          HAVING AVG(PATIENT_SATISFACTION)<(
                       SELECT AVG(PATIENT_SATISFACTION) 
                       FROM services_weekly)
           );

      
