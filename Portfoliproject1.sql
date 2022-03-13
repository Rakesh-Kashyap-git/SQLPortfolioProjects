SELECT * 
FROM PortfoliProject.dbo.CovidDeaths$


--SELECT * 
--FROM PortfoliProject.dbo.CovidVaccinations$
--order by 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population 
FROM PortfoliProject.dbo.CovidDeaths$ 
order by 1,2

-- Total Cases Vs Total Deaths

SELECT location,date,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
order by 1,2

--INDIAN NUMBERS

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





--GLOBAL NUMBERS

-- Total cases Vs Population

Select Location, date, Population, total_cases,round((total_cases/population)*100,2) as PercentPopulationInfected
From PortfoliProject.dbo.CovidDeaths$
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectedCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfoliProject.dbo.CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfoliProject.dbo.CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Maximum Cases in a day till date

SELECT location,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_cases = 
(select MAX(new_cases) from PortfoliProject.dbo.CovidDeaths$ where location not in  ('World','High income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
order by 1,2

-- Minimum Cases in a day till date

SELECT location,date,new_cases,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_cases = 
(select MIN(new_cases) from PortfoliProject.dbo.CovidDeaths$ where new_cases != 0 and location not in  ('World','High income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
order by 1,2

-- Maximum Deaths in a day till date

SELECT location,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_deaths = 
(select MAX(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where location not in  ('World','High income','Upper middle income','Lower middle income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
 and location not in  ('World','High income','Upper middle income','Lower middle income') order by 1,2

-- Minumum Deaths in a day till date

SELECT location,date,new_deaths,total_cases,total_deaths, round((total_deaths/total_cases)*100,2)  as DeathPercentange 
FROM PortfoliProject.dbo.CovidDeaths$ 
where new_deaths = 
(select MIN(new_deaths) from PortfoliProject.dbo.CovidDeaths$ where 
new_deaths is not NULL and new_deaths !=0 and location not in  ('World','High income','Upper middle income','Lower middle income') and 
location not in (select distinct(continent) from PortfoliProject.dbo.CovidDeaths$ where continent is not NULL))
 and location not in  ('World','High income','Upper middle income','Lower middle income') order by 1,2






