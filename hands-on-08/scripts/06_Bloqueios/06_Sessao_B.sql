-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 2: executar enquanto Sessão A mantém transação aberta.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET LOCK_TIMEOUT -1;
SELECT * FROM dbo.H08_TesteIsolamento WHERE Id=1; -- Aguarda até ao ROLLBACK de A
