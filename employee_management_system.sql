-- ============================================================
-- EMPLOYEE MANAGEMENT SYSTEM
-- MySQL SQL Project
-- ============================================================


-- ============================================================
-- 1. DATABASE CREATION
-- ============================================================

CREATE DATABASE employee_management;

USE employee_management;


-- ============================================================
-- 2. TABLE CREATION
-- NOTE: The original document contains (...) placeholders
-- ============================================================

CREATE TABLE departments (...);

CREATE TABLE employees (...);

CREATE TABLE projects (...);


-- Display all tables
SHOW TABLES;


-- ============================================================
-- 3. DQL BASICS
-- ============================================================

-- Count total employees
SELECT COUNT(*) AS total_employees
FROM employees;


-- Calculate total salary
SELECT SUM(salary) AS total_salary
FROM employees;


-- Calculate average salary
SELECT ROUND(AVG(salary),2) AS average_salary
FROM employees;


-- Find highest salary
SELECT MAX(salary) AS highest_salary
FROM employees;


-- Find lowest salary
SELECT MIN(salary) AS lowest_salary
FROM employees;


-- ============================================================
-- 4. GROUP BY AND HAVING
-- ============================================================

SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary),2) AS average_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;


-- ============================================================
-- 5. INNER JOIN
-- ============================================================

SELECT
    e.first_name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;


-- ============================================================
-- 6. SELF JOIN / EMPLOYEE-MANAGER
-- ============================================================

SELECT
    e.first_name AS employee,
    COALESCE(m.first_name,'No Manager') AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;


-- ============================================================
-- 7. SUBQUERY
-- Employees earning more than average salary
-- ============================================================

SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


-- ============================================================
-- 8. CORRELATED SUBQUERY
-- Employees earning more than their department average
-- ============================================================

SELECT e.*
FROM employees e
WHERE e.salary >
(
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);


-- ============================================================
-- 9. EXISTS
-- ============================================================

SELECT *
FROM departments d
WHERE EXISTS
(
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);


-- ============================================================
-- 10. UNION
-- ============================================================

SELECT first_name,salary
FROM employees
WHERE salary > 100000

UNION

SELECT first_name,salary
FROM employees
WHERE experience > 8;


-- ============================================================
-- 11. CASE AND COALESCE
-- ============================================================

SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'HIGH'
        WHEN salary >= 60000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS salary_category
FROM employees;


-- ============================================================
-- 12. CTE
-- Common Table Expression
-- ============================================================

WITH department_stats AS
(
    SELECT
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department_id
)
SELECT
    d.department_name,
    ds.employee_count,
    ROUND(ds.average_salary,2) AS average_salary
FROM department_stats ds
JOIN departments d
ON ds.department_id = d.department_id;


-- ============================================================
-- 13. WINDOW FUNCTION - RANK
-- Overall salary ranking
-- ============================================================

SELECT
    first_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;


-- ============================================================
-- 14. WINDOW FUNCTION - DEPARTMENT RANKING
-- ============================================================

SELECT
    e.first_name,
    d.department_name,
    e.salary,
    RANK() OVER
    (
        PARTITION BY e.department_id
        ORDER BY e.salary DESC
    ) AS department_rank
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- ============================================================
-- 15. VIEW
-- ============================================================

CREATE OR REPLACE VIEW employee_department_view AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email,
    e.salary,
    e.job_role,
    e.experience,
    d.department_name,
    d.location
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- Retrieve employees with salary greater than 70000
SELECT *
FROM employee_department_view
WHERE salary > 70000;


-- ============================================================
-- 16. STORED PROCEDURE
-- ============================================================

DELIMITER //

CREATE PROCEDURE get_employee(IN emp_id INT)
BEGIN
    SELECT *
    FROM employees
    WHERE employee_id = emp_id;
END //

DELIMITER ;


-- Execute stored procedure
CALL get_employee(5);


-- ============================================================
-- 17. STORED PROCEDURE CALL
-- ============================================================

CALL get_department_employees(1);


-- NOTE:
-- The original document calls get_department_employees(1),
-- but its CREATE PROCEDURE definition is not included
-- in the document.


-- ============================================================
-- 18. STORED FUNCTION
-- ============================================================

CREATE FUNCTION annual_salary(monthly_salary DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN monthly_salary * 12;
END;


-- Use stored function
SELECT
    first_name,
    salary,
    annual_salary(salary) AS yearly_salary
FROM employees
LIMIT 5;


-- ============================================================
-- 19. TCL - COMMIT, ROLLBACK AND SAVEPOINT
-- ============================================================

START TRANSACTION;

UPDATE employees
SET salary = salary + 5000
WHERE employee_id = 3;

COMMIT;


START TRANSACTION;

UPDATE employees
SET salary = salary + 10000
WHERE employee_id = 3;

ROLLBACK;


START TRANSACTION;

UPDATE employees
SET salary = salary + 5000
WHERE employee_id = 3;

SAVEPOINT salary_update;

UPDATE employees
SET salary = salary + 10000
WHERE employee_id = 4;

ROLLBACK TO salary_update;

COMMIT;


-- ============================================================
-- 20. DCL - CREATE USER
-- ============================================================

CREATE USER 'hr_user'@'localhost'
IDENTIFIED BY 'hr123';


-- ============================================================
-- 21. DCL - GRANT
-- ============================================================

GRANT SELECT, INSERT, UPDATE
ON employee_management.*
TO 'hr_user'@'localhost';


-- ============================================================
-- 22. SHOW GRANTS
-- ============================================================

SHOW GRANTS FOR 'hr_user'@'localhost';


-- ============================================================
-- 23. DCL - REVOKE
-- ============================================================

REVOKE UPDATE
ON employee_management.*
FROM 'hr_user'@'localhost';


-- ============================================================
-- 24. REAL-WORLD REPORT
-- Department-wise employee salary statistics
-- ============================================================

SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id,d.department_name;


-- ============================================================
-- 25. REAL-WORLD REPORT
-- Department-wise project budget
-- ============================================================

SELECT
    d.department_name,
    SUM(p.budget) AS total_project_budget
FROM departments d
LEFT JOIN projects p
ON d.department_id = p.department_id
GROUP BY d.department_id,d.department_name;

-- ============================================================
