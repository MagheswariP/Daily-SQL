/*UNION combines results from multiple SELECT statements into a single result set.

**Syntax:**

```sql
SELECT column1, column2 FROM table1
UNION [ALL]
SELECT column1, column2 FROM table2;
```

**UNION vs UNION ALL:**
- **UNION**: Removes duplicate rows (slower)
- **UNION ALL**: Keeps all rows including duplicates (faster)

**Requirements:**
- Same number of columns in each SELECT
- Compatible data types in corresponding columns
- Column names from first SELECT are used 

### 💡 Tips & Tricks

✅ **Use UNION ALL when possible** - it’s faster since it doesn’t check for duplicates:

-- If you know there are no duplicates, use UNION ALLSELECT * FROM patients WHERE age < 30UNION ALLSELECT * FROM patients WHERE age > 60  -- No overlap, use UNION ALL

✅ **Column names from first query are used**:

SELECT name AS patient_name FROM patients  -- Result uses 'patient_name'UNIONSELECT staff_name FROM staff  -- 'staff_name' ignored

✅ **Use literals to identify source**:

SELECT name, 'Patient' AS source FROM patients
UNION ALLSELECT staff_name, 'Staff' AS source FROM staff

✅ **Order by applies to final result**:

-- ORDER BY goes at the end (not in individual queries)SELECT name FROM patients
UNIONSELECT staff_name FROM staff
ORDER BY name;  -- Sorts combined result

✅ **Match data types** to avoid errors

*/


use sqlchallenge;

--1)Combine patient names and staff names into a single list.
SELECT NAME AS NAME,'PATIENT' AS TYPE, SERVICE
FROM patients
UNION ALL
SELECT staff_name AS name, 'STAFF' AS type, service
FROM staff
ORDER BY service, type, name;


--2)Create a union of high satisfaction patients (>90) and low satisfaction patients (<50).
SELECT PATIENT_ID, NAME,SATISFACTION , 'HIGH PERFORMER' AS CATEGORY
FROM patients
WHERE satisfaction >= 90
UNION
SELECT patient_id, name, satisfaction, 'Low Performer' AS category
FROM patients
WHERE satisfaction < 50
ORDER BY satisfaction DESC;


--3)List all unique names from both patients and staff tables.
SELECT DISTINCT NAME AS NAME , 
      'PATIENT' AS TYPE  FROM patients
UNION
SELECT DISTINCT STAFF_NAME AS NAME , 
      'STAFF' AS TYPE FROM staff;

 /*Create a comprehensive personnel and patient list showing: 
 identifier (patient_id or staff_id), full name, type ('Patient' or 'Staff'), 
 and associated service. Include only those in 'surgery' or 'emergency' services. 
 Order by type, then service, then name. */
(SELECT NAME AS FULL_NAME, 
        'PATIENT' AS TYPE,
        SERVICE FROM patients
WHERE SERVICE IN ('SURGERY','EMERGENCY'))
UNION
(SELECT STAFF_NAME AS FULL_NAME, 
       'STAFF' AS TYPE, 
       SERVICE FROM staff
WHERE SERVICE IN ('SURGERY','EMERGENCY'))
ORDER BY TYPE,SERVICE,FULL_NAME;

