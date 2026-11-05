-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
UPDATE dbo.H09_IncidenteAuditoria
SET Estado=N'Em resolução',Prioridade=N'Crítica'
WHERE IncidenteId=1;
GO
SELECT AuditoriaId,IncidenteId,Operacao,
 JSON_VALUE(DadosAntes,'$.Estado') AS EstadoAnterior,
 JSON_VALUE(DadosDepois,'$.Estado') AS EstadoNovo,
 JSON_VALUE(DadosAntes,'$.Prioridade') AS PrioridadeAnterior,
 JSON_VALUE(DadosDepois,'$.Prioridade') AS PrioridadeNova,
 UtilizadorSQL,DataOperacao
FROM dbo.H09_LogAuditoria WHERE IncidenteId=1 AND Operacao='UPDATE' ORDER BY AuditoriaId;
GO
