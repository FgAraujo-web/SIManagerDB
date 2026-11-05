-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 3: executar noutra janela enquanto B está bloqueada.
SELECT r.session_id AS SessaoBloqueada,r.blocking_session_id AS SessaoBloqueadora,
       r.status,r.command,r.wait_type,r.wait_time,r.wait_resource,
       DB_NAME(r.database_id) AS BaseDados
FROM sys.dm_exec_requests AS r
WHERE r.database_id=DB_ID('SIManagerDB') AND r.blocking_session_id<>0;
-- Nota: algumas DMVs podem exigir VIEW SERVER STATE.
