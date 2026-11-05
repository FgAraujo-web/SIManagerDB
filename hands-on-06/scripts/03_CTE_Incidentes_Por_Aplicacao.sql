/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 03 — CTE + GROUP BY: Indicadores de Incidentes por Aplicação
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Agregar por aplicação, incluindo aplicações sem incidentes
;WITH CTE_IncidentesPorAplicacao AS
(
    SELECT a.AplicacaoId, a.Nome AS Aplicacao, a.Criticidade,
           COUNT(i.IncidenteId) AS TotalIncidentes
    FROM dbo.Aplicacao AS a
    LEFT JOIN dbo.Incidente AS i ON a.AplicacaoId = i.AplicacaoId
    GROUP BY a.AplicacaoId, a.Nome, a.Criticidade
)
SELECT AplicacaoId, Aplicacao, Criticidade, TotalIncidentes
FROM CTE_IncidentesPorAplicacao
ORDER BY TotalIncidentes DESC, AplicacaoId ASC;
GO

-- ETAPA 2 — Reconciliação dos totais da CTE com as tabelas de origem
;WITH CTE_IncidentesPorAplicacao AS
(
    SELECT a.AplicacaoId, COUNT(i.IncidenteId) AS TotalIncidentes
    FROM dbo.Aplicacao AS a
    LEFT JOIN dbo.Incidente AS i ON a.AplicacaoId = i.AplicacaoId
    GROUP BY a.AplicacaoId
)
SELECT
    (SELECT COUNT(*) FROM dbo.Aplicacao) AS TotalAplicacoes,
    COUNT(*) AS AplicacoesNaCTE,
    (SELECT COUNT(*) FROM dbo.Incidente) AS TotalIncidentesBD,
    SUM(TotalIncidentes) AS TotalIncidentesCTE,
    SUM(CASE WHEN TotalIncidentes = 0 THEN 1 ELSE 0 END)
        AS AplicacoesSemIncidentes
FROM CTE_IncidentesPorAplicacao;
GO
-- Validado no SSMS: 25 / 25 / 50000 / 50000 / 0.
