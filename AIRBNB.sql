---First I check for columns with the Distinct Function to know which columns we need to clean and transform for our data
select * from Airbnb_Data$
SELECT DISTINCT(bathrooms) from Airbnb_Data$

--After I identifying columns we need to transform we now begin the work
--Here, we standardize the figures used in the bathroom column to make it simple to understand
SELECT CONVERT(decimal, bathrooms) as bathrooms1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD bathrooms1 int

UPDATE Airbnb_Data$
SET bathrooms1 =  CONVERT(decimal, bathrooms)

select DISTINCT(bathrooms1) from Airbnb_Data$

---Now we standardize the review columns
select CONVERT(date, first_review) as first_reviewDate from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD first_reviewDate date

UPDATE Airbnb_Data$
SET first_reviewDate = CONVERT(date, first_review)
select * from Airbnb_Data$

select DISTINCT(host_has_profile_pic) from Airbnb_Data$

--Then for easy understanding, we need to change the T's and F's so that we know excatly what those are. in this case, True or False
SELECT host_has_profile_pic,
CASE
WHEN host_has_profile_pic = 't' THEN 'True'
WHEN host_has_profile_pic = 'f' THEN 'False'
Else host_has_profile_pic
END as host_has_profile_pic1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD host_has_profile_pic1 varchar(50)

UPDATE Airbnb_Data$
SET host_has_profile_pic1 = CASE
WHEN host_has_profile_pic = 't' THEN 'True'
WHEN host_has_profile_pic = 'f' THEN 'False'
Else host_has_profile_pic
END

select * from Airbnb_Data$

select DISTINCT(host_identity_verified) from Airbnb_Data$
select host_identity_verified,
CASE
WHEN host_identity_verified = 't' THEN 'True'
WHEN host_identity_verified = 'f' THEN 'False'
ELSE host_identity_verified
END as host_identity_verified1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD host_identity_verified1 VARCHAR(50)

UPDATE Airbnb_Data$
SET host_identity_verified1 = CASE
WHEN host_identity_verified = 't' THEN 'True'
WHEN host_identity_verified = 'f' THEN 'False'
ELSE host_identity_verified
END


select * from Airbnb_Data$

--Then we round up the figures for the host_response_rate column
SELECT DISTINCT(host_response_rate) from Airbnb_Data$
select CONVERT(decimal, host_response_rate) as host_response_rate1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD host_response_rate1 INT

UPDATE Airbnb_Data$
SET host_response_rate1 = CONVERT(decimal, host_response_rate)


select * from Airbnb_Data$


---We also standardize the host_since column
SELECT CONVERT(date, host_since)as host_since1 from Airbnb_Data$
ALTER TABLE Airbnb_Data$
ADD host_since1 DATE

UPDATE Airbnb_Data$
SET host_since1 = CONVERT(date, host_since)

select * from Airbnb_Data$

SELECT DISTINCT(instant_bookable) from Airbnb_Data$

SELECT instant_bookable,
CASE
WHEN instant_bookable = 't' THEN 'True'
WHEN instant_bookable = 'f' THEN 'False'
ELSE instant_bookable END as instant_bookable1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD instant_bookable1 varchar(50)

UPDATE Airbnb_Data$
SET instant_bookable1 = CASE
WHEN instant_bookable = 't' THEN 'True'
WHEN instant_bookable = 'f' THEN 'False'
ELSE instant_bookable END

select * from Airbnb_Data$

--Here, we I needed to round the figures into 2 decimal places as show below for longitudes, latitudes and log_price
SELECT CONVERT(decimal(14,2), latitude) as latitude2 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD latitude2 DECIMAL(14,2)

UPDATE Airbnb_Data$
SET latitude2 = CONVERT(decimal(14,2), latitude)

select * from Airbnb_Data$

SELECT CONVERT(decimal(14,2), longitude) as longitude1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD longitude2 DECIMAL(14,2)

UPDATE Airbnb_Data$
SET longitude2 = CONVERT(decimal(14,2), longitude)

select * from Airbnb_Data$

SELECT DISTINCT(bedrooms) from Airbnb_Data$

select CONVERT(decimal(16,2), log_price) as log_price1 from Airbnb_Data$

ALTER TABLE Airbnb_Data$
ADD log_price1 DECIMAL(16,2)

UPDATE Airbnb_Data$
SET log_price1 = CONVERT(decimal(16,2), log_price)

select * from Airbnb_Data$

SELECT DISTINCT(room_type) from Airbnb_Data$

---Now we want to create a review for our Power Bi and by this, we can just automatically drop the columns we wont be using in preparing our dashboard

CREATE VIEW AIRBNB1 as  
SELECT id, property_type, room_type, accommodates, bed_type, cancellation_policy, cleaning_fee, city, name, neighbourhood, number_of_reviews, review_scores_rating, zipcode, bedrooms, beds, bathrooms1,
first_reviewDate, host_has_profile_pic1, host_identity_verified1, host_response_rate1, host_since1, instant_bookable1, log_price1, longitude2, latitude2 from Airbnb_Data$

select * FROM AIRBNB1

--WE SHALL Clear all null values when we import this data now in Power BI for our dashboard

