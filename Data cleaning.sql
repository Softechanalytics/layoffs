Select * 
from layoffs

--1. Remove Duplicates
--2. Standardize the data
--3. Null Values or Blank Values
--4. Remove unneccessary columns

/* step 1.
Create a staging table, duplicate of the original data
*/
-- To copy data from layoff into layoff_staging table
Select *
into layoff_staging
From layoffs;

Select *
from layoff_staging2;

-- remove duplicate data (We are going to use Row_Number and check where the row_number is greater than 1)

WITH duplicate_CTE AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [Date],stage,country,funds_raised_millions
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM layoff_staging2
)

SELECT *
FROM duplicate_CTE
WHERE row_num > 1;

-- Note, 5 duplicates identified
-- double check the field again like
Select *
from layoff_staging2
where company = 'yahoo';

-- To remove the duplicate, we would repeat the CTE used in checking for duplicates but, we would replace the select to delete
WITH deleteDuplicate_CTE AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [Date],stage,country,funds_raised_millions
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM layoff_staging2
)

Delete
FROM deleteDuplicate_CTE
WHERE row_num > 1;


-- Standardizing Data
-- Note: We need to standardize the Company field as it as has some space, so we use the Trim Syntax

Select company, trim(company)
from layoff_staging2;

UPDATE layoff_staging2
set company = Trim(company); -- To remove the whitespace

UPDATE layoff_staging2
set location = Trim(location);

UPDATE layoff_staging2
set industry = Trim(industry);

UPDATE layoff_staging2
set stage = trim(stage);


UPDATE layoff_staging2
set country = Trim(country);

-- 2. Let check the industry field
select distinct Industry
from layoff_staging2
order by industry;

-- Note, we have some null values, also we need to standardize some of the company name, such as Crypto, cypto Currency, cyrtocurrency etc

Select INdustry
From layoff_staging2
where Industry like 'Crypto%';

-- let update 

update layoff_staging2
set INdustry = 'Crypto'
where INdustry like 'Crypto%';

select distinct country
from layoff_staging2
order by Country;

update layoff_staging2
set country = 'United States'
where Country like 'United Sta%';

-- Note the Date is in String format and if we are going to do time series analysis, then we can need to convert this from string to Date

SELECT 
    [date],
    TRY_CONVERT(DATE, [date], 101) AS ConvertedDate
FROM 
    layoff_staging2;

-- Let use update
update layoff_staging2
set date = TRY_CONVERT(DATE, [date], 101) ;

select *
from layoff_staging2;

-- Change the field type from Varchar to date field
Alter table layoff_staging2
Alter COLUMN [date] Date;

-- Working with Null and blank values

Select distinct industry
from layoff_staging2
order by industry;

Select *
from layoff_staging2
where Industry = Null;

Select *
from layoff_staging2
where company   like 'Bally%';

update layoff_staging2
set industry = 'Transportation'
where company = 'Carvana';

-- Convert the field type from Nvarchar to Float

SELECT percentage_laid_off
FROM layoff_staging2
WHERE TRY_CAST(percentage_laid_off AS FLOAT) IS NULL
  AND percentage_laid_off IS NOT NULL;

  SELECT 
    percentage_laid_off,
    TRY_CAST(percentage_laid_off AS FLOAT)AS ConvertedPercentage
FROM 
    layoff_staging2;


Update layoff_staging2
set percentage_laid_off = TRY_CAST(percentage_laid_off AS FLOAT);

Alter table layoff_staging2
alter column percentage_laid_off FLOAT;

select *
From layoff_staging2;

-- Let remove unneed row, let remove rows without total_laid_off value, since the dataset is about layoff, so if a row does not contain layoff value, hence it is not essential to the dataset

select *
From layoff_staging2
where total_laid_off is null 
and Percentage_laid_off is null;

-- Delete rows with total_laid_off is null and Percentage_laid_off is Null

Delete
From layoff_staging2
where total_laid_off is null 
and Percentage_laid_off is null;

-- Remove unneed column
alter table layoff_staging2
drop column row_num;

