/*
 PontoTec | SIManagerDB | Script de Validacao
 Dados ficticios | Execucao apenas de leitura

 Objetivo:
  1. Consultar a quantidade de registos nas 15 tabelas funcionais.
  2. Explorar os incidentes por aplicacao e prioridade.
  3. Apresentar um indicador simplificado de cumprimento de SLA.

 Nota: este script nao substitui os testes especificos de constraints
 e relacionamentos documentados no Hands-On #05.
*/
USE SIManagerDB;
GO
SET NOCOUNT ON;

-- 1. Contagem de registos por entidade.
-- Os valores correspondem ao estado da base de dados no momento da consulta.
-- Numa instalacao inicial, o total esperado e 96 156 registos ficticios.
-- Esta consulta nao valida, por si so, constraints ou integridade referencial.
SELECT 'Departamento' AS Entidade, COUNT_BIG(*) AS Registos FROM dbo.Departamento
UNION ALL SELECT 'Equipa',COUNT_BIG(*) FROM dbo.Equipa
UNION ALL SELECT 'Utilizador',COUNT_BIG(*) FROM dbo.Utilizador
UNION ALL SELECT 'Tecnico',COUNT_BIG(*) FROM dbo.Tecnico
UNION ALL SELECT 'Aplicacao',COUNT_BIG(*) FROM dbo.Aplicacao
UNION ALL SELECT 'ModuloAplicacao',COUNT_BIG(*) FROM dbo.ModuloAplicacao
UNION ALL SELECT 'VersaoAplicacao',COUNT_BIG(*) FROM dbo.VersaoAplicacao
UNION ALL SELECT 'Fornecedor',COUNT_BIG(*) FROM dbo.Fornecedor
UNION ALL SELECT 'Contrato',COUNT_BIG(*) FROM dbo.Contrato
UNION ALL SELECT 'Licenca',COUNT_BIG(*) FROM dbo.Licenca
UNION ALL SELECT 'PoliticaSLA',COUNT_BIG(*) FROM dbo.PoliticaSLA
UNION ALL SELECT 'Incidente',COUNT_BIG(*) FROM dbo.Incidente
UNION ALL SELECT 'PedidoServico',COUNT_BIG(*) FROM dbo.PedidoServico
UNION ALL SELECT 'Intervencao',COUNT_BIG(*) FROM dbo.Intervencao
UNION ALL SELECT 'Alteracao',COUNT_BIG(*) FROM dbo.Alteracao;
GO
-- 2. Incidentes por aplicacao e prioridade.
-- Apresenta os 10 grupos com maior quantidade de incidentes.
-- Trata-se de uma consulta de exploracao, nao de um teste exaustivo
-- de integridade referencial.
SELECT TOP (10) a.Nome AS Aplicacao,s.Prioridade,COUNT(*) AS TotalIncidentes
FROM dbo.Incidente i
JOIN dbo.Aplicacao a ON a.AplicacaoId=i.AplicacaoId
JOIN dbo.PoliticaSLA s ON s.SLAId=i.SLAId
GROUP BY a.Nome,s.Prioridade ORDER BY TotalIncidentes DESC,a.Nome;
GO
-- 3. SLA simplificado: horas corridas (nao desconta fins de semana/feriados).
-- Considera os incidentes com DataResolucao preenchida, incluindo os
-- estados Resolvido e Fechado segundo as regras atuais da SIManagerDB.
-- A coluna Resolvidos e um nome simplificado para este conjunto.
-- Nao representa um calculo contratual completo de SLA, pois nao
-- contempla calendarios de servico, pausas ou outras regras operacionais.
SELECT s.Prioridade,COUNT(*) AS Resolvidos,
 SUM(CASE WHEN DATEDIFF(MINUTE,i.DataAbertura,i.DataResolucao)>s.HorasResolucao*60 THEN 1 ELSE 0 END) AS ForaSLA
FROM dbo.Incidente i JOIN dbo.PoliticaSLA s ON i.SLAId=s.SLAId
WHERE i.DataResolucao IS NOT NULL
GROUP BY s.Prioridade,s.HorasResolucao ORDER BY s.Prioridade;
GO
