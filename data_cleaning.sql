-- DATA CLEANING PROJECT: LAYOFFS DATASET
-- Autor: [Jorge Sebastian]
-- Este script limpia y estandariza los datos del dataset 'layoffs', abordando la eliminación de duplicados, la normalización de valores y el tratamiento de valores nulos.

-- 1. CREAR UNA TABLA DE TRABAJO (STAGING TABLE) PARA NO MODIFICAR LOS DATOS ORIGINALES
CREATE TABLE layoffs_staging LIKE layoffs;

-- Copiamos los datos originales a la tabla staging
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- 2. ELIMINAR DUPLICADOS USANDO CTE Y ROW_NUMBER()
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions 
               ORDER BY company
           ) AS ROW_NUM
    FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE employee_id IN (
    SELECT employee_id FROM duplicate_cte WHERE ROW_NUM > 1
);

-- 3. CREAR UNA SEGUNDA TABLA STAGING PARA NORMALIZAR MEJOR LOS DATOS
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    ROW_NUM INT
);

-- Copiamos los datos limpios en la nueva tabla staging
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions 
    ORDER BY company
) AS ROW_NUM
FROM layoffs_staging;

-- Eliminamos duplicados en la nueva tabla
DELETE FROM layoffs_staging2 WHERE ROW_NUM > 1;

-- 4. ESTANDARIZACIÓN DE DATOS (TRIM Y NORMALIZACIÓN DE TEXTO)
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Normalizar nombres de industria (Ejemplo: 'Crypto%' -> 'Crypto')
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';

-- Normalizar país (Ejemplo: 'United States%' -> 'United States')
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';

-- 5. CONVERTIR FORMATO DE FECHA
UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

-- 6. TRATAMIENTO DE VALORES NULOS Y VACÍOS
-- Rellenar industria basándonos en compañías repetidas
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Eliminar registros sin información relevante
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- 7. ELIMINAR COLUMNAS INNECESARIAS
ALTER TABLE layoffs_staging2 DROP COLUMN ROW_NUM;

-- FIN DEL PROCESO DE LIMPIEZA