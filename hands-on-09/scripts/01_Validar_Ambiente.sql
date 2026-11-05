-- Ponto de Conhecimento Tecnológico | HANDS-ON #09
-- Série 2 — SQL Server | SIManagerDB

USE SIManagerDB;
GO
SELECT @@SERVERNAME AS Servidor, SERVERPROPERTY('ProductVersion') AS VersaoSQLServer,
 SERVERPROPERTY('Edition') AS EdicaoSQLServer, DB_NAME() AS BaseDadosAtual,
 d.compatibility_level AS NivelCompatibilidade, d.state_desc AS EstadoBaseDados
FROM sys.databases d WHERE d.database_id=DB_ID();
GO
SELECT t.name AS NomeTabela, SUM(p.rows) AS NumeroRegistos, t.temporal_type_desc AS TipoTemporal
FROM sys.tables t JOIN sys.partitions p ON p.object_id=t.object_id
WHERE p.index_id IN (0,1) AND t.name IN ('Aplicacao','Incidente','PedidoServico')
GROUP BY t.name,t.temporal_type_desc ORDER BY t.name;
GO
