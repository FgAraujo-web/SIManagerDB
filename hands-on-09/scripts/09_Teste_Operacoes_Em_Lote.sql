-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
-- Inserção de três linhas numa só instrução
INSERT INTO dbo.H09_IncidenteAuditoria(AplicacaoId,Titulo,Estado,Prioridade)
VALUES (3,N'Falha no processamento de pedidos',N'Aberto',N'Alta'),
       (4,N'Erro de sincronização de dados',N'Aberto',N'Média'),
       (5,N'Indisponibilidade de serviço',N'Aberto',N'Crítica');
GO
SELECT i.IncidenteId,i.Titulo,a.AuditoriaId,a.Operacao
FROM dbo.H09_IncidenteAuditoria i JOIN dbo.H09_LogAuditoria a ON a.IncidenteId=i.IncidenteId
WHERE i.AplicacaoId IN (3,4,5) AND a.Operacao='INSERT' ORDER BY i.IncidenteId;
GO
UPDATE dbo.H09_IncidenteAuditoria
SET Estado=N'Em análise',Prioridade=CASE WHEN IncidenteId=3 THEN N'Crítica'
 WHEN IncidenteId=4 THEN N'Alta' WHEN IncidenteId=5 THEN N'Crítica' END
WHERE IncidenteId IN (3,4,5);
GO
SELECT IncidenteId,Operacao,
 JSON_VALUE(DadosAntes,'$.Estado') AS EstadoAnterior,
 JSON_VALUE(DadosDepois,'$.Estado') AS EstadoNovo,
 JSON_VALUE(DadosAntes,'$.Prioridade') AS PrioridadeAnterior,
 JSON_VALUE(DadosDepois,'$.Prioridade') AS PrioridadeNova
FROM dbo.H09_LogAuditoria WHERE IncidenteId IN (3,4,5) AND Operacao='UPDATE' ORDER BY IncidenteId;
GO
DELETE FROM dbo.H09_IncidenteAuditoria WHERE IncidenteId IN (4,5);
GO
SELECT IncidenteId,Operacao,JSON_VALUE(DadosAntes,'$.Estado') AS EstadoAnterior,
 JSON_VALUE(DadosAntes,'$.Prioridade') AS PrioridadeAnterior,DadosDepois
FROM dbo.H09_LogAuditoria WHERE IncidenteId IN (4,5) AND Operacao='DELETE' ORDER BY IncidenteId;
GO
