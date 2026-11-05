# HANDS-ON #06 — Joins, CTEs e Window Functions

**Ponto de Conhecimento Tecnológico · Série 2 — SQL Server**

## Objetivo
Resolver seis exercícios progressivos de consulta e análise de dados na base fictícia **SIManagerDB**, combinando `JOIN`, expressões de tabela comuns (`CTE`) e funções de janela.

## Pré-requisitos
- SQL Server 2019 ou posterior e SSMS.
- `SIManagerDB` instalada e validada.

## Sequência dos seis exercícios
1. `scripts/01_InnerJoin_Aplicacoes_Departamentos.sql` — `INNER JOIN`.
2. `scripts/02_LeftJoin_Incidentes_Tecnicos.sql` — `LEFT JOIN`.
3. `scripts/03_CTE_Incidentes_Por_Aplicacao.sql` — `CTE` e agregação.
4. `scripts/04_RowNumber_Ultimos_Incidentes.sql` — `ROW_NUMBER()` e `COUNT() OVER()`.
5. `scripts/05_Ranking_Aplicacoes.sql` — `RANK()` e `DENSE_RANK()`.
6. `scripts/06_Evolucao_Mensal_Incidentes.sql` — evolução mensal com funções de janela, incluindo meses sem incidentes.

## Como executar
Abrir os ficheiros por ordem no SSMS, confirmar a base `SIManagerDB`, executar cada consulta e analisar as colunas e ordenação dos resultados. Comparar o comportamento de `INNER JOIN` e `LEFT JOIN`, e de `RANK` e `DENSE_RANK` em situações de empate.

## Validação
Os seis exercícios foram consolidados na documentação técnica. A execução na sua instância pode devolver resultados diferentes se os dados tiverem sido modificados.

## Segurança
Scripts destinados a consulta e aprendizagem numa base fictícia; verificar sempre o conteúdo antes de executar.
