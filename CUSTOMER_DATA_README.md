# Customer Data Files

This repository contains UK customer data in multiple formats for testing and development purposes.

## Files Overview

### 1. customers_table.sql
SQL CREATE TABLE statement that defines the customer database schema.

**Table Structure:**
- `customer_id` - Primary key (auto-increment)
- `first_name` - Customer's first name
- `last_name` - Customer's last name
- `email` - Unique email address
- `phone` - UK phone number
- `address_line1` - Primary address line
- `address_line2` - Secondary address line (optional)
- `city` - City name
- `county` - County name
- `postcode` - UK postcode
- `country` - Country (defaults to "United Kingdom")
- `credit_limit` - Customer's credit limit in decimal format
- `created_date` - Date when customer was created
- `active` - Boolean flag indicating if customer is active

### 2. customers_insert.sql
SQL INSERT statements containing clean, ready-to-use customer data for 15 UK-based customers.

**Usage:**
```sql
-- First create the table
SOURCE customers_table.sql;

-- Then insert the data
SOURCE customers_insert.sql;
```

### 3. customers_raw.csv
CSV file containing "dirty" customer data that requires cleansing before use.

**Data Quality Issues:**
- **Credit Limit Field**: Values contain UK pound symbol (£) before the number (e.g., `£5000.00`)
  - This needs to be removed before loading into a database
  - Example: `£5000.00` should be cleaned to `5000.00`

**Cleansing Requirements:**
1. Remove the £ symbol from the credit_limit column
2. Ensure numeric values are properly formatted as decimals
3. Handle empty address_line2 fields appropriately

**Python Cleansing Example:**
```python
import pandas as pd

# Read the raw CSV
df = pd.read_csv('customers_raw.csv')

# Remove £ symbol from credit_limit
df['credit_limit'] = df['credit_limit'].str.replace('£', '').astype(float)

# Save cleaned data
df.to_csv('customers_cleaned.csv', index=False)
```

**SQL Cleansing Example (MySQL):**
```sql
LOAD DATA INFILE 'customers_raw.csv'
INTO TABLE customers_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Clean and insert into main table
INSERT INTO customers 
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    address_line1,
    address_line2,
    city,
    county,
    postcode,
    country,
    CAST(REPLACE(credit_limit, '£', '') AS DECIMAL(10,2)) as credit_limit,
    created_date,
    active
FROM customers_staging;
```

## Customer Data Details

All 15 customers are UK-based and include:
- Diverse locations across England, Scotland, and Wales
- Major cities: London, Manchester, Edinburgh, Cardiff, Birmingham, Leeds, Glasgow, Bristol, Newcastle, Liverpool, Norwich, Oxford, Cambridge, Brighton, Southampton
- Valid UK postcodes and phone numbers
- Credit limits ranging from £3,000 to £10,000
- Created dates spanning from January to September 2024

## Use Cases

1. **Testing Database Import/Export**: Use the SQL files to test database creation and data insertion
2. **Data Cleansing Practice**: Use the CSV file to practice data cleaning techniques
3. **ETL Pipeline Testing**: Test Extract, Transform, Load processes with the raw CSV
4. **Query Development**: Practice writing SQL queries against realistic UK customer data
