USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 04 — Índice Composto com INCLUDE

Objetivo:
Otimizar a pesquisa de incidentes por aplicação
e data de abertura.

Resultado histórico:
928 -> 35 leituras lógicas.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.Incidente')
      AND name = 'IX_Incidente_Aplicacao_DataAbertura'
)
BEGIN
    CREATE NONCLUSTERED INDEX
        IX_Incidente_Aplicacao_DataAbertura
    ON dbo.Incidente
    (
        AplicacaoId ASC,
        DataAbertura DESC
    )
    INCLUDE
    (
        Titulo,
        Estado
    );
END;
GO

-- Verificar a existência e o estado do índice.

SELECT
    name AS NomeIndice,
    type_desc AS TipoIndice,
    is_disabled AS Desativado
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.Incidente')
  AND name = 'IX_Incidente_Aplicacao_DataAbertura';