-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
IF OBJECT_ID('dbo.H09_IncidenteTemporal','U') IS NULL
BEGIN
 CREATE TABLE dbo.H09_IncidenteTemporal (
  IncidenteId INT IDENTITY(1,1) CONSTRAINT PK_H09_IncidenteTemporal PRIMARY KEY,
  Titulo NVARCHAR(200) NOT NULL,Estado NVARCHAR(30) NOT NULL,Prioridade NVARCHAR(20) NOT NULL,
  ValidoDesde DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
  ValidoAte DATETIME2(7) GENERATED ALWAYS AS ROW END NOT NULL,
  PERIOD FOR SYSTEM_TIME(ValidoDesde,ValidoAte)
 ) WITH (SYSTEM_VERSIONING=ON (HISTORY_TABLE=dbo.H09_IncidenteTemporalHistorico));
END;
GO
SELECT t.name AS NomeTabela,t.temporal_type_desc AS TipoTemporal,h.name AS TabelaHistorico
FROM sys.tables t LEFT JOIN sys.tables h ON h.object_id=t.history_table_id
WHERE t.name IN ('H09_IncidenteTemporal','H09_IncidenteTemporalHistorico');
GO
