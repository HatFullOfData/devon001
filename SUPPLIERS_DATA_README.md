# UK Toy Shop Suppliers Data - ETL Practice Dataset

This dataset contains supplier information for UK toy shops with intentionally introduced data quality issues to practice ETL (Extract, Transform, Load) and data cleansing skills in Power Query and other data processing tools.

## File Overview

### suppliers_raw.csv
A CSV file containing 25 supplier records with various data quality issues that require cleansing before use. This dataset is specifically designed for practicing data cleansing techniques in Power Query, Python, SQL, or other ETL tools.

## Dataset Schema

| Column Name | Description | Data Type |
|-------------|-------------|-----------|
| supplier_id | Unique identifier for supplier | Integer |
| supplier_name | Company name of the supplier | Text |
| contact_person | Primary contact person's name | Text |
| email | Contact email address | Text |
| phone | UK phone number | Text |
| address_line1 | Primary address line | Text |
| address_line2 | Secondary address line (optional) | Text |
| city | City name | Text |
| county | County name | Text |
| postcode | UK postcode | Text |
| country | Country name | Text |
| product_category | Main product category supplied | Text |
| minimum_order | Minimum order value | Decimal |
| credit_terms | Payment terms | Text |
| delivery_days | Expected delivery time range | Text |
| rating | Supplier rating (1-5) | Decimal |
| active | Whether supplier is currently active | Boolean |
| last_order_date | Date of last order placed | Date |

## Data Quality Issues to Cleanse

This dataset contains **15 different types** of data quality issues commonly found in real-world data. Practice identifying and resolving each of these issues:

### 1. Leading and Trailing Whitespace
**Description**: Extra spaces before and/or after values  
**Affected Fields**: supplier_name, contact_person, phone, address_line1, credit_terms  
**Examples**:
- ` Toys R Fun Ltd ` (Row 1 - supplier_name)
- `  John Smith  ` (Row 2 - contact_person)
- ` 0161 234 5678 ` (Row 3 - phone)
- `  56 Trade Center  ` (Row 5 - address_line1)
- `  45 days  ` (Row 3 - credit_terms)

**Action Required**: Trim all leading and trailing whitespace from text fields

### 2. Inconsistent Case - UPPERCASE
**Description**: Some company names and contact names are fully capitalized  
**Affected Fields**: supplier_name, contact_person  
**Examples**:
- `brighton BEARS` (Row 2)
- `LISA DAVIES` (Row 5)
- `AMANDA ROBERTS` (Row 9)
- `DOLL HOUSE SUPPLIES` (Row 18)
- `STEAM Learning Toys` (Row 22)

**Action Required**: Standardize to Title Case or proper business name format

### 3. Inconsistent Case - lowercase
**Description**: Some names use improper lowercase formatting  
**Affected Fields**: supplier_name, county  
**Examples**:
- `puzzles & games direct` (Row 4)
- `kidz electronic toys` (Row 7)
- `board game emporium` (Row 11)
- `vintage toy COLLECTORS` (Row 21)
- `magic & tricks wholesale` (Row 25)
- `greater manchester` (Row 3 - county)
- `south glamorgan` (Row 6 - county)

**Action Required**: Standardize to Title Case

### 4. Mixed Case in Contact Names
**Description**: Contact names with inconsistent capitalization  
**Affected Fields**: contact_person  
**Examples**:
- `emma JONES` (Row 3)

**Action Required**: Standardize to proper name format (Title Case)

### 5. Currency Symbol Inconsistencies
**Description**: Mixture of £ (British Pound) and $ (Dollar) symbols in minimum_order field  
**Affected Fields**: minimum_order  
**Examples**:
- `£250.00` (Row 1 - correct for UK)
- `$150.00` (Row 2 - incorrect, should be £)
- `$225.00` (Row 11 - incorrect)
- `$325.00` (Row 18 - incorrect)
- `$125.00` (Row 23 - incorrect)

**Action Required**: 
- Remove all currency symbols and store as numeric value
- OR standardize all to £ for UK suppliers

### 6. Missing Currency Symbols
**Description**: Some minimum_order values lack currency symbols  
**Affected Fields**: minimum_order  
**Examples**:
- `200` (Row 4)
- `350.00` (Row 7)
- `150.00` (Row 14)
- `200.00` (Row 20)
- `150` (Row 25)

**Action Required**: Add appropriate currency symbol or remove all symbols and treat as numeric

### 7. Text in Numeric Fields
**Description**: Non-numeric text values in numeric columns  
**Affected Fields**: minimum_order  
**Examples**:
- `price pending` (Row 9)

**Action Required**: 
- Replace with NULL or default value
- Mark for follow-up to obtain actual value

