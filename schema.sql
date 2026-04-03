-- ==========================================
-- TASK 1: ADVANCED SCHEMA DESIGN (3NF)
-- ==========================================

-- 1. Cities (For Distributed Design - Task 5)
CREATE TABLE Cities (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

-[span_0](start_span)- 3. Customers (With Security - Task 4)[span_0](end_span)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    [span_1](start_span)password_hash VARCHAR(255) NOT NULL, -- Hashing for Security[span_1](end_span)
    [span_2](start_span)phone_encrypted VARBINARY(255),      -- Data Protection[span_2](end_span)
    city_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);

-[span_3](start_span)- 4. Products (With Inventory Management)[span_3](end_span)
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    category_id INT,
    [span_4](start_span)price DECIMAL(10, 2) NOT NULL, -- ETB[span_4](end_span)
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-[span_5](start_span)[span_6](start_span)- 5. Orders (Lifecycle Management)[span_5](end_span)[span_6](end_span)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    [span_7](start_span)status ENUM('placed', 'paid', 'shipped', 'delivered') DEFAULT 'placed', -- Task 2 Requirement[span_7](end_span)
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-[span_8](start_span)- 6. Order_Items (Prevent Overselling Strategy)[span_8](end_span)
CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-[span_9](start_span)[span_10](start_span)- 7. Payments (Telebirr, Bank, Cash)[span_9](end_span)[span_10](end_span)
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method ENUM('Telebirr', 'Bank Transfer', 'Cash on Delivery') NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- ==========================================
-[span_11](start_span)- TASK 2: OPTIMIZATION & INDEXING[span_11](end_span)
-- ==========================================

-- Index for fast product searching by name and price
CREATE INDEX idx_product_search ON Products(name, price);

-- Index for customer order history lookup
CREATE INDEX idx_customer_orders ON Orders(customer_id);

-- ==========================================
-- TASK 3: CONCURRENCY CONTROL (Example)
-- ==========================================

-[span_12](start_span)- Handling simultaneous purchases (Preventing Overselling)[span_12](end_span)
/* START TRANSACTION;
SELECT stock_quantity FROM Products WHERE product_id = 1 FOR UPDATE;
-- Logic: If stock > quantity, then update
UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1;
INSERT INTO Orders ...;
COMMIT; 
*/

-- ==========================================
-[span_13](start_span)- TASK 4: AUDIT LOGGING[span_13](end_span)
-- ==========================================
CREATE TABLE Audit_Logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(255),
    table_name VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
