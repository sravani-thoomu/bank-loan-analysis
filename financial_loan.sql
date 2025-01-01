CREATE TABLE financial_loan (
    id BIGINT PRIMARY KEY,
    address_state VARCHAR(2),
    application_type VARCHAR(50),
    emp_length VARCHAR(20),
    emp_title VARCHAR(255),
    grade CHAR(1),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id BIGINT,
    purpose VARCHAR(255),
    sub_grade VARCHAR(5),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income NUMERIC(15, 2),
    dti NUMERIC(10, 4),
    installment NUMERIC(10, 2),
    int_rate NUMERIC(10, 4),
    loan_amount BIGINT,
    total_acc INT,
    total_payment BIGINT
);
SELECT * FROM financial_loan

SELECT COUNT(id) AS "Total_Loan_Applications" FROM financial_loan

--(MTD)MONTH TO DATE 

SELECT COUNT(id) AS "MTD_Total_Loan_Applications" FROM financial_loan
WHERE DATE_PART('month', issue_date) = 12
  AND DATE_PART('year', issue_date) = 2021;
  
--(PMTD) PREVIOUS MONTH TO DATE
SELECT COUNT(id) AS "MTD_Total_Loan_Applications" FROM financial_loan
WHERE DATE_PART('month', issue_date) = 11
  AND DATE_PART('year', issue_date) = 2021;
  
--(MTD-PMTD)/PMTD
  
SELECT SUM(Loan_Amount) AS "MTD_Total_Funded_Amount" FROM financial_loan
WHERE DATE_PART('month', issue_date) = 12
  AND DATE_PART('year', issue_date) = 2021;

SELECT SUM(Loan_Amount) AS "PMTD_Total_Funded_Amount" FROM financial_loan
WHERE DATE_PART('month', issue_date) = 11
  AND DATE_PART('year', issue_date) = 2021;


select sum(Total_Payment) AS "MTD_Total_Amount_Received" FROM financial_loan
WHERE DATE_PART('MONTH', issue_date)=12 AND 
DATE_PART ('YEAR',issue_date)= 2021;

select sum(Total_Payment) AS "PMTD_Total_Amount_Received" FROM financial_loan
WHERE DATE_PART('MONTH', issue_date)=11 AND 
DATE_PART ('YEAR',issue_date)= 2021;

SELECT ROUND(avg (int_rate),4) * 100 As " PMTD_Avg_Interest_Rate" FROM financial_loan
WHERE DATE_PART('MONTH',issue_date) = 11 AND 
DATE_PART ('YEAR',issue_date)=2021

SELECT * FROM financial_loan

SELECT ROUND(AVG(DTI),4)*100 AS "MTD_Avg_DTI" FROM financial_loan
WHERE DATE_PART('MONTH',issue_date)=12
And DATE_PART('YEAR',issue_date)=2021

SELECT ROUND(AVG(DTI),4)*100 AS "PMTD_Avg_DTI" FROM financial_loan
WHERE DATE_PART('MONTH',issue_date)=11
And DATE_PART('YEAR',issue_date)=2021
--
SELECT 
    (COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) * 100) 
    / 
    COUNT(id) AS good_loan_percentage FROM financial_loan;
---
SELECT COUNT(id) AS Good_Loan_Applications FROM Financial_Loan
WHERE loan_status = 'Fully Paid' OR Loan_Status = 'Current';
----
SELECT sum(loan_amount) AS Good_Loan_Funded_Amount FROM Financial_Loan
WHERE loan_status = 'Fully Paid' OR Loan_Status = 'Current';
-----
SELECT sum(Total_Payment) AS Good_Loan_Recieved_Amount FROM Financial_Loan
WHERE loan_status = 'Fully Paid' OR Loan_Status = 'Current';
-------
SELECT 
    (COUNT(CASE WHEN loan_status ILIKE 'Charged off' THEN id END) * 100.0) 
    / COUNT(id) AS Bad_loan_percentage
FROM Financial_Loan;
--------
SELECT COUNT(ID) AS Bad_Loan_Applications 
FROM Financial_Loan
WHERE TRIM(loan_status) ILIKE 'Charged off';
----------
SELECT sum(loan_amount) AS "Bad_Loan_Funded_Amount" 
FROM Financial_Loan
WHERE TRIM(loan_status) ILIKE 'Charged off';
--------------
SELECT SUM(Total_Payment) AS "Bad_Loan_Amount_Recieved" 
FROM Financial_Loan
WHERE TRIM(loan_status) ILIKE 'Charged off';
-------------------
SELECT
        loan_status,
        COUNT(id) AS "Total_Loan_Applications",
        SUM(total_payment) AS "Total_Amount_Received",
        SUM(loan_amount) AS "Total_Funded_Amount",
        AVG(int_rate * 100) AS "Interest_Rate",
        AVG(dti * 100) AS DTI
    FROM
     Financial_Loan   
    GROUP BY
        loan_status
		ORDER BY
    loan_status DESC;
----------------------
SELECT 
    loan_status, 
    SUM(total_payment) AS "MTD_Total_Amount_Received", 
    SUM(loan_amount) AS "MTD_Total_Funded_Amount"
FROM Financial_Loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
GROUP BY loan_status
order by "MTD_Total_Amount_Received" DESC;
-----------------------------
SELECT 
    EXTRACT(MONTH FROM issue_date) AS "Month_Number", 
    TO_CHAR(issue_date, 'Month') AS "Month_Name", 
    COUNT(id) AS "Total_Loan_Applications",
    SUM(loan_amount) AS "Total_Funded_Amount",
    SUM(total_payment) AS "Total_Amount_Received"
FROM Financial_Loan
GROUP BY EXTRACT(MONTH FROM issue_date), TO_CHAR(issue_date, 'Month')
ORDER BY EXTRACT(MONTH FROM issue_date);
--------------------------------------------------
SELECT 
	address_state AS State, 
	COUNT(id) AS "Total_Loan_Applications",
	SUM(loan_amount) AS "Total_Funded_Amount",
	SUM(total_payment) AS "Total_Amount_Received"
FROM Financial_Loan
GROUP BY address_state
ORDER BY address_state;
----------------------------------------------------
SELECT 
	term AS Term, 
	COUNT(id) AS "Total_Loan_Applications",
	SUM(loan_amount) AS "Total_Funded_Amount",
	SUM(total_payment) AS "Total_Amount_Received"
FROM Financial_Loan
GROUP BY term
ORDER BY term
-------------------------------------------------------
SELECT 
	emp_length AS "Employee_Length", 
	COUNT(id) AS "Total_Loan_Applications",
	SUM(loan_amount) AS "Total_Funded_Amount",
	SUM(total_payment) AS "Total_Amount_Received"
FROM Financial_Loan
GROUP BY emp_length
ORDER BY COUNT(ID)DESC;
--------------------------------------------------------------

SELECT 
	purpose AS "Purpose", 
	COUNT(id) AS "Total_Loan_Applications",
	SUM(loan_amount) AS "Total_Funded_Amount",
	SUM(total_payment) AS "Total_Amount_Received"
FROM Financial_Loan
GROUP BY purpose
ORDER BY COUNT(ID)DESC
----------------------------------------------------------
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY home_ownership
ORDER BY COUNT(ID)DESC
------------------------------------------------------------
SELECT 
	purpose AS "Purpose", 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan 
WHERE grade = 'A'
GROUP BY purpose
ORDER BY COUNT(ID)DESC;

----END-----



























