-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
UPDATE dbo.H08_TesteIsolamento SET Descricao='Valor inicial',Valor=100 WHERE Id=1;
