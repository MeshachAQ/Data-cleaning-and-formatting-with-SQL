--SELECT * FROM CovidDeaths$

--SELECT * FROM CovidVaccination

--select * from CovidDeaths$ order by 3,4

--select * from CovidVaccination order by 3,4

--We are about to select only the data we will be using

----Select continent, location, date, population, total_cases, new_cases,total_deaths FROM CovidDeaths$ order by 2,3

--Question 1. Find total cases vs total deaths IN dESCENDING ORDER based on percentage_total_deaths_total_cases as at April 2021

--ANSWER:
Select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as percentage_total_deaths_total_cases
FROM CovidDeaths$ WHERE continent IS NOT NULL order by percentage_total_deaths_total_cases DESC




--Question 2; Find percentage of total cases vs total deaths IN Ghana As at April 2021

--ANSWER;
Select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as percentage_Death
FROM CovidDeaths$ WHERE location LIKE '%Ghana%' order by 2,3



--Question 3; Find percentage of the total cases vs population of people that contracted the virus as at April 2021

--ANSWER;
Select continent, location, date, total_cases, population, (total_cases/population) * 100 as Total_Case_per_population
FROM CovidDeaths$ WHERE continent IS NOT NULL order by 2,3


--Question 4; Countries with highest infection rate compared to population

--ANSWER;

Select location, population, MAX(total_cases) as highestinfectioncountries, MAX((total_cases/population)) * 100 as percentage_of_highestinfected_countries
FROM CovidDeaths$ WHERE continent IS NOT NULL group by location, population order by highestinfectioncountries DESC


--QUESTION 5; Countries with the highest date rate per population

--ANSWER;
Select Location, MAX(total_deaths) as highest_deathrate_countries, MAX(cast(total_deaths as int)) as total_death_Count
FROM CovidDeaths$ WHERE continent IS NOT NULL
Group by location
order by total_death_Count DESC


--WE CAN ALSO LOOK AT THE ABOVE QUESTION GROUPED BY ONLY CONTINENT. SEE BELOW
Select location, MAX(cast(total_deaths as int)) as total_death_Count
FROM CovidDeaths$ WHERE continent IS NULL
Group by location
order by total_death_Count DESC




Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as percentage_Death
FROM CovidDeaths$ WHERE continent IS NOT NULL order by 1,2

--So how about looking at this data globally by new cases, death and death percentage BY DATE

 --ANSWER;
 Select date, SUM(total_cases) total_case_global, SUM(CAST(total_deaths as int)) total_deaths_global, SUM(cast(total_deaths as int)/total_cases) * 100 as death_percentage_global
FROM CovidDeaths$ WHERE continent IS NOT NULL 
Group by date
order by 1,2

--Hence if we are finding the data at once without dates, we can do this below

Select SUM(total_cases) total_case_global, SUM(CAST(total_deaths as int)) total_deaths_global, SUM(cast(total_deaths as int)/total_cases) * 100 as death_percentage_global
FROM CovidDeaths$ WHERE continent IS NOT NULL 




--Now let us talk a little about covid vaccination

select * from CovidVaccination

select * from CovidDeaths$
Now we want to join both tables, so...yh

Select * from CovidDeaths$ JOIN
CovidVaccination ON CovidDeaths$.location = CovidVaccination.location



Assuming we want to create a visualization using one of the queries above,

Create view COVIDVISUALIZATION as
Select date, SUM(total_cases) total_case_global, SUM(CAST(total_deaths as int)) total_deaths_global, SUM(cast(total_deaths as int)/total_cases) * 100 as death_percentage_global
FROM CovidDeaths$ WHERE continent IS NOT NULL 
Group by date
--order by 1,2

--We can the go and derive this from views under project_portfolio database








