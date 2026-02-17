# Motorbike Parts and Equipment Dataset

This dataset contains intentionally "dirty" data for teaching ETL (Extract, Transform, Load) skills and data cleansing techniques in Power BI's Power Query Editor. The dataset includes 42 motorbike parts and equipment records featuring well-known brands in the motorcycle industry.

## Well-Known Brands Included

- **Tires**: Michelin, Dunlop
- **Helmets & Safety**: Shoei, HJC
- **Riding Gear**: Dainese, Alpinestars, Rev'it!, Sidi
- **Fluids & Oils**: Motul, Castrol, Engine Ice
- **Filters**: K&N, Hiflofiltro
- **Drive Train**: DID, RK, JT Sprockets
- **Brakes**: Brembo
- **Lights**: Philips, Rizoma
- **Batteries**: Yuasa, Shorai
- **Controls**: Motion Pro, Pro Grip, Pazzos, Oxford
- **Security**: Xena
- **Electronics**: Sena
- **Accessories**: CRG, TechSpec, Dowco
- **Tools**: Snap-On, Pitbull
- **Engine Parts**: NGK, Cometic
- **Exhaust**: Akrapovic
- **Foot Pegs**: Vortex

## File Structure

**File**: `motorbike_parts_raw.csv`

### Columns:
1. **part_code** - Unique identifier for each part
2. **part_name** - Name/description of the part
3. **category** - Main product category
4. **brand** - Manufacturer brand name
5. **description** - Detailed product description
6. **unit_price** - Price per unit
7. **unit_of_measure** - Unit type (each, pair, set)
8. **stock_quantity** - Current inventory level
9. **reorder_level** - Minimum stock before reordering
10. **supplier_name** - Supplier company name
11. **supplier_sku** - Supplier's product code
12. **weight_kg** - Weight in kilograms
13. **dimensions_cm** - Product dimensions
14. **material** - Primary material composition
15. **color** - Product color
16. **warranty_months** - Warranty period in months
17. **is_active** - Whether product is active
18. **date_added** - Date product was added to system

## Data Cleansing Challenges for Power Query

This dataset contains various data quality issues that students should identify and fix using Power Query in Power BI:

### 1. **Whitespace Issues**
   - **Leading/Trailing Spaces**: Multiple fields have extra spaces
     - Examples: " Sport Tire 120/70-17 ", " Modular Helmet L ", " Racing Gloves L "
     - Fields affected: part_name, description, part_name, brand
   - **Solution in Power Query**: Use Transform > Trim to remove leading/trailing spaces
   - **Columns to clean**: part_name, description, category, brand

### 2. **Case Inconsistencies**
   - **Product Codes**: Mixed case usage
     - Uppercase: MB-TIRE-001, MB-HELMET-002
     - Lowercase: mb-helmet-001, mb-oil-001, mb-brake-002, mb-cable-002
   - **Brand Names**: Inconsistent capitalization
     - "dunlop" should be "Dunlop"
     - "castrol" should be "Castrol"
     - "motion pro" should be "Motion Pro"
     - "shoei" should be "Shoei"
     - "pazzos" should be "Pazzos"
     - "akrapovic" should be "Akrapovic"
   - **Materials**: Mixed case
     - "rubber", "polycarbonate", "steel", "stainless steel", "aluminum" need Title Case
   - **Colors**: Inconsistent
     - "black", "Matte Black", "Glossy Black", "Blue", "blue"
   - **Solution**: Use Transform > Format > Uppercase/Title Case/Lowercase appropriately

### 3. **Price Format Issues**
   - **Currency Symbols**: Some prices have dollar signs ($), some don't
     - Examples: "$189.99", "229.50", "$699.00", "149.99"
   - **Text Values**: Invalid price data
     - "price pending" (MB-HELMET-002, MB-BATTERY-002)
   - **Null Values**: String "null" instead of proper null (MB-OIL-001)
   - **Solution**: 
     - Remove currency symbols with Replace Values
     - Convert "price pending" and "null" to actual null
     - Change data type to Decimal Number

