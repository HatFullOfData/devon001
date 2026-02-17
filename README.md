# ETL Practice Data Repository

This repository contains SQL scripts and data files for practicing ETL (Extract, Transform, Load) skills with realistic "dirty" data that requires cleansing. Includes catering supplies products, UK customer data, and UK toy shop supplier information.

## Files Included

### 1. `create_products_table.sql`
SQL script to create the products table with the following schema:
- **product_id**: Auto-incrementing primary key
- **product_code**: Unique product identifier (e.g., CS-PLATE-001)
- **product_name**: Name of the product
- **category**: Main category (e.g., Dinnerware, Cutlery, Cookware)
- **subcategory**: Sub-category for better organization
- **description**: Detailed product description
- **unit_price**: Price in decimal format
- **unit_of_measure**: Unit (each, pack, set, etc.)
- **stock_quantity**: Current stock level
- **reorder_level**: Minimum stock before reorder
- **supplier_name**: Supplier company name
- **supplier_sku**: Supplier's product code
- **weight_kg**: Product weight in kilograms
- **dimensions_cm**: Dimensions in centimeters
- **material**: Primary material composition
- **color**: Product color
- **is_active**: Boolean flag for active products
- **date_added**: Timestamp of record creation
- **last_updated**: Timestamp of last update

### 2. `insert_products.sql`
SQL script containing INSERT statements for 30 clean product records ready for direct import. These products include:
- Dinnerware (plates, bowls, cups)
- Cutlery (forks, knives, spoons)
- Glassware (wine glasses, water goblets, beer mugs)
- Table linens (napkins, tablecloths, table runners)
- Chef apparel (coats, hats, pants, aprons)
- Cookware (pans, pots)
- Kitchen tools (knives, cutting boards, utensils)
- Kitchen safety equipment
- Food storage containers
- Kitchen measuring tools and timers

### 3. `products_raw.csv`
A CSV file containing 41 product records with intentionally "dirty" data that requires cleansing before import.

## Data Cleansing Requirements for `products_raw.csv`

The raw CSV file contains various data quality issues that must be addressed before importing into the database:

### 1. **Whitespace Issues**
- **Leading/Trailing Spaces**: Several fields have extra spaces (e.g., " Pasta Bowl 16oz ", "  Wide pasta bowl for generous servings  ")
- **Action**: Trim all whitespace from the beginning and end of each field

### 2. **Case Inconsistencies**
- **Product Codes**: Some codes are lowercase (e.g., "cs-fork-001", "cs-toast-001")
- **Unit of Measure**: Mixed case (e.g., "EACH", "each", "Each", "ea")
- **Supplier Names**: Inconsistent capitalization (e.g., "silverline catering")
- **Materials**: Mixed case (e.g., "porcelain", "stainless steel", "glass")
- **Colors**: Mixed case (e.g., "white", "White", "silver", "Silver", "clear")
- **Action**: Standardize to proper case conventions:
  - Product codes: UPPERCASE with hyphens
  - Unit of measure: lowercase "each", "pack", "set"
  - Supplier names: Title Case
  - Materials: Title Case
  - Colors: Title Case

### 3. **Price Format Issues**
- **Currency Symbols**: Some prices have dollar signs (e.g., "$4.99")
- **Text Values**: Non-numeric values (e.g., "price pending")
- **Null Values**: Some prices are "null" (string)
- **Action**: Remove currency symbols, handle null/invalid values appropriately

### 4. **Missing Values**
- **Empty Fields**: Missing reorder_level (CS-CUP-002), weight_kg (CS-SPOON-002), supplier_sku (CS-PEELER-001)
- **Action**: Determine appropriate default values or leave as NULL if allowed

### 5. **Boolean Value Inconsistencies**
- **is_active Field**: Multiple representations:
  - "1" (numeric)
  - "TRUE" (string)
  - "yes" (string)
- **Action**: Convert all to proper boolean value (TRUE/FALSE or 1/0)

### 6. **Negative Values**
- **stock_quantity**: Invalid negative value (-15 for CS-SAUCE-001)
- **Action**: Investigate and correct (likely data entry error, should be positive or zero)

### 7. **Inconsistent Delimiters in Dimensions**
- Some entries use quotes around dimensions: `"6.5 x 8.5 x 5.5"`
- Inconsistent spacing: "19 x 19 x 6" vs "6.5 x 8.5 x 5.5"
- Text in dimensions: "Top: 9 Bottom: 6.5 Height: 15"
- **Action**: Standardize format and remove unnecessary quotes

### 8. **Unit Abbreviations**
- **ea** should be standardized to **each**
- **Action**: Expand all abbreviations to full unit names

### 9. **Duplicate Records**
- **CS-PEELER-001** appears twice (rows with different supplier_sku values)
- **Action**: Identify and remove/merge duplicate entries

### 10. **Inconsistent Quoting**
- Some fields are unnecessarily quoted: `"Crystal Clear Co"`
- **Action**: Remove quotes where not needed (only use quotes for fields containing delimiters)

### 11. **Special Characters**
- Check for any special characters that might cause import issues
- **Action**: Validate and escape special characters as needed

### 12. **Numeric Precision**
- Ensure decimal values match database schema precision (e.g., DECIMAL(10,2) for prices)
- **Action**: Round or format to appropriate decimal places

## Usage Instructions

### Step 1: Create the Database Table
```sql
mysql -u username -p database_name < create_products_table.sql
```

### Step 2: Insert Clean Sample Data
```sql
mysql -u username -p database_name < insert_products.sql
```

