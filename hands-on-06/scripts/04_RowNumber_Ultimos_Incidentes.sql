/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 04 — ROW_NUMBER() + PARTITION BY + COUNT() OVER(): Últimos Três Incidentes
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Três incidentes mais recentes por aplicação
;WITH CTE_IncidentesOrdenados AS
(
    SELECT a.AplicacaoId, a.Nome AS Aplicacao,
           i.IncidenteId, i.Titulo, i.Estado, i.DataAbertura,
           ROW_NUMBER() OVER
           (
               PARTITION BY i.AplicacaoId
               ORDER BY i.DataAbertura DESC, i.IncidenteId DESC
           ) AS Posicao,
           COUNT(*) OVER (PARTITION BY i.AplicacaoId)
               AS TotalIncidentesAplicacao
    FROM dbo.Incidente AS i
    INNER JOIN dbo.Aplicacao AS a ON i.AplicacaoId = a.AplicacaoId
)
SELECT AplicacaoId, Aplicacao, IncidenteId, Titulo, Estado,
       DataAbertura, Posicao, TotalIncidentesAplicacao
FROM CTE_IncidentesOrdenados
WHERE Posicao <= 3
ORDER BY AplicacaoId, Posicao;
GO

-- ETAPA 2 — Verificar posições, aplicações e totais por aplicação
;WITH CTE_IncidentesOrdenados AS
(
    SELECT i.AplicacaoId, i.IncidenteId,
           ROW_NUMBER() OVER
           (
               PARTITION BY i.AplicacaoId
               ORDER BY i.DataAbertura DESC, i.IncidenteId DESC
           ) AS Posicao,
           COUNT(*) OVER (PARTITION BY i.AplicacaoId)
               AS TotalIncidentesAplicacao
    FROM dbo.Incidente AS i
),
CTE_UltimosTres AS
(
    SELECT * FROM CTE_IncidentesOrdenados WHERE Posicao <= 3
)
SELECT COUNT(*) AS TotalLinhas,
       COUNT(DISTINCT AplicacaoId) AS AplicacoesRepresentadas,
       MIN(Posicao) AS PosicaoMinima,
       MAX(Posicao) AS PosicaoMaxima,
       MIN(TotalIncidentesAplicacao) AS MinIncidentesAplicacao,
       MAX(TotalIncidentesAplicacao) AS MaxIncidentesAplicacao
FROM CTE_UltimosTres;
GO
-- Validado no SSMS: 75 / 25 / 1 / 3 / 2000 / 2000.
-- Nota: foi observada demora na execução; desempenho não analisado.
