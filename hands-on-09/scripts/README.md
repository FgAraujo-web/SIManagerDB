# HANDS-ON #09 — Auditoria de Dados com Triggers e Tabelas Temporais

**Ponto de Conhecimento Tecnológico | Série 2 — SQL Server**

## Objetivo

Explorar rastreabilidade de alterações com triggers `AFTER INSERT`, `AFTER UPDATE` e `AFTER DELETE`, registo de valores em JSON e histórico automático com `SYSTEM_VERSIONING` e `FOR SYSTEM_TIME`.

## Ambiente validado

- SQL Server 2019 Express (15.0.2190.7), compatibilidade 150.
- Base de dados `SIManagerDB` (ONLINE).
- Tabelas originais: `Aplicacao` (25), `Incidente` (50 000), `PedidoServico` (12 000).
- Os scripts criam objetos próprios prefixados com `H09_` e não modificam as tabelas originais.

## Execução no SSMS

**Execute os ficheiros por ordem num laboratório limpo.** Cada ficheiro pode conter vários lotes `GO`. Não execute novamente os scripts de teste que inserem dados sem primeiro repor o laboratório: os IDs e as contagens esperadas deixarão de coincidir. A criação de objetos é maioritariamente idempotente, mas os testes DML não são.

| Ordem | Ficheiro | Exercício |
|---|---|---|
| 01 | `01_Validar_Ambiente.sql` | 01 — Verificar ambiente |
| 02 | `02_Criar_Tabelas_Auditoria.sql` | 01 — Criar tabelas de laboratório |
| 03–04 | `03_Trigger_INSERT.sql`, `04_Teste_INSERT.sql` | 02 — Auditoria de inserção |
| 05–06 | `05_Trigger_UPDATE.sql`, `06_Teste_UPDATE.sql` | 03 — Auditoria de atualização |
| 07–08 | `07_Trigger_DELETE.sql`, `08_Teste_DELETE.sql` | 04 — Auditoria de eliminação |
| 09 | `09_Teste_Operacoes_Em_Lote.sql` | 05 — INSERT, UPDATE e DELETE em conjunto |
| 10–11 | `10_Criar_Tabela_Temporal.sql`, `11_Teste_Versionamento_Temporal.sql` | 06 — Versionamento temporal |
| 12 | `12_Consultas_Temporais.sql` | 07 — AS OF, BETWEEN e ALL |
| 13 | `13_Validacao_Final.sql` | 08 — Comparação e validação |

## Resultados da execução original validada (05/11/2026)

- **3 triggers ativos**, `is_disabled = 0`.
- **12 auditorias:** 5 `INSERT`, 4 `UPDATE`, 3 `DELETE`.
- **1 tabela temporal** `H09_IncidenteTemporal` e **1 tabela de histórico** `H09_IncidenteTemporalHistorico`.
- **3 versões** do incidente temporal 1: `Aberto/Alta` → `Em análise/Alta` → `Resolvido/Baixa`.
- `FOR SYSTEM_TIME AS OF` recuperou `Em análise` no instante `2026-11-05T16:28:30` (UTC da tabela).
- `BETWEEN` recuperou `Aberto` e `Em análise` no intervalo documentado.

## Notas importantes

- `ORIGINAL_LOGIN()` regista o login original da sessão SQL, **não necessariamente o utilizador final da aplicação**.
- O registo de auditoria criado por trigger participa na **mesma transação** da operação DML; `ROLLBACK` anula ambos.
- `SYSTEM_VERSIONING` mantém estados anteriores, **não um diário de eventos com identidade do autor**.
- O histórico temporal utiliza tempos UTC de início das transações; os instantes fixos do ficheiro `12_Consultas_Temporais.sql` pertencem à execução original e devem ser **adaptados numa nova execução**.
- Triggers são **set-based**: uma instrução pode afetar várias linhas, e a ordem dos valores `IDENTITY` não é garantida.
- A tabela de auditoria usa JSON (`DadosAntes` e `DadosDepois`) e mantém registos mesmo após um `DELETE` confirmado.
- O laboratório não implementa políticas de retenção, proteção contra alterações à própria tabela de auditoria ou identificação fiável do utilizador de negócio. Esses aspetos exigem desenho adicional em produção.

## Limpeza do laboratório (opcional)

Para preservar as evidências, **não execute limpeza durante os exercícios**. Se precisar de recomeçar, faça primeiro uma cópia de segurança e confirme que os objetos `H09_` não contêm dados a preservar. A eliminação de uma tabela temporal requer desativar `SYSTEM_VERSIONING` antes de eliminar a tabela atual e a de histórico.

## Estado

Exercícios **01 a 08 validados** no laboratório original. Este pacote reconstrói os scripts utilizados; **não foi reexecutado automaticamente** num SQL Server nesta sessão.