### 4. **Missing Values (null)**
   - **Empty Fields**: Several records have "null" as text or missing data
     - MB-JACKET-001: dimensions_cm = "null"
     - MB-CHAIN-001: dimensions_cm = "null"
     - MB-OIL-001: unit_price = "null", warranty_months = "null"
     - MB-LIGHT-001: dimensions_cm = "null"
     - MB-BATTERY-002: dimensions_cm = "null"
     - MB-STAND-001: dimensions_cm = "null"
     - MB-GASKET-001: dimensions_cm = "null"
   - **Missing supplier_sku**: MB-JACKET-002 has blank supplier_sku
   - **Solution**: Replace "null" text with proper null values, decide on handling strategy

### 5. **Boolean Value Inconsistencies**
   - **is_active Field**: Multiple representations
     - Numeric: "1"
     - Text uppercase: "TRUE", "YES", "Y"
     - Text lowercase: "true", "yes"
   - **Solution**: Use Replace Values or Custom Column to standardize to TRUE/FALSE

### 6. **Negative/Invalid Values**
   - **stock_quantity**: MB-GLOVE-001 has -5 (impossible negative inventory)
   - **Solution**: Identify and correct negative values (set to 0 or investigate)

### 7. **Date Format Inconsistencies**
   - **date_added**: Multiple date formats
     - ISO format: "2024-01-15", "2024-02-10"
     - UK format: "01/20/2024", "15/02/2024", "20/03/2024"
     - Short format: "05/04/2024", "01/05/2024"
   - **Solution**: Parse dates using appropriate locale settings, standardize to single format

### 8. **Unit of Measure Abbreviations**
   - **Inconsistent units**:
     - "each", "EACH", "Each"
     - "ea" (abbreviation that should be expanded)
     - "pair", "set"
   - **Solution**: Replace "ea" with "each", standardize case to lowercase

### 9. **Duplicate Records**
   - **MB-LEVER-001** appears twice (Brake Lever and Clutch Lever - likely a data entry error where the code should be different)
   - **Solution**: Identify duplicates, investigate which should have different code (MB-LEVER-002)

### 10. **Inconsistent Dimension Formats**
   - Various formats for dimensions:
     - Standard: "120 x 70 x 43"
     - Quoted: "8 x 8 x 22"
     - Coiled format: "Coiled 30cm diameter"
     - Descriptive: "Top: 9 Bottom: 6.5 Height: 15"
     - Text descriptions: "Cable 120cm", "Mirror 9cm diameter", "Fits bikes up to 250cm"
     - Specific measurements: "Chest: 56 Waist: 52 Length: 68"
     - Size references: "Size 43 EUR", "Waist 34\" Length 32\""
   - **Solution**: Decide on standardization approach, possibly create separate columns

### 11. **Warranty Data Issues**
   - **Mixed formats**:
     - Numeric values: "24", "36", "12"
     - Text: "N/A", "null", "lifetime"
     - Blank/missing values in some records
   - **Solution**: Standardize null representation, handle special cases like "lifetime"

### 12. **Material Format Inconsistencies**
   - **Compound materials** with different delimiters:
     - Hyphen: "Leather-Carbon", "Paper-Steel", "LED-Aluminum"
     - Space: "AGM Lead-Acid", "Multi-layer Steel"
   - **Case issues**: "rubber" vs "Rubber", "steel" vs "Steel"
   - **Solution**: Standardize case and delimiter format

