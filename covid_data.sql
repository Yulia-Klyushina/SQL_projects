select * from covid_data.coviddeaths_1
where continent is not null
order by new_deaths desc;

select count(*) from covid_data.coviddeaths_1; -- 81686
select count(*) from covid_data.coviddeathsvaccinations; -- 85171
select count(distinct location) from covid_data.coviddeathsvaccinations; -- 219
select count(distinct location) from covid_data.coviddeaths_1; -- 196
select * from covid_data.coviddeaths_1
order by location, date;
-- select * from covid_data.coviddeathsvaccinations
-- order by location, date; 

-- Select data that we are going to be using
select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, new_cases, total_deaths, population
from covid_data.coviddeaths_1
where continent is not null
order by location, date;

-- Looking at Total Cases vs Total Deaths
select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, total_deaths, 
(total_deaths*100/total_cases) as DeathPersentage
from covid_data.coviddeaths_1
where continent is not null
order by location, date;

-- Death Persentage in the USA
select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, total_deaths, 
(total_deaths*100/total_cases) as DeathPersentage
from covid_data.coviddeaths_1
where continent is not null and location like '%state%'
order by location, date;

-- Death Persentage in Russia
select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, total_deaths, 
(total_deaths*100/total_cases) as DeathPersentage
from covid_data.coviddeaths_1
where continent is not null and location = 'Russia'
order by location, date;

-- Looking at Tatal Cases vs Population:
-- Shows what persentage of population got Covid
select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, population, 
(total_cases*100/population) as TotalCasesPersentage
from covid_data.coviddeaths_1
where continent is not null
order by location, date;


select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, population, 
(total_cases*100/population) as TotalCasesPersentage
from covid_data.coviddeaths_1
where continent is not null and location like '%state%'
order by location, date;

select location, STR_TO_DATE(date, '%m/%d/%y') as date, total_cases, population, 
(total_cases*100/population) as TotalCasesPersentage
from covid_data.coviddeaths_1
where location= 'Russia'
order by location, date;

-- Looking at countries with highest infection rate compared to population:
select location, max(total_cases) as HighestInfectionCount, population, 
(max(total_cases)/population)*100 as PercentPopulationInfected
from covid_data.coviddeaths_1
where continent is not null
group by location, population
order by PercentPopulationInfected desc;
  
-- Showing countries with highest death count per population
select location, max(cast(total_deaths AS UNSIGNED)) as TotalDeathsCount
from covid_data.coviddeaths_1
where continent is not null
group by location
order by TotalDeathsCount desc;

-- Show total death count by continent:
select continent, sum(TotalDeathsCount) as TotalDeathsByContinent from (select continent, location, max(cast(total_deaths AS UNSIGNED)) as TotalDeathsCount
from covid_data.coviddeaths_1
where continent is not null
group by continent, location) t
group by continent
order by TotalDeathsByContinent desc;

-- Showing continents with the highest death count per population

select continent, location, max(cast(total_deaths AS UNSIGNED)) as TotalDeathsCount
from covid_data.coviddeaths_1
where continent is not null
group by continent, location
order by continent, TotalDeathsCount desc;

-- GLOBAL NUMBERS:
select date, sum(new_cases) as total_cases, 
sum(new_deaths) as total_deaths,
sum(new_deaths)*100/sum(new_cases) as DeathPercentage
from covid_data.coviddeaths_1
where continent is not null
group by date
order by date, total_cases;

select sum(new_cases) as total_cases, 
sum(new_deaths) as total_deaths,
sum(new_deaths)*100/sum(new_cases) as DeathPercentage
from covid_data.coviddeaths_1
where continent is not null
order by total_cases;

-- Looking at Total Population vs Vaccinations
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_data.coviddeaths_1 d
join covid_data.coviddeathsvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by location, date;

-- Use CTE:
with PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
as
(select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_data.coviddeaths_1 d
join covid_data.coviddeathsvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by location, date)
select *, (RollingPeopleVaccinated/Population)*100 from PopvsVac;

-- TEMP TABLE:
drop table if exists covid_data.PersentPopulationVactinated;
CREATE TEMPORARY TABLE covid_data.PersentPopulationVactinated
(Continent varchar(255),
Location varchar(255),
Date datetime,
Population char(15),
New_vaccination char(15),
RollingPeopleVaccinated INT);

insert into covid_data.PersentPopulationVactinated(Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_data.coviddeaths_1 d
join covid_data.coviddeathsvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by location, date;

select *, (RollingPeopleVaccinated/Population)*100 from covid_data.PersentPopulationVactinated;

-- Creating View to store date for later visualization:
create view covid_data.PersentPopulationVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_data.coviddeaths_1 d
join covid_data.coviddeathsvaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by location, date;

select * from covid_data.PersentPopulationVaccinated;