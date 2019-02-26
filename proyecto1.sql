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
LIMIT 5;

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

SELECT
    Reporting_Airline,
    ((((SUM(CASE WHEN Quarter = 2 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 1 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 1 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END)) + 
    ((SUM(CASE WHEN Quarter = 3 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 2 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 2 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END)) +
    ((SUM(CASE WHEN Quarter = 4 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 3 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 3 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END)) + 
    ((SUM(CASE WHEN Quarter = 1 and "Year" = '2018' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 4 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 4 and "Year" = '2017' NOT NULL THEN 1 ELSE 0 END)) +
    ((SUM(CASE WHEN Quarter = 2 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 1 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 1 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END)) +
    ((SUM(CASE WHEN Quarter = 3 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 2 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 2 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END)) +
    ((SUM(CASE WHEN Quarter = 4 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 3 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 3 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END)))/4)*100 as CrecimientoPromedio
FROM ontime ontime_externo
GROUP BY Reporting_Airline
ORDER BY CrecimientoPromedio DESC;


/*
    PREGUNTA 8
 */

SELECT Reporting_Airline, COUNT(DISTINCT origen) as estados
FROM ontime o
JOIN (
    SELECT COUNT(DISTINCT DestAirportID) as CantAeropuertos, OriginStateNm as origen
    FROM ontime
    GROUP BY OriginStateNm
    ORDER BY CantAeropuertos DESC
    LIMIT 10
) tabla ON o.DestStateNm = tabla.origen
GROUP BY Reporting_Airline
ORDER BY estados DESC

/*
    PREGUNTA 9
 */

SELECT Reporting_Airline, RetrasosAerolineas, SUM(Distance)/(SUM(AirTime)/60) as Velocidad
FROM ontime
JOIN (
    SELECT SUM(arrDelay) as RetrasosAerolineas, Reporting_Airline as aero
    FROM ontime 
    WHERE arrDelay>0
    GROUP BY Reporting_Airline
    ORDER BY RetrasosAerolineas ASC
) Delays ON ontime.Reporting_Airline = Delays.aero
GROUP BY Reporting_Airline
ORDER BY Velocidad DESC
 /*
    PREGUNTA 10
 */

SELECT Reporting_Airline, Clasificacion, TiempoEnAire
FROM ontime
JOIN (
    SELECT SUM(AirTime) as TiempoEnAire, DistanceGroup as Clasificacion
    FROM ontime 
    GROUP BY DistanceGroup
    ORDER BY TiempoEnAire ASC
) TiemposAire ON ontime.DistanceGroup = TiemposAire.Clasificacion
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire, DistanceGroup ASC