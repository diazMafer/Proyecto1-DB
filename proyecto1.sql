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

 /*
    PREGUNTA 2
 */

SELECT unique_carriers.Description as aerolinea, COUNT(DISTINCT DestStateNm) as cantidad_estados
FROM ontime
INNER JOIN unique_carriers ON IATA_CODE_Reporting_Airline = code
GROUP BY IATA_CODE_Reporting_Airline
ORDER BY COUNT(DISTINCT DestStateNm) DESC

 /*
    PREGUNTA 3
 */

SELECT DISTINCT unique_carriers.Description as aerolinea, SUM(CASE WHEN "Year"="2017" THEN 1 ELSE 0 END) as "CantidadVuelos2017", SUM(CASE WHEN "Year"="2018" THEN 1 ELSE 0 END) as "CantidadVuelos2018"
FROM ontime
INNER JOIN unique_carriers ON unique_carriers.Code = ontime.Reporting_Airline
WHERE DepDelay = 0 and ArrDelay < 0 
GROUP BY Reporting_Airline
ORDER BY ("2017"+"2018") DESC

 /*
    PREGUNTA 4
 */

SELECT (SUM(CarrierDelay)*1.0*100)/(RetrasosAerolineas) as PorcentajeRetraso, U.Description
FROM ontime, 
(
    SELECT SUM(CarrierDelay) as RetrasosAerolineas 
    FROM ontime 
    WHERE CarrierDelay >0
)
JOIN unique_carriers U ON U.code = ontime.Reporting_Airline
WHERE CarrierDelay >0
GROUP BY Reporting_Airline 
ORDER BY PorcentajeRetraso ASC

/*
    PREGUNTA 5

    a esta todavia me falta unir los quarters para que salga solo un dato (frecuencia)
 */

SELECT
    Reporting_Airline,
    SUM(CASE WHEN Cancelled = 1 AND CancellationCode = 'A' THEN 1 ELSE 0 END) AS Cancelado,
    (SUM(CASE WHEN Quarter = 1 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 2 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 3 THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Quarter = 4 THEN 1 ELSE 0 END))/4 as CantVuelosPorCuarto
FROM ontime ontime_externo
GROUP BY Reporting_Airline
ORDER BY Cancelado ASC;


/*
    PREGUNTA 6
 */
 
SELECT Reporting_Airline as Aerolinea, (SUM(Distance)/COUNT(*)) as Razon
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
    ((SUM(CASE WHEN Quarter = 4 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN Quarter = 3 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END))*1.0/SUM(CASE WHEN Quarter = 3 AND "Year" = '2018' NOT NULL THEN 1 ELSE 0 END)))/7)*100 as CrecimientoPromedio
FROM ontime ontime_externo
GROUP BY Reporting_Airline
ORDER BY CrecimientoPromedio DESC


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
ORDER BY RetrasosAerolineas ASC
 /*
    PREGUNTA 10
 */

SELECT Reporting_Airline as Aerolineas,
SUM(CASE WHEN DistanceGroup = 1 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion1,
SUM(CASE WHEN DistanceGroup = 2 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion2,
SUM(CASE WHEN DistanceGroup = 3 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion3,
SUM(CASE WHEN DistanceGroup = 4 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion4,
SUM(CASE WHEN DistanceGroup = 5 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion5,
SUM(CASE WHEN DistanceGroup = 6 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion6,
SUM(CASE WHEN DistanceGroup = 7 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion7,
SUM(CASE WHEN DistanceGroup = 8 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion8,
SUM(CASE WHEN DistanceGroup = 9 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion9,
SUM(CASE WHEN DistanceGroup = 10 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion10,
SUM(CASE WHEN DistanceGroup = 11 THEN AirTime ELSE 0 END) as TiempoEnAireClasificacion11
FROM ontime
GROUP BY Reporting_Airline
ORDER BY (TiempoEnAireClasificacion1 + TiempoEnAireClasificacion2 + TiempoEnAireClasificacion3 +
TiempoEnAireClasificacion4 + TiempoEnAireClasificacion5 + TiempoEnAireClasificacion6 +
TiempoEnAireClasificacion7 + TiempoEnAireClasificacion8 + TiempoEnAireClasificacion9 +
TiempoEnAireClasificacion10 + TiempoEnAireClasificacion11) ASC


/* Query anterior dividido en tablas distintas, para mayor orden y facilidad para pasar a html */

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =1
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =2
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =3
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =4
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =5
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =6
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =7
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =8
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =9
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC

SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =10
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC
SELECT Reporting_Airline as Aerolineas, SUM(AirTime) as TiempoEnAire, DistanceGroup
FROM ontime
WHERE DistanceGroup =11
GROUP BY Reporting_Airline
ORDER BY TiempoEnAire ASC