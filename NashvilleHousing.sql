-- Step 1: Cleaning Data in SQL Queries

-- 1.1: Display data from the 'Nashwille_Housing' table
SELECT *
FROM NashvilleHousing_DB..Nashville_Housing;

-- 1.2: Standardize Date Format

ALTER TABLE NashvilleHousing_DB..Nashville_Housing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing_DB..Nashville_Housing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

-- 1.3: Populate property address data
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing_DB..Nashville_Housing a
JOIN NashvilleHousing_DB..Nashville_Housing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing_DB..Nashville_Housing a
JOIN NashvilleHousing_DB..Nashville_Housing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Step 2: Breaking out Address into Individual Columns (Address, City, State)
SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS CityState
FROM NashvilleHousing_DB..Nashville_Housing;

ALTER TABLE NashvilleHousing_DB..Nashville_Housing
ADD PropertySplitAddress NVARCHAR(255),
    PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing_DB..Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- Step 3: Process Owner Address

-- 3.1: Display Owner Address
SELECT OwnerAddress
FROM NashvilleHousing_DB..Nashville_Housing;

-- 3.2: Split Owner Address into City, State, and Address
SELECT
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitState,
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitAddress
FROM NashvilleHousing_DB..Nashville_Housing;

-- 3.3: Update the table with the split Owner Address
ALTER TABLE NashvilleHousing_DB..Nashville_Housing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing_DB..Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Step 4: Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing_DB..Nashville_Housing
GROUP BY SoldAsVacant
ORDER BY 2;

UPDATE NashvilleHousing_DB..Nashville_Housing
SET SoldAsVacant = CASE
                       WHEN SoldAsVacant = 'Y' THEN 'Yes'
                       WHEN SoldAsVacant = 'N' THEN 'No'
                       ELSE SoldAsVacant
                   END;

-- Step 5: Remove Duplicates
WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
  FROM NashvilleHousing_DB..Nashville_Housing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

-- Step 6: Drop Unused Columns
ALTER TABLE NashvilleHousing_DB..Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
