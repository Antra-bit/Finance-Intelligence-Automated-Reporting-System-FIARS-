-- Departments Table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    manager_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Regions Table
CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL DEFAULT 'India',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment Methods
CREATE TABLE payment_methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_method_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Brands Table
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE,
    country_of_origin VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Warehouse Table
CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100),
    state VARCHAR(100),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

show tables;
describe departments;
describe brands;
describe suppliers;

-- 8. EMPLOYEES TABLE
-- Purpose: Stores employee information
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    designation VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    status ENUM('Active','Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- 9. CUSTOMERS TABLE
-- Purpose: Stores customer information
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_code VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    gender ENUM('Male','Female','Other'),
    age INT,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    customer_segment ENUM('Retail','Corporate','Wholesale')
        DEFAULT 'Retail',
    join_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. PRODUCTS TABLE
-- Purpose: Stores product information
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_code VARCHAR(30) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    supplier_id INT NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    reorder_level INT DEFAULT 20,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),
    CONSTRAINT fk_product_brand
        FOREIGN KEY (brand_id)
        REFERENCES brands(brand_id),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

-- 11. INVENTORY TABLE
-- Purpose: Tracks product stock across warehouses

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    last_restock_date DATE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),
    CONSTRAINT chk_inventory_quantity
        CHECK (quantity_in_stock >= 0)
);

-- 12. BUDGETS TABLE
-- Purpose: Stores departmental monthly budgets
CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    region_id INT NOT NULL,
    budget_year YEAR NOT NULL,
    budget_month TINYINT NOT NULL,
    allocated_budget DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_budget_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT fk_budget_region
        FOREIGN KEY (region_id)
        REFERENCES regions(region_id),
    CONSTRAINT chk_budget_month
        CHECK (budget_month BETWEEN 1 AND 12),
    CONSTRAINT chk_budget_amount
        CHECK (allocated_budget >= 0),
    CONSTRAINT uk_budget
        UNIQUE (department_id, region_id, budget_year, budget_month)
);

-- 13. EXPENSES TABLE

CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    region_id INT NOT NULL,
    expense_date DATE NOT NULL,
    expense_category ENUM(
        'Salary',
        'Rent',
        'Utilities',
        'Marketing',
        'Travel',
        'Maintenance',
        'Office Supplies',
        'Other'
    ) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_expense_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT fk_expense_region
        FOREIGN KEY (region_id)
        REFERENCES regions(region_id),
    CONSTRAINT chk_expense_amount
        CHECK(amount >= 0)
);


-- 14. SALES TARGETS TABLE

CREATE TABLE sales_targets (
    target_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    target_year YEAR NOT NULL,
    target_month TINYINT NOT NULL,
    target_amount DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_target_employee
        FOREIGN KEY(employee_id)
        REFERENCES employees(employee_id),
    CONSTRAINT chk_target_month
        CHECK(target_month BETWEEN 1 AND 12),
    CONSTRAINT chk_target_amount
        CHECK(target_amount >= 0),
    CONSTRAINT uk_employee_target
        UNIQUE(employee_id,target_year,target_month)
);

-- 15. SALES TRANSACTIONS TABLE
CREATE TABLE sales_transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(30) NOT NULL UNIQUE,
    transaction_date DATE NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    employee_id INT NOT NULL,
    region_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    tax DECIMAL(5,2) DEFAULT 18.00,
    total_sales DECIMAL(15,2) NOT NULL,
    total_cost DECIMAL(15,2) NOT NULL,
    profit DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id),
    CONSTRAINT fk_transaction_product
        FOREIGN KEY(product_id)
        REFERENCES products(product_id),
    CONSTRAINT fk_transaction_employee
        FOREIGN KEY(employee_id)
        REFERENCES employees(employee_id),
    CONSTRAINT fk_transaction_region
        FOREIGN KEY(region_id)
        REFERENCES regions(region_id),
    CONSTRAINT fk_transaction_payment
        FOREIGN KEY(payment_method_id)
        REFERENCES payment_methods(payment_method_id),
    CONSTRAINT chk_quantity
        CHECK(quantity > 0),
    CONSTRAINT chk_discount
        CHECK(discount BETWEEN 0 AND 100),
    CONSTRAINT chk_tax
        CHECK(tax >= 0)
);


-- 15. SALES TRANSACTIONS TABLE
CREATE TABLE sales_transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(30) NOT NULL UNIQUE,
    transaction_date DATE NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    employee_id INT NOT NULL,
    region_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    tax DECIMAL(5,2) DEFAULT 18.00,
    total_sales DECIMAL(15,2) NOT NULL,
    total_cost DECIMAL(15,2) NOT NULL,
    profit DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id),
    CONSTRAINT fk_transaction_product
        FOREIGN KEY(product_id)
        REFERENCES products(product_id),
    CONSTRAINT fk_transaction_employee
        FOREIGN KEY(employee_id)
        REFERENCES employees(employee_id),
    CONSTRAINT fk_transaction_region
        FOREIGN KEY(region_id)
        REFERENCES regions(region_id),
    CONSTRAINT fk_transaction_payment
        FOREIGN KEY(payment_method_id)
        REFERENCES payment_methods(payment_method_id),
    CONSTRAINT chk_quantity
        CHECK(quantity > 0),
    CONSTRAINT chk_discount
        CHECK(discount BETWEEN 0 AND 100),
    CONSTRAINT chk_tax
        CHECK(tax >= 0)
);

-- 16. RETURNS TABLE

CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id BIGINT NOT NULL,
    return_date DATE NOT NULL,
    quantity_returned INT NOT NULL,
    return_reason ENUM(
        'Damaged',
        'Wrong Item',
        'Customer Dissatisfaction',
        'Defective',
        'Other'
    ) NOT NULL,
    refund_amount DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_return_transaction
        FOREIGN KEY(transaction_id)
        REFERENCES sales_transactions(transaction_id),
    CONSTRAINT chk_return_quantity
        CHECK(quantity_returned > 0),
    CONSTRAINT chk_refund
        CHECK(refund_amount >= 0)
);

show tables;