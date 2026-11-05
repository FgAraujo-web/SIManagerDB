/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #06 — Joins, CTEs e Window Functions
Exercício 02 — LEFT JOIN: Incidentes com e sem Técnico Atribuído
Ambiente: SQL Server 2019+ / SSMS
Base de dados: SIManagerDB (dados fictícios)
Consultas de leitura; não alteram os dados.
*/
USE SIManagerDB;
GO

-- ETAPA 1 — Consulta principal: preservar incidentes sem técnico
SELECT i.IncidenteId, i.Titulo, i.Estado, i.DataAbertura, i.TecnicoId,
       u.Nome AS TecnicoResponsavel,
       CASE WHEN i.TecnicoId IS NULL THEN 'Nao Atribuido'
            ELSE 'Atribuido' END AS SituacaoAtribuicao
FROM dbo.Incidente AS i
LEFT JOIN dbo.Tecnico AS t ON i.TecnicoId = t.TecnicoId
LEFT JOIN dbo.Utilizador AS u ON t.UtilizadorId = u.UtilizadorId
ORDER BY i.IncidenteId;
GO

-- ETAPA 2 — Validação das contagens e da preservação dos registos
SELECT
    (SELECT COUNT(*) FROM dbo.Incidente) AS TotalIncidentes,
    (SELECT COUNT(*) FROM dbo.Incidente WHERE TecnicoId IS NOT NULL)
       AS IncidentesAtribuidos,
    (SELECT COUNT(*) FROM dbo.Incidente WHERE TecnicoId IS NULL)
       AS IncidentesNaoAtribuidos,
    (SELECT COUNT(*) FROM dbo.Incidente AS i
     LEFT JOIN dbo.Tecnico AS t ON i.TecnicoId = t.TecnicoId
     LEFT JOIN dbo.Utilizador AS u ON t.UtilizadorId = u.UtilizadorId)
       AS TotalComLeftJoin;
GO
-- Validado no SSMS: 50000 / 45455 / 4545 / 50000.
