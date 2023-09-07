SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- DATA CLEANING
-- Checking if there is any syntax error where the answer should be unique

SELECT COUNT(reviewer_id)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
-- output = 33396

SELECT COUNT(DISTINCT reviewer_id)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
-- output = 33396

-- Since both the total count and the distinct count are the same, we can conclude that there are no duplicates

SELECT COUNT(DISTINCT store_name)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
-- output = 2
-- This means that the store name was misspelled in at least one entry

SELECT DISTINCT store_name
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- Cleaning the data by creating a new column with the corrected spelling

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD cleaned_store_name VARCHAR(255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET cleaned_store_name = RIGHT(store_name, 10)

-- Checking if it was  corrected

SELECT DISTINCT cleaned_store_name
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

SELECT COUNT(DISTINCT category)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

SELECT COUNT(DISTINCT store_address), COUNT(DISTINCT [latitude ]), COUNT(DISTINCT longitude)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- Separating store_adrress into different columns more useful for analysis
-- Found some NULLs when the store_address state was Los Angeles so I had to update the query

SELECT store_address
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

SELECT 
PARSENAME (REPLACE(store_address, ',', '.'), 4),
PARSENAME (REPLACE(store_address, ',', '.'), 3),
PARSENAME (REPLACE(store_address, ',', '.'), 2),
PARSENAME (REPLACE(store_address, ',', '.'), 1)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD store_split_address NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET store_split_address = IIF (store_split_address IS NULL, SUBSTRING(store_address, 0, 38),
						PARSENAME (REPLACE(store_address, ',', '.'), 4) )

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD store_split_state NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET store_split_state = IIF (store_split_state IS NULL, SUBSTRING(store_address, 40, 10),
						PARSENAME (REPLACE(store_address, ',', '.'), 3) )

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD store_split_zipcode NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET store_split_zipcode = IIF (store_split_zipcode IS NULL, SUBSTRING(store_address, 51, 9),
						PARSENAME (REPLACE(store_address, ',', '.'), 2) )

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD store_split_country NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET store_split_country = IIF (store_split_country IS NULL, SUBSTRING(store_address, 61, 15),
						PARSENAME (REPLACE(store_address, ',', '.'), 1) )

SELECT DISTINCT store_address, store_split_state
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
ORDER BY store_split_state

-- NOTE: There are states with more than one store!

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
ORDER BY store_split_state


-- The column rating_count would be more useful if it was a whole number

SELECT CAST(rating_count AS int)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD rounded_rating_count NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET rounded_rating_count = CAST(rating_count AS int)

-- The rating column would also be more useful if it was a whole number

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD rating_value VARCHAR(255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET rating_value = LEFT(rating, 1)

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- Checking for null values

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE years_past IS NULL

-- I checked all the columns in the same query

-- Deleting data with errors

SELECT store_address
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE store_address LIKE '%¿½ï%'

DELETE
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE store_address LIKE '%¿½ï%'

SELECT review
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE review LIKE '%½ï%'

DELETE
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE review LIKE '%¿½ï%'

-- Breaking the review_time column to make it usable

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
ORDER BY review_time DESC


SELECT 
PARSENAME (REPLACE(review_time, ' ', '.'), 3),
PARSENAME (REPLACE(review_time, ' ', '.'), 2),
PARSENAME (REPLACE(review_time, ' ', '.'), 1)
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD review_split_time NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time = PARSENAME (REPLACE(review_time, ' ', '.'), 3)

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD review_split_time_2 NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_2 = PARSENAME (REPLACE(review_time, ' ', '.'), 2)

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD review_split_time_3 NVARCHAR (255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_3 = PARSENAME (REPLACE(review_time, ' ', '.'), 1)

-- Now we need to clean the data in these columns

-- Replacing 'a' with '1' in review_split_time and replacing the plural words into sigulars

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time = REPLACE(review_split_time, 'a', '1')

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_2 = REPLACE(review_split_time_2, 'years', 'year')

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_2 = REPLACE(review_split_time_2, 'months', 'month')

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_2 = REPLACE(review_split_time_2, 'weeks', 'week')

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET review_split_time_2 = REPLACE(review_split_time_2, 'days', 'day')

-- We don't need the 'ago' column so let's delete it

ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
DROP COLUMN review_split_time_3

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
ORDER BY review_time DESC

SELECT DISTINCT review_split_time_2
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- Turning review_time data into yearly data to improve data visualization

-- If the data says months, days, weeks or hours ago we can aggregate those reviews in the year 0
SELECT IIF (review_split_time_2 = 'year', review_split_time * 1 ,
		IIF (review_split_time_2 = 'month', 0,
			IIF (review_split_time_2 = 'week', 0,
			IIF (review_split_time_2 = 'day', 0,
				0)))) AS years_past
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
	
ALTER TABLE PortfolioProject_1.dbo.McDonald_s_Reviews
ADD years_past varchar(255)

UPDATE PortfolioProject_1.dbo.McDonald_s_Reviews
SET years_past = (SELECT IIF (review_split_time_2 = 'year', review_split_time * 1 ,
		IIF (review_split_time_2 = 'month', 0,
			IIF (review_split_time_2 = 'week', 0,
			IIF (review_split_time_2 = 'day', 0,
				0)))))

SELECT *
FROM PortfolioProject_1.dbo.McDonald_s_Reviews


-- All the data we need as been cleaned

-- Now to the Analysis

-- Let's start by checking the overall average rating

SELECT AVG(CAST(rating_value AS INT))
FROM PortfolioProject_1.dbo.McDonald_s_Reviews

-- The average store rating is 3

-- Average rating by state

SELECT store_split_state, AVG(CAST(rating_value AS INT))
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
GROUP BY store_split_state
ORDER BY store_split_state

-- The average store rating per state varies beteween 2 and 3

SELECT store_split_state, rating_count
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
ORDER BY store_split_state

-- NOTE: The number of voters varies a lot from state to state!

-- What stores are doing better than average?

SELECT store_split_state, store_split_address, AVG(CAST(rating_value AS INT))
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE rating_value > 3
GROUP BY store_split_state, store_split_address
ORDER BY AVG(CAST(rating_value AS INT)) DESC, store_split_state

-- Los Angeles and New York are the best rated (5), followed by Annandale and others with a rating of 4

-- What stores are doing worst than average?

SELECT store_split_state, store_split_address, AVG(CAST(rating_value AS INT))
FROM PortfolioProject_1.dbo.McDonald_s_Reviews
WHERE rating_value < 3
GROUP BY store_split_state, store_split_address
ORDER BY AVG(CAST(rating_value AS INT)) DESC, store_split_state

-- Some exemples of the worst rated stores are located in Austin, Dallas and Las Vegas, with a 1 star rating

