-- Changing DateStamp type into Date

use PortfolioProject
alter table housing
add DateSale date

update Housing
set DateSale = CONVERT(date,SaleDate)

select * from housing
-------------------------------------
-- Breaking out address into individual columns (Address, City, State)
alter table housing 
add SplitedPropertyaddress varchar(255)
alter table housing 
add SplitedPropertyStreet varchar(255)
alter table housing 
add SplitedOwneraddress varchar(255)
alter table housing 
add SplitedOwnerCity varchar(255)
alter table housing 
add SplitedOwnerState varchar(255)

update Housing
set splitedPropertyAddress = SUBSTRING(PropertyAddress, 1, charindex(',',propertyaddress)-1)
update Housing
set splitedPropertyStreet = SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1, len(propertyaddress))

update Housing
set splitedowneraddress = PARSENAME(REPLACE(owneraddress,',','.'),3)
update Housing
set splitedownercity = parsename(replace(owneraddress, ',','.'),2)
update Housing
set SplitedOwnerState = PARSENAME(replace(owneraddress, ',','.'),1)

select * from Housing
--------------------------------------------------------------------------------
-------- Replacing N with "No" and Y with "Yes" in the "Soldasvacant" collumn
select soldasvacant,count(SoldAsVacant)
from Housing
group by SoldAsVacant

update Housing
set soldasvacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
----------------------------------------------------------
------ Remove Duplicates

with rownum as(
select*,
	ROW_NUMBER() over(
			partition by parcelID,
						 propertyaddress,
				         saleprice,
						 saledate,
						 legalreference
						 order by
						 uniqueid) row_num
from housing)
delete from rownum
where row_num >1
----------------------------------
----Delete Unused Columns

alter table housing
drop column propertyaddress, owneraddress, TaxDistrict, saledate

select* from Housing
