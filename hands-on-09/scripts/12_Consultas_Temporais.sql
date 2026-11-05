-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
-- Instantes de referência são UTC e correspondem à execução original documentada.
-- Para nova execução, substitua pelos valores ValidoDesde/ValidoAte do seu histórico.
SELECT IncidenteId,Titulo,Estado,Prioridade,ValidoDesde,ValidoAte
FROM dbo.H09_IncidenteTemporal FOR SYSTEM_TIME AS OF '2026-11-05T16:28:30'
WHERE IncidenteId=1;
GO
SELECT IncidenteId,Titulo,Estado,Prioridade,ValidoDesde,ValidoAte
FROM dbo.H09_IncidenteTemporal
FOR SYSTEM_TIME BETWEEN '2026-11-05T16:28:04.6000000' AND '2026-11-05T16:28:30.0000000'
WHERE IncidenteId=1 ORDER BY ValidoDesde;
GO
SELECT ROW_NUMBER() OVER (PARTITION BY IncidenteId ORDER BY ValidoDesde) AS NumeroVersao,
 IncidenteId,Titulo,Estado,Prioridade,ValidoDesde,ValidoAte,
 CASE WHEN ValidoAte='9999-12-31T23:59:59.9999999' THEN 'ATUAL' ELSE 'HISTORICO' END AS TipoVersao
FROM dbo.H09_IncidenteTemporal FOR SYSTEM_TIME ALL
WHERE IncidenteId=1 ORDER BY ValidoDesde;
GO
