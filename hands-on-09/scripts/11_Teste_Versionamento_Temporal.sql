-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
INSERT INTO dbo.H09_IncidenteTemporal(Titulo,Estado,Prioridade)
VALUES(N'Falha de comunicação com serviço externo',N'Aberto',N'Alta');
GO
UPDATE dbo.H09_IncidenteTemporal SET Estado=N'Em análise'
WHERE Titulo=N'Falha de comunicação com serviço externo' AND Estado=N'Aberto';
GO
SELECT * FROM dbo.H09_IncidenteTemporal;
SELECT * FROM dbo.H09_IncidenteTemporalHistorico;
GO
UPDATE dbo.H09_IncidenteTemporal SET Estado=N'Resolvido',Prioridade=N'Baixa'
WHERE IncidenteId=1 AND Estado=N'Em análise';
GO
SELECT IncidenteId,Titulo,Estado,Prioridade,ValidoDesde,ValidoAte
FROM dbo.H09_IncidenteTemporal FOR SYSTEM_TIME ALL
WHERE IncidenteId=1 ORDER BY ValidoDesde;
GO
