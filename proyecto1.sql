 /*
    PREGUNTA 1
 */

SELECT (COUNT(*)*1.0*100)/Cancelados as Porcentaje, Reporting_Airline
FROM ontime, 
(
    SELECT COUNT(*) as Cancelados
    FROM ontime
    WHERE Cancelled = 1 and CancellationCode = "A"
)
WHERE Cancelled = 1 and CancellationCode = "A"
GROUP BY Reporting_Airline
ORDER BY Porcentaje ASC
LIMIT 5;

 /*
    PREGUNTA 2
 */

SELECT unique_carriers.Description as aerolinea, COUNT(DISTINCT DestStateNm) as cantidad_estados
FROM ontime
INNER JOIN unique_carriers ON IATA_CODE_Reporting_Airline = code
GROUP BY IATA_CODE_Reporting_Airline
ORDER BY COUNT(DISTINCT DestStateNm) DESC
LIMIT 5;

 /*
    PREGUNTA 3
 */

SELECT DISTINCT unique_carriers.Description as aerolinea, COUNT(*) as cant_vuelos
FROM ontime
INNER JOIN unique_carriers ON unique_carriers.Code = ontime.IATA_CODE_Reporting_Airline
WHERE DepDelay = 0 and ArrDelay < 0
GROUP BY IATA_CODE_Reporting_Airline
ORDER BY COUNT(DISTINCT Flight_Number_Reporting_Airline) DESC
LIMIT 5;

 /*
    PREGUNTA 4
 */

SELECT (RetrasosAerolineas*1.0*100)/SUM(arrDelay) as PorcentajeRetraso, U.Description
FROM ontime, 
(
    SELECT SUM(arrDelay) as RetrasosAerolineas 
    FROM ontime 
    WHERE arrDelay>0
    GROUP BY Reporting_Airline
)
JOIN unique_carriers U ON U.code = ontime.Reporting_Airline
WHERE arrDelay>0
GROUP BY Reporting_Airline 
ORDER BY PorcentajeRetraso ASC

/*
    PREGUNTA 5

    a esta todavia me falta unir los quarters para que salga solo un dato (frecuencia)
 */

 SELECT
    Reporting_Airline,
    SUM(CASE WHEN arrDelay > 0 THEN arrDelay ELSE 0 END) AS sumaCondicionada,
    SUM(CASE WHEN Cancelled = 1 AND CancellationCode = 'A' THEN 1 ELSE 0 END) AS Cancelado,
    (SUM(CASE WHEN Quarter = 1 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 2 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 3 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 4 THEN 1 ELSE 0 END))/4 as CantVuelosPorCuarto
FROM ontime ontime_externo
GROUP BY Reporting_Airline
ORDER BY sumaCondicionada ASC, Cancelado ASC;


/*
    PREGUNTA 6
 */
 
SELECT(SUM(Distance)/COUNT(*)) as Razon, Reporting_Airline
FROM ontime
GROUP BY Reporting_Airline
ORDER BY Razon ASC

/*
    PREGUNTA 7
 */



/*
    PREGUNTA 8
 */