# HANDS-ON #08 — Transações, Concorrência e Deadlocks

**Ponto de Conhecimento Tecnológico** · Série 2 — SQL Server

## Requisitos
- SQL Server e SQL Server Management Studio (SSMS).
- Base de dados `SIManagerDB` instalada, com as tabelas `Aplicacao`, `Incidente`, `PedidoServico` e `Intervencao`.
- Permissões para criar tabelas `dbo.H08_*` e consultar DMVs (para diagnóstico, poderá ser necessária a permissão `VIEW SERVER STATE`).
- **Ambiente de laboratório, nunca de produção.** Os scripts alteram tabelas de teste permanentes em `SIManagerDB`.

## Ordem de execução
1. `01_Ambiente/01_Verificar_Ambiente.sql` — inventário do ambiente.
2. `02_Transacoes/02_Commit_Rollback.sql` — executar numa janela.
3. `03_Erros/03_Try_Catch_Xact_State.sql` — executar numa janela.
4. `04_Isolamento/00_Preparar_Tabela.sql`; abrir duas janelas e seguir **Sessão A → Sessão B → ROLLBACK de A → última leitura de B**. As instruções finais da Sessão A estão comentadas para evitar execução prematura.
5. `05_Leituras_Nao_Repetiveis/00_Repor_Valor.sql`; **A primeira leitura → B UPDATE e COMMIT → A segunda leitura e COMMIT**.
6. `06_Bloqueios`: **A UPDATE sem COMMIT → B SELECT (bloqueia) → C DMV → A ROLLBACK**.
7. `07_Deadlocks/00_Preparar_Tabela.sql`; **A atualiza Id=1 → B atualiza Id=2 → A tenta Id=2 → B tenta Id=1 → SQL Server deteta deadlock → transação sobrevivente COMMIT**. As linhas que devem ser executadas mais tarde estão comentadas: selecionar e executar apenas essas instruções no momento indicado, removendo `--`.
8. `08_Prevencao/00_Repor_Valores.sql`; **A atualiza Id=1 e Id=2 → B tenta Id=1 e aguarda → A COMMIT → B prossegue e COMMIT**.

## Resultados esperados
- Ex. 2: ROLLBACK recupera «Estado inicial»; COMMIT preserva «Alteracao confirmada».
- Ex. 3: erro **2627**, `XACT_STATE()=-1` no CATCH; rollback preserva apenas o registo inicial.
- Ex. 4: erro **1222** sob READ COMMITTED (timeout 5 s); READ UNCOMMITTED lê **500**; após rollback lê **100**.
- Ex. 5: leitura **100 → 200** na mesma transação READ COMMITTED.
- Ex. 6: DMV mostra uma sessão bloqueada, `LCK_M_S`; após rollback de A, B lê **200**.
- Ex. 7: erro **1205** (a sessão vítima pode variar); no ensaio documentado, B foi vítima, e os valores finais foram **150, 275**.
- Ex. 8: ambas as sessões terminam sem deadlock; valores finais **175, 275**.

## Cuidados
- **Cada sessão corresponde a uma janela de consulta distinta no SSMS.** Confirme `@@SPID` em cada janela.
- Não execute de uma vez todas as instruções comentadas: siga a sequência de cada experiência.
- Em caso de interrupção, execute `IF @@TRANCOUNT > 0 ROLLBACK;` na **mesma sessão** que ficou com transação aberta, antes de reiniciar o exercício.
- Os SPIDs, tempos de espera e sessão escolhida como vítima podem variar.
- A simulação de deadlock é intencional. Não execute com dados de produção.
- As tabelas permanentes `dbo.H08_TesteIsolamento` e `dbo.H08_TesteDeadlock` são preservadas para repetir os testes.
