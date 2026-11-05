USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 03 — Criação e Avaliação de Índice Simples

Objetivo:
Avaliar um índice NONCLUSTERED sobre AplicacaoId.

Resultado histórico:
928 leituras lógicas antes e após a criação
do índice simples.

Nota:
O índice só será criado se ainda não existir.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.Incidente')
      AND name = 'IX_Incidente_AplicacaoId'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Incidente_AplicacaoId
    ON dbo.Incidente (AplicacaoId);
END;
GO

-- Verificação do índice

SELECT
    name AS NomeIndice,
    type_desc AS TipoIndice,
    is_disabled AS Desativado
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.Incidente')
  AND name = 'IX_Incidente_AplicacaoId';