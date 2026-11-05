-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
UPDATE dbo.H08_TesteDeadlock SET Valor=CASE Id WHEN 1 THEN 100 WHEN 2 THEN 200 END WHERE Id IN (1,2);
SELECT * FROM dbo.H08_TesteDeadlock ORDER BY Id;
