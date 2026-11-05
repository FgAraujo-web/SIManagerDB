-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
SELECT s.session_id,s.status,s.open_transaction_count
FROM sys.dm_exec_sessions AS s WHERE s.is_user_process=1
ORDER BY s.session_id;
SELECT * FROM dbo.H08_TesteDeadlock ORDER BY Id; -- Executar após resolução