### 8. Country Name Variations
**Description**: Multiple variations of the same country name  
**Affected Fields**: country  
**Examples**:
- `United Kingdom` (Rows 1, 3, 4, 5, 7, 8, 9, 13, 15, etc.)
- `UK` (Rows 2, 12)
- `united kingdom` (Row 6 - lowercase)

**Action Required**: Standardize to single format (e.g., "United Kingdom")

### 9. Boolean Value Inconsistencies
**Description**: Multiple representations of TRUE/FALSE values  
**Affected Fields**: active  
**Examples**:
- `TRUE` (Rows 1, 4, 5, 8, 9, 11, 13, 15, 17, 20, 21, 24, 25)
- `yes` (Rows 3, 6, 10, 14, 19, 22)
- `1` (Rows 2, 7, 12, 18, 23)

**Action Required**: Convert all to consistent boolean format (TRUE/FALSE or 1/0)

### 10. Missing Values (Empty Fields)
**Description**: Required fields left blank  
**Affected Fields**: rating, last_order_date  
**Examples**:
- Missing rating (Row 4 - shows "null" as text)
- Missing rating (Row 17 - blank)
- Missing last_order_date (Row 8 - blank)
- Missing last_order_date (Row 24 - blank)

**Action Required**: 
- Determine if NULL is acceptable or if default values are needed
- Mark records with missing required data for review

### 11. "null" as Text String
**Description**: The word "null" stored as text instead of actual NULL value  
**Affected Fields**: rating  
**Examples**:
- `null` (Row 4)

**Action Required**: Convert text "null" to actual NULL value

### 12. Duplicate Records
**Description**: Completely duplicate supplier entries  
**Affected Records**: Rows 1 and 16  
**Details**: 
- Row 1 has supplier_id 1 and Row 16 has supplier_id 16, but both represent the same supplier
- Identical supplier_name: "Toys R Fun Ltd" (with different spacing/whitespace)
- Same contact person, email, phone, and address
- Same product category and terms

**Action Required**: 
- Identify and remove duplicate entries
- Keep only one record (typically the first or most recent)
- Verify if genuinely duplicate or if there's a reason for both records

### 13. Inconsistent Credit Terms Format
**Description**: Multiple ways of expressing the same payment terms  
**Affected Fields**: credit_terms  
**Examples**:
- `30 days` (Rows 1, 4, 7, 11, 14, 19, 23)
- `net 30` (Rows 2, 10, 18)
- `  45 days  ` (Row 3 - with extra spaces)
- `45 days` (Rows 9, 12, 15, 20, 22, 25)
- `net 45` (Row 6)
- `  net 45  ` (Row 13, 24 - with extra spaces)
- `60 days` (Row 5)
- `  60 days  ` (Row 17 - with extra spaces)
- `  net 60  ` (Row 21 - with extra spaces)

**Action Required**: Standardize format (e.g., all to "net XX" or all to "XX days")

### 14. Negative Values in Numeric Fields
**Description**: Invalid negative numbers in fields that should only be positive  
**Affected Fields**: delivery_days  
**Examples**:
- `-5` (Row 22 - impossible negative delivery time)

**Action Required**: 
- Investigate and correct (likely data entry error)
- Should be positive value, possibly meant to be "5"

### 15. Inconsistent Phone Number Spacing
**Description**: Inconsistent formatting of UK phone numbers  
**Affected Fields**: phone  
**Examples**:
- ` 0161 234 5678 ` (Row 3 - extra spaces)
- ` 0191 432 1098 ` (Row 10 - extra spaces)
- ` 01752 543 2109 ` (Row 19 - extra spaces)
- ` 01223 098 654` (Row 24 - extra space before number)

**Action Required**: 
- Trim whitespace
- Optionally standardize phone number format (e.g., remove spaces or standardize spacing)

## Power Query Cleansing Guide

Here's a step-by-step approach to cleanse this data in Power Query (Microsoft Excel/Power BI):

### Step 1: Load the Data
1. Open Power Query Editor
2. Get Data > From File > From Text/CSV
3. Select `suppliers_raw.csv`

### Step 2: Trim Whitespace
```powerquery
// Apply to all text columns
= Table.TransformColumns(
    Source,
    {{"supplier_name", Text.Trim},
     {"contact_person", Text.Trim},
     {"phone", Text.Trim},
     {"address_line1", Text.Trim},
     {"credit_terms", Text.Trim}}
)
```

### Step 3: Standardize Case
```powerquery
// Convert to Title Case
= Table.TransformColumns(
    PreviousStep,
    {{"supplier_name", Text.Proper},
     {"contact_person", Text.Proper},
     {"city", Text.Proper},
     {"county", Text.Proper}}
)
```