### 13. **Special Characters in Data**
   - **Quotation marks**: Some fields unnecessarily quoted
   - **Apostrophes**: Rev'it! brand name contains apostrophe
   - **Measurement symbols**: Inch symbol (") in dimension fields
   - **Solution**: Handle appropriately - some are valid (brand names), others need cleaning

### 14. **Inconsistent Supplier Names**
   - Some supplier names are consistent, others may have spacing or case issues
   - **Solution**: Group and standardize supplier names

## Power Query Transformation Workflow

### Recommended Step-by-Step Approach:

1. **Initial Load**
   - Load CSV into Power Query Editor
   - Promote first row to headers
   - Check column data types

2. **Whitespace Cleanup**
   - Select all text columns
   - Transform > Format > Trim (removes leading/trailing spaces)

3. **Standardize Case**
   - part_code: Transform > Format > UPPERCASE
   - brand: Transform > Format > Capitalize Each Word
   - category: Transform > Format > Capitalize Each Word
   - material: Transform > Format > Capitalize Each Word
   - unit_of_measure: Transform > Format > lowercase

4. **Fix Price Column**
   - Replace "$" with ""
   - Replace "price pending" with null
   - Replace "null" with null
   - Change data type to Decimal Number

5. **Fix Boolean Column (is_active)**
   - Replace Values: "1" = "TRUE"
   - Replace Values: "yes" = "TRUE", "Y" = "TRUE", "YES" = "TRUE"
   - Replace Values: "true" = "TRUE"
   - Change data type to TRUE/FALSE

6. **Fix Unit of Measure**
   - Replace "ea" with "each"
   - Replace "EACH" with "each"
   - Replace "Each" with "each"

7. **Fix Date Column**
   - Parse with appropriate locale
   - Standardize to single date format

8. **Handle Negative Values**
   - Filter or replace negative stock_quantity values
   - Use conditional column if needed

9. **Handle Null Values**
   - Replace text "null" with actual null
   - Replace "N/A" in warranty_months with null

10. **Fix Duplicates**
    - Identify duplicate part_codes
    - Manually edit or remove duplicates

11. **Validate Data Types**
    - Ensure numeric columns are decimal/integer
    - Ensure dates are date type
    - Ensure boolean columns are TRUE/FALSE

## Categories of Parts Included

1. **Tires** - Sport and cruiser tires
2. **Safety Equipment** - Helmets (full face, modular)
3. **Riding Gear** - Jackets, gloves, pants, boots
4. **Fluids & Lubes** - Engine oil, coolant
5. **Filters** - Oil filters, air filters
6. **Drive Train** - Chains, sprockets
7. **Brakes** - Brake pads, brake fluid
8. **Lights & Electrical** - LED bulbs, turn signals
9. **Electrical** - Batteries
10. **Controls** - Cables, grips, levers, foot pegs
11. **Accessories** - Mirrors, tank pads, covers
12. **Maintenance Tools** - Paddock stands
13. **Tools** - Socket sets
14. **Security** - Alarms, locks
15. **Electronics** - Bluetooth intercoms
16. **Engine Parts** - Spark plugs, gaskets
17. **Exhaust Systems** - Slip-on exhausts
18. **Footwear** - Touring boots

## Learning Objectives

By cleansing this dataset, students will learn to:

1. Identify common data quality issues
2. Use Power Query transformations effectively
3. Handle missing and null values
4. Standardize text formatting and case
5. Parse and clean currency values
6. Standardize date formats
7. Work with boolean data
8. Identify and resolve duplicates
9. Handle inconsistent categorical data
10. Prepare data for analysis and reporting

## Expected Output

After cleansing, the data should:
- Have consistent formatting across all text fields
- Use proper data types for each column
- Have no leading/trailing whitespace
- Use standardized formats for dates, prices, and units
- Have resolved or documented null values
- Have no duplicate part codes
- Be ready for analysis in Power BI

## Usage in Power BI Course

This dataset is ideal for teaching:
- Power Query Editor basics
- Data transformation techniques
- Data type conversions
- Text manipulation functions
- Date handling
- Dealing with real-world messy data
- ETL best practices
- Data quality assessment

## License

This is sample data created for educational purposes.
