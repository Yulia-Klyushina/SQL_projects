drop database if exists chemicalsincosmetics;
create database chemicalsincosmetics;
select count(*) from chemicalsincosmetics.chemicals_in_cosmetics; -- 69664

-- update column BrandName
update chemicalsincosmetics.chemicals_in_cosmetics
set BrandName = replace(BrandName, 'bare Minerals', 'BareMinerals');
select count(BrandName) from chemicalsincosmetics.chemicals_in_cosmetics 
where BrandName = 'bare Minerals'; -- 0

-- top 10 brand names having chemicals in their products
select BrandName, count(distinct ProductName) from chemicalsincosmetics.chemicals_in_cosmetics
group by BrandName
order by count(distinct ProductName) desc;

-- top 10 product names having the most chemicals
select distinct CDPHId, BrandName, ProductName, PrimaryCategory, count(distinct ChemicalName) 
from chemicalsincosmetics.chemicals_in_cosmetics
group by CDPHId, BrandName, ProductName, PrimaryCategory
order by count(distinct ChemicalName)  desc limit 10;

-- show all Primary category
select distinct PrimaryCategory from chemicalsincosmetics.chemicals_in_cosmetics; 

-- show baby products name having chemicals
select distinct CDPHId, BrandName, ProductName, ChemicalName, ChemicalCount 
from chemicalsincosmetics.chemicals_in_cosmetics
where PrimaryCategory = 'Baby Products'
order by ChemicalCount desc;

-- top chemicals in cosmetics
select ChemicalName, count(distinct CDPHId) as total from chemicalsincosmetics.chemicals_in_cosmetics
group by ChemicalName
order by total desc;

-- top chemicals in baby products
select ChemicalName, count(distinct CDPHId) as total 
from chemicalsincosmetics.chemicals_in_cosmetics
where PrimaryCategory = 'Baby Products'
group by ChemicalName
order by total desc;

-- product names having lead
select distinct CDPHId, BrandName, ProductName, PrimaryCategory  
from chemicalsincosmetics.chemicals_in_cosmetics
where ChemicalName = 'Lead'
order by BrandName;

-- show all chemicals in sun-related product
select distinct CDPHId, BrandName, ProductName, ChemicalName, ChemicalCount 
from chemicalsincosmetics.chemicals_in_cosmetics
where PrimaryCategory = 'Sun-Related Products'
order by ChemicalCount desc;   