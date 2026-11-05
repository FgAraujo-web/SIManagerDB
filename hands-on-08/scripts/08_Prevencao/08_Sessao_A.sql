-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 1: adquirir locks pela ordem Id=1 e depois Id=2.
BEGIN TRAN;
UPDATE dbo.H08_TesteDeadlock SET Valor=150 WHERE Id=1;
UPDATE dbo.H08_TesteDeadlock SET Valor=250 WHERE Id=2;
-- PASSO 3: depois de B ficar à espera, executar:
-- COMMIT;
