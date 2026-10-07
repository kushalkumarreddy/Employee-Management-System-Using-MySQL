# Employee Management System

A MySQL-based Employee Management System designed to demonstrate database design and a wide range of SQL concepts using departments, employees, and projects.

## 📌 Project Overview

This project implements an Employee Management System using MySQL with three core tables:

- Departments
- Employees
- Projects

It demonstrates basic as well as advanced SQL concepts including DDL, DML, DQL, joins, subqueries, CTEs, window functions, views, stored procedures, stored functions, transactions, and DCL.

## 🛠️ Technologies Used

- MySQL 8.x
- MySQL Workbench
- SQL

## 🗄️ Database Structure

The database contains three main tables:

- `departments`
- `employees`
- `projects`

### Relationships

- One department → Many employees
- One department → Many projects
- One employee → Many employees through the manager relationship

## 📚 SQL Concepts Covered

- DDL: CREATE, ALTER, DROP, TRUNCATE
- DML: INSERT, UPDATE, DELETE
- DQL: SELECT, WHERE, DISTINCT, LIKE, BETWEEN, IN, IS NULL, ORDER BY, LIMIT
- Primary Key and Foreign Key
- UNIQUE, NOT NULL, DEFAULT, CHECK constraints
- Aggregate Functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY and HAVING
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- CROSS JOIN
- SELF JOIN
- Subqueries
- Correlated Subqueries
- EXISTS and NOT EXISTS
- ANY and ALL
- UNION and UNION ALL
- CASE and COALESCE
- Common Table Expressions (CTEs)
- Window Functions
- Views
- Stored Procedures
- Stored Functions
- Transactions
- COMMIT, ROLLBACK and SAVEPOINT
- DCL: CREATE USER, GRANT and REVOKE

## ▶️ How to Run

1. Install MySQL 8.x and MySQL Workbench.
2. Clone this repository.

```bash
git clone https://github.com/yourusername/employee-management-system-sql.git
