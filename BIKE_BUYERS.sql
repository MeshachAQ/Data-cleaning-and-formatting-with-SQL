select * from bike_buyers

--First, we want to tandardize Marital Status and Gender column for easy understanding
select DISTINCT(MaritalStatus) from bike_buyers

---so we want to change all M's to Married and Ss to Single
SELECT MaritalStatus, 
CASE
WHEN MaritalStatus = 'S' THEN 'Single'
WHEN MaritalStatus = 'M' THEN 'Married'
Else MaritalStatus
END as MaritalStatus from bike_buyers

UPDATE bike_buyers
SET MaritalStatus = CASE
WHEN MaritalStatus = 'S' THEN 'Single'
WHEN MaritalStatus = 'M' THEN 'Married'
Else MaritalStatus
END
select * from bike_buyers

---Now we do same for Gender
SELECT DISTINCT(Gender) from bike_buyers

select Gender,
CASE
WHEN Gender = 'F' THEN 'FEMALEle'
WHEN Gender = 'M' THEN 'MALE'
ELSE Gender
END as Gender from bike_buyers

UPDATE bike_buyers
SET Gender = CASE
WHEN Gender = 'F' THEN 'FEMALE'
WHEN Gender = 'M' THEN 'MALE'
ELSE Gender
END

---SORRY LET US MAKE ONLY FIRST LETTER CAPITAL
select Gender,
CASE
WHEN Gender = 'FEMALE' THEN 'Female'
WHEN Gender = 'MALE' THEN 'Male'
ELSE Gender
END as Gender from bike_buyers

UPDATE bike_buyers
SET Gender = CASE
WHEN Gender = 'FEMALE' THEN 'Female'
WHEN Gender = 'MALE' THEN 'Male'
ELSE Gender
END

select * from bike_buyers

---Now we want to change the format for the income column for easy reading
Select DISTINCT(Income) from bike_buyers
SELECT Income, CONVERT(decimal, Income) as Incomeconverted from bike_buyers

ALTER TABLE bike_buyers
ADD Incomeconverted int;

UPDATE bike_buyers
SET Incomeconverted =  CONVERT(decimal, Income)


select * from bike_buyers
---let's take a look at Occupation if it is standardized so...
SELECT DISTINCT(Occupation) from bike_buyers

---so it is standardized

--Now, looking at this data, the commute distance column, we might have a problem visualizing 10+ miles so we want to chnage that to 
--'more than 10 miles'

SELECT DISTINCT(CommuteDistance) from bike_buyers

select CommuteDistance,
CASE
WHEN CommuteDistance = '10+ Miles' THEN 'More than 10 Miles'
ELSE CommuteDistance
END as CommuteDistance from bike_buyers

UPDATE bike_buyers
SET CommuteDistance = CASE
WHEN CommuteDistance = '10+ Miles' THEN 'More than 10 Miles'
ELSE CommuteDistance
END 

select * from bike_buyers

--Now let us see if there is anything to standardize at the Region column
SELECT DISTINCT(Region) from bike_buyers

--Since, it is okay, we want to look at the Age column, now it will be difficult to use the age column as it is for visualization
--hence, we want to group the age column into bracket

SELECT DISTINCT(Age) from bike_buyers ORDER BY Age DESC
---OKAY SO THE AGE RANGE STARTS FROM 25-89
---We want to group age bracket such that age 25-39 shall be 'YOUNG ADULTS', Age 40-59 shall be 'Adults' and above age 59, 'old'

SELECT Age,
CASE
WHEN (Age <='39') THEN 'Young_Adults'
WHEN (Age > '59') THEN 'old'
ELSE 'Adults'
END as AgeConverted FROM bike_buyers

ALTER TABLE bike_buyers
ADD AgeConverted NVARCHAR(255)

UPDATE bike_buyers
SET AgeConverted = CASE
WHEN (Age <='39') THEN 'Young_Adults'
WHEN (Age > '59') THEN 'old'
ELSE 'Adults'
END

CREATE TABLE #bike_buyers2
(ID int,
MaritalStatus nvarchar(255),
Gender nvarchar(255),
Income int,
Children int,
Education nvarchar(255),
Occupation nvarchar(255),
HomeOwner nvarchar(255),
Cars int,
CommuteDistance nvarchar(255),
Region nvarchar(255),
Age int,
PurchasedBike nvarchar(255),
Incomeconverted int,
AgeConverted nvarchar(255)
)

INSERT INTO #bike_buyers2
SELECT * FROM bike_buyers


--We will want to remove unused columns now so...
ALTER TABLE bike_buyers
DROP COLUMN Income, Age

select * from bike_buyers

--Now we want to create view for our visualization

CREATE VIEW BIKE AS
select * from bike_buyers

SELECT * FROM BIKES

--let's remove duplicates
WITH BIKE2 AS(
select *, ROW_NUMBER()
OVER (PARTITION BY MaritalStatus, GENDER, Education, Occupation, CommuteDistance, Incomeconverted, AgeConverted ORDER BY MaritalStatus)
ROW_NUMBER FROM BIKE)
SELECT * FROM BIKE2 WHERE ROW_NUMBER > 1
ORDER BY MaritalStatus

WITH BIKE2 AS(
select *, ROW_NUMBER()
OVER (PARTITION BY MaritalStatus, GENDER, Education, Occupation, CommuteDistance, Incomeconverted, AgeConverted ORDER BY MaritalStatus)
ROW_NUMBER FROM BIKE)
DELETE FROM BIKE2 WHERE ROW_NUMBER > 1
--ORDER BY MaritalStatus

select * from bike_buyers

CREATE VIEW BIKERS AS
select * from bike_buyers

select * from BIKERS