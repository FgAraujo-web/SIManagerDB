USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas
Script 08 — Validação da equivalência funcional

Compara integralmente os resultados dos Scripts 06 e 07.
Executar numa sessão sem alterações concorrentes aos incidentes.
*/

SET NOCOUNT ON;

DROP TABLE IF EXISTS #Resultado06;
DROP TABLE IF EXISTS #Resultado07;

-- Script 06: ROW_NUMBER() + COUNT(*) OVER()
;WITH CTE_IncidentesOrdenados AS
(
    SELECT
        i.AplicacaoId,
        i.IncidenteId,
        i.DataAbertura,
        ROW_NUMBER() OVER
        (
            PARTITION BY i.AplicacaoId
            ORDER BY i.DataAbertura DESC, i.IncidenteId DESC
        ) AS Posicao,
        COUNT(*) OVER
        (
            PARTITION BY i.AplicacaoId
        ) AS TotalIncidentesAplicacao
    FROM dbo.Incidente AS i
)
SELECT AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
INTO #Resultado06
FROM CTE_IncidentesOrdenados
WHERE Posicao <= 3;

-- Script 07: ROW_NUMBER() + GROUP BY + JOIN
;WITH CTE_Totais AS
(
    SELECT AplicacaoId, COUNT(*) AS TotalIncidentesAplicacao
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
            ORDER BY i.DataAbertura DESC, i.IncidenteId DESC
        ) AS Posicao
    FROM dbo.Incidente AS i
)
SELECT io.AplicacaoId, io.IncidenteId, io.DataAbertura,
       io.Posicao, t.TotalIncidentesAplicacao
INTO #Resultado07
FROM CTE_IncidentesOrdenados AS io
INNER JOIN CTE_Totais AS t ON io.AplicacaoId = t.AplicacaoId
WHERE io.Posicao <= 3;

-- EXCEPT compara conjuntos; a validação de duplicados é adicional.
SELECT * INTO #Diferencas06_07
FROM
(
    SELECT AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
    FROM #Resultado06
    EXCEPT
    SELECT AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
    FROM #Resultado07
) AS d;

SELECT * INTO #Diferencas07_06
FROM
(
    SELECT AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
    FROM #Resultado07
    EXCEPT
    SELECT AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
    FROM #Resultado06
) AS d;

DECLARE @Linhas06 bigint = (SELECT COUNT_BIG(*) FROM #Resultado06);
DECLARE @Linhas07 bigint = (SELECT COUNT_BIG(*) FROM #Resultado07);
DECLARE @Dif06_07 bigint = (SELECT COUNT_BIG(*) FROM #Diferencas06_07);
DECLARE @Dif07_06 bigint = (SELECT COUNT_BIG(*) FROM #Diferencas07_06);
DECLARE @Duplicados06 bigint =
(
    SELECT COALESCE(SUM(Quantidade - 1), 0)
    FROM
    (
        SELECT COUNT_BIG(*) AS Quantidade
        FROM #Resultado06
        GROUP BY AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
        HAVING COUNT_BIG(*) > 1
    ) AS d
);
DECLARE @Duplicados07 bigint =
(
    SELECT COALESCE(SUM(Quantidade - 1), 0)
    FROM
    (
        SELECT COUNT_BIG(*) AS Quantidade
        FROM #Resultado07
        GROUP BY AplicacaoId, IncidenteId, DataAbertura, Posicao, TotalIncidentesAplicacao
        HAVING COUNT_BIG(*) > 1
    ) AS d
);

SELECT
    @Linhas06 AS RegistosScript06,
    @Linhas07 AS RegistosScript07,
    @Dif06_07 AS Diferencas06Para07,
    @Dif07_06 AS Diferencas07Para06,
    @Duplicados06 AS DuplicadosScript06,
    @Duplicados07 AS DuplicadosScript07,
    CASE
        WHEN @Linhas06 = 75 AND @Linhas07 = 75
         AND @Dif06_07 = 0 AND @Dif07_06 = 0
         AND @Duplicados06 = 0 AND @Duplicados07 = 0
        THEN 'VALIDADO — resultados equivalentes (75 registos)'
        ELSE 'NAO VALIDADO — analisar divergencias'
    END AS ResultadoValidacao;

-- Se existirem diferenças, estas consultas mostram os registos divergentes.
SELECT '06 menos 07' AS OrigemDiferenca, * FROM #Diferencas06_07;
SELECT '07 menos 06' AS OrigemDiferenca, * FROM #Diferencas07_06;

DROP TABLE IF EXISTS #Diferencas06_07;
DROP TABLE IF EXISTS #Diferencas07_06;
DROP TABLE IF EXISTS #Resultado06;
DROP TABLE IF EXISTS #Resultado07;
