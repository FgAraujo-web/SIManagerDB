-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 1: executar e manter transação aberta.
BEGIN TRAN;
UPDATE dbo.H08_TesteIsolamento SET Descricao='Bloqueio controlado',Valor=300 WHERE Id=1;
-- PASSO 4: após observar bloqueio na Sessão C, executar:
-- ROLLBACK;
