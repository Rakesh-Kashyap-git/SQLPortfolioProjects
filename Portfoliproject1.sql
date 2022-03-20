SELECT * 
FROM PortfoliProject.dbo.CovidDeaths$


SELECT location,date,total_cases,new_cases,total_deaths,population 
FROM PortfoliProject.dbo.CovidDeaths$ 
order by 1,2


--GLOBAL NUMBERS

--Total cases 
Select SUM(new_cases) as total_cases, SUM(new_deaths ) as total_deaths, SUM(new_deaths )/SUM(New_Cases)*100 as DeathPercentage
From PortfoliProject.dbo.CovidDeaths$
where new_cases is not null and continent is not null 


-- Everyday cases
Select date,SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
CASE SUM(new_cases)
	WHEN NULL THEN 0
	WHEN 0 THEN 0
	ELSE SUM(new_deaths)/SUM(New_Cases)*100
END as DeathPercentage
From PortfoliProject.dbo.CovidDeaths$
where new_cases is not null and continent is not null 
group by date
order by 1

-- Total cases Vs Population
Select Location, date, Population, total_cases,  round((total_cases/population)*100,2) as PercentPopulationInfected
From PortfoliProject.dbo.CovidDeaths$
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectedCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfoliProject.dbo.CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc

-- Total Cases Vs Total Deaths

SELECT location,date,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
order by 1,2

-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeaths , ((MAX(Total_deaths)/MAX(population)))*100 as PercentPopulationDead
From PortfoliProject.dbo.CovidDeaths$
Where continent is not null 
Group by Location
order by PercentPopulationDead desc

-- Maximum Cases in a day till date

SELECT location,continent,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where continent is not null and new_cases = 
(select MAX(new_cases) from PortfoliProject.dbo.CovidDeaths$ where location not in ('World','High income','Upper middle income','Lower middle income')  
and continent is not null)
order by 1,2

-- Minimum Cases in a day till date

SELECT location,continent,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where continent is not null and new_cases = 
(select MIN(new_cases) from PortfoliProject.dbo.CovidDeaths$ where location not in ('World','High income','Upper middle income','Lower middle income')  
and continent is not null and new_cases != 0)
order by 1,2

-- Maximum Deaths in a day till date

