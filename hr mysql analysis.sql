# Created a database for my hr ptoject
create database HR_PROJECT;
select * from hr_dataset;
# i discovered the id name needs to be changed
alter table hr_dataset
change column ï»¿id emp_id varchar(15) null;
# lets check the datatyypes of our dataset and also clean data for dates
describe hr_dataset;
set sql_safe_updates = 1;
select birthdate from hr_dataset;
 update hr_dataset
 set birthdate = case 
 when birthdate like "%/%" then date_format(str_to_date(birthdate,"%m/%d/%Y"),"%y-%m-%d")
 when birthdate like "%-%" then date_format(str_to_date(birthdate,"%m-%d-%Y"),"%y-%m-%d")
 else null
 end;
 
 alter table hr_dataset
 modify column birthdate date;
 # thesame is done for the hire date
 update hr_dataset
 set hire_date = case 
 when hire_date like "%/%" then date_format(str_to_date(hire_date,"%m/%d/%Y"),"%y-%m-%d")
 when hire_date like "%-%" then date_format(str_to_date(hire_date,"%m-%d-%Y"),"%y-%m-%d")
 else null
 end;
 
 alter table hr_dataset
 modify column hire_date date;
 
 select hire_date from hr_dataset;
 
 UPDATE hr_dataset
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '' AND termdate != '0';

UPDATE hr_dataset
SET termdate = NULL
WHERE termdate = '0';


ALTER TABLE hr_dataset MODIFY COLUMN termdate date;

# lets check the termdate 
select termdate from hr_dataset;
# i creatde a procedure to 
create procedure hr()
select * from hr_dataset;
call hr;
alter table hr_dataset
add column  age int;
alter table hr_dataset
drop column Employee_age;
ALTER TABLE hr_dataset
ADD COLUMN Employee_age INT;

-- Update the values in the new column
UPDATE hr_dataset
SET Employee_age = TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE);
#
select Employee_age from hr_dataset;
# checking to see the wrong values
select
min(Employee_age) as youngest,
max(Employee_age) as Oldest
from hr_dataset;
# so then lets exclude those less than 18 from our analysis
select count(*) from hr_dataset
where Employee_age < 18; 
--- QUESTIONS
call hr();

--- 1. WHHAT IS THE GENDER BREAKDOWN OF EMPLOYEE IN THE COMPANY
select gender,count(*) AS COUNT from hr_dataset
where 
Employee_age > 18 and termdate is null
group by gender;
--- Race/Ethnicity Breakdown:
select race,count(*) AS COUNT from hr_dataset
where 
Employee_age > 18 and termdate is null
group by RACE
order by count(*) desc;

---- Age Distribution
select
case
when Employee_age >= 18 and Employee_age<=24 THEN "18-24"
when Employee_age >= 25 and Employee_age<=34 THEN "25-34"
when Employee_age >= 35 and Employee_age<=44 THEN "35-44"
when Employee_age >= 45 and Employee_age<=54 THEN "45-54"
when Employee_age >= 55 and Employee_age<=64 THEN "55-64"
ELSE "65+"
END AS Age_Bracket,
count(*) as count
from hr_dataset
where Employee_age > 18 and termdate is null
group by Age_Bracket;

-- employee at the headquater vs those working remotely
call hr();
select location , count(*) as count
from hr_dataset
where Employee_age > 18 and termdate is null
group by location;

--- average length of employment terminated

select
round(avg(datediff(termdate,hire_date))/365,0) as AVG_LENGTH_EMPLOYMENT
from hr_dataset
where termdate <=  CURRENT_DATE and  termdate is not null  and Employee_age >= 18;

---------- distribution of jobs across company

select
jobtitle , count(*) as count
from hr_dataset
where Employee_age > 18 and termdate is null
group by jobtitle
order by count;

------ gender and department distribution

select
department , gender, count(*) as count
from hr_dataset
where Employee_age > 18 and termdate is null
group by department,gender
order by department;

------- Depatmnet turnover rate
select
employee_count,
Terminated_emp_count,
Terminated_emp_count/employee_count as termination_rate
from
( select
department, count(*) as employee_count,
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS Terminated_emp_count
from hr_dataset
where Employee_age >= 18
group by department
order by Terminated_emp_count
) subquery_emp;

-------- location of employees
select location_state,
count(*) as total_number_emplo
from hr_dataset
 where Employee_age >= 18 and termdate is null
 group by location_state;
 ----------- how has the company employee number change over time over the years
 select 
 Year ,
 hires,
 termination,
-( termination - hires) as net_change,
  (-(termination-hires)/hires) * 100 as percent_change
  from
  ( select
  Year(hire_date) AS Year,
  count(*) as hires,
  SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS termination
from hr_dataset
where Employee_age >= 18
group by year ) as subquery
order by Year;
  
  
 
 



























