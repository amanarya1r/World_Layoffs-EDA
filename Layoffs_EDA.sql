-- =============================================== --
-- World Layoffs - Exploratory Data Analysis
-- =============================================== --
-- To get the data table use: /data/Layoffs_Data_Cleaning.sql
-- ----------------------------------------------- -- 

USE world_layoffs;

SELECT * 
FROM layoffs_staging;

-- Max employees laid off in a day:
-- =============================================== --
SELECT MAX(total_laid_off)-- 
FROM world_layoffs.layoffs_staging;

-- Max percentage and employees laid off in a day:
-- =============================================== --
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;

-- Companies which laid off all employees:
-- =============================================== --
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1;

-- Total number of companies which laid of all the employees:
-- =============================================== -- 
SELECT COUNT(DISTINCT company) AS total_companies_laid_off
FROM layoffs_staging
WHERE percentage_laid_off = 1;

-- Total number of companies which laid of all the employees in descending order:
-- =============================================== -- 
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Highest funding raised by companies with a complete layoff:
-- =============================================== -- 
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Sum of total laid off by a each company(only in two table):
-- =============================================== --
SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

-- Date from which layoffs started to last date at which layoffs recorded:
-- =============================================== --
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging;

-- Industries that are laid off the highest:
-- =============================================== --
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry 
ORDER BY 2 DESC;

-- Countries with the most layoffs:
-- =============================================== --
SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country 
ORDER BY 2 DESC;

-- Years with the highest layoffs:
-- =============================================== --
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Stage at which companies laid off:
-- =============================================== --
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY stage
ORDER BY stage DESC;

-- Layoffs on the basis of months:
-- =============================================== --
SELECT SUBSTRING(`date`,6,2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY `MONTH`;

-- Layoffs on the basis of YY-MM
-- =============================================== --
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Rolling sum of layoffs on the basis of YY-MM:
-- =============================================== --
WITH Rolling_Total AS
(
	SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
	FROM layoffs_staging
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `MONTH`
	ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

