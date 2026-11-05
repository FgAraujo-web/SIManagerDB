-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
CREATE OR ALTER TRIGGER dbo.trg_H09_AuditoriaUpdate ON dbo.H09_IncidenteAuditoria
AFTER UPDATE AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO dbo.H09_LogAuditoria(IncidenteId,Operacao,DadosAntes,DadosDepois,UtilizadorSQL)
 SELECT i.IncidenteId,'UPDATE',
 (SELECT d.IncidenteId,d.AplicacaoId,d.Titulo,d.Estado,d.Prioridade,d.DataCriacao
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
 (SELECT i.IncidenteId,i.AplicacaoId,i.Titulo,i.Estado,i.Prioridade,i.DataCriacao
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), ORIGINAL_LOGIN()
 FROM inserted i INNER JOIN deleted d ON d.IncidenteId=i.IncidenteId;
END;
GO
