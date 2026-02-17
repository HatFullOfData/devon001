-- Create Products Table for Catering Supplies Company
-- This table stores information about catering equipment, supplies, and consumables

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100),
    description TEXT,
    unit_price DECIMAL(10, 2) NOT NULL,
    unit_of_measure VARCHAR(50) NOT NULL,
    stock_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 0,
    supplier_name VARCHAR(255),
    supplier_sku VARCHAR(100),
    weight_kg DECIMAL(8, 3),
    dimensions_cm VARCHAR(50),
    material VARCHAR(100),
    color VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_product_code (product_code),
    INDEX idx_supplier (supplier_name)
);

-- Add comment to table
ALTER TABLE products COMMENT = 'Product catalog for catering supplies including equipment, consumables, and accessories';
