USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 07 — Otimização com GROUP BY + JOIN

Objetivo:
Substituir COUNT(*) OVER() por uma agregação
independente, preservando os resultados.
*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

;WITH CTE_Totais AS
(
    SELECT
        AplicacaoId,
        COUNT(*) AS TotalIncidentesAplicacao
    FROM dbo.Incidente
    GROUP BY AplicacaoId
),
CTE_IncidentesOrdenados AS
(
    SELECT
        i.AplicacaoId,
        i.IncidenteId,
        i.DataAbertura,
        ROW_NUMBER() OVER
        (
            PARTITION BY i.AplicacaoId
            ORDER BY
                i.DataAbertura DESC,
                i.IncidenteId DESC
        ) AS Posicao
    FROM dbo.Incidente AS i
)
SELECT
    io.AplicacaoId,
    io.IncidenteId,
    io.DataAbertura,
    io.Posicao,
    t.TotalIncidentesAplicacao
FROM CTE_IncidentesOrdenados AS io
INNER JOIN CTE_Totais AS t
    ON io.AplicacaoId = t.AplicacaoId
WHERE io.Posicao <= 3
ORDER BY
    io.AplicacaoId,
    io.Posicao;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;