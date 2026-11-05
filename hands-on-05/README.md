# HANDS-ON #05 — Modelação de Dados e Constraints

**Ponto de Conhecimento Tecnológico · Série 2 — SQL Server**

## Objetivo
Explorar o modelo relacional da **SIManagerDB** e verificar como as chaves e constraints protegem a integridade dos dados. O laboratório inclui consultas de metadados e testes de integridade.

## Pré-requisitos
- SQL Server 2019 ou posterior e SQL Server Management Studio (SSMS).
- Base fictícia `SIManagerDB` previamente instalada e validada.
- Executar os testes apenas num ambiente de laboratório; ler previamente os comentários dos scripts.

## Ficheiros e sequência
1. `scripts/01_Consultar_Relacionamentos.sql` — consulta às chaves estrangeiras, respetivas colunas e estado de confiança.
2. `scripts/02_Consultar_Constraints.sql` — inventário das constraints existentes.
3. `scripts/03_Testes_Integridade.sql` — testes de validação das regras de integridade; rever os efeitos e as transações antes de executar.

## Resultados de referência
A base de laboratório foi documentada com **15 tabelas e 21 relacionamentos**. As contagens efetivas devem ser confirmadas na instância através dos scripts; podem variar se o esquema tiver sido alterado.

## Cuidados
Usar uma instância de desenvolvimento. Não executar testes de integridade numa base de produção. Conservar as mensagens de erro esperadas como evidência dos mecanismos de proteção.

## Documentação
Consultar a documentação técnica do HANDS-ON #05 para a interpretação dos resultados e o contexto do modelo.
