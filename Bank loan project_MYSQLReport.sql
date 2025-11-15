Create database Bankloan;

Use Bankloan;

select * from bankloan;

create table bankloan
(
	id int,
    member_id int,
    loan_amnt char(255),
    funded_amnt char(255),
    funded_amnt_inv char(255),
    term char(255),
    int_rate decimal (10,2),
    installment char(255),
    Grade char(255),
    sub_grade char(255),
    emp_length char(255),
    home_onwership char(255),
    annual_income char(255),
    verification_status char(255),
    issue_d date,
    loan_status char(255),
	purpose char(255),
    zip_code char(255),
    addr_state varchar(255),
    dti char(255));
    
select * from finance_1;

Load data infile "C:/Bank_1.csv" into table bankloan
Fields terminated by ","
ignore 1 lines;

Select @@secure_file_priv;


rename table bankloan to Finance_1;

Create table Finance_2
( id int,
delinq_2yrs char(255),
earliest_cr_line date,
inq_last_6mths char(255),
mths_since_last_delinq char(255),
open_acc char(255),
pub_rec char(255),
revol_bal char(255),
revol_util char(255),
total_acc char(255),
total_pymnt char(255),
total_pymnt_inv char(255),
total_rec_prncp char(255),
total_rec_int char(255),
total_rec_late_fee char(255),
recoveries char(255),
collection_recovery_fee char(255),
last_pymnt_d date,
last_pymnt_d2 date,
Last_pymnt_amnt char(255),
next_payment_d date,
last_credit_pull_d DATE);

Select * from Finance_1;

Select * from Finance_2;

SET GLOBAL local_infile = 1;


Load data infile "C:/Users/Lenovo/Desktop/Finance_2.csv" into TABLE Finance_2
Fields terminated by ","
ignore 1 lines;
    
LOAD DATA INFILE 'C:/Users/Lenovo/Desktop/Finance_2.csv'
INTO TABLE Finance_2
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(last_pymnt_d)
SET last_pymnt_d = NULLIF(last_pymnt_d, '0');

truncate table finance_2;
select * from finance_2;

Select count(*) as "Total Rows" from finance_1;

Select count(*) as "Total Rows" from finance_2;


-- KPI 1

Select year(issue_d) as "Year_of_issue_d", sum(loan_amnt) as "Loan_Amount"
from finance_1
group by Year_of_issue_d
Order by Year_of_issue_d;  


-- KPI 2

Select grade, sub_grade, sum(revol_bal) as "Total_revol_bal"
From Finance_1 
Inner Join
finance_2
ON finance_1.id=finance_2.id
group by grade , sub_grade
Order by grade, sub_grade;   

-- KPI 3

select verification_status,
concat("$ ",format(round(sum(total_pymnt)/1000000,2),2),"M") as "Total_Payment"
from finance_1 inner join finance_2
ON finance_1.id=finance_2.id
Group by verification_status
order by verification_status; 		

-- KPI 4

Select addr_state, last_credit_pull_d, Loan_status
from finance_1 inner join finance_2
ON finance_1.id=finance_2.id
Group by addr_state, last_credit_pull_d, Loan_status
order by Loan_status; 		

-- KPI 5

Select home_ownership, last_pymnt_d,
concat("$ ",format(round(sum(last_pymnt_amnt)/10000,2),2)," K") as "last_payment_amount"
from finance_1 Inner join finance_2
ON finance_1.id=finance_2.id
Group by home_ownership, last_pymnt_d
order by last_pymnt_d desc, home_ownership desc;	














Select year(issue_d) as "Year_of_issue_d", 
concat("$ ", format(sum(loan_amnt)/100000,0)," K") as "Loan amount"
from finance_1
group by Year_of_issue_d
Order by Year_of_issue_d; 							# 1 might be wrong with the values "K"
