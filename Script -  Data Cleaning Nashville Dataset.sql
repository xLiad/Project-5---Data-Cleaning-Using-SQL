USE Nashville;

---------------------------
-- 1) Standardize date format
---------------------------

ALTER TABLE NashvilleHousing
	  ADD PropertySaleDate DATE 

UPDATE NashvilleHousing SET PropertySaleDate = CONVERT(DATE,SaleDate)

-- Created a new column to hold the data of the Date column in a YYYY/MM/DD format
-- the old column will be delated later.

;
---------------------------------------------
-- 2) Fill null values for property address data
---------------------------------------------

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing A JOIN NashvilleHousing B ON a.ParcelID = b.ParcelID
                                               AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- the column "UniqueID" is primary key column and the value is unique and used as index,
-- the column "ParcelID" is a unique number each property got and is used to help identify your property for tax,
-- in the database there are rows with the same "ParcelID" which means the same property is in the database more than once.
-- in some rows "PropertyAdress" column is null but if the property exist in the data base with diffrent "UniqueID" (diffrent index)
-- we can take the "PropertyAdress" of the property from a row with same "ParcelID" (which means same property). 

;
------------------------------------------------------------
-- 3) Breaking out address data to street/city/state columns
------------------------------------------------------------
-- Property City Name

ALTER TABLE NashvilleHousing ADD PropertyAdressCityName VARCHAR(100)

UPDATE NashvilleHousing SET PropertyAdressCityName = PARSENAME(REPLACE(PropertyAddress,',','.'),1)
FROM NashvilleHousing

;
-- Property Street Name

ALTER TABLE NashvilleHousing ADD PropertyAdressStreetName VARCHAR(100)

UPDATE NashvilleHousing SET PropertyAdressStreetName = PARSENAME(REPLACE(PropertyAddress,',','.'),2)
FROM NashvilleHousing

;

-- Owner State Name

ALTER TABLE NashvilleHousing ADD OwnerAdressStateName VARCHAR(100)

UPDATE NashvilleHousing SET OwnerAdressStateName = PARSENAME (REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

;

-- Owner City Name

ALTER TABLE NashvilleHousing ADD OwnerAdressCityName VARCHAR(100)

UPDATE NashvilleHousing SET OwnerAdressCityName = PARSENAME (REPLACE(OwnerAddress,',','.'),2)
FROM NashvilleHousing

;

-- Owner Street Name

ALTER TABLE NashvilleHousing ADD OwnerAdressStreetName VARCHAR(100)

UPDATE NashvilleHousing SET OwnerAdressStreetName = PARSENAME (REPLACE(OwnerAddress,',','.'),3)
FROM NashvilleHousing

-- because the street/city/state name data was divided by symbol it was possible to split the data based on symbol position.
-- i created new columns to hold the street/city/state name data.
-- It will be easier to analyze the data based on street/city/state name if the adress data is 
-- splited into diffrent columns based on street/city/state name.

;
--------------------------------------------------------------------
-- 4) Change "Y" and "N" to "Yes" and "No" in "Sold as Vacant" field
--------------------------------------------------------------------

UPDATE NashvilleHousing SET SoldAsVacant =
	   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
            WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

-- Some rows in the column "SoldAsVacant" had the values 'Y' and 'N' instead of
-- 'Yes' and 'No', the rows were updated rows using case command to make all the data in this column in the same format.

;
---------------------
-- 5) Remove Duplicates
---------------------

WITH CTE_Dupliactes
AS
(
SELECT * ,ROW_NUMBER () OVER (PARTITION BY ParcelID,
										   PropertyAddress,
										   SaleDate,
										   LegalReference
										   ORDER BY UniqueID) AS "RN"
FROM NashvilleHousing
)
DELETE
FROM CTE_Dupliactes
WHERE RN > 1

-- The database had some duplicate rows with the exact same data,
-- same "ParcelID", "PropertyAddress", "SaleDate" ...
-- using Row_Number function to check for duplicated data we deleted rows that are duplicated.
-- (a row that the Row_Number function value is bigger than 1 partiton by all the identifying columns is a row that already exist, a duplicate).


;
-------------------------
-- 6) Delete Unused Columns
-------------------------

ALTER TABLE NashvilleHousing DROP COLUMN PropertyAddress

;

ALTER TABLE NashvilleHousing DROP COLUMN SaleDate

;

ALTER TABLE NashvilleHousing DROP COLUMN OwnerAddress

;

-- Deleting the columns that we dont need anymore after we inserted their data in better way (for analyzing) into new columns

SELECT *
FROM NashvilleHousing

