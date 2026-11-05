-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
IF OBJECT_ID('dbo.H09_IncidenteAuditoria','U') IS NULL
BEGIN
 CREATE TABLE dbo.H09_IncidenteAuditoria (
  IncidenteId INT IDENTITY(1,1) CONSTRAINT PK_H09_IncidenteAuditoria PRIMARY KEY,
  AplicacaoId INT NOT NULL, Titulo NVARCHAR(200) NOT NULL,
  Estado NVARCHAR(30) NOT NULL, Prioridade NVARCHAR(20) NOT NULL,
  DataCriacao DATETIME2(0) NOT NULL CONSTRAINT DF_H09_IncidenteAuditoria_DataCriacao DEFAULT SYSUTCDATETIME());
END;
GO
IF OBJECT_ID('dbo.H09_LogAuditoria','U') IS NULL
BEGIN
 CREATE TABLE dbo.H09_LogAuditoria (
  AuditoriaId BIGINT IDENTITY(1,1) CONSTRAINT PK_H09_LogAuditoria PRIMARY KEY,
  IncidenteId INT NOT NULL, Operacao VARCHAR(10) NOT NULL,
  DadosAntes NVARCHAR(MAX) NULL, DadosDepois NVARCHAR(MAX) NULL,
  UtilizadorSQL SYSNAME NOT NULL,
  DataOperacao DATETIME2(3) NOT NULL CONSTRAINT DF_H09_LogAuditoria_DataOperacao DEFAULT SYSUTCDATETIME(),
  CONSTRAINT CK_H09_LogAuditoria_Operacao CHECK (Operacao IN ('INSERT','UPDATE','DELETE')));
END;
GO
SELECT c.name AS Coluna, TYPE_NAME(c.user_type_id) AS TipoDados, c.is_identity AS EhIdentity
FROM sys.columns c WHERE c.object_id=OBJECT_ID('dbo.H09_IncidenteAuditoria') ORDER BY c.column_id;
SELECT COUNT(*) AS TotalAuditorias FROM dbo.H09_LogAuditoria;
GO
