-- Finance Reporting System Database
-- Author : Antra Verma

CREATE DATABASE finance_reporting_system;
USE finance_reporting_system;

-- Creating Department table
Create Table department(
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    manager_name VARCHAR(100) NOT NULL
);
select * from department;
-- Creating Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);

-- Creating Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(100),
    state VARCHAR(100),
    join_date DATE,
    segment VARCHAR(50)
);

-- Create Product Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    cost_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL
);

-- Create Transaction Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,

    transaction_date DATE NOT NULL,

    customer_id INT NOT NULL,

    product_id INT NOT NULL,

    employee_id INT NOT NULL,

    quantity INT NOT NULL,

    discount DECIMAL(5,2),

    sales DECIMAL(12,2),

    cost DECIMAL(12,2),

    profit DECIMAL(12,2),

    region VARCHAR(50),

    payment_method VARCHAR(50),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

Show tables;
DESCRIBE customers;
DESCRIBE employees;
DESCRIBE products;
DESCRIBE department;
DESCRIBE transactions;