SELECT location,continent,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_deaths = 
(select MAX(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where location not in  ('World','High income','Upper middle income','Lower middle income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
 and location not in  ('World','High income','Upper middle income','Lower middle income') order by 1,2

-- Minumum Deaths in a day till date

SELECT location,continent,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_deaths = 
(select MIN(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where 
new_deaths is not NULL and new_deaths !=0 and location not in  ('World','High income','Upper middle income','Lower middle income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
 and location not in  ('World','High income','Upper middle income','Lower middle income') order by 1,2






--INDIAN NUMBERS

--Total cases 
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfoliProject.dbo.CovidDeaths$
where new_cases is not null and continent is not null and location = 'India'


-- Everyday cases
Select location,date,SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
CASE SUM(new_cases)
	WHEN NULL THEN 0
	WHEN 0 THEN 0
	ELSE SUM(new_deaths)/SUM(New_Cases)*100
END as DeathPercentage
From PortfoliProject.dbo.CovidDeaths$
where location = 'India'
group by date,location
order by 1

-- Total cases Vs Total Deaths in India

SELECT location,date,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ where location = 'India' 
order by 1,2

-- Maximum Cases in a day in India till date

SELECT location,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ where new_cases = (select max(new_cases) from PortfoliProject.dbo.CovidDeaths$ where location = 'India' ) 
and location = 'India' order by 1,2

-- Minimum Cases in a day in India till date

SELECT location,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ where 
new_cases = (select min(new_cases) from PortfoliProject.dbo.CovidDeaths$ where location = 'India' and new_cases !=0) 
and location = 'India' order by 1,2

-- Maximum Deaths in a day in India till date

SELECT continent,location,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ where new_deaths = (select max(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where location = 'India' ) 
and location = 'India' order by 1,2

-- Minumum Deaths in a day in India till date

SELECT location,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ where 
new_deaths = (select min(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where location = 'India' and new_deaths is not null and new_deaths != 0) 
and location = 'India' order by 1,2


-- CONTINENT NUMBERS

-- Continents with Highest Infection  

Select location, MAX(total_cases) as HighestInfectedCount
From PortfoliProject.dbo.CovidDeaths$ 
where continent is  NULL and location not in ('World','High income','Upper middle income','Lower middle income','Low income','International')
Group by location
order by HighestInfectedCount desc 


-- Continents with Highest Death

Select location, MAX(total_deaths) as HighestDeathCount
From PortfoliProject.dbo.CovidDeaths$ 
where continent is  NULL and location not in ('World','High income','Upper middle income','Lower middle income','Low income','International')
Group by location
order by HighestDeathCount desc 


---- Minimum Cases in a day by continents till date

select location, max(new_cases) as Maximum_cases
From PortfoliProject.dbo.CovidDeaths$ 
where new_cases != 0 and continent is NULL and location not in ('World','High income','Upper middle income','Lower middle income','Low income','International')
group by location
order by Maximum_cases DESC

---- Maximum Cases in a day by continents till date


select location, max(new_cases) as Maximum_cases
From PortfoliProject.dbo.CovidDeaths$ 
where new_cases != 0 and continent is NULL and location not in ('World','High income','Upper middle income','Lower middle income','Low income','International')
group by location
order by Maximum_cases DESC




--VACCINATION AND TEST NUMBERS 




-- GLOBAL NUMBERS


select * from PortfoliProject.[dbo].[CovidVaccinations$] order by date


-- Total Tests done all over the world
select SUM(cast(new_tests as float)) from PortfoliProject.[dbo].[CovidVaccinations$]


-- Max. Positive rate in a day
select date, location,new_tests,continent, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where positive_rate = 
( 
select MAX(cast(positive_rate as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(positive_rate as float)!=0 and positive_rate is not null
)

--Min Positive rate in a day
select date, location,new_tests,continent, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where positive_rate = 
( 
select MIN(cast(positive_rate as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(positive_rate as float)!=0 and positive_rate is not null
)


-- Max. Vaccination in a day
select date, location,new_tests,continent, new_vaccinations,positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where new_vaccinations = 
( 
select MAX(cast(new_vaccinations as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(new_vaccinations as float)!=0 and new_vaccinations is not null and  continent is not null and 
location not in ('World','High income','Upper middle income','Lower middle income','Low income','International' )
)

--Min Vaccinations in a day
select date, location,new_tests,continent,new_vaccinations, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where new_vaccinations = 
( 
select MIN(cast(new_vaccinations as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(new_vaccinations as float)!=0 and new_vaccinations is not null and continent is not null and 
location not in ('World','High income','Upper middle income','Lower middle income','Low income','International')
)

-- Country with min vaccinations 
select location, sum(cast(new_vaccinations as float)) as Total_Vaccinations from PortfoliProject.[dbo].[CovidVaccinations$]
where continent is not null 
group by location
order by Total_Vaccinations

-- Country with max vaccinations 
select location, sum(cast(new_vaccinations as float)) as Total_Vaccinations from PortfoliProject.[dbo].[CovidVaccinations$]
where continent is not null 
group by location
order by Total_Vaccinations desc


-- Vaccination Vs Population
select vacc.location, sum(cast(vacc.new_vaccinations as float)) as Total_Vaccinations ,max(death.population) as population_,
( sum(cast(vacc.new_vaccinations as float))/max(death.population) )*100 as Vaccination_percentage
from  
PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.continent is not null 
group by vacc.location
order by Vaccination_percentage desc

-- Country with max fully vaccinated people
select location, max(cast(new_vaccinations as float)) as Total_Vaccinations from PortfoliProject.[dbo].[CovidVaccinations$]
where continent is not null 
group by location
order by Total_Vaccinations desc

-- Country with min fully vaccinated people
select location, max(cast(new_vaccinations as float)) as Total_Vaccinations from PortfoliProject.[dbo].[CovidVaccinations$]
where continent is not null 
group by location
order by Total_Vaccinations


-- Max Fully Vaccinated Vs Population
select vacc.location, max(cast(vacc.people_fully_vaccinated as float)) as Total_Fully_Vaccinated ,max(death.population) as population_,
( max(cast(vacc.people_fully_vaccinated as float))/max(death.population) )*100 as Fully_Vaccinated_percentage
from  
PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.continent is not null 
group by vacc.location
order by Fully_Vaccinated_percentage desc

-- Min Fully Vaccinated Vs Population
select vacc.location, max(cast(vacc.people_fully_vaccinated as float)) as Total_Fully_Vaccinated ,max(death.population) as population_,
( max(cast(vacc.people_fully_vaccinated as float))/max(death.population) )*100 as Fully_Vaccinated_percentage
from  
PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.continent is not null 
group by vacc.location
order by Fully_Vaccinated_percentage 

-- Death Count V/S life_expectancy

Select death.Location, MAX(death.population) as population ,MAX(death.Total_deaths) as TotalDeaths , 
((MAX(death.Total_deaths)/MAX(death.population))*100) as PercentPopulationDead , MAX(vacc.life_expectancy) as life_expectancy_
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
Where vacc.continent is not null 
Group by death.Location
order by PercentPopulationDead desc


-- Total Population vs Vaccinations

Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, 
CASE CAST(new_vaccinations AS float)
     WHEN NULL then NULL
     ELSE SUM(CONVERT(float,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) 
END as RollingPeopleVaccinated
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where death.continent is not null and new_vaccinations is not null
order by 2,3


-- Shows Percentage of Population that has recieved at least one Covid Vaccine
With TempPopVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, CASE CAST(new_vaccinations AS float)
     WHEN NULL then NULL
     ELSE SUM(CONVERT(float,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) 
END as RollingPeopleVaccinated
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where death.continent is not null and new_vaccinations is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as Rollingpercent
From TempPopVac


use PortfoliProject

--CREATE VIEW PercentPeopleVaccinated as 
--Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
--, 
--CASE CAST(new_vaccinations AS float)
--     WHEN NULL then NULL
--     ELSE SUM(CONVERT(float,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) 
--END as RollingPeopleVaccinated
--From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
--on
--death.location = vacc.location and death.date = vacc.date
--where death.continent is not null and new_vaccinations is not null

--select * from PercentPeopleVaccinated


-- INDIAN NUMBERS


select * from PortfoliProject.[dbo].[CovidVaccinations$] where location = 'India' order by date 


select count(*) from PortfoliProject.[dbo].[CovidVaccinations$] where location = 'India'  



-- Total Tests done in India
select SUM(cast(new_tests as float)) as Total_Cases_ from PortfoliProject.[dbo].[CovidVaccinations$] where location = 'India'


-- Max. Positive rate in a day in India
select date, location,new_tests,continent, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where location = 'India' and positive_rate = 
( 
select MAX(cast(positive_rate as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(positive_rate as float)!=0 and positive_rate is not null and location = 'India'
)

--Min Positive rate in a day in India
select date, location,new_tests,continent, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where location = 'India' and positive_rate = 
( 
select MIN(cast(positive_rate as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(positive_rate as float)!=0 and positive_rate is not null and location = 'India'
)


-- Max. Vaccination in a day in India
select date, location,new_tests,continent, new_vaccinations,positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where location = 'India' and new_vaccinations = 
( 
select MAX(cast(new_vaccinations as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(new_vaccinations as float)!=0 and new_vaccinations is not null and  continent is not null and 
location = 'India'
)

--Min Vaccinations in a day in India 
select date, location,new_tests,continent,new_vaccinations, positive_rate from PortfoliProject.[dbo].[CovidVaccinations$]
where location = 'India' and new_vaccinations = 
( 
select MIN(cast(new_vaccinations as float)) from PortfoliProject.[dbo].[CovidVaccinations$] 
where cast(new_vaccinations as float)!=0 and new_vaccinations is not null and continent is not null and 
location = 'India'
)




-- Vaccination Vs Population
select max(vacc.location) as Location, sum(cast(vacc.new_vaccinations as float)) as Total_Vaccinations ,max(death.population) as population_,
( sum(cast(vacc.new_vaccinations as float))/max(death.population) )*100 as Vaccination_percentage
from  
PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.continent is not null 
and vacc.location = 'India'
order by Vaccination_percentage desc


-- Death Count V/S life_expectancy

Select MAX(vacc.Location) as location , MAX(death.population) as population ,MAX(death.Total_deaths) as TotalDeaths , 
((MAX(death.Total_deaths)/MAX(death.population))*100) as PercentPopulationDead , MAX(vacc.life_expectancy) as life_expectancy_
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
Where vacc.continent is not null 
and death.location = 'India'
order by PercentPopulationDead desc


-- Shows Percentage of Population that has recieved at least one Covid Vaccine

With TempPopVacInd (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float,vacc.new_vaccinations)) OVER (order by death.date) as RollingPeopleVaccinated
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.location = 'India' and death.continent is not null and new_vaccinations is not null
)
select *, round((RollingPeopleVaccinated/Population)*100,2) as Rollingpercent from TempPopVacInd


use PortfoliProject


CREATE VIEW PercentPeopleVaccinatedInd as 
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float,vacc.new_vaccinations)) OVER (order by death.date) as RollingPeopleVaccinated
From PortfoliProject.dbo.CovidDeaths$ death join PortfoliProject.[dbo].[CovidVaccinations$] vacc
on
death.location = vacc.location and death.date = vacc.date
where vacc.location = 'India' and death.continent is not null and new_vaccinations is not null

select * from PercentPeopleVaccinatedInd


















