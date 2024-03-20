select * from Amazon

select CONVERT(Date, OrderDate) AS ConvertedOrderDate FROM Amazon
Alter table Amazon
ADD ConvertedOrderDate nvarchar(255)

Update Amazon
SET ConvertedOrderDate = CONVERT(Date, OrderDate)

select CONVERT(Date, ShipDate) AS ConvertedShipDate FROM Amazon

Alter table Amazon
ADD ConvertedShipDate nvarchar(255)

Update Amazon
SET ConvertedShipDate = CONVERT(Date, ShipDate)

select PARSENAME(REPLACE(Geography, ',', '.'), 3 ) as Country,
PARSENAME(REPLACE(Geography, ',', '.'), 2) as City,
PARSENAME(REPLACE(Geography, ',', '.'), 1) as State from Amazon

ALTER TABLE Amazon
ADD Country nvarchar(255), City nvarchar(255), State nvarchar(255)

UPDATE Amazon
SET Country =  PARSENAME(REPLACE(Geography, ',', '.'), 3 )

UPDATE Amazon
SET City =  PARSENAME(REPLACE(Geography, ',', '.'), 2)

UPDATE Amazon
SET State =  PARSENAME(REPLACE(Geography, ',', '.'), 1 )

select CONVERT(decimal, Sales) as RoundedSales from Amazon
ALTER TABLE Amazon
ADD RoundedSales int

UPDATE Amazon
SET RoundedSales = CONVERT(decimal, Sales)

select CONVERT(decimal, Profit) as RoundedProfit from Amazon
ALTER TABLE Amazon
ADD RoundedProfit int

UPDATE Amazon
SET RoundedProfit = CONVERT(decimal, Profit)

SELECT * FROM Amazon

ALTER table Amazon
DROP COLUMN OrderDate, ShipDate, Geography, Sales, Profit

CREATE VIEW AmazonData as 
select * from Amazon

select * from AmazonData
--removing duplicate values

WITH ROWNUMBERCTE1 AS(select *, ROW_NUMBER() OVER(PARTITION BY EmailID, Category, Quantity, ProductName, ConvertedOrderDate, ConvertedShipDate, Country, City, State, RoundedSales, RoundedProfit
ORDER BY ConvertedOrderDate) ROW_NUMBER from AmazonData)
DELETE FROM ROWNUMBERCTE1 WHERE ROW_NUMBER > 1

---Since there are no duplicate values, I believe we can assume the previous view created is correct. please find it below
select * from AmazonData

