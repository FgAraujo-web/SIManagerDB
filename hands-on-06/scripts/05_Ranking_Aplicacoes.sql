/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 05 — RANK() + DENSE_RANK(): Ranking de Aplicações
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Ranking com os dados reais da SIManagerDB
;WITH CTE_IncidentesPorAplicacao AS
(
    SELECT a.AplicacaoId, a.Nome AS Aplicacao, a.Criticidade,
           COUNT(i.IncidenteId) AS TotalIncidentes
    FROM dbo.Aplicacao AS a
    LEFT JOIN dbo.Incidente AS i ON a.AplicacaoId = i.AplicacaoId
    GROUP BY a.AplicacaoId, a.Nome, a.Criticidade
),
CTE_RankingAplicacoes AS
(
    SELECT AplicacaoId, Aplicacao, Criticidade, TotalIncidentes,
           RANK() OVER (ORDER BY TotalIncidentes DESC) AS PosicaoRank,
           DENSE_RANK() OVER (ORDER BY TotalIncidentes DESC)
               AS PosicaoDenseRank
    FROM CTE_IncidentesPorAplicacao
)
SELECT AplicacaoId, Aplicacao, Criticidade, TotalIncidentes,
       PosicaoRank, PosicaoDenseRank
FROM CTE_RankingAplicacoes
ORDER BY PosicaoRank, AplicacaoId;
GO
-- Validado: 25 aplicações com 2000 incidentes; ambas as posições = 1.

-- ETAPA 2 — Demonstração dos empates sem modificar a base de dados
;WITH CTE_DadosExemplo AS
(
    SELECT Aplicacao, TotalIncidentes
    FROM (VALUES
        ('Aplicacao A', 2500),
        ('Aplicacao B', 2000),
        ('Aplicacao C', 2000),
        ('Aplicacao D', 1500),
        ('Aplicacao E', 1000)
    ) AS Dados(Aplicacao, TotalIncidentes)
)
SELECT Aplicacao, TotalIncidentes,
       RANK() OVER (ORDER BY TotalIncidentes DESC) AS PosicaoRank,
       DENSE_RANK() OVER (ORDER BY TotalIncidentes DESC)
           AS PosicaoDenseRank
FROM CTE_DadosExemplo
ORDER BY TotalIncidentes DESC, Aplicacao;
GO
-- Validado no SSMS: RANK = 1,2,2,4,5; DENSE_RANK = 1,2,2,3,4.
