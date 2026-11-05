-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
CREATE TABLE #TesteErros (Id INT PRIMARY KEY, Descricao VARCHAR(100));
INSERT INTO #TesteErros VALUES (1,'Registo inicial');
BEGIN TRY
 BEGIN TRAN;
 INSERT INTO #TesteErros VALUES (2,'Registo temporario');
 INSERT INTO #TesteErros VALUES (1,'Chave duplicada'); -- Erro 2627
 COMMIT;
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() AS NumeroErro,ERROR_MESSAGE() AS Mensagem,
        XACT_STATE() AS EstadoTransacao,@@TRANCOUNT AS TransacoesAbertas;
 IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
SELECT * FROM #TesteErros ORDER BY Id;
SELECT XACT_STATE() AS EstadoFinal,@@TRANCOUNT AS TransacoesFinais;
DROP TABLE #TesteErros;
SET XACT_ABORT OFF;
