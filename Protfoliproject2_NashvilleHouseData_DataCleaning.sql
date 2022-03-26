
select * from PortfoliProject.dbo.NashvilleHousing;


-----Cleaning/Standardising Date format

select SaleDate from PortfoliProject.dbo.NashvilleHousing;

select SaleDate, convert(Date,SaleDate) 
from 
PortfoliProject.dbo.NashvilleHousing;

update PortfoliProject.dbo.NashvilleHousing
set SaleDate = convert(Date,SaleDate) 

--or 
ALTER table PortfoliProject.dbo.NashvilleHousing
add SaleConvertedDate Date;

update PortfoliProject.dbo.NashvilleHousing
set SaleConvertedDate = convert(Date,SaleDate) ;



----- Property Address


select PropertyAddress from PortfoliProject.dbo.NashvilleHousing where PropertyAddress is null;

select * from PortfoliProject.dbo.NashvilleHousing where PropertyAddress is null;

--If we see in the dataset each unique ParcelID has same address, we'll use the same and fill null values

--Non Equi join
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)--If a.address is null populate b.address else retain a.adress
From PortfoliProject.dbo.NashvilleHousing a
JOIN PortfoliProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfoliProject.dbo.NashvilleHousing a
JOIN PortfoliProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


----- Separating address into address,city,state

Select PropertyAddress
From PortfoliProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
FROM
PortfoliProject.dbo.NashvilleHousing;


ALTER TABLE PortfoliProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfoliProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfoliProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfoliProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from PortfoliProject.dbo.NashvilleHousing ;

Select OwnerAddress
From PortfoliProject.dbo.NashvilleHousing ;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) --parsename parses the string from backwards delimited by '.' and the number we give which occurence of '.'
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfoliProject.dbo.NashvilleHousing ;

ALTER TABLE PortfoliProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfoliProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfoliProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfoliProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfoliProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfoliProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfoliProject.dbo.NashvilleHousing;


----- Soldvacant field change from Y or N to Yes or No since it as 'Y','N','Yes', 'No'

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfoliProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfoliProject.dbo.NashvilleHousing


Update PortfoliProject.dbo.NashvilleHousing
SET SoldAsVacant = 
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfoliProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


----- Selecting and Removing Duplicates in 3 ways

select * from PortfoliProject.dbo.NashvilleHousing


WITH RowNumCTE AS(                         -- To get duplicates
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfoliProject.dbo.NashvilleHousing 	

)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress
 ORDER BY UniqueID

 select * FROM PortfoliProject.dbo.NashvilleHousing  -- If we replace select * with delete, duplicates will get deleted
	WHERE UniqueID NOT IN
	(
	SELECT MIN(UniqueID)
	FROM PortfoliProject.dbo.NashvilleHousing
	GROUP BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
			
	) 	 ORDER BY UniqueID



Select * from  PortfoliProject.dbo.NashvilleHousing where UniqueID not in   -- To get duplicates
(                       
	Select
		FIRST_VALUE (UniqueID) OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num
	From PortfoliProject.dbo.NashvilleHousing 	

) -- If we replace select * with delete, duplicates will get deleted





























