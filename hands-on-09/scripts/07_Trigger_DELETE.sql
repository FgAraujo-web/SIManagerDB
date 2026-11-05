-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
CREATE OR ALTER TRIGGER dbo.trg_H09_AuditoriaDelete ON dbo.H09_IncidenteAuditoria
AFTER DELETE AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO dbo.H09_LogAuditoria(IncidenteId,Operacao,DadosAntes,DadosDepois,UtilizadorSQL)
 SELECT d.IncidenteId,'DELETE',
 (SELECT d.IncidenteId,d.AplicacaoId,d.Titulo,d.Estado,d.Prioridade,d.DataCriacao
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),NULL,ORIGINAL_LOGIN()
 FROM deleted d;
END;
GO
