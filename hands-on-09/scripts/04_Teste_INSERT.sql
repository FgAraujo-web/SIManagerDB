-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
-- Executar apenas uma vez para reproduzir os IDs 1 e 2.
INSERT INTO dbo.H09_IncidenteAuditoria(AplicacaoId,Titulo,Estado,Prioridade)
VALUES (1,N'Falha de autenticação na aplicação',N'Aberto',N'Alta'),
       (2,N'Erro na integração de dados',N'Em análise',N'Média');
GO
SELECT * FROM dbo.H09_IncidenteAuditoria ORDER BY IncidenteId;
SELECT * FROM dbo.H09_LogAuditoria ORDER BY AuditoriaId;
GO
