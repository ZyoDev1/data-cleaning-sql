-- Obtener todos los datos de la tabla layoffs_staging2
SELECT * FROM world_layoffs.layoffs_staging2;

-- Obtener el máximo número de despidos y el mayor porcentaje de despidos
SELECT MAX(total_laid_off) AS max_despidos, MAX(percentage_laid_off) AS max_porcentaje_despidos
FROM world_layoffs.layoffs_staging2;

-- Empresas que han despedido al 100% de su personal, ordenadas por fondos recaudados
SELECT * FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Sumar el total de despidos por empresa, ordenando por la cantidad total de despidos
SELECT company, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_despidos DESC;

-- Obtener la fecha mínima y máxima en los datos
SELECT MIN(date) AS fecha_min, MAX(date) AS fecha_max
FROM world_layoffs.layoffs_staging2;

-- Sumar el total de despidos por industria, ordenando por la cantidad total de despidos
SELECT industry, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_despidos DESC;

-- Sumar el total de despidos por país, ordenando por la cantidad total de despidos
SELECT country, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_despidos DESC;

-- Total de despidos por año
SELECT YEAR(date) AS ano, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY ano DESC;

-- Total de despidos por etapa de financiamiento
SELECT stage, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_despidos DESC;

-- Promedio de porcentaje de despidos por empresa
SELECT company, AVG(percentage_laid_off) AS promedio_porcentaje_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY promedio_porcentaje_despidos DESC;

-- Total de despidos por mes
SELECT SUBSTRING(date, 1, 7) AS mes, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY mes
ORDER BY mes ASC;

-- Cálculo de la suma acumulativa de despidos por mes
WITH rolling_total AS (
    SELECT SUBSTRING(date, 1, 7) AS mes, SUM(total_laid_off) AS total_off
    FROM world_layoffs.layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY mes
    ORDER BY mes ASC
)
SELECT mes, total_off, SUM(total_off) OVER(ORDER BY mes) AS rolling_total
FROM rolling_total;

-- Total de despidos por empresa y año
SELECT company, YEAR(date) AS ano, SUM(total_laid_off) AS total_despidos
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY company ASC;

-- Empresas con más despidos por año
WITH company_Year AS (
    SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_despidos
    FROM world_layoffs.layoffs_staging2
    GROUP BY company, YEAR(date)
), company_Year_Rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_despidos DESC) AS ranking
    FROM company_Year
    WHERE years IS NOT NULL
)
SELECT * FROM company_Year_Rank
WHERE ranking <= 5;









