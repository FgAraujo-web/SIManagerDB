-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
CREATE OR ALTER TRIGGER dbo.trg_H09_AuditoriaInsert ON dbo.H09_IncidenteAuditoria
AFTER INSERT AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO dbo.H09_LogAuditoria(IncidenteId,Operacao,DadosAntes,DadosDepois,UtilizadorSQL)
 SELECT i.IncidenteId,'INSERT',NULL,
 (SELECT i.IncidenteId,i.AplicacaoId,i.Titulo,i.Estado,i.Prioridade,i.DataCriacao
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), ORIGINAL_LOGIN()
 FROM inserted i;
END;
GO
