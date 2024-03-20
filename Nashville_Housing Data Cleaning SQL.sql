select * from nashville_housing
--Convert/ Standardize Date
select SaleDate from nashville_housing
select SaleDate, CONVERT(date, SaleDate) as SaleDateConverted from nashville_housing

Alter table nashville_housing
Add SaleDateConverted date;
Update nashville_housing
SET SaleDateConverted = CONVERT(date, SaleDate)

--Split PropertyAddress into Address and City
select PropertyAddress from nashville_housing
select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as PropertyAddressConverted,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as PropertyAddressCity from nashville_housing

Alter table nashville_housing
Add PropertyAddressConverted nvarchar(255);
Update nashville_housing
SET PropertyAddressConverted = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table nashville_housing
Add PropertyAddressCity nvarchar(255);
UPDATE nashville_housing
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT * FROM nashville_housing

--Split OwnerAddress Into Address, City, State
select OwnerAddress from nashville_housing

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as ConvertedOwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as ConvertedOwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as ConvertedOwnerState from nashville_housing

Alter table nashville_housing
Add ConvertedOwnerAddress nvarchar(255);
Update nashville_housing
SET ConvertedOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter table nashville_housing
Add ConvertedOwnerCity nvarchar(255);
Update nashville_housing
SET ConvertedOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table nashville_housing
Add ConvertedOwnerState nvarchar(255);
Update nashville_housing
SET ConvertedOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select * from nashville_housing


--Now we want to Change Values in  Column
select DISTINCT(SoldAsVacant) from nashville_housing

--Here, we realise in this column, N also means NO and Y MEANS YES and so we can make this column uniform by changing N and Y 
--to YES or NO.
--We want to see if indeed YES AND NO Values are more than N AND Y Values to know which values to convert.
select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) from nashville_housing GROUP BY SoldAsVacant

--NOW
select SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant END as ConvertedSoldAsVacant FROM nashville_housing

Alter table nashville_housing
Add ConvertedSoldAsVacant nvarchar(255);

UPDATE nashville_housing
SET ConvertedSoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant END
--So Let's check
SELECT DISTINCT(ConvertedSoldAsVacant) FROM nashville_housing

--now, we want to remove duplicate items
select *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY SaleDate)
ROW_NUMBER from nashville_housing
--We wanna create a cte table for this to avoid deleting the data so...
WITH ROWNUMBERCTE AS(
select *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY SaleDate)
ROW_NUMBER from nashville_housing)
SELECT * FROM ROWNUMBERCTE WHERE ROW_NUMBER > 1
ORDER BY SaleDate

--SO TO DELETE THESE DUPLICATES, WE...
WITH ROWNUMBERCTE AS(
select *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY SaleDate)
ROW_NUMBER from nashville_housing)
DELETE FROM ROWNUMBERCTE WHERE ROW_NUMBER > 1
--ORDER BY SaleDate
---SO LETS RUN THE WHOLE THING AGAIN.

SELECT * FROM nashville_housing

---SO IT HAS WORKED BECAUSE THE NUMBER OF ROWS HAVE CHANGED FROM 56477 TO 56374 OR WE CAN CHECK BELOW
WITH ROWNUMBERCTE AS(
select *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY SaleDate)
ROW_NUMBER from nashville_housing)
SELECT * FROM ROWNUMBERCTE WHERE ROW_NUMBER > 1
ORDER BY SaleDate

--NOW WE WANT TO DELETE UNUSED COLUMNS OR ONCE WE AREN'T INTERESTED IN
--We want to create a temporary table for this before we decide to remove colums so...

CREATE table #Nashville
(UniqueID int,
ParcelID int,
LandUse varchar(255),
PropertyAddress varchar(255),
SaleDate int,
SalePrice int,
LegalReference int,
SoldAsVacant varchar(255),
OwnerName varchar(255),
OwnerAddress varchar(255),
Acreage int,
TaxDistrict varchar(255),
LandValue int,
BuildingValue int,
TotalValue int,
YearBuilt date,
Bedrooms int,
FullBath int,
HalfBath int,
SaleDateConverted date,
PropertyAddressConverted varchar(255),
PropertyAddressCity varchar(255),
ConvertedOwnerAddress varchar(255),
ConvertedOwnerCity varchar(255),
ConvertedOwnerState varchar(255),
ConvertedSoldAsVacant varchar(255)
)
select * from nashville_housing

INSERT INTO #Nashville
select * from nashville_housing

--So now to remove unused columns OR columns we have converted
select * from nashville_housing

Alter table nashville_housing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress

CREATE VIEW POWERBI as
select * from nashville_housing

SELECT * FROM POWERBI