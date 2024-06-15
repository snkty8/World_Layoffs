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

-- Take 2: Finding duplicates
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

--Insert same data into new table including new colums
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

--Industry values with Nulls or blanks
select * from layoffs_2
	where industry is null 
	or industry = 'NULL'
	or industry = ''

select * from layoffs_2
where company like 'Juul%'

update layoffs_2 set industry = 'Consumer'
	where company = 'Juul'
	and industry is null

--Find same company values with that have Nulls values 	
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


--Show rows that have nulls and blanks for total_laid_off and percentage_laid_off	
select * from layoffs_2
where (total_laid_off is null or total_laid_off = 'NULL' or total_laid_off = '')
and (percentage_laid_off is null or percentage_laid_off = 'NULL' or percentage_laid_off = '')

delete from layoffs_2
where (total_laid_off is null or total_laid_off = 'NULL' or total_laid_off = '')
and (percentage_laid_off is null or percentage_laid_off = 'NULL' or percentage_laid_off = '')

select * from layoffs_2 where date is null or date = 'NULL'

--single row with lay_off_date as NULL
delete from layoffs_2
	where date is null or date = 'NULL'

--remove row_num colunm 
alter table layoffs_2
drop column row_num;

--change lay_off_date to date data type
alter table layoffs_2 
alter column date type date
USING date::date;	


--Exploaratory Analysis
select * from layoffs_2;

update layoffs_2 set total_laid_off = '0'
where total_laid_off = 'NULL'

update layoffs_2 set percentage_laid_off = '0'
where percentage_laid_off = 'NULL'

update layoffs_2 set funds_raised_millions = '0'
where funds_raised_millions = 'NULL'

alter table layoffs_2 
alter column total_laid_off type int
USING total_laid_off::int;	

alter table layoffs_2 
alter column percentage_laid_off type float
USING percentage_laid_off::float;	

alter table layoffs_2 
alter column funds_raised_millions type float
USING funds_raised_millions::float;	

select * from layoffs_2;

select max(total_laid_off) from layoffs_2

select max(total_laid_off), max(percentage_laid_off) from layoffs_2

select * from layoffs_2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

select company, sum(total_laid_off)
from layoffs_2
group by company
order by 2 DESC;

select min(date), max(date)
	from layoffs_2;

select extract(year from date), sum(total_laid_off)
from layoffs_2
group by 1
order by 1 DESC;

select stage, sum(total_laid_off)
from layoffs_2
group by stage
order by 2 DESC;

select company, avg(percentage_laid_off)
from layoffs_2
group by company
order by 2 DESC;

--pull sum laid off by month and year
select substring(concat(date_trunc('year', date)::date, '-', date_trunc('month', date)::date),12, 18) as date_test, sum(total_laid_off)
from layoffs_2
group by date_test
order by 1 ASC;

--create rolling sum 
with Rolling_Total as 
(select substring(concat(date_trunc('year', date)::date, '-', date_trunc('month', date)::date),12, 18) as date_test, sum(total_laid_off) as total_gone
from layoffs_2
group by date_test
order by 1 ASC
)
select date_test, total_gone, sum(total_gone) over(order by date_test) as rolling_total
from Rolling_Total;

select company, sum(total_laid_off)
from layoffs_2
group by company
order by 2 DESC;

--group sum laid off by company and year
select company, extract(year from date) as test, sum(total_laid_off)
from layoffs_2
group by company, test
order by 3 DESC;

--Ranking largest lay offs by company and year top 5 each year
with Company_Year (company, years, total_laid_off) as 
(select company, extract(year from date) as test, sum(total_laid_off)
from layoffs_2
group by company, test
order by 3 DESC
), Company_Year_Rank as 
(select *, dense_rank() over (partition by years order by total_laid_off DESC) as rank_years
	from Company_Year
)
select * from Company_Year_Rank	
	where rank_years <= 5
;