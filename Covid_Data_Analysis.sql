Select count(total_cases) 

from PortfolioProject..CovidDeaths

select * 
from PortfolioProject..CovidDeaths

-- Looking at Total Cases Vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percentage_of_Death
from PortfolioProject..CovidDeaths
where location like '%India%'
Order By 1,2

-- Looking at Total Cases Vs Population

select location, date, total_cases, population, (total_cases/population)*100 as Cases_per_Population
from PortfolioProject..CovidDeaths
where location like '%India%'
Order By 1,2


-- Looking at Highest number of cases compared to population

select location, max(total_cases) as Highest_Infection_count, population, max((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject..CovidDeaths
group by location, population
--where location like '%India%'
Order By Percent_Population_Infected desc

-- Showing countries with highest death counts per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
--where location like '%India%'
Order By TotalDeathCount desc

-- Showing continent with highest death counts per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
--where location like '%India%'
Order By TotalDeathCount desc


-- Global Numbers
select date, sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as Total_deaths, sum(CAST(new_deaths as int))/sum(new_cases) * 100 as Total_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2
--where location like '%India%'

-- Total Global Cases

select sum(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as Total_deaths, sum(CAST(new_deaths as int))/sum(new_cases) * 100 as Total_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2
--where location like '%India%'

--Looking at Total Vaccination vs Population

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
order by 2,3


-- USE CTE
with PopvsVac (continent,location,date, population,new_vaccination,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
)
select *,(RollingPeopleVaccinated/Population)*100 as People_Vaccinated_Percentage
from PopvsVac

-- Temp Table
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null

select *,(RollingPeopleVaccinated/Population)*100 as People_Vaccinated_Percentage
from #PercentPopulationVaccinated



-- Creating Views
go
CREATE VIEW PercentPopulationVaccinated2 as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null

select * from PercentPopulationVaccinated2