### Step 3: Cleanse the Raw CSV Data
Before importing `products_raw.csv`, apply the data cleansing steps outlined above. You can use:
- ETL tools (e.g., Talend, Apache NiFi)
- Scripting languages (Python with pandas, R)
- SQL preprocessing
- Excel/Google Sheets with formulas and cleanup functions

### Example Python Cleansing Script Structure
```python
import pandas as pd
import re

# Load the raw data
df = pd.read_csv('products_raw.csv')

# 1. Trim whitespace
df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)

# 2. Standardize product codes to uppercase
df['product_code'] = df['product_code'].str.upper()

# 3. Standardize unit_of_measure
df['unit_of_measure'] = df['unit_of_measure'].str.lower()
df['unit_of_measure'] = df['unit_of_measure'].replace('ea', 'each')

# 4. Clean price field
df['unit_price'] = df['unit_price'].str.replace('$', '')
df['unit_price'] = pd.to_numeric(df['unit_price'], errors='coerce')

# 5. Standardize boolean values
df['is_active'] = df['is_active'].map({'1': True, 'TRUE': True, 'true': True, 
                                        'yes': True, 'Yes': True, 'YES': True,
                                        '0': False, 'FALSE': False, 'false': False,
                                        'no': False, 'No': False, 'NO': False})

# 6. Handle negative stock quantities
df.loc[df['stock_quantity'] < 0, 'stock_quantity'] = 0

# 7. Remove duplicates
df = df.drop_duplicates(subset=['product_code'], keep='first')

# 8. Standardize case for text fields
df['category'] = df['category'].str.title()
df['material'] = df['material'].str.title()
df['color'] = df['color'].str.title()

# Save cleaned data
df.to_csv('products_clean.csv', index=False)
```

### Step 4: Import Cleaned CSV Data
After cleansing, import using:
```sql
LOAD DATA INFILE 'products_clean.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_code, product_name, category, subcategory, description, 
 unit_price, unit_of_measure, stock_quantity, reorder_level, 
 supplier_name, supplier_sku, weight_kg, dimensions_cm, 
 material, color, is_active);
```

## Database Schema Diagram

```
┌─────────────────────────────────────────────────┐
│                   PRODUCTS                       │
├─────────────────────────────────────────────────┤
│ PK │ product_id          INT AUTO_INCREMENT    │
│ UK │ product_code        VARCHAR(50)           │
│    │ product_name        VARCHAR(255)          │
│    │ category            VARCHAR(100)          │
│    │ subcategory         VARCHAR(100)          │
│    │ description         TEXT                  │
│    │ unit_price          DECIMAL(10,2)         │
│    │ unit_of_measure     VARCHAR(50)           │
│    │ stock_quantity      INT                   │
│    │ reorder_level       INT                   │
│    │ supplier_name       VARCHAR(255)          │
│    │ supplier_sku        VARCHAR(100)          │
│    │ weight_kg           DECIMAL(8,3)          │
│    │ dimensions_cm       VARCHAR(50)           │
│    │ material            VARCHAR(100)          │
│    │ color               VARCHAR(50)           │
│    │ is_active           BOOLEAN               │
│    │ date_added          TIMESTAMP             │
│    │ last_updated        TIMESTAMP             │
└─────────────────────────────────────────────────┘

Indexes:
- PRIMARY KEY: product_id
- UNIQUE: product_code
- INDEX: category
- INDEX: supplier_name
```

## Product Categories Included

1. **Dinnerware**: Plates, bowls, cups, saucers, serving pieces
2. **Cutlery**: Forks, knives, spoons
3. **Glassware**: Wine glasses, water glasses, beer mugs, champagne flutes
4. **Table Linens**: Napkins, tablecloths, table runners
5. **Chef Apparel**: Coats, hats, pants, aprons
6. **Cookware**: Pots, pans, Dutch ovens
7. **Kitchen Tools**: Knives, cutting boards, utensils, measuring tools
8. **Kitchen Textiles**: Towels, oven mitts
9. **Food Storage**: Containers, dispensers
10. **Disposables**: Paper products, plastic cutlery
11. **Small Appliances**: Mixers, blenders, toasters, coffee makers
12. **Large Appliances**: Microwaves, food warmers, slicers
13. **Baking**: Pans, racks, muffin tins

## Additional Datasets

### UK Toy Shop Suppliers Data
See `SUPPLIERS_DATA_README.md` for details on the UK toy shop suppliers dataset.

**File**: `suppliers_raw.csv`
- **Records**: 25 supplier records (24 unique after removing duplicates)
- **Purpose**: Practice ETL and data cleansing with UK-based toy suppliers
- **Data Issues**: 15 different types of data quality problems including:
  - Leading/trailing whitespace
  - Case inconsistencies (UPPERCASE, lowercase, Mixed)
  - Currency symbol inconsistencies (£ vs $)
  - Boolean value variations (TRUE/yes/1)
  - Duplicate records
  - Missing values and "null" as text
  - Negative values in numeric fields
  - Country name variations (UK vs United Kingdom)
  - And more...

**Product Categories Covered**: Plush toys, action figures, puzzles, board games, educational toys, electronic toys, outdoor play equipment, arts & crafts, baby toys, dolls, RC toys, musical instruments, and more.

### UK Customer Data
See `CUSTOMER_DATA_README.md` for details on the UK customer dataset.

**File**: `customers_raw.csv`
- **Records**: 15 UK-based customer records
- **Data Issues**: Credit limit field contains UK pound symbol (£) that needs cleansing
- **Coverage**: Diverse locations across England, Scotland, and Wales

## License

This is sample data for educational and demonstration purposes.