/*
SELECT * 
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3, 4

--SELECT * 
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3, 4
--SELECT DATA that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject. .CovidDeaths
ORDER BY 1, 2

--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in US
SELECT location, date, total_cases, total_deaths, (total_deaths /total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1, 2

SELECT location, date, total_cases, total_deaths, (total_deaths /total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE LOCATION like '%states%'
ORDER BY 1, 2

--Looking at total cases vs Population

SELECT location, date, population, total_cases, (total_cases /population)*100 AS 'Infection Rate', total_deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE LOCATION like '%states%'
ORDER BY 1, 2

--Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases /population))*100 AS 'PercentPopulationInfected'
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
GROUP BY location, population
ORDER BY 1, 2

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases /population))*100 AS 'PercentPopulationInfected', MAX(total_deaths) AS TotalDeaths
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
GROUP BY location, population
ORDER BY 1, 2, 3
--HIghest Infection from all locations will be shown and ordered by it
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases /population))*100 AS 'PercentPopulationInfected', MAX(total_deaths) AS TotalDeaths
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
GROUP BY location, population
ORDER BY 'PercentPopulationInfected' desc

--showing Countries with the highest death count per population and using NULL to remove continents while also using CAST()INT
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
GROUP BY location
ORDER BY TotalDeathCount desc
--Breaking down everything by continent
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
WHERE continent IS NULL 
GROUP BY location
ORDER BY TotalDeathCount desc
--WHERE continent IS NULL grouped by location to obtain more locations ex. world, high income, upper middle income, lower middle income
*/
-- Showing continents highest death cout per population
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
--WHERE LOCATION like '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc
-- Global NUMBERS using date to see new cases across globe per day
SELECT date, SUM(new_cases) AS NewCasesPerDay--, total_deaths, (total_deaths /total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2
-- SUM(CAST(new_deaths as int))/SUM(CAST(new_cases AS INT))*100 As NewdeathsToDeathRatio--(new_cases/new_deaths ) -- total_deaths, (total_deaths /total_cases)*100 AS DeathPercentage
SELECT date, SUM(CAST(new_cases AS INT)) AS NewCasesPerDay, SUM(CAST(new_deaths as int)) AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

SELECT date, SUM(CAST(new_cases AS INT)) AS NewCasesPerDay, SUM(CAST(new_deaths as int)) AS Deaths, SUM(CAST(new_deaths as int)*1))/(SUM(CAST(new_cases AS INT)*1))*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths as int)) AS Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like %states%
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2
-- generating the death percentage from the total cases and total deaths to generate death percentage
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths as int)) AS Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like %states%
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

-- joining the tables together Population vs Vaccinations
SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location)
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CAST( AS INT) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location)
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CONVERT(INT, ) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3
--Editing to increment/sum from each day that passes
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CONVERT(INT, ) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3
-- use CTE
--Creating CTE must always be ran together with intended actions
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date)
AS RollingPeopleVaccinated --The different colunms that will be used
--, (RollingPeopleVaccinted/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CONVERT(INT, ) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
)
--using the CTE to do further calculations
SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentageOfVaccinated
FROM PopvsVac

--TEMP TABLE using the same Joined table to, CREATE TABLE #TEMP  
--Use DROP to make wanted changes to TEMP TABLE
--DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,--same number from the JOIN Tables, 6 colunms 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date)
AS RollingPeopleVaccinated --The different colunms that will be used, 6 colunms
--, (RollingPeopleVaccinted/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CONVERT(INT, ) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentageOfVaccinated
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date)
AS RollingPeopleVaccinated --The different colunms that will be used, 6 colunms
--, (RollingPeopleVaccinted/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac--using CONVERT(INT, ) & bigint
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
SELECT *
FROM PercentPopulationVaccinated