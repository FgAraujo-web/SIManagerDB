-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 1: executar este bloco e DEIXAR a transação aberta.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
UPDATE dbo.H08_TesteIsolamento SET Descricao='Valor nao confirmado',Valor=500 WHERE Id=1;
SELECT @@SPID AS SessaoA,@@TRANCOUNT AS TransacoesAbertas;
-- PASSO 3: após os testes da Sessão B, executar APENAS o bloco seguinte:
-- ROLLBACK;
-- SELECT * FROM dbo.H08_TesteIsolamento WHERE Id=1;
