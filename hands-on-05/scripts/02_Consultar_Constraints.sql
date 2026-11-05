/* PontoTec | Hands-On #05 | SIManagerDB
   02 — Consultar Constraints
   SQL Server 2019+ | Apenas leitura

   Objetivo: listar as constraints PK, FK, UNIQUE, DEFAULT e CHECK
   das 15 tabelas funcionais da SIManagerDB, excluindo sysdiagrams.

   Nota: a consulta mostra a definição das constraints; não substitui
   testes de integridade nem a validação dos dados.
*/
USE SIManagerDB;
GO
SET NOCOUNT ON;

-- 1. Detalhe das constraints por tabela e tipo.
;WITH ConstraintsModelo AS (
    SELECT t.name AS Tabela, kc.name AS NomeConstraint,
           CASE kc.type WHEN 'PK' THEN 'PRIMARY KEY' WHEN 'UQ' THEN 'UNIQUE' END AS Tipo,
           CAST(NULL AS nvarchar(max)) AS Definicao,
           CAST(0 AS bit) AS Desativada,
           CAST(0 AS bit) AS NaoConfiavel
    FROM sys.key_constraints AS kc
    JOIN sys.tables AS t ON t.object_id = kc.parent_object_id
    WHERE t.schema_id = SCHEMA_ID(N'dbo') AND t.name <> N'sysdiagrams'

    UNION ALL
    SELECT t.name, fk.name, 'FOREIGN KEY',
           CAST(NULL AS nvarchar(max)), fk.is_disabled, fk.is_not_trusted
    FROM sys.foreign_keys AS fk
    JOIN sys.tables AS t ON t.object_id = fk.parent_object_id
    WHERE t.schema_id = SCHEMA_ID(N'dbo') AND t.name <> N'sysdiagrams'

    UNION ALL
    SELECT t.name, dc.name, 'DEFAULT',
           CONVERT(nvarchar(max), dc.definition), CAST(0 AS bit), CAST(0 AS bit)
    FROM sys.default_constraints AS dc
    JOIN sys.tables AS t ON t.object_id = dc.parent_object_id
    WHERE t.schema_id = SCHEMA_ID(N'dbo') AND t.name <> N'sysdiagrams'

    UNION ALL
    SELECT t.name, cc.name, 'CHECK',
           CONVERT(nvarchar(max), cc.definition), cc.is_disabled, cc.is_not_trusted
    FROM sys.check_constraints AS cc
    JOIN sys.tables AS t ON t.object_id = cc.parent_object_id
    WHERE t.schema_id = SCHEMA_ID(N'dbo') AND t.name <> N'sysdiagrams'
)
SELECT Tabela, NomeConstraint, Tipo, Definicao, Desativada, NaoConfiavel
FROM ConstraintsModelo
ORDER BY Tabela, CASE Tipo
    WHEN 'PRIMARY KEY' THEN 1 WHEN 'FOREIGN KEY' THEN 2
    WHEN 'UNIQUE' THEN 3 WHEN 'DEFAULT' THEN 4 WHEN 'CHECK' THEN 5 END,
    NomeConstraint;
GO

-- 2. Resumo por tipo (inclui constraints CHECK e FK desativadas/não confiáveis).
;WITH Inventario AS (
    SELECT 'PRIMARY KEY' AS Tipo, CAST(0 AS int) AS Desativada, CAST(0 AS int) AS NaoConfiavel
    FROM sys.key_constraints kc JOIN sys.tables t ON t.object_id=kc.parent_object_id
    WHERE kc.type='PK' AND t.schema_id=SCHEMA_ID(N'dbo') AND t.name<>N'sysdiagrams'
    UNION ALL
    SELECT 'UNIQUE', 0, 0
    FROM sys.key_constraints kc JOIN sys.tables t ON t.object_id=kc.parent_object_id
    WHERE kc.type='UQ' AND t.schema_id=SCHEMA_ID(N'dbo') AND t.name<>N'sysdiagrams'
    UNION ALL
    SELECT 'FOREIGN KEY', CONVERT(int,fk.is_disabled), CONVERT(int,fk.is_not_trusted)
    FROM sys.foreign_keys fk JOIN sys.tables t ON t.object_id=fk.parent_object_id
    WHERE t.schema_id=SCHEMA_ID(N'dbo') AND t.name<>N'sysdiagrams'
    UNION ALL
    SELECT 'DEFAULT', 0, 0
    FROM sys.default_constraints dc JOIN sys.tables t ON t.object_id=dc.parent_object_id
    WHERE t.schema_id=SCHEMA_ID(N'dbo') AND t.name<>N'sysdiagrams'
    UNION ALL
    SELECT 'CHECK', CONVERT(int,cc.is_disabled), CONVERT(int,cc.is_not_trusted)
    FROM sys.check_constraints cc JOIN sys.tables t ON t.object_id=cc.parent_object_id
    WHERE t.schema_id=SCHEMA_ID(N'dbo') AND t.name<>N'sysdiagrams'
)
SELECT Tipo, COUNT(*) AS Total, SUM(Desativada) AS Desativadas,
       SUM(NaoConfiavel) AS NaoConfiaveis
FROM Inventario
GROUP BY Tipo
ORDER BY CASE Tipo WHEN 'PRIMARY KEY' THEN 1 WHEN 'FOREIGN KEY' THEN 2
                   WHEN 'UNIQUE' THEN 3 WHEN 'DEFAULT' THEN 4 WHEN 'CHECK' THEN 5 END;
GO
