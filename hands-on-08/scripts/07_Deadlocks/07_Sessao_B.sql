-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 2: executar apenas este bloco:
BEGIN TRAN;
UPDATE dbo.H08_TesteDeadlock SET Valor=250 WHERE Id=2;
-- PASSO 4: após A tentar atualizar Id=2, executar:
-- UPDATE dbo.H08_TesteDeadlock SET Valor=175 WHERE Id=1;
-- Esperado: erro 1205 numa das sessões (a vítima pode variar).
-- Se B for vítima, a transação é anulada automaticamente.
