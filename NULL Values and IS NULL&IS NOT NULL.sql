/*NULL represents missing or unknown data in SQL. It’s not zero, not empty string, but the absence of a value.*/

/*NULL Handling:
-- Check for NULLIS NULLIS NOT NULL-- Replace NULL with default valueCOALESCE(column, default_value)
-- NULL-safe comparison (some databases)column IS DISTINCT FROM value*/

/*✅ **Never use = or != with NULL**

```sql
-- ❌ Wrong: WHERE event = NULL-- ❌ Wrong: WHERE event != NULL-- ✅ Correct: WHERE event IS NULL-- ✅ Correct: WHERE event IS NOT NULL
```

✅ **NULL in arithmetic** makes the entire result NULL:

```sql
-- If any value is NULL, result is NULL5 + NULL = NULLNULL * 10 = NULL
```

✅ **COALESCE accepts multiple arguments** and returns first non-NULL:

```sql
COALESCE(column1, column2, 'default')  -- Returns first non-NULL value
```

✅ **COUNT(*) includes NULLs, COUNT(column) excludes NULLs**

✅ **Handle NULL in ORDER BY**:

```sql
-- Put NULLs lastORDER BY COALESCE(event, 'ZZZZ')  -- Trick to sort NULLs to end
```

✅ **Empty string (’’) is NOT NULL** - they’re different! Always check both if needed*/



use sqlchallenge;

--1)Find all weeks in services_weekly where no special event occurred.
SELECT WEEK,EVENT FROM services_weekly
WHERE EVENT IS NULL OR EVENT='NONE';

--2)Count how many records have null or empty event values.
SELECT COUNT(EVENT) WITHOUT_EVENTS
FROM services_weekly
WHERE EVENT IS NULL OR EVENT ='NONE';

--3)List all services that had at least one week with a special event.
SELECT SERVICE FROM services_weekly
WHERE EVENT IS NULL OR EVENT != 'NONE'
GROUP BY SERVICE;

/* Analyze the event impact by comparing weeks with events vs weeks without events. 
Show: event status ('With Event' or 'No Event'), count of weeks, 
average patient satisfaction, and average staff morale. Order by average patient satisfaction descending.*/

SELECT 
CASE WHEN EVENT='NONE' THEN 'WITHOUT EVENT'
ELSE 'WITH EVENT'
END EVENT_STATUS,
COUNT(*) EVENT_WEEKS,
AVG(PATIENT_SATISFACTION) AVG_PATIENT_SATISFACTION,
AVG(STAFF_MORALE) AVG_STAFF_MORALE
FROM services_weekly
GROUP BY CASE WHEN EVENT='NONE' THEN 'WITHOUT EVENT'
ELSE 'WITH EVENT'
END
ORDER BY AVG(PATIENT_SATISFACTION) DESC;

