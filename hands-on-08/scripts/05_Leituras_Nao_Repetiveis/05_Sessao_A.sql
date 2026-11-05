-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 1: executar apenas até à primeira leitura e manter transação aberta.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
SELECT Valor FROM dbo.H08_TesteIsolamento WHERE Id=1; -- 100
-- PASSO 3: depois de a Sessão B executar o UPDATE/COMMIT, executar:
-- SELECT Valor FROM dbo.H08_TesteIsolamento WHERE Id=1; -- 200
-- COMMIT;
