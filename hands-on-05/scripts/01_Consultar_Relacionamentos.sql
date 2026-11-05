/*
 PontoTec | Hands-On #05 — Modelação de Dados e Constraints
 01_Consultar_Relacionamentos.sql

 Objetivo: consultar as FOREIGN KEY da SIManagerDB, as colunas de origem
 e destino e o estado de ativação/confiança das constraints.

 Pré-requisito: SIManagerDB instalada.
 Segurança: apenas leitura; não altera dados nem objetos.
 Compatibilidade: SQL Server 2019+.

 Interpretação:
   Desativada = 0  -> FK ativa
   NaoConfiavel = 0 -> FK considerada trusted pelo SQL Server

 Resultado de referência no modelo validado: 21 FOREIGN KEY, todas
 ativas e confiáveis. Se houver chaves compostas, a primeira consulta
 apresenta uma linha por par de colunas; a segunda conta constraints.
*/
USE SIManagerDB;
GO

SET NOCOUNT ON;

-- 1. Detalhe das relações: uma linha por par de colunas da FOREIGN KEY.
SELECT
    fk.name AS NomeForeignKey,
    tp.name AS TabelaOrigem,
    cp.name AS ColunaOrigem,
    tr.name AS TabelaReferenciada,
    cr.name AS ColunaReferenciada,
    fk.is_disabled AS Desativada,
    fk.is_not_trusted AS NaoConfiavel
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.tables AS tp
    ON fkc.parent_object_id = tp.object_id
INNER JOIN sys.columns AS cp
    ON fkc.parent_object_id = cp.object_id
   AND fkc.parent_column_id = cp.column_id
INNER JOIN sys.tables AS tr
    ON fkc.referenced_object_id = tr.object_id
INNER JOIN sys.columns AS cr
    ON fkc.referenced_object_id = cr.object_id
   AND fkc.referenced_column_id = cr.column_id
WHERE tp.name <> 'sysdiagrams'
  AND tr.name <> 'sysdiagrams'
  AND SCHEMA_NAME(tp.schema_id) = 'dbo'
ORDER BY
    tp.name,
    fk.name,
    fkc.constraint_column_id;
GO

-- 2. Controlo: número de constraints FK, ativas e confiáveis.
-- Conta constraints (não pares de colunas), evitando duplicações
-- caso o modelo venha a incluir chaves estrangeiras compostas.
SELECT
    COUNT(*) AS TotalForeignKeys,
    SUM(CASE WHEN fk.is_disabled = 1 THEN 1 ELSE 0 END) AS Desativadas,
    SUM(CASE WHEN fk.is_not_trusted = 1 THEN 1 ELSE 0 END) AS NaoConfiaveis
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS tp
    ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables AS tr
    ON fk.referenced_object_id = tr.object_id
WHERE tp.name <> 'sysdiagrams'
  AND tr.name <> 'sysdiagrams'
  AND SCHEMA_NAME(tp.schema_id) = 'dbo';
GO
