
--Select and view data needed

Select continent, location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 3,4

--Total cases vs total deaths (percentage of dying due to covid)
/*
Select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/population)*100 as Deathpercentage
From PortfolioProject..CovidDeaths$
order by 1,2*/

--Death percentage for united states
/*
Select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/population)*100 as Deathpercentage
From PortfolioProject..CovidDeaths$
Where location like '%states'
order by 1,2*/

--looking at total cases vs population (percentage) united states InfectionRates
/*
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where location like '%states'
order by 1,2*/

--contrys with the highest infection rate compared to population
/*
Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
group by location, population
order by PercentPopulationInfected desc*/

--country with the highest death count per population
--total_deaths is nvarchar remeber to cast
/*
Select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not NULL
group by location
order by TotalDeathCount desc*/

--continent with the highest death count per population
--total_Deaths is nvarchar remeber to cast
/*
Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not NULL
group by continent
order by TotalDeathCount desc*/

--Global numbers by date
/*
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/ SUM(new_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not NULL
group by date
order by 1,2*/

--Global numbers in Total
/*
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/ SUM(new_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not NULL
order by 1,2*/

-- COVID VACCINATIONS
--Select * from PortfolioProject..CovidVaccinations$

--Looking at total population vs vaccinations
/*
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
from PortfolioProject..CovidDeaths$ as deaths
Join PortfolioProject..CovidVaccinations$ as vacs
on deaths.location = vacs.location
AND deaths.date = vacs.date
where deaths.continent is not NULL
order by 2,3 */

--Looking at total population vs vaccinations
--Looking at total amount of vaccinations by location
/*
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) OVER (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ as deaths
Join PortfolioProject..CovidVaccinations$ as vacs
on deaths.location = vacs.location
AND deaths.date = vacs.date
where deaths.continent is not NULL
order by 2,3;*/

--CTE Population vs Vaccinations
/*
With PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as (
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) OVER (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ as deaths
Join PortfolioProject..CovidVaccinations$ as vacs
on deaths.location = vacs.location
AND deaths.date = vacs.date
where deaths.continent is not NULL
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 from PopVsVac
order by 2,3*/

--TEMPT TABLE
/*
Drop table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated(
Continent nvarchar(255), location nvarchar(255), date datetime, 
population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) OVER (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ as deaths
Join PortfolioProject..CovidVaccinations$ as vacs
on deaths.location = vacs.location
AND deaths.date = vacs.date
where deaths.continent is not NULL

Select *, (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated
order by 2,3*/

--Creating view to store data for later visualizations
/*
Create View PercentPopulationVaccinated as 
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) OVER (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ as deaths
Join PortfolioProject..CovidVaccinations$ as vacs
on deaths.location = vacs.location
AND deaths.date = vacs.date
where deaths.continent is not NULL

Select * from PercentPopulationVaccinated*/