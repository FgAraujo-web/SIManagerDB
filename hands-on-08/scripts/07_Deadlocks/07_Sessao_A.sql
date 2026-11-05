-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 1: executar somente este bloco:
BEGIN TRAN;
UPDATE dbo.H08_TesteDeadlock SET Valor=150 WHERE Id=1;
-- PASSO 3: executar a instrução seguinte DEPOIS de B bloquear Id=2:
-- UPDATE dbo.H08_TesteDeadlock SET Valor=275 WHERE Id=2;
-- PASSO 5: depois de B receber erro 1205, confirmar a transação de A:
-- COMMIT;
-- SELECT * FROM dbo.H08_TesteDeadlock ORDER BY Id;
