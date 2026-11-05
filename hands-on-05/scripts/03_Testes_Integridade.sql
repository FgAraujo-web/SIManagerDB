/* PontoTec | SIManagerDB | HANDS-ON #05
   03_Testes_Integridade.sql
   SQL Server 2019+ | Testes controlados de integridade referencial e de dominio.

   PRE-REQUISITOS:
   - Executar exclusivamente numa instancia de desenvolvimento, com SIManagerDB povoada.
   - Os testes utilizam registos existentes de dbo.Incidente como base.
   - Cada tentativa de INSERT decorre numa transacao que e revertida com ROLLBACK.
   - Nenhum teste utiliza COMMIT.
   - Resultado esperado em cada caso: erro SQL Server 547 (violacao de CHECK ou FK).

   NOTA: A execucao foi preparada para validacao no SSMS; confirmar os resultados
   apresentados antes de considerar o script validado.
*/
USE SIManagerDB;
GO
SET NOCOUNT ON;
SET XACT_ABORT OFF; -- Permite capturar erros de constraint no TRY/CATCH.

IF NOT EXISTS (SELECT 1 FROM dbo.Incidente)
    THROW 51000, 'Nao existem incidentes de referencia. Execute primeiro a instalacao e o povoamento.', 1;

IF NOT EXISTS (SELECT 1 FROM dbo.Incidente WHERE Estado IN ('Resolvido','Fechado') AND DataResolucao IS NOT NULL)
    THROW 51001, 'Nao existe incidente resolvido/fechado para o teste de datas.', 1;

DECLARE @Resultados TABLE (
    Teste varchar(8) NOT NULL,
    Regra nvarchar(120) NOT NULL,
    ErroObtido int NULL,
    Resultado nvarchar(80) NOT NULL
);

/* TESTE 01 — CK_Incidente_Datas: resolucao anterior a abertura. */
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Incidente
        (AplicacaoId, AbertoPorId, TecnicoId, SLAId, Titulo, Estado, DataAbertura, DataResolucao)
    SELECT TOP (1)
        AplicacaoId, AbertoPorId, TecnicoId, SLAId,
        N'Teste 01 - Data de resolucao invalida', Estado, DataAbertura,
        DATEADD(MINUTE, -1, DataAbertura)
    FROM dbo.Incidente
    WHERE Estado IN ('Resolvido','Fechado') AND DataResolucao IS NOT NULL
    ORDER BY IncidenteId;
    ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 01', N'DataResolucao anterior a DataAbertura', NULL, N'FALHA: insercao aceite');
END TRY
BEGIN CATCH
    DECLARE @Erro01 int = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 01', N'DataResolucao anterior a DataAbertura', @Erro01,
        CASE WHEN @Erro01 = 547 THEN N'OK: insercao rejeitada' ELSE N'REVER: erro inesperado' END);
END CATCH;

/* TESTE 02 — CK_Incidente_Estado: estado fora do dominio. */
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Incidente
        (AplicacaoId, AbertoPorId, TecnicoId, SLAId, Titulo, Estado, DataAbertura, DataResolucao)
    SELECT TOP (1)
        AplicacaoId, AbertoPorId, TecnicoId, SLAId,
        N'Teste 02 - Estado invalido', 'Cancelado', DataAbertura, DataResolucao
    FROM dbo.Incidente ORDER BY IncidenteId;
    ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 02', N'Estado fora dos valores permitidos', NULL, N'FALHA: insercao aceite');
END TRY
BEGIN CATCH
    DECLARE @Erro02 int = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 02', N'Estado fora dos valores permitidos', @Erro02,
        CASE WHEN @Erro02 = 547 THEN N'OK: insercao rejeitada' ELSE N'REVER: erro inesperado' END);
END CATCH;

/* TESTE 03 — CK_Incidente_EstadoResolucao: resolvido sem data. */
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Incidente
        (AplicacaoId, AbertoPorId, TecnicoId, SLAId, Titulo, Estado, DataAbertura, DataResolucao)
    SELECT TOP (1)
        AplicacaoId, AbertoPorId, TecnicoId, SLAId,
        N'Teste 03 - Resolvido sem data', 'Resolvido', DataAbertura, NULL
    FROM dbo.Incidente ORDER BY IncidenteId;
    ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 03', N'Incidente resolvido sem data de resolucao', NULL, N'FALHA: insercao aceite');
END TRY
BEGIN CATCH
    DECLARE @Erro03 int = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 03', N'Incidente resolvido sem data de resolucao', @Erro03,
        CASE WHEN @Erro03 = 547 THEN N'OK: insercao rejeitada' ELSE N'REVER: erro inesperado' END);
END CATCH;

/* TESTE 04 — FK Incidente -> Aplicacao: identificador inexistente.
   O valor -1 e intencionalmente invalido no conjunto de dados ficticios. */
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Incidente
        (AplicacaoId, AbertoPorId, TecnicoId, SLAId, Titulo, Estado, DataAbertura, DataResolucao)
    SELECT TOP (1)
        -1, AbertoPorId, TecnicoId, SLAId,
        N'Teste 04 - Aplicacao inexistente', Estado, DataAbertura, DataResolucao
    FROM dbo.Incidente ORDER BY IncidenteId;
    ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 04', N'AplicacaoId inexistente (-1)', NULL, N'FALHA: insercao aceite');
END TRY
BEGIN CATCH
    DECLARE @Erro04 int = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    INSERT INTO @Resultados VALUES ('TESTE 04', N'AplicacaoId inexistente (-1)', @Erro04,
        CASE WHEN @Erro04 = 547 THEN N'OK: insercao rejeitada' ELSE N'REVER: erro inesperado' END);
END CATCH;

SELECT Teste, Regra, ErroObtido, Resultado
FROM @Resultados ORDER BY Teste;

SELECT COUNT(*) AS TotalTestes,
       SUM(CASE WHEN ErroObtido = 547 THEN 1 ELSE 0 END) AS RejeicoesEsperadas,
       SUM(CASE WHEN ErroObtido IS NULL OR ErroObtido <> 547 THEN 1 ELSE 0 END) AS TestesARever
FROM @Resultados;
GO
