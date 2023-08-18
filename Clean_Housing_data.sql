/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.housing_data

--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select SaleDate,CONVERT(Date,SaleDate)
from portfolioproject.dbo.housing_data


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.housing_data


Update housing_data
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table housing_data
Add SaleDateConverted Date;


Update portfolioproject.dbo.housing_data
SET SaleDateConverted = CONVERT(Date,SaleDate)

select * 
from portfolioproject.dbo.housing_data

-- remove the saledate column from the data 

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
from portfolioproject.dbo.housing_data
-- where PropertyAddress is null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from portfolioproject.dbo.housing_data a
join portfolioproject.dbo.housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


-- now fill the null value of a.propertyadress with b.property address

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.housing_data a
join portfolioproject.dbo.housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-- now update the column
UPDATE a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.housing_data a
join portfolioproject.dbo.housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from portfolioproject.dbo.housing_data


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.housing_data


ALTER TABLE housing_data
Add PropertySplitAddress Nvarchar(255);

Update housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing_data
Add PropertySplitCity Nvarchar(255);


Update housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.housing_data

----------------------------------------------------------------------------------------------------------------------------

-- Lets look on the owner address



Select OwnerAddress
From PortfolioProject.dbo.housing_data


Select 
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)

From PortfolioProject.dbo.housing_data

-- Now update the these column


ALTER TABLE housing_data
Add OwnerSplitAddress Nvarchar(255);

Update housing_data
SET OwnerSplitAddress =PARSENAME(Replace(OwnerAddress,',','.'),3)


ALTER TABLE housing_data
Add OwnerSplitCity Nvarchar(255);


Update housing_data
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


ALTER TABLE housing_data
Add OwnerSplitState Nvarchar(255);


Update housing_data
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
From PortfolioProject.dbo.housing_data





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject.dbo.housing_data
Group by SoldAsVacant
order by 2


select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End

From PortfolioProject.dbo.housing_data


Update housing_data
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.housing_data
--order by ParcelID
)
Select *
from RowNumCTE
where row_num >1
--order by PropertyAddress





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject.dbo.housing_data


ALTER TABLE PortfolioProject.dbo.housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress




-----------------------------------------------------------------------------------------------










