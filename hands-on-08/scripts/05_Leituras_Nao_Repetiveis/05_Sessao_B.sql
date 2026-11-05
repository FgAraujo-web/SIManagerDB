-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 2: executar após primeira leitura da Sessão A.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
UPDATE dbo.H08_TesteIsolamento SET Descricao='Valor alterado pela Sessao B',Valor=200 WHERE Id=1;
COMMIT;
