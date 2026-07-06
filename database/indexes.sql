USE finance_reporting_system;

-- Employee Search
CREATE INDEX idx_employee_department
ON employees(department_id);

-- Customers
CREATE INDEX idx_customer_city
ON customers(city);

CREATE INDEX idx_customer_segment
ON customers(customer_segment);

-- Products
CREATE INDEX idx_product_category
ON products(category_id);

CREATE INDEX idx_product_brand
ON products(brand_id);

CREATE INDEX idx_product_supplier
ON products(supplier_id);

-- Inventory
CREATE INDEX idx_inventory_product
ON inventory(product_id);

CREATE INDEX idx_inventory_warehouse
ON inventory(warehouse_id);

-- Expenses
CREATE INDEX idx_expense_date
ON expenses(expense_date);

CREATE INDEX idx_expense_department
ON expenses(department_id);

-- Sales Target
CREATE INDEX idx_target_employee
ON sales_targets(employee_id);

-- Sales Transactions
CREATE INDEX idx_transaction_date
ON sales_transactions(transaction_date);

CREATE INDEX idx_transaction_customer
ON sales_transactions(customer_id);

CREATE INDEX idx_transaction_product
ON sales_transactions(product_id);

CREATE INDEX idx_transaction_employee
ON sales_transactions(employee_id);

CREATE INDEX idx_transaction_region
ON sales_transactions(region_id);

CREATE INDEX idx_transaction_payment
ON sales_transactions(payment_method_id);

-- Returns
CREATE INDEX idx_return_transaction
ON returns(transaction_id);

SHOW INDEX FROM sales_transactions;