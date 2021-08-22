USE Nashville;

---------------------------
-- 1) Standardize date format
---------------------------

ALTER TABLE NashvilleHousing
	  ADD PropertySaleDate DATE 

UPDATE NashvilleHousing SET PropertySaleDate = CONVERT(DATE,SaleDate)

;
---------------------------------------------
-- 2) Fill null values for property address data
---------------------------------------------

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing A JOIN NashvilleHousing B ON a.ParcelID = b.ParcelID
                                               AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


;
--------------------------------------------------
-- 3) Breaking out address data to street/city/state columns
--------------------------------------------------
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

;
----------------------------------------------------------
-- 4) Change "Y" and "N" to "Yes" and "No" in "Sold as Vacant" field
----------------------------------------------------------

UPDATE NashvilleHousing SET SoldAsVacant =
	   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
            WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing



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


SELECT *
FROM NashvilleHousing

