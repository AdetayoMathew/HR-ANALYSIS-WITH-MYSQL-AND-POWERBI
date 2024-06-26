# PROJECT NAME: HR-ANALYSIS-WITH-MYSQL-AND-POWERBI

![HR-Analytics-768x512](https://github.com/Mathex7/HR-ANALYSIS-WITH-MYSQL-AND-POWERBI/assets/106633060/f809ae8b-efbc-46dc-9687-13ed5ef368b7)

# PROJECT BACKGROUND:
InnovateTech Solutions, a leading technology firm in the software industry, recognizes the crucial role of human resources (HR) in maintaining a skilled and diverse workforce. With over 1,000 employees spread across multiple locations, HR plays a pivotal role in attracting top talent, fostering employee development, and ensuring a positive work environment.

In line with InnovateTech Solutions' commitment to data-driven decision-making, this project aims to analyze various HR metrics to gain insights into employee demographics, distribution, tenure, and turnover. By delving into the available HR data, we can identify patterns and trends that will help inform HR policies, improve employee engagement, and foster an inclusive workplace culture.

The project will utilize data from InnovateTech Solutions' HR database, encompassing information such as gender, race/ethnicity, age, job titles, locations, tenure, and termination records. Ensuring the confidentiality and privacy of the data will be a top priority throughout the analysis.

The key stakeholders for this project include the HR management team, department heads, and senior executives at InnovateTech Solutions, who are responsible for shaping HR strategies and initiatives. The findings of this analysis will provide valuable insights to support evidence-based decision-making in areas such as diversity and inclusion, talent management, and employee retention.

By conducting this comprehensive analysis, we aim to contribute to InnovateTech Solutions' ongoing efforts to optimize its HR practices, foster a diverse and inclusive workforce, and create a thriving work environment where employees can reach their full potential.

# PROJECT OBJECTIVE
The objective of this project is to analyze various aspects of the organization's human resources (HR) data to gain insights into employee demographics, distribution, tenure, and turnover. The specific areas of focus include:

Employee Demographics:
* a. Gender Breakdown: Determine the proportion of male and female employees in the company.
* b. Race/Ethnicity Breakdown: Analyze the diversity of employees by examining their race/ethnicity distribution.
* c. Age Distribution: Explore the age distribution of employees across different age groups.

Employee Distribution:
a. Headquarters vs. Remote Locations: Identify the number of employees working at the headquarters compared to remote locations.

Employee Tenure and Termination:
a. Average Length of Employment for Terminated Employees: Calculate the average length of employment for employees who have been terminated.

Gender Distribution Across Departments and Job Titles:
a. Analyze how the gender distribution varies across different departments and job titles.

Job Title Distribution:
a. Determine the distribution of job titles across the company.

Turnover Rate:
a. Identify the department with the highest turnover rate by analyzing the rate of employee attrition.

Employee Distribution Across Locations:
a. Explore the distribution of employees across different locations by state.

Employee Count Changes Over Time:
a. Analyze changes in the company's employee count over time based on hire and termination dates.

Tenure Distribution by Department:
a. Determine the distribution of employee tenure within each department.

By conducting this analysis, we aim to gain insights into various HR metrics that can inform decision-making, identify areas of improvement, and promote a more inclusive and productive work environment.

# Data sourcing : Kaggle

# Tools : 
Data Cleaning & Analysis - MySQL Workbench

Data Visualization - PowerBI

# SQL Transformation Script

## Database Creation and Data Cleaning

```sql
# Created a database for my HR project
CREATE DATABASE HR_PROJECT;

# Check the data in hr_dataset
SELECT * FROM hr_dataset;

# Change the column name from ï»¿id to emp_id
ALTER TABLE hr_dataset
CHANGE COLUMN ï»¿id emp_id VARCHAR(15) NULL;

# Check the data types and clean data for dates
DESCRIBE hr_dataset;

SET sql_safe_updates = 1;

# Clean the birthdate column
UPDATE hr_dataset
SET birthdate = CASE 
    WHEN birthdate LIKE "%/%" THEN DATE_FORMAT(STR_TO_DATE(birthdate,"%m/%d/%Y"),"%y-%m-%d")
    WHEN birthdate LIKE "%-%" THEN DATE_FORMAT(STR_TO_DATE(birthdate,"%m-%d-%Y"),"%y-%m-%d")
    ELSE NULL
END;

ALTER TABLE hr_dataset
MODIFY COLUMN birthdate DATE;

# Clean the hire date column
UPDATE hr_dataset
SET hire_date = CASE 
    WHEN hire_date LIKE "%/%" THEN DATE_FORMAT(STR_TO_DATE(hire_date,"%m/%d/%Y"),"%y-%m-%d")
    WHEN hire_date LIKE "%-%" THEN DATE_FORMAT(STR_TO_DATE(hire_date,"%m-%d-%Y"),"%y-%m-%d")
    ELSE NULL
END;

ALTER TABLE hr_dataset
MODIFY COLUMN hire_date DATE;

# Clean the term date column
UPDATE hr_dataset
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '' AND termdate != '0';

UPDATE hr_dataset
SET termdate = NULL
WHERE termdate = '0';

ALTER TABLE hr_dataset MODIFY COLUMN termdate DATE;
# Create a stored procedure to view the dataset
CREATE PROCEDURE hr()
SELECT * FROM hr_dataset;

CALL hr;

# Add an age column
ALTER TABLE hr_dataset
ADD COLUMN age INT;

ALTER TABLE hr_dataset
DROP COLUMN Employee_age;

ALTER TABLE hr_dataset
ADD COLUMN Employee_age INT;

-- Update the values in the new column
UPDATE hr_dataset
SET Employee_age = TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE);

# Check the age column
SELECT Employee_age FROM hr_dataset;

# Check for incorrect values in age column
SELECT
MIN(Employee_age) AS youngest,
MAX(Employee_age) AS Oldest
FROM hr_dataset;

# Exclude employees younger than 18 from analysis
SELECT COUNT(*) FROM hr_dataset
WHERE Employee_age < 18; 

```




# Summary of Findings
* There are more male employees
* White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
* The youngest employee is 20 years old and the oldest is 57 years old
* 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
* A large number of employees work at the headquarters versus remotely.
* The average length of employment for terminated employees is around 8 years.
* The gender distribution across departments is fairly balanced but there are generally more male than female employees.
* The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
* A large number of employees come from the state of Ohio.
* The net change in employees has increased over the years.
* The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.

# Limitations
* Some records had negative ages and these were excluded during querying (967 records). Ages used were 18 years and above.
* Some term dates were far into the future and were not included in the analysis (1599 records). The only term dates used were those less than or equal to the current date.

# DASHBOARD

![Screenshot (631)](https://github.com/Mathex7/HR-ANALYSIS-WITH-MYSQL-AND-POWERBI/assets/106633060/02ab7f0f-65e7-4bea-af0f-a0f86fed5c79)
