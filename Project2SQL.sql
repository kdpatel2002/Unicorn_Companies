select * from Unicorn_Companies


-- countries with the most unicorns

select country, COUNT(*) as total_unicorn_companies
from Unicorn_Companies
group by Country
order by 2 desc;
----------------------------------

-- city with most unicorns
	
select top 20 city, industry, COUNT(*) as total_unicorn_companies
from Unicorn_Companies
where City is not null
group by City, Industry
order by 3 desc;

---------------------------------------------------------------------------
-- Industries with the most unicorns?
select industry, COUNT(*)
from Unicorn_Companies
group by Industry
order by COUNT(*) desc;

-------------------------------------------------------
-- Which unicorn company is the oldest?

SELECT TOP 5
    company,
    YEAR_founded,
    YEAR(date_joined) AS year_joined,
    YEAR(date_joined) - YEAR_founded AS year_difference,
    funding,
    valuation
FROM unicorn_companies
ORDER BY year_founded;

---------------------------------------------------------------------------
-- How long does it usually take for a company to become a unicorn?

SELECT ROUND(AVG(YEAR(date_joined) - YEAR_founded), 1) AS avg_years_difference
FROM unicorn_companies;

-----------------------------------------------------------------------------------------------
-- companies with the most investment in unicorns

WITH SplitInvestors AS (
    SELECT 
        company,
        LTRIM(RTRIM(value)) AS investor
    FROM Unicorn_Companies
    CROSS APPLY STRING_SPLIT(select_investors, ',')
)
SELECT 
    investor, 
    COUNT(*) AS count_of_invested_unicorns
FROM SplitInvestors
WHERE investor IS NOT NULL
GROUP BY investor
ORDER BY count_of_invested_unicorns DESC;

----------------------------------------------------------------
-- funding vs valuation

select company, funding,
		valuation
from Unicorn_Companies;

----------------------------------------------------------------
-- creating row_number on the table

SELECT 
    ROW_NUMBER() OVER (ORDER BY company) AS row_number,
    company,
    valuation,
    date_joined,
    industry,
    city,
    country,
    continent,
    year_founded,
    funding,
    select_investors
FROM 
    Unicorn_Companies;

------------------------------------------------------------------------------------------------------------------------------------
-- Top 3 best-performing industries based on the number of new unicorns created over three years (2019, 2020, and 2021) combined.

	WITH IndustryCount AS (
    SELECT 
        industry,
        COUNT(*) AS count_new_unicorns
    FROM Unicorn_Companies
    WHERE DATEPART(year, date_joined) IN (2019, 2020, 2021)
    GROUP BY industry
)
SELECT TOP 5
    industry,
    count_new_unicorns,
    ROW_NUMBER() OVER (ORDER BY count_new_unicorns DESC) AS rank
FROM IndustryCount
ORDER BY count_new_unicorns DESC;

-----------------------------------------------------------------------------------------------------
-- Calculating the number of unicorns and the average valuation, grouped by year and industry.

SELECT 
    DATEPART(year, date_joined) AS year,
    industry,
    COUNT(*) AS number_of_unicorns,
    AVG(CAST(REPLACE(REPLACE(valuation, '$', ''), 'B', '000000000') AS BIGINT)) AS average_valuation
FROM 
    Unicorn_Companies
where Industry != 'other'
GROUP BY 
    DATEPART(year, date_joined), 
    industry
ORDER BY 
    year, 
    industry;

---------------------------------------------------------------------------------------------------------

--  oldest company and year founded

select top 10 company, industry, year_founded
from Unicorn_Companies
order by Year_Founded;
------------------------------------------------------
-- newest company and year founded

select top 10 company, industry, year_founded
from Unicorn_Companies
order by Year_Founded desc;
---------------------------------------------------------------------
-- company and years to become unicorn (longest and shortest)

select top 10 company, industry, year_founded,
		YEAR(date_joined) - Year_founded as years_to_unicorn
from Unicorn_Companies
order by YEAR(date_joined) - Year_founded desc;


select top 10 company, industry, year_founded,
		YEAR(date_joined) - Year_founded as years_to_unicorn
from Unicorn_Companies
order by YEAR(date_joined) - Year_founded asc;


-------------------------------------------------------------------
-- average valuation per continent
 
select continent, AVG(CAST(REPLACE(REPLACE(valuation, '$', ''), 'B', '000000000') AS BIGINT)) AS average_valuation
from Unicorn_Companies
group by Continent
order by average_valuation desc;

-----------------------------------

-- list of countries with highest valuation

select top 7 country, MAX(CAST(REPLACE(REPLACE(valuation, '$', ''), 'B', '000000000') AS BIGINT)) AS highest_valuation
from Unicorn_Companies
group by Country
order by highest_valuation desc;


-------------------------------------------------------
-- average valuation according to country

SELECT TOP 20 country, 
       REPLACE(CAST(AVG(CAST(REPLACE(REPLACE(valuation, '$', ''), 'B', '000000000') AS BIGINT)) AS VARCHAR), '000000000', 'B') AS average_valuation
FROM Unicorn_Companies
GROUP BY country
ORDER BY average_valuation DESC;

select country, industry, cast(replace(REPLACE(Valuation,'$',''),'B','') as bigint)*1000000000 as valuation1
from Unicorn_Companies
where Country = 'India'

select *,cast(replace(REPLACE(Valuation,'$',''),'B','') as bigint)*1000000000 as valuation1 from Unicorn_Companies


------------------------------------------------------------------------------
--SELECT  
--    COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE 
--FROM  
--    INFORMATION_SCHEMA.COLUMNS 
--WHERE  
--TABLE_NAME = 'unicorn_companies'


----------------------------------------------------------------

-- list of countries and their average valuation.

SELECT Country, continent, AVG(valuation1) AS average_valuation
FROM (
    SELECT *,
           CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS BIGINT) * 1000000000 AS valuation1
    FROM Unicorn_Companies
) subquery
GROUP BY Country, Continent
order by average_valuation desc;


