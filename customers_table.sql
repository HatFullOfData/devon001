-- Customer Table Definition for UK-based customers
-- This table stores customer information including contact details and credit limit

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    county VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL DEFAULT 'United Kingdom',
    credit_limit DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_date DATE NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    INDEX idx_postcode (postcode),
    INDEX idx_last_name (last_name)
);
