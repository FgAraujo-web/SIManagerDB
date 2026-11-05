-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
DELETE FROM dbo.H09_IncidenteAuditoria WHERE IncidenteId=2;
GO
SELECT * FROM dbo.H09_IncidenteAuditoria ORDER BY IncidenteId;
SELECT AuditoriaId,IncidenteId,Operacao,
 JSON_VALUE(DadosAntes,'$.Titulo') AS TituloAnterior,
 JSON_VALUE(DadosAntes,'$.Estado') AS EstadoAnterior,
 JSON_VALUE(DadosAntes,'$.Prioridade') AS PrioridadeAnterior,
 DadosDepois,UtilizadorSQL,DataOperacao
FROM dbo.H09_LogAuditoria WHERE IncidenteId=2 AND Operacao='DELETE';
GO
