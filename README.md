
# Nashville Housing Data Cleaning Project







## Overview: 

This project focuses on cleaning and preprocessing data from the 'Nashville_Housing' table in the `NashvilleHousing_DB` database. The primary goal is to enhance data quality and structure for better analysis and reporting.

## Steps:


### Step 1: Cleaning Data in SQL Queries:
1.1: Display data from the 'Nashville_Housing' table
Display all records from the 'Nashville_Housing' table.

1.2: Standardize Date Format
Add a new column, 'SaleDateConverted,' and update it to have a standardized date format.

1.3: Populate property address data
Fill in missing property addresses by using non-null values from other rows with the same ParcelID.

### Step 2: Breaking out Address into Individual Columns (Address, City, State)

Extract the address and city/state information from the 'PropertyAddress' column and store them in new columns.

### Step 3: Process Owner Address

3.1: Display Owner Address
Show the existing owner addresses in the 'OwnerAddress' column.

3.2: Split Owner Address into City, State, and Address
Separate the owner address into city, state, and address components.

3.3: Update the table with the split Owner Address
Add new columns for the split owner address components and update the table accordingly.

### Step 4: Change Y and N to Yes and No in "Sold as Vacant" field

Convert 'Y' to 'Yes' and 'N' to 'No' in the 'SoldAsVacant' field.

### Step 5: Remove Duplicates

Identify and delete duplicate rows based on specific columns to ensure data integrity.

### Step 6: Drop Unused Columns

Remove unnecessary columns from the dataset.

    
## Conclusion:
This series of data cleaning steps ensures that the 'Nashville_Housing' table is well-structured and ready for further analysis. The cleaned dataset can be used for various analytical purposes and is now more consistent and standardized.