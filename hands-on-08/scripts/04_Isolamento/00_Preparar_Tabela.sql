-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
IF OBJECT_ID('dbo.H08_TesteIsolamento','U') IS NULL
 CREATE TABLE dbo.H08_TesteIsolamento (Id INT NOT NULL PRIMARY KEY, Descricao VARCHAR(100), Valor INT);
DELETE FROM dbo.H08_TesteIsolamento WHERE Id=1;
INSERT INTO dbo.H08_TesteIsolamento (Id,Descricao,Valor) VALUES (1,'Valor inicial',100);
SELECT * FROM dbo.H08_TesteIsolamento;
