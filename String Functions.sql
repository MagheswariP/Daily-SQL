/*String functions manipulate text data in your queries.*/

/*✅ Use || or CONCAT for string concatenation (database-dependent):
-- SQLite/PostgreSQL: name || ' - ' || service-- MySQL: CONCAT(name, ' - ', service)
​
✅ TRIM variants: LTRIM() (left), RTRIM() (right), TRIM() (both sides)
✅ Case-insensitive comparison:
WHERE LOWER(name) = LOWER('john smith')  -- Matches any case
​
✅ String functions are great in SELECT but avoid them in WHERE for better performance (they prevent index usage)
✅ Combine with CASE for complex logic:
SELECT
    name,
    CASE
        WHEN LENGTH(name) > 20 THEN SUBSTRING(name, 1, 20) || '...'        ELSE name
    END AS display_name
FROM patients; */


use sqlchallenge;


--1)Convert all patient names to uppercase.

SELECT UPPER(NAME) AS PATIENT_NAME FROM patients;

--2)Find the length of each staff member's name.

SELECT LEN (STAFF_NAME) AS LENGTH_OF_STAFF_NAME
FROM staff;

--3)Concatenate staff_id and staff_name with a hyphen separator.

SELECT CONCAT(STAFF_ID,' - ',STAFF_NAME) AS STAFF_ID_AND_NAME
FROM staff;

/*Create a patient summary that shows patient_id, full name in uppercase, 
service in lowercase, age category (if age >= 65 then 'Senior',
if age >= 18 then 'Adult', else 'Minor'), and name length. 
Only show patients whose name length is greater than 10 characters.*/
SELECT UPPER(NAME) AS PATIENT_NAME,
       LOWER(SERVICE) AS SERVICE,
       LEN(NAME) AS NAME_LENGTH,
 (CASE
    WHEN AGE >=65 THEN 'SENIOR'
    WHEN AGE >=18 THEN 'ADULT'
    ELSE 'MINOR'
  END) AS CATEGORY
  FROM patients
WHERE LEN(NAME)>10;
