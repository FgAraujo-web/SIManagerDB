/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 06 — CTE + SUM() OVER() + LAG() + LEAD(): Evolução Mensal
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Série mensal contínua, acumulado e comparação temporal
;WITH CTE_Limites AS
(
    SELECT DATEFROMPARTS(YEAR(MIN(DataAbertura)), MONTH(MIN(DataAbertura)), 1)
               AS PrimeiroMes,
           DATEFROMPARTS(YEAR(MAX(DataAbertura)), MONTH(MAX(DataAbertura)), 1)
               AS UltimoMes
    FROM dbo.Incidente
),
CTE_CalendarioMensal AS
(
    SELECT PrimeiroMes AS MesReferencia, UltimoMes
    FROM CTE_Limites WHERE PrimeiroMes IS NOT NULL
    UNION ALL
    SELECT DATEADD(MONTH, 1, MesReferencia), UltimoMes
    FROM CTE_CalendarioMensal
    WHERE MesReferencia < UltimoMes
),
CTE_IncidentesMensais AS
(
    SELECT DATEFROMPARTS(YEAR(DataAbertura), MONTH(DataAbertura), 1)
               AS MesReferencia,
           COUNT(*) AS TotalIncidentes
    FROM dbo.Incidente
    GROUP BY DATEFROMPARTS(YEAR(DataAbertura), MONTH(DataAbertura), 1)
),
CTE_SerieMensal AS
(
    SELECT c.MesReferencia,
           COALESCE(m.TotalIncidentes, 0) AS TotalIncidentes
    FROM CTE_CalendarioMensal AS c
    LEFT JOIN CTE_IncidentesMensais AS m
        ON c.MesReferencia = m.MesReferencia
),
CTE_AnaliseMensal AS
(
    SELECT MesReferencia, TotalIncidentes,
           SUM(TotalIncidentes) OVER
           (
               ORDER BY MesReferencia
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS TotalAcumulado,
           LAG(TotalIncidentes) OVER (ORDER BY MesReferencia)
               AS IncidentesMesAnterior,
           LEAD(TotalIncidentes) OVER (ORDER BY MesReferencia)
               AS IncidentesMesSeguinte
    FROM CTE_SerieMensal
)
SELECT YEAR(MesReferencia) AS Ano,
       MONTH(MesReferencia) AS Mes,
       MesReferencia, TotalIncidentes, TotalAcumulado,
       IncidentesMesAnterior,
       CASE WHEN IncidentesMesAnterior IS NULL THEN NULL
            ELSE TotalIncidentes - IncidentesMesAnterior
       END AS DiferencaMesAnterior,
       IncidentesMesSeguinte
FROM CTE_AnaliseMensal
ORDER BY MesReferencia
OPTION (MAXRECURSION 0);
GO

-- ETAPA 2 — Validação independente da série temporal e do acumulado
;WITH CTE_Limites AS
(
    SELECT DATEFROMPARTS(YEAR(MIN(DataAbertura)), MONTH(MIN(DataAbertura)), 1)
               AS PrimeiroMes,
           DATEFROMPARTS(YEAR(MAX(DataAbertura)), MONTH(MAX(DataAbertura)), 1)
               AS UltimoMes
    FROM dbo.Incidente
),
CTE_CalendarioMensal AS
(
    SELECT PrimeiroMes AS MesReferencia, UltimoMes
    FROM CTE_Limites WHERE PrimeiroMes IS NOT NULL
    UNION ALL
    SELECT DATEADD(MONTH, 1, MesReferencia), UltimoMes
    FROM CTE_CalendarioMensal
    WHERE MesReferencia < UltimoMes
),
CTE_IncidentesMensais AS
(
    SELECT DATEFROMPARTS(YEAR(DataAbertura), MONTH(DataAbertura), 1)
               AS MesReferencia,
           COUNT(*) AS TotalIncidentes
    FROM dbo.Incidente
    GROUP BY DATEFROMPARTS(YEAR(DataAbertura), MONTH(DataAbertura), 1)
),
CTE_SerieMensal AS
(
    SELECT c.MesReferencia,
           COALESCE(m.TotalIncidentes, 0) AS TotalIncidentes
    FROM CTE_CalendarioMensal AS c
    LEFT JOIN CTE_IncidentesMensais AS m
        ON c.MesReferencia = m.MesReferencia
),
CTE_Validacao AS
(
    SELECT MesReferencia, TotalIncidentes,
           SUM(TotalIncidentes) OVER
           (
               ORDER BY MesReferencia
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS TotalAcumulado
    FROM CTE_SerieMensal
)
SELECT MIN(MesReferencia) AS PrimeiroMes,
       MAX(MesReferencia) AS UltimoMes,
       COUNT(*) AS TotalMeses,
       SUM(TotalIncidentes) AS TotalIncidentesSerie,
       (SELECT COUNT(*) FROM dbo.Incidente) AS TotalIncidentesBD,
       MAX(TotalAcumulado) AS AcumuladoFinal,
       SUM(CASE WHEN TotalIncidentes = 0 THEN 1 ELSE 0 END)
           AS MesesSemIncidentes
FROM CTE_Validacao
OPTION (MAXRECURSION 0);
GO
-- Validado no SSMS: 2023-01-01 / 2025-09-01 / 33 /
-- 50000 / 50000 / 50000 / 0.
-- Nota: a inclusão de meses vazios está implementada, mas não foi
-- demonstrada com um mês vazio nos dados atuais.
