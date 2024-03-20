select * from US_Presidents
---First, Standardize date_updated

select date_updated from US_Presidents
SELECT date_updated, CONVERT(date, date_updated) as ConvertedDateUpdated from US_Presidents

ALTER TABLE US_Presidents
DROP COLUMN US_Presidents

UPDATE US_Presidents
SET ConvertedDateUpdated = CONVERT(date, date_updated)

---Secondly, we want to standardize date_created

select date_created from US_Presidents
SELECT date_created, CONVERT(date, date_created) as ConvertedDateCreated from US_Presidents

ALTER TABLE US_Presidents
ADD ConvertedDateCreated DATE

UPDATE US_Presidents
SET ConvertedDateCreated =  CONVERT(date, date_created)


---Now, we want to standardize the president column too as the names are messed up
select president from US_Presidents

select president, TRIM(LOWER(president)) as CleanedPresident from US_Presidents

ALTER TABLE US_Presidents
ADD CleanedPresident NVARCHAR(255)
UPDATE US_Presidents
SET CleanedPresident =  TRIM(LOWER(president))


---WE MIGHT WANT TO SPLIT THE FIRST AND LAST NAME OF THE PRESIDENT COLUMN
select PARSENAME(REPLACE(CleanedPresident, ' ', '.'), 2) as FirstName, 
PARSENAME(REPLACE(CleanedPresident, ' ', '.'), 1) as LastName from US_Presidents

ALTER TABLE US_Presidents
ADD FirstName nvarchar(255)

UPDATE US_Presidents
SET FirstName = PARSENAME(REPLACE(CleanedPresident, ' ', '.'), 2)

ALTER TABLE US_Presidents
ADD LastName nvarchar(255)

UPDATE US_Presidents
SET LastName = PARSENAME(REPLACE(CleanedPresident, ' ', '.'), 1)


select * from US_Presidents

--We also want to clean the VICE column
SELECT vice from US_Presidents
SELECT SUBSTRING(vice, 1, CHARINDEX(' ', vice)-1) as ViceFirstName,
SUBSTRING(vice, CHARINDEX(' ', vice)+1, LEN(vice)) as ViceLastName from US_Presidents

ALTER TABLE US_Presidents
ADD ViceFirstName NVARCHAR(255)
UPDATE US_Presidents
SET ViceFirstName = SUBSTRING(vice, 1, CHARINDEX(' ', vice)-1)



ALTER TABLE US_Presidents
ADD ViceLastName NVARCHAR(255)
UPDATE US_Presidents
SET ViceLastName = SUBSTRING(vice, CHARINDEX(' ', vice)+1, LEN(vice))


select * from US_Presidents

--Then we clean ViceFirstName and ViceLastName
select ViceLastName, TRIM(LOWER(ViceLastName)) as CleanedViceLastName FROM US_Presidents
ALTER TABLE US_Presidents
ADD CleanedViceLastName NVARCHAR(255)
UPDATE US_Presidents
SET CleanedViceLastName = TRIM(LOWER(ViceLastName))


SELECT ViceFirstName, TRIM(LOWER(ViceFirstName)) as CleanedViceFirstName from US_Presidents
ALTER TABLE US_Presidents
ADD CleanedViceFirstName nvarchar(255)
Update US_Presidents
SET CleanedViceFirstName = TRIM(LOWER(ViceFirstName))

--Let us standardize the salary column as well
select salary, CONVERT(decimal, salary) as ConvertedSalary from US_Presidents
ALTER TABLE US_Presidents
ADD ConvertedSalary int;
UPDATE US_Presidents
SET ConvertedSalary =  CONVERT(decimal, salary)

select * from US_Presidents

--Now, we look at the party Column to see if it is cleaned
SELECT DISTINCT(party), COUNT(party) from US_Presidents GROUP BY party

--So we see that, there are some spelling mistakes and ommissions causing differences and needs to be cleaned
select party,
CASE WHEN party = 'Democratic-Republic' THEN 'Democratic'
WHEN party = 'Republicans' THEN 'Republican'
WHEN party = 'Whig   April 4, 1841  –  September 13, 1841' THEN 'Whig'
WHEN party = 'Demorcatic' THEN 'Democratic'
WHEN party = 'Nonpartisan' THEN 'Non-partisan'
ELSE party
END as PartyConverted 
from US_Presidents
ALTER TABLE US_Presidents
ADD PartyConverted nvarchar(255)

UPDATE US_Presidents
SET PartyConverted = CASE WHEN party = 'Democratic-Republic' THEN 'Democratic'
WHEN party = 'Republicans' THEN 'Republican'
WHEN party = 'Whig   April 4, 1841  –  September 13, 1841' THEN 'Whig'
WHEN party = 'Demorcatic' THEN 'Democratic'
WHEN party = 'Nonpartisan' THEN 'Non-partisan'
ELSE party
END

---Now, we want to remove unwanted columns

ALTER TABLE US_Presidents
DROP COLUMN president, prior, party, vice, salary, date_updated, date_created
ALTER TABLE US_Presidents
DROP COLUMN ViceLastName, ViceFirstName

SELECT * FROM US_Presidents
SELECT DISTINCT(CleanedViceLastName) from US_Presidents

--Now we want to remove duplicate values
Select *, ROW_NUMBER() OVER (PARTITION BY CleanedPresident, FirstName, LastName, CleanedViceFirstName, CleanedViceLastName, ConvertedSalary, PartyConverted
ORDER BY CleanedPresident) ROW_NUMBER from US_Presidents

WITH PRESIDENTS AS(
Select *, ROW_NUMBER() OVER (PARTITION BY CleanedPresident, FirstName, LastName, CleanedViceFirstName, CleanedViceLastName, ConvertedSalary, PartyConverted
ORDER BY CleanedPresident) ROW_NUMBER from US_Presidents)
SELECT * FROM PRESIDENTS WHERE ROW_NUMBER > 1
ORDER BY FirstName

--SO TO DELETE THIS DUPLICATE VALUES...
WITH PRESIDENTS AS(
Select *, ROW_NUMBER() OVER (PARTITION BY CleanedPresident, FirstName, LastName, CleanedViceFirstName, CleanedViceLastName, ConvertedSalary, PartyConverted
ORDER BY CleanedPresident) ROW_NUMBER from US_Presidents)
DELETE FROM PRESIDENTS WHERE ROW_NUMBER > 1
--ORDER BY FirstName

Now, lets drop CleanedPresident column as we have already split it
ALTER TABLE US_Presidents
DROP COLUMN CleanedPresident

select * from US_Presidents

---Ermm... the CleanedViceLastName column has some problem

SELECT CleanedViceLastName,
CASE
WHEN CleanedViceLastName = 'c.     calhoun' THEN 'c. calhoun'
ELSE CleanedViceLastName
END as CleanedViceLastName
FROM US_Presidents

UPDATE US_Presidents
SET CleanedViceLastName = CASE
WHEN CleanedViceLastName = 'c.     calhoun' THEN 'c. calhoun'
ELSE CleanedViceLastName
END
FROM US_Presidents

SELECT * FROM US_Presidents

CREATE VIEW US_PRESIDENT_PROJECT AS 
SELECT * FROM US_Presidents