### Step 4: Clean Currency in Minimum Order
```powerquery
// Remove currency symbols and convert to number
= Table.TransformColumns(
    PreviousStep,
    {{"minimum_order", each 
        if _ = "price pending" then null 
        else Number.From(Text.Remove(_, {"£", "$"}))
    }}
)
```

### Step 5: Standardize Country Names
```powerquery
= Table.ReplaceValue(
    PreviousStep,
    each [country],
    each if Text.Lower([country]) = "uk" or Text.Lower([country]) = "united kingdom" 
         then "United Kingdom" 
         else [country],
    Replacer.ReplaceValue,
    {"country"}
)
```

### Step 6: Standardize Boolean Values
```powerquery
= Table.TransformColumns(
    PreviousStep,
    {{"active", each 
        if _ = "TRUE" or _ = "yes" or _ = "1" then true 
        else if _ = "FALSE" or _ = "no" or _ = "0" then false 
        else null
    }}
)
```

### Step 7: Handle Null Values
```powerquery
= Table.ReplaceValue(
    PreviousStep,
    "null",
    null,
    Replacer.ReplaceValue,
    {"rating"}
)
```

### Step 8: Fix Negative Values
```powerquery
= Table.TransformColumns(
    PreviousStep,
    {{"delivery_days", each if Text.Contains(_, "-") 
        then Text.Remove(_, "-") 
        else _
    }}
)
```

### Step 9: Remove Duplicates
```powerquery
// Remove duplicates based on business keys (supplier name and email)
// since the duplicate records have different supplier_ids
= Table.Distinct(PreviousStep, {"supplier_name", "email"})
```

### Step 10: Standardize Credit Terms
```powerquery
= Table.TransformColumns(
    PreviousStep,
    {{"credit_terms", each 
        if Text.Contains(Text.Lower(_), "net") then _ 
        else "net " & Text.Remove(_, " days")
    }}
)
```

## Python Cleansing Example

```python
import pandas as pd
import numpy as np

# Load the data
df = pd.read_csv('suppliers_raw.csv')

# 1. Trim whitespace from all string columns
string_columns = df.select_dtypes(include=['object']).columns
df[string_columns] = df[string_columns].apply(lambda x: x.str.strip() if x.dtype == "object" else x)

# 2. Standardize case - Title Case
df['supplier_name'] = df['supplier_name'].str.title()
df['contact_person'] = df['contact_person'].str.title()
df['city'] = df['city'].str.title()
df['county'] = df['county'].str.title()

# 3. Clean minimum_order - remove currency symbols
df['minimum_order'] = df['minimum_order'].replace('price pending', np.nan)
df['minimum_order'] = df['minimum_order'].str.replace('£', '').str.replace('$', '')
df['minimum_order'] = pd.to_numeric(df['minimum_order'], errors='coerce')

# 4. Standardize country names
df['country'] = df['country'].str.title()
df['country'] = df['country'].replace('Uk', 'United Kingdom')

# 5. Standardize boolean values
bool_map = {'TRUE': True, 'yes': True, '1': True, 
            'FALSE': False, 'no': False, '0': False}
df['active'] = df['active'].astype(str).map(bool_map)

# 6. Handle null text
df['rating'] = df['rating'].replace('null', np.nan)
df['rating'] = pd.to_numeric(df['rating'], errors='coerce')

# 7. Fix negative values
df['delivery_days'] = df['delivery_days'].str.replace('-', '')

# 8. Remove duplicates based on business keys
# Note: Duplicate records have different supplier_ids, so use business keys
df = df.drop_duplicates(subset=['supplier_name', 'email'], keep='first')

# 9. Standardize credit terms
def standardize_terms(term):
    if pd.isna(term):
        return term
    term = term.strip()
    if 'net' not in term.lower():
        days = term.replace(' days', '').strip()
        return f'net {days}'
    return term

df['credit_terms'] = df['credit_terms'].apply(standardize_terms)

# Save cleaned data
df.to_csv('suppliers_clean.csv', index=False)

print(f"Original records: 25")
print(f"After removing duplicates: {len(df)}")
print(f"Records with missing ratings: {df['rating'].isna().sum()}")
print(f"Records with missing last_order_date: {df['last_order_date'].isna().sum()}")
```

## SQL Cleansing Example (MySQL)

```sql
-- Create a staging table to load raw data
CREATE TABLE suppliers_staging LIKE suppliers;

-- Load the raw CSV
LOAD DATA INFILE 'suppliers_raw.csv'
INTO TABLE suppliers_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create cleaned suppliers table and remove duplicates
-- Use ROW_NUMBER() to keep first occurrence of duplicates based on business keys
CREATE TABLE suppliers_clean AS
SELECT 
    supplier_id,
    supplier_name,
    contact_person,
    email,
    phone,
    address_line1,
    address_line2,
    city,
    county,
    postcode,
    country,
    product_category,
    minimum_order,
    credit_terms,
    delivery_days,
    rating,
    active,
    last_order_date
FROM (
    SELECT 
        supplier_id,
        TRIM(supplier_name) as supplier_name,
        TRIM(contact_person) as contact_person,
        email,
        TRIM(phone) as phone,
        TRIM(address_line1) as address_line1,
        address_line2,
        city,
        county,
        postcode,
        CASE 
            WHEN LOWER(country) IN ('uk', 'united kingdom') THEN 'United Kingdom'
            ELSE country 
        END as country,
        product_category,
        CASE 
            WHEN minimum_order = 'price pending' THEN NULL
            ELSE CAST(REPLACE(REPLACE(minimum_order, '£', ''), '$', '') AS DECIMAL(10,2))
        END as minimum_order,
        TRIM(credit_terms) as credit_terms,
        REPLACE(delivery_days, '-', '') as delivery_days,
        CASE 
            WHEN rating = 'null' THEN NULL
            ELSE CAST(rating AS DECIMAL(3,1))
        END as rating,
        CASE 
            WHEN active IN ('TRUE', 'yes', '1') THEN 1
            WHEN active IN ('FALSE', 'no', '0') THEN 0
            ELSE NULL
        END as active,
        last_order_date,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(supplier_name), email 
            ORDER BY supplier_id
        ) as row_num
    FROM suppliers_staging
) as cleaned
WHERE row_num = 1;
```

## Expected Outcomes After Cleansing

After properly cleansing the data, you should have:

1. **24 unique supplier records** (down from 25 after removing 1 duplicate)
2. **All text fields trimmed** of leading/trailing whitespace
3. **Consistent Title Case** for company names, contact names, and locations
4. **Numeric minimum_order values** without currency symbols (range: £125.00 - £750.00)
5. **Standardized country** to "United Kingdom" for all records
6. **Boolean values** consistently represented (TRUE/FALSE or 1/0)
7. **2 records with NULL ratings** (where data was missing or marked as "null")
8. **2 records with missing last_order_date** (to be followed up)
9. **No negative values** in delivery_days
10. **Consistent credit terms format** (all standardized to "net XX" or "XX days")

## Learning Objectives

By working with this dataset, you will practice:

1. ✅ Identifying and removing leading/trailing whitespace
2. ✅ Standardizing text case (upper, lower, title case)
3. ✅ Handling currency symbols and numeric conversions
4. ✅ Detecting and removing duplicate records
5. ✅ Standardizing boolean/logical values
6. ✅ Managing NULL values and missing data
7. ✅ Converting text "null" to actual NULL values
8. ✅ Fixing data entry errors (negative values, typos)
9. ✅ Standardizing categorical data (country names, terms)
10. ✅ Data type conversions (text to number, text to boolean)
11. ✅ Pattern matching and text replacement
12. ✅ Data validation rules
13. ✅ Referential integrity checks
14. ✅ Building data quality reports
15. ✅ Creating repeatable ETL processes

## Additional Practice Exercises

Once you've cleansed the basic issues, try these advanced exercises:

1. **Create a data quality report** showing:
   - Number of records with each type of issue
   - Percentage of records affected
   - Fields with most quality issues

2. **Add validation rules**:
   - Ensure UK postcodes match proper format
   - Validate email addresses have proper format
   - Check phone numbers are valid UK numbers
   - Ensure ratings are between 1 and 5

3. **Create lookup tables**:
   - Counties of the UK (normalize county names)
   - Product categories (standardize categories)
   - Credit terms (create standard terms table)

4. **Build a data profiling dashboard**:
   - Show distribution of suppliers by region
   - Average rating by product category
   - Credit terms analysis
   - Delivery time patterns

5. **Implement data quality scoring**:
   - Assign quality scores to each record
   - Identify records needing manual review
   - Track data quality improvements over time

## Use Cases

This dataset is perfect for:
- **Power Query tutorials** and training sessions
- **ETL pipeline development** and testing
- **Data quality workshops** and exercises
- **SQL cleansing practice** with realistic scenarios
- **Python pandas** data manipulation exercises
- **Data governance** policy demonstrations
- **Before/after data quality** presentations
- **Building automated data cleansing** processes

## Support Files

For a complete ETL solution, consider creating:
- `suppliers_clean.csv` - Your cleansed output file
- `suppliers_table.sql` - Database schema for suppliers
- `data_quality_report.xlsx` - Quality metrics before/after cleansing
- `cleansing_documentation.md` - Your cleansing decisions and methodology

## License

This is sample data created for educational and demonstration purposes. All company names, contact details, and other information are fictional and generated for training purposes only.
