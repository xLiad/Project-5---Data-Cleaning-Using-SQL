# Project 5 Data Cleaning Using SQL

* This project was made thanks to a guide created by "Alex The Analyst"
-- https://www.youtube.com/c/AlexTheAnalyst -- 

* In this project we clean data from an excel file using SQL.

* The dataset is called Nashville Housing.
The dataset contains data about Real Estate in the city of Nashville, Tennessee.

# The tasks for cleaning this dataset:

1) Changing the date format of the "SaleDate" column as the hours in the default date format are not needed. 

2) Filling null values in the "PropertyAddress" column.

3) Breaking out address data from the "PropertyAddress" column to street/city/state name columns - easier to analyze address data.

4) Changing rows with "Y" and "N" values in "SoldAsVacant" column to "Yes" and "No" - to create one format of values.

5) Removing duplicates rows.

6) Deleting Unused Columns.

# The columns of the dataset in its raw form in the excel file:
Using the data in the first row as example. 
# UniqueID 
2045
* column used as index, the values are unique.
# ParcelID
007 00 0 125.00
* a parcel number is assigned by your local tax assessment office and is used to help identify your property for tax, so unique value for each diffrent property.
# LandUse
SINGLE FAMILY
# PropertyAddress
1808  FOX CHASE DR, GOODLETTSVILLE
# SaleDate
April 9, 2013
# SalePrice
240000
# LegalReference
20130412-0036474
# SoldAsVacant
No
# OwnerName
FRAZIER, CYRENTHA LYNETTE
# OwnerAddress
1808  FOX CHASE DR, GOODLETTSVILLE, TN
# Acreage
2.3
# TaxDistrict
GENERAL SERVICES DISTRICT
# LandValue
50000
# BuildingValue
168200
# TotalValue
235700
# YearBuilt
1986
# Bedrooms
3
# FullBath
3
# HalfBath
0


