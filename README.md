# Proyecto de Data Cleaning - Layoffs Dataset

Este proyecto se centra en la limpieza y normalización del dataset de layoffs. El script SQL incluido realiza las siguientes tareas:

- **Creación de tablas de staging:** Se crean tablas temporales para trabajar sin modificar los datos originales.
- **Eliminación de duplicados:** Uso de CTE y la función `ROW_NUMBER()` para identificar y eliminar registros duplicados.
- **Estandarización de datos:** Se aplican funciones como `TRIM()` para normalizar textos y se actualizan valores inconsistentes (por ejemplo, transformar 'Crypto%' en 'Crypto').
- **Conversión de formatos de fecha:** Se utiliza `STR_TO_DATE()` para convertir cadenas a formato de fecha y se modifica el tipo de datos.
- **Manejo de valores nulos:** Se identifican y corrigen campos con valores nulos o vacíos.
- **Eliminación de columnas innecesarias:** Se remueven columnas que no aportan valor al análisis.

## Tecnologías utilizadas

- SQL (MySQL o MariaDB)

## Instrucciones de uso

1. Clona este repositorio en tu máquina local.
2. Abre el archivo `data_cleaning.sql` en tu entorno de base de datos.
3. Ejecuta el script paso a paso para observar cómo se limpian y transforman los datos.
4. Revisa el resultado final en la tabla `layoffs_staging2`.

## Contribuciones

Si deseas mejorar este proyecto o tienes sugerencias, siéntete libre de enviar un pull request o abrir un issue.

## Autor

**Zyodata**  
*Analista de Datos y Responsable de Administración*

## Licencia

Este proyecto se distribuye bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.
