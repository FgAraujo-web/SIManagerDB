/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 01 — INNER JOIN: Aplicações e Departamentos Responsáveis
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Consulta principal
SELECT a.AplicacaoId, a.Nome AS Aplicacao, a.Criticidade, a.Estado,
       d.Nome AS DepartamentoResponsavel
FROM dbo.Aplicacao AS a
INNER JOIN dbo.Departamento AS d
    ON a.DepartamentoResponsavelId = d.DepartamentoId
ORDER BY a.Nome, a.AplicacaoId;
GO

-- ETAPA 2 — Validação: total de aplicações, correspondências e ausências
SELECT
    (SELECT COUNT(*) FROM dbo.Aplicacao) AS TotalAplicacoes,
    (SELECT COUNT(*) FROM dbo.Aplicacao AS a
     INNER JOIN dbo.Departamento AS d
       ON a.DepartamentoResponsavelId = d.DepartamentoId) AS TotalComCorrespondencia,
    (SELECT COUNT(*) FROM dbo.Aplicacao AS a
     LEFT JOIN dbo.Departamento AS d
       ON a.DepartamentoResponsavelId = d.DepartamentoId
     WHERE d.DepartamentoId IS NULL) AS AplicacoesSemDepartamento;
GO
-- Validado no SSMS: 25 / 25 / 0.
