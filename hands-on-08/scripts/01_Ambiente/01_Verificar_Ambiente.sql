-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
SELECT @@VERSION AS VersaoSQLServer, DB_NAME() AS BaseAtual, @@SPID AS Sessao;
SELECT name, state_desc, compatibility_level, recovery_model_desc,
       is_read_committed_snapshot_on, snapshot_isolation_state_desc
FROM sys.databases WHERE name = 'SIManagerDB';
SELECT 'Aplicacao' AS Tabela, COUNT_BIG(*) AS Registos FROM dbo.Aplicacao
UNION ALL SELECT 'Incidente', COUNT_BIG(*) FROM dbo.Incidente
UNION ALL SELECT 'PedidoServico', COUNT_BIG(*) FROM dbo.PedidoServico
UNION ALL SELECT 'Intervencao', COUNT_BIG(*) FROM dbo.Intervencao;
