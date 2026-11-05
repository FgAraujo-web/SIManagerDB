-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
-- PASSO 2: executar após A adquirir ambos os locks.
-- B aguarda no Id=1; depois do COMMIT de A, continua automaticamente.
BEGIN TRAN;
UPDATE dbo.H08_TesteDeadlock SET Valor=175 WHERE Id=1;
UPDATE dbo.H08_TesteDeadlock SET Valor=275 WHERE Id=2;
COMMIT;
SELECT @@TRANCOUNT AS TransacoesAbertas;
SELECT * FROM dbo.H08_TesteDeadlock ORDER BY Id; -- 175 e 275
