-- HANDS-ON #08 | Ponto de Conhecimento Tecnológico
-- Executar em janela de consulta própria no SSMS.
USE SIManagerDB;
GO
SET NOCOUNT ON;
CREATE TABLE #TesteTransacao (Id INT PRIMARY KEY, Descricao VARCHAR(100));
INSERT INTO #TesteTransacao VALUES (1,'Estado inicial');
SELECT 'Inicial' AS Etapa,* FROM #TesteTransacao;
BEGIN TRAN;
 UPDATE #TesteTransacao SET Descricao='Alteracao temporaria' WHERE Id=1;
 SELECT 'Antes do rollback' AS Etapa, @@TRANCOUNT AS TransacoesAbertas,* FROM #TesteTransacao;
ROLLBACK;
SELECT 'Depois do rollback' AS Etapa,@@TRANCOUNT AS TransacoesAbertas,* FROM #TesteTransacao;
BEGIN TRAN;
 UPDATE #TesteTransacao SET Descricao='Alteracao confirmada' WHERE Id=1;
COMMIT;
SELECT 'Depois do commit' AS Etapa,@@TRANCOUNT AS TransacoesAbertas,* FROM #TesteTransacao;
DROP TABLE #TesteTransacao;
