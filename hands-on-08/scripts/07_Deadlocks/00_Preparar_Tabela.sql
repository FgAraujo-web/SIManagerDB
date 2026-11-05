-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
IF OBJECT_ID('dbo.H08_TesteDeadlock','U') IS NULL
 CREATE TABLE dbo.H08_TesteDeadlock (Id INT NOT NULL PRIMARY KEY,Descricao VARCHAR(100),Valor INT);
DELETE FROM dbo.H08_TesteDeadlock WHERE Id IN (1,2);
INSERT INTO dbo.H08_TesteDeadlock VALUES (1,'Registo A',100),(2,'Registo B',200);
SELECT * FROM dbo.H08_TesteDeadlock ORDER BY Id;
