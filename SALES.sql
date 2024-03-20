select * from Sales$

--we first will like to standardize the date column
select Date from Sales$

select CONVERT(date, Date) as DateConverted from Sales$
Alter table Sales$
ADD DateConverted nvarchar(255)

UPDATE Sales$
SET DateConverted = CONVERT(date, Date)
select * from Sales$

--We also want to standardise Customer-Gender Column. Change M to Male and F to Female for easy understanding
select DISTINCT(Customer_Gender) from Sales$

SELECT Customer_Gender,
CASE
WHEN Customer_Gender = 'F' THEN 'FEMALE'
WHEN Customer_Gender = 'M' THEN 'MALE'
ELSE Customer_Gender
END as Gender FROM Sales$

Alter table Sales$
ADD Gender nvarchar(255)

UPDATE Sales$
SET Gender = CASE
WHEN Customer_Gender = 'F' THEN 'FEMALE'
WHEN Customer_Gender = 'M' THEN 'MALE'
ELSE Customer_Gender
END

select * from Sales$

--Assuming we want to join Country and State column to have a single column containing both informations
select Country, State from Sales$

SELECT CONCAT(Country,', ', State) as Country_State from Sales$
ALTER TABLE Sales$
ADD Country_State NVARCHAR(255)

UPDATE Sales$
SET Country_State = CONCAT(Country,', ', State)

select * from Sales$

--WE WILL LIKE TO STANDARDIZE Age_Group to avoid discrepancies during our visalization
select DISTINCT(Age_Group) from Sales$
select Age_Group,
CASE
WHEN Age_Group = 'Seniors (64+)' THEN 'Seniors'
WHEN Age_Group = 'Young Adults (25-34)' THEN 'Young_Adults'
WHEN Age_Group = 'Adults (35-64)' THEN 'Adults'
WHEN Age_Group = 'Youth (<25)' THEN 'Youth'
END as AgeGroup from Sales$

ALTER TABLE Sales$
ADD AgeGroup nvarchar(255)

UPDATE Sales$
SET AgeGroup = CASE
WHEN Age_Group = 'Seniors (64+)' THEN 'Seniors'
WHEN Age_Group = 'Young Adults (25-34)' THEN 'Young_Adults'
WHEN Age_Group = 'Adults (35-64)' THEN 'Adults'
WHEN Age_Group = 'Youth (<25)' THEN 'Youth'
END
select * from Sales$

--Now we can try calculating to see if calculations are correct
--lets take a look at the profit column, so...
--profit =
select Revenue - Cost from Sales$
--result shows the columns are correct
select * from Sales$

--now let us see if there are duplicates
WITH SalesDataCTE as (select *, ROW_NUMBER() OVER(PARTITION BY Product_Category, Product, Country_State, Gender, Revenue, DateConverted, AgeGroup,
Sub_Category, Customer_Age ORDER BY Country_State, DateConverted, Country_State)ROW_NUMBER from Sales$)
DELETE FROM SalesDataCTE WHERE ROW_NUMBER > 1
select * from Sales$

---Now we want to remove unused columns
ALTER TABLE Sales$
DROP COLUMN Date, Age_Group, Customer_Gender, Country, State


select * from Sales$

---Now let us create view for our visualization later
CREATE VIEW SalesData$ as
select * from Sales$

--Let us open our view
select * from SalesData$