USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 01 — Inventário de Índices
*/

SELECT
    t.name AS Tabela,
    i.name AS NomeIndice,
    i.type_desc AS TipoIndice,
    i.is_unique AS Unico,
    i.is_primary_key AS ChavePrimaria,
    i.is_disabled AS Desativado,
    c.name AS Coluna,
    ic.key_ordinal AS OrdemChave,
    CASE
        WHEN ic.is_included_column = 1
            THEN 'INCLUDE'
        WHEN ic.is_descending_key = 1
            THEN 'DESC'
        ELSE 'ASC'
    END AS TipoColuna
FROM sys.tables AS t
INNER JOIN sys.indexes AS i
    ON t.object_id = i.object_id
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE
    t.is_ms_shipped = 0
    AND i.index_id > 0
    AND i.is_hypothetical = 0
ORDER BY
    t.name,
    i.name,
    ic.is_included_column,
    ic.key_ordinal,
    ic.index_column_id;