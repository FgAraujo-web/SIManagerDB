USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 06 — ROW_NUMBER() e COUNT() OVER()

Objetivo:
Analisar os últimos três incidentes por aplicação
e o total de incidentes por aplicação.

Nota:
A consulta é executada com os índices atualmente
existentes. Não reproduz automaticamente o
cenário histórico anterior à otimização.
*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

;WITH CTE_IncidentesOrdenados AS
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
        ) AS Posicao,

        COUNT(*) OVER
        (
            PARTITION BY i.AplicacaoId
        ) AS TotalIncidentesAplicacao

    FROM dbo.Incidente AS i
)
SELECT
    AplicacaoId,
    IncidenteId,
    DataAbertura,
    Posicao,
    TotalIncidentesAplicacao
FROM CTE_IncidentesOrdenados
WHERE Posicao <= 3
ORDER BY
    AplicacaoId,
    Posicao;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;