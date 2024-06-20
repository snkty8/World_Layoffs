# World_Layoffs

Dataset contains layoff data from around the world from 2020 to the first few months of 2023. PgAdmin used to analyze. 

## ETL Process 
### Started by removing duplicates: 
Created CTE and partioned over company, industry, total laid off, percentage laid off, and added column indicated to count of each. A count greater than 1, indicates duplicates:

<img width="563" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/2fe44b86-cf66-428f-af6a-1fa21c371cbe">

To check, chose company Oda to compare each value in each row. As you can see, these are now true duplicates. Edited query to partion over all columns:

<img width="473" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/8606619b-11b1-4ef1-8179-3a6d011b22bc">

These should be true duplicates: 

<img width="565" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/329fe7ea-82d8-4f97-8511-e71a9cc76fa4">

To check, chose company: Casper. This shows true duplicate lines: 

<img width="512" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/6d08ac3b-fa7c-4a1c-97b5-96fed610b96d">

With duplicates indenified, created a new table: layoffs_2 and used this one as to continue. This way the original data is not affected, and I have a way to restore if any mistakes are made. Duplicates were removed from layoffs_2. 

### Standardizing the Data 
Starting with company column, removed any white space from the front and back of each value. Then checked for any industry names that should be combined or edited in someway. Found issue with Crypto, there were 3 different ways:

<img width="135" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/b2510b24-2231-4078-876a-0a90a6537a4a">

These were all updated to show Cypto as the industry name. Found a second issue in the contry column. Some of the values for United States had a period at the end: 

<img width="108" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/e3c455fb-41fb-4d36-88bf-4579396646f7">

Values were updated to show United States without the period. Moving on to the date column, the data type shows as text and the formatting needs to be changed: 

<img width="147" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/625f8457-5a1d-4747-9acc-1754ef4774a9">

Format and data type updated: 

<img width="172" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/b43117c1-432f-49a1-b092-5296126d3365">

### Handling NULL values 

Filtered through to find any NULL or blank industry values

<img width="507" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/c17196b5-29af-4c7f-ac26-3a07a2aab714">

All values had other row with the same company, and the industy was updated using those values. Expcept Bally's Interactive, this one was the only value and was left NULL

<img width="511" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/f5fe97dc-a56c-4700-b690-0311c6b5d734">

Since comptations can not be done, rows with NULL or blank values for both total laid off and percentage laid off were removed. Column row_num was also removed.


## Exploratory Analysis
Ran into issues with running sum and count functions, noticed values were equal to NULL versus is null in the total_laid_off, percentage_laid_off columns, and funds_raised_millions. These colums also had the data type of text. The NULL values were then changed to 0, and the data type changed to integar for total_laid off and float for percentage_laid_off and funds_raised_millions since they contained decimals. 

<img width="606" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/426d55d7-1f91-4c07-9b0b-a3baaa070bcb">


Ranking largest lay offs by company and year top 5 each year:

2020

<img width="275" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/40b1e3c4-3fa7-401f-bfa9-2e8a09d8218c">

2021

<img width="269" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/5b87d1b9-f898-454f-8836-ef83347f738d">

2022

<img width="271" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/a483a325-5966-4227-8fa2-9bd227c30ee0">


-- Ranking layoffs per industry per year top 5

2020

<img width="280" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/3d4a8281-0305-4452-b1bb-119a4cb89956">

2021

<img width="281" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/f1add84e-2ae5-4a27-8572-41c913516069">

2022

<img width="284" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/6dcf66da-b8d5-4aa2-b40e-b254f73ad1ae">


--Rank layoffs by country per year top 5

2020

<img width="279" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/8aa3c278-5b48-498b-8050-4ad18c6db504">

2021

<img width="278" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/3acb8f9e-c0fa-46a5-9d96-8cfd83d2c440">

2022

<img width="279" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/7a536b8b-94af-405c-b672-ed1e70d6701e">

### Visuals 
#### Total Laid Off by Country

2020

<img width="313" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/70738a74-6d07-45d7-b63f-02542bf3028b">

2021

<img width="319" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/23166edd-8ba2-4951-9d30-7973a517c3fe">

2022

<img width="953" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/22cd8342-7b95-471b-9956-1d6b936d05e1">

#### Total Laid off in Each Industry for top 3 countries 

2020

<img width="318" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/a26a5058-4e70-415a-b865-ca3cfae18ada">

2021

<img width="326" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/f5e7d58b-de16-43a2-bdb7-ecbcc02e66f1">

2022

<img width="319" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/4611c019-264d-4b8e-899a-da0dd7a62bd0">

#### Map View 
<img width="293" alt="image" src="https://github.com/snkty8/World_Layoffs/assets/78936833/25d0906b-e798-4ecc-95ae-71d99e996c5c">
