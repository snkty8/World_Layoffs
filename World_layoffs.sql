Create Table layoffs (
	company text,
	location text,
	industry text,
	total_laid_off text,
	percentage_laid_off text,
	date text,
	stage text,
	country text,
	funds_raised_millions text
);


-- Steps for ETL
-- 1. Remove duplicates
-- 2. Standized the Data
-- 3. Null Values 
-- 4. Remove Columns not Needed 
--
create table layoffs_backup
as table layoffs;

--Remove duplicates
select * from layoffs;


select *, 
	row_number() over(
	partition by company, industry, total_laid_off, percentage_laid_off, date) as row_num
from layoffs;

-- row_num > 1 are the dupilcates
with duplicate_cte as 
(select *, 
	row_number() over(
	partition by company, industry, total_laid_off, percentage_laid_off, date) as row_num
from layoffs
)
select * from duplicate_cte
where row_num > 1;

--Checking duplicate data and finding this not a duplicate and need to partition over all colums in query above
select * from layoffs where company = 'Oda';

-- Take 2 on finding duplicates
with duplicate_cte as 
(select *, 
	row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ) as row_num
from layoffs
)
select * from duplicate_cte
where row_num > 1;

-- This is for sure a duplicate
select * from layoffs where company = 'Casper';

--Create table new table with new colum, row_num to delete the duplicates
CREATE TABLE IF NOT EXISTS public.layoffs_2
(
    company text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    industry text COLLATE pg_catalog."default",
    total_laid_off text COLLATE pg_catalog."default",
    percentage_laid_off text COLLATE pg_catalog."default",
    date text COLLATE pg_catalog."default",
    stage text COLLATE pg_catalog."default",
    country text COLLATE pg_catalog."default",
    funds_raised_millions text COLLATE pg_catalog."default",
	row_num int
)

TABLESPACE pg_default;

select * from layoffs_2;

insert into layoffs_2
select *, 
	row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ) as row_num
from layoffs;

select * from layoffs_2;

--Delete the duplicates
delete from layoffs_2
where row_num > 1;

--Standardizing the data

--Trim any white space
select company, trim(company) from layoffs_2;

update layoffs_2 set company = trim(company);


select * from layoffs_2
where industry like 'Crypto%';

update layoffs_2 set industry = 'Crypto'
where industry like 'Crypto%';

-- Now scan each distinct column for any noticible issues
select distinct country from layoffs_2
order by 1;

select * from layoffs_2
where country like 'United States%'
order by 1;

-- Found an issue with United States. Some values have a period at the end.
select distinct country, trim(trailing '.' from country)
from layoffs_2 
order by 1;

-- Get rid of the period 
update layoffs_2 set country = trim(trailing '.' from country)
where country like 'United States%';

--Change date column to acutal date data
select date, TO_DATE(date, 'MM/DD/YYYY') from layoffs_2 
	where date <> 'NULL'

update layoffs_2 set date = TO_DATE(date, 'MM/DD/YYYY') where date <> 'NULL'

select * from layoffs_2;

--Can't alert due to NULL 
alter table layoffs_2 
alter column lay_off_date type date
USING lay_off_date::date;	

--Handle the Nulls
select * from layoffs_2 where total_laid_off = 'NULL'


select * from layoffs_2
	where industry is null 
	or industry = 'NULL'
	or industry = ''

select * from layoffs_2
where company like 'Bally%'

select * from layoffs_2 t1
join layoffs_2 t2
on t1.company = t2.company 
where t1.industry is null
and t2.industry is not null

update layoffs_2 set industry = NULL
	where industry = '';
	
update layoffs_2 t1
join layoffs_2 t2 
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null

	
select * from layoffs_2
where (total_laid_off is null or total_laid_off = 'NULL' or total_laid_off = '')
and (percentage_laid_off is null or percentage_laid_off = 'NULL' or percentage_laid_off = '')

delete from layoffs_2
where (total_laid_off is null or total_laid_off = 'NULL' or total_laid_off = '')
and (percentage_laid_off is null or percentage_laid_off = 'NULL' or percentage_laid_off = '')
and 	

select * from layoffs_2 where lay_off_date is null or lay_off_date = 'NULL'

delete from layoffs_2
	where lay_off_date is null or lay_off_date = 'NULL'

alter table layoffs_2
drop column row_num;

alter table layoffs_2 
alter column lay_off_date type date
USING lay_off_date::date;	

select * from layoffs_2;