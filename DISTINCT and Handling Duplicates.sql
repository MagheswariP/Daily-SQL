/*DISTINCT removes duplicate rows from your result set, returning only unique values.

**Basic Syntax:**

```sql
SELECT DISTINCT column1, column2
FROM table_name;
```

**Key Concepts:**
- DISTINCT considers ALL selected columns together
- Acts like “unique combinations”
- Can impact performance on large datasets */

/*✅ **DISTINCT vs GROUP BY**:

```sql
-- These are similar:SELECT DISTINCT service FROM patients;
SELECT service FROM patients GROUP BY service;
-- Use DISTINCT for simple unique values, GROUP BY when you need aggregates
```

✅ **DISTINCT applies to entire row**, not individual columns:

```sql
-- This returns unique combinations of (service, name)SELECT DISTINCT service, name FROM patients;
```

✅ **Use COUNT(DISTINCT column)** to count unique values within groups

✅ **DISTINCT can be expensive** - consider if you really need it or if GROUP BY would work better

✅ **DISTINCT with NULL**: NULL values are considered equal, so only one NULL appears

✅ **Remove duplicates before processing** when possible for better performance */




use sqlchallenge

--Day - 11
--List all unique services in the patients table.

SELECT DISTINCT SERVICE FROM patients;

--Find all unique staff roles in the hospital.

SELECT DISTINCT ROLE FROM staff;

--Get distinct months from the services_weekly table.

SELECT DISTINCT MONTH FROM services_weekly;

/*Question: Find all unique combinations of service 
and event type from the services_weekly table where events 
are not null or none, along with the count of occurrences for each combination. 
Order by count descending.*/

SELECT DISTINCT SERVICE, EVENT, COUNT(*) COUNT_OCCURRENCE
FROM services_weekly
WHERE EVENT NOT IN ('NULL','NONE')
GROUP BY SERVICE, EVENT
ORDER BY COUNT_OCCURRENCE DESC;
