select * from Housing_data.nashville_housing_data;
-- Standardize Date format:
select SaleDate, STR_TO_DATE(SaleDate, '%M %d,%Y')
from Housing_data.nashville_housing_data;
Update Housing_data.nashville_housing_data
set SaleDate = STR_TO_DATE(SaleDate, '%M %d,%Y');

Alter table Housing_data.nashville_housing_data
add SaleDateConverted date;

Update Housing_data.nashville_housing_data
set SaleDateConverted = STR_TO_DATE(SaleDate, '%Y-%m-%d'); 

select SaleDateConverted, SaleDate
from Housing_data.nashville_housing_data;

-- Populate property Address date:
update Housing_data.nashville_housing_data
set PropertyAddress = null where PropertyAddress = ''; 

select * from Housing_data.nashville_housing_data
where PropertyAddress is null;

select * from Housing_data.nashville_housing_data
order by ParcelID;

select a.ParcelID, a.PropertyAddress, 
b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress) 
from Housing_data.nashville_housing_data a
join Housing_data.nashville_housing_data b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

UPDATE Housing_data.nashville_housing_data t
JOIN (
  SELECT a.ParcelID, COALESCE(a.PropertyAddress, b.PropertyAddress) AS PropertyAddress
  FROM Housing_data.nashville_housing_data a
  JOIN Housing_data.nashville_housing_data b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL
) s ON t.ParcelID = s.ParcelID
SET t.PropertyAddress = s.PropertyAddress;

-- Breaking out Address into individual columns (Address, City, State):
select SUBSTRING_INDEX(PropertyAddress, ',', 1) as Address, SUBSTRING_INDEX(PropertyAddress, ',', -1) as City
from Housing_data.nashville_housing_data;

Alter table Housing_data.nashville_housing_data
add PropertySplitAddress varchar(255);
Alter table Housing_data.nashville_housing_data
add PropertySplitCity varchar(255);

Update Housing_data.nashville_housing_data
set PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

Update Housing_data.nashville_housing_data
set PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1); 

select PropertyAddress, PropertySplitAddress, PropertySplitCity
from Housing_data.nashville_housing_data;
select * from Housing_data.nashville_housing_data;

select SUBSTRING_INDEX(OwnerAddress, ',', 1) as Address, SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) as OwnerAddressCity, SUBSTRING_INDEX(OwnerAddress, ',', -1) as OwnerAddressState
from Housing_data.nashville_housing_data;

Alter table Housing_data.nashville_housing_data
add OwnerSplitAddress varchar(255);
Alter table Housing_data.nashville_housing_data
add OwnerSplitCity varchar(255);
Alter table Housing_data.nashville_housing_data
add OwnerSplitState varchar(255);


Update Housing_data.nashville_housing_data
set OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

Update Housing_data.nashville_housing_data
set OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1); 

Update Housing_data.nashville_housing_data
set OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from Housing_data.nashville_housing_data;

select * from Housing_data.nashville_housing_data;

-- Change Y and N to Yes and No in "Sold as Vacant" field:
select distinct SoldAsVacant from Housing_data.nashville_housing_data;

select distinct SoldAsVacant, count(SoldAsVacant) from Housing_data.nashville_housing_data
group by SoldAsVacant
order by count(SoldAsVacant);

select SoldAsVacant, case  when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end 
from Housing_data.nashville_housing_data
order by SoldAsVacant;

update Housing_data.nashville_housing_data
set SoldAsVacant = case  when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end; 

select distinct SoldAsVacant, count(SoldAsVacant) from Housing_data.nashville_housing_data
group by SoldAsVacant
order by count(SoldAsVacant);

-- Remove duplicates:
with RowNumCTE as 
(select *, row_number()over(
partition by ParcelID, PropertyAddress, SalePrice,SaleDate, LegalReference
order by UniqueID
) row_num
from Housing_data.nashville_housing_data)
select * from RowNumCTE
where row_num > 1;

DELETE FROM Housing_data.nashville_housing_data
WHERE UniqueID NOT IN (
    SELECT * FROM (
        SELECT MIN(UniqueID)
        FROM Housing_data.nashville_housing_data
        GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    ) AS t
);

-- Delete unused columns:
alter table Housing_data.nashville_housing_data
DROP COLUMN OwnerAddress, 
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict;

select * from Housing_data.nashville_housing_data;

alter table Housing_data.nashville_housing_data
DROP COLUMN SaleDate; 

select * from Housing_data.nashville_housing_data;
