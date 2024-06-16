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

