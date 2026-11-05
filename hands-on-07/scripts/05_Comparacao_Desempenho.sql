USE SIManagerDB;
GO

/*
Ponto De Conhecimento Tecnológico
Série 2 — SQL Server
HANDS-ON #07 — Índices e Otimização de Consultas

Script 05 — Comparação de Desempenho

Medições históricas:
Sem índice adicional: 928 leituras lógicas
Índice simples:       928 leituras lógicas
Índice composto:       35 leituras lógicas

Redução observada: 96,2%

Nota:
Os índices já existem. A execução atual
não reproduz automaticamente os três
cenários históricos.
*/

-- Comparação das medições históricas

SELECT
    Cenario,
    LeiturasLogicas
FROM
(
    VALUES
        (1, 'Sem índice adicional', 928),
        (2, 'Índice simples', 928),
        (3, 'Índice composto com INCLUDE', 35)
) AS Resultados
(
    Ordem,
    Cenario,
    LeiturasLogicas
)
ORDER BY Ordem;
GO

-- Consulta funcional com os índices atuais

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    IncidenteId,
    AplicacaoId,
    Titulo,
    Estado,
    DataAbertura
FROM dbo.Incidente
WHERE AplicacaoId = 10
ORDER BY DataAbertura DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;