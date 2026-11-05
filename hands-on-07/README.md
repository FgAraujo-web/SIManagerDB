# HANDS-ON #07 — Índices e Otimização de Consultas

**Ponto de Conhecimento Tecnológico · Série 2 — SQL Server**

## Objetivo
Analisar o custo de consultas SQL e estudar como a estrutura dos índices e a reescrita de consultas influenciam leituras lógicas, CPU e tempo de execução.

## Pré-requisitos
- SQL Server 2019 ou posterior e SSMS.
- `SIManagerDB` instalada e validada, preferencialmente com o conjunto de dados original.
- Ativar, quando apropriado, `SET STATISTICS IO ON` e `SET STATISTICS TIME ON`, e consultar o plano de execução real.

## Scripts disponíveis neste pacote
- `scripts/06_RowNumber_Count_Over.sql` — consulta com funções de janela.
- `scripts/07_Otimizacao_GroupBy.sql` — alternativa de otimização por agregação.
- `scripts/08_Validacao_Equivalencia_Resultados.sql` — comparação funcional dos resultados dos scripts 06 e 07.

**Nota de integridade:** os scripts 01 a 05 não estavam disponíveis entre os ficheiros recuperados e **não foram inventados** neste pacote. Consultar a documentação técnica do HANDS-ON #07 para os cenários iniciais e os índices estudados. Este ZIP não constitui ainda o conjunto completo de scripts do #07.

## Resultados documentados no laboratório
- Consulta de referência: **928 leituras lógicas**.
- Índice de cobertura: **35 leituras lógicas** (redução aproximada de **96,2%**).
- Consulta com `ROW_NUMBER()` e `COUNT() OVER()`: **101 651 leituras** na worktable, 234 ms CPU e 306 ms decorridos.
- Melhor cenário final documentado: **215 leituras lógicas**, 31 ms CPU e 128 ms decorridos.
- Equivalência funcional: **75 resultados**, sem diferenças nem duplicados.

Os valores são medições de uma execução de laboratório, não garantias de desempenho noutros ambientes.

## Como validar
Executar os scripts disponíveis numa base de testes, recolher as estatísticas e verificar a equivalência funcional. Os planos e tempos dependem do volume, estatísticas, índices, cache e carga da instância.

## Segurança
Evitar criar ou alterar índices em produção sem análise de impacto e plano de reversão.
