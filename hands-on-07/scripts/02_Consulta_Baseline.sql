USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 02 — Consulta Baseline

Objetivo:
Reproduzir a consulta funcional utilizada
na medição inicial de desempenho.

Nota:
Os resultados históricos foram obtidos antes
da criação dos índices adicionais.

A execução atual pode apresentar um plano
diferente devido aos índices existentes.
*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    IncidenteId,
    AplicacaoId,
    Titulo,
    Estado,
    DataAbertura
FROM dbo.Incidente
WHERE AplicacaoId = 10
ORDER BY DataAbertura DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;