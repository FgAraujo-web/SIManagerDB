-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
SELECT t.name AS NomeTrigger,OBJECT_NAME(t.parent_id) AS TabelaAssociada,t.is_disabled AS Desativado
FROM sys.triggers t WHERE t.name LIKE 'trg_H09_Auditoria%' ORDER BY t.name;
GO
SELECT Operacao,COUNT(*) AS TotalOperacoes FROM dbo.H09_LogAuditoria GROUP BY Operacao ORDER BY Operacao;
GO
SELECT t.name AS NomeTabela,t.temporal_type_desc AS TipoTemporal,h.name AS TabelaHistorico
FROM sys.tables t LEFT JOIN sys.tables h ON h.object_id=t.history_table_id
WHERE t.name IN ('H09_IncidenteTemporal','H09_IncidenteTemporalHistorico') ORDER BY t.name;
GO
SELECT IncidenteId,COUNT(*) AS TotalVersoes
FROM dbo.H09_IncidenteTemporal FOR SYSTEM_TIME ALL GROUP BY IncidenteId;
